import SwiftUI
import Charts

struct WeightChartView: View {
    let records: [WeightRecord]
    let unit: String
    var showGoalLine: Bool = false
    var goalWeight: Double? = nil
    
    private var sortedRecords: [WeightRecord] {
        records.sorted { $0.date < $1.date }
    }
    
    private var chartData: [(Date, Double)] {
        sortedRecords.map { record in
            let weight = unit == "kg" ? record.weight * 0.453592 : record.weight
            return (record.date, weight)
        }
    }
    
    var body: some View {
        Chart {
            ForEach(chartData, id: \.0) { dataPoint in
                LineMark(
                    x: .value("Date", dataPoint.0),
                    y: .value("Weight", dataPoint.1)
                )
                .foregroundStyle(AppTheme.Colors.primaryBlue)
                .interpolationMethod(.catmullRom)
                
                PointMark(
                    x: .value("Date", dataPoint.0),
                    y: .value("Weight", dataPoint.1)
                )
                .foregroundStyle(AppTheme.Colors.primaryBlue)
                .symbolSize(40)
            }
            
            if showGoalLine, let goal = goalWeight {
                let displayGoal = unit == "kg" ? goal * 0.453592 : goal
                RuleMark(y: .value("Goal", displayGoal))
                    .foregroundStyle(AppTheme.Colors.successGreen)
                    .lineStyle(StrokeStyle(lineWidth: 2, dash: [5, 5]))
                    .annotation(position: .top, alignment: .trailing) {
                        Text("Goal")
                            .font(.caption)
                            .foregroundColor(AppTheme.Colors.successGreen)
                    }
            }
        }
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 5)) { value in
                AxisGridLine()
                AxisValueLabel(format: .dateTime.month(.abbreviated).day())
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading) { value in
                AxisGridLine()
                AxisValueLabel {
                    if let doubleValue = value.as(Double.self) {
                        Text("\(Int(doubleValue))")
                    }
                }
            }
        }
    }
}

struct InjectionCalendarView: View {
    let injections: [InjectionRecord]
    let month: Date
    
    private var injectionDates: Set<Date> {
        Set(injections.map { Calendar.current.startOfDay(for: $0.injectionDate) })
    }
    
    private var daysInMonth: [Date] {
        let calendar = Calendar.current
        guard let range = calendar.range(of: .day, in: .month, for: month),
              let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: month)) else {
            return []
        }
        
        return range.compactMap { day in
            calendar.date(byAdding: .day, value: day - 1, to: firstDay)
        }
    }
    
    private var firstWeekday: Int {
        let calendar = Calendar.current
        guard let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: month)) else {
            return 1
        }
        return calendar.component(.weekday, from: firstDay)
    }
    
    var body: some View {
        let columns = Array(repeating: GridItem(.flexible()), count: 7)
        
        VStack(spacing: AppTheme.Spacing.sm) {
            HStack {
                ForEach(["S", "M", "T", "W", "T", "F", "S"], id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }
            
            LazyVGrid(columns: columns, spacing: AppTheme.Spacing.sm) {
                ForEach(0..<(firstWeekday - 1), id: \.self) { _ in
                    Color.clear
                        .frame(height: 36)
                }
                
                ForEach(daysInMonth, id: \.self) { date in
                    let hasInjection = injectionDates.contains(Calendar.current.startOfDay(for: date))
                    let isToday = Calendar.current.isDateInToday(date)
                    
                    Text("\(Calendar.current.component(.day, from: date))")
                        .font(.subheadline)
                        .fontWeight(isToday ? .bold : .regular)
                        .frame(width: 36, height: 36)
                        .background(
                            Circle()
                                .fill(hasInjection ? AppTheme.Colors.primaryBlue : Color.clear)
                                .frame(width: 32, height: 32)
                        )
                        .foregroundColor(hasInjection ? .white : (isToday ? AppTheme.Colors.primaryBlue : .primary))
                }
            }
        }
    }
}

struct StatsCardView: View {
    let startWeight: Double
    let currentWeight: Double
    let unit: String
    
    private var change: Double {
        currentWeight - startWeight
    }
    
    private var changeColor: Color {
        if change < 0 {
            return AppTheme.Colors.successGreen
        } else if change > 0 {
            return AppTheme.Colors.warningOrange
        }
        return .secondary
    }
    
    private var displayStart: String {
        unit == "kg" ? String(format: "%.1f kg", startWeight * 0.453592) : String(format: "%.1f lbs", startWeight)
    }
    
    private var displayCurrent: String {
        unit == "kg" ? String(format: "%.1f kg", currentWeight * 0.453592) : String(format: "%.1f lbs", currentWeight)
    }
    
    private var displayChange: String {
        let absChange = abs(change)
        let displayChange = unit == "kg" ? absChange * 0.453592 : absChange
        if change > 0 {
            return "+\(String(format: "%.1f", displayChange))"
        }
        return String(format: "%.1f", displayChange)
    }
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Starting")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(displayStart)
                        .font(.headline)
                }
                
                Spacer()
                
                Image(systemName: "arrow.right")
                    .foregroundColor(.secondary)
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Current")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(displayCurrent)
                        .font(.headline)
                }
            }
            
            Divider()
            
            HStack {
                Text("Total Change")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text(displayChange)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(changeColor)
            }
        }
        .padding(AppTheme.Spacing.md)
        .background(AppTheme.Colors.surface)
        .cornerRadius(AppTheme.CornerRadius.medium)
    }
}

#Preview {
    VStack {
        WeightChartView(
            records: [
                WeightRecord(date: Date().adding(days: -30), weight: 200),
                WeightRecord(date: Date().adding(days: -20), weight: 195),
                WeightRecord(date: Date().adding(days: -10), weight: 190),
                WeightRecord(date: Date(), weight: 185)
            ],
            unit: "lbs"
        )
        .frame(height: 200)
        .padding()
    }
}
