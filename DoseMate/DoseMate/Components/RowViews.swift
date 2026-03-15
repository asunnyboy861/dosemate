import SwiftUI

struct InjectionRowView: View {
    let injection: InjectionRecord
    
    var body: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            ZStack {
                Circle()
                    .fill(AppTheme.Colors.primaryBlue.opacity(0.1))
                    .frame(width: 44, height: 44)
                
                Image(systemName: "syringe.fill")
                    .font(.system(size: 18))
                    .foregroundColor(AppTheme.Colors.primaryBlue)
            }
            
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                HStack {
                    Text(injection.medication?.name ?? "Unknown")
                        .font(.headline)
                    
                    if !injection.sideEffects.isEmpty {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.caption)
                            .foregroundColor(AppTheme.Colors.warningOrange)
                    }
                }
                
                Text(injection.injectionDate.formattedWithTime)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack(spacing: AppTheme.Spacing.md) {
                    Label(injection.site, systemImage: "location")
                    Label("\(String(format: "%.1f", injection.dosage)) \(injection.medication?.dosageUnit ?? "mg")", systemImage: "pills")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, AppTheme.Spacing.xs)
    }
}

struct WeightRowView: View {
    let record: WeightRecord
    let unit: String
    
    var body: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            ZStack {
                Circle()
                    .fill(AppTheme.Colors.successGreen.opacity(0.1))
                    .frame(width: 44, height: 44)
                
                Image(systemName: "scalemass.fill")
                    .font(.system(size: 18))
                    .foregroundColor(AppTheme.Colors.successGreen)
            }
            
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Text(record.date.formattedMedium)
                    .font(.headline)
                
                Text(unit == "kg" ? "\(String(format: "%.1f", record.weight * 0.453592)) kg" : "\(String(format: "%.1f", record.weight)) lbs")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            if !record.notes.isEmpty {
                Image(systemName: "note.text")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, AppTheme.Spacing.xs)
    }
}

struct SideEffectBadge: View {
    let severity: Int
    
    var severityColor: Color {
        switch severity {
        case 1...3:
            return AppTheme.Colors.successGreen
        case 4...6:
            return AppTheme.Colors.warningOrange
        case 7...10:
            return AppTheme.Colors.errorRed
        default:
            return .gray
        }
    }
    
    var severityText: String {
        switch severity {
        case 1...3:
            return "Mild"
        case 4...6:
            return "Moderate"
        case 7...10:
            return "Severe"
        default:
            return "Unknown"
        }
    }
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...10, id: \.self) { index in
                Circle()
                    .fill(index <= severity ? severityColor : Color.gray.opacity(0.3))
                    .frame(width: 8, height: 8)
            }
        }
    }
}

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            
            Text(title)
                .font(.headline)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            if let actionTitle = actionTitle, let action = action {
                Button(action: action) {
                    Text(actionTitle)
                        .fontWeight(.medium)
                }
                .padding(.top, AppTheme.Spacing.sm)
            }
        }
        .padding(AppTheme.Spacing.xl)
    }
}

#Preview {
    List {
        InjectionRowView(injection: InjectionRecord(dosage: 2.5))
        
        WeightRowView(record: WeightRecord(weight: 180), unit: "lbs")
        
        SideEffectBadge(severity: 5)
    }
    
    EmptyStateView(
        icon: "syringe",
        title: "No Injections Yet",
        message: "Record your first injection to get started",
        actionTitle: "Add Injection",
        action: {}
    )
}
