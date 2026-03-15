import Foundation
import SwiftUI
import SwiftData
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var todayInjection: InjectionRecord?
    @Published var nextInjectionDate: Date?
    @Published var recentInjections: [InjectionRecord] = []
    @Published var activeMedications: [Medication] = []
    @Published var latestWeight: WeightRecord?
    @Published var daysOnMedication: Int = 0
    @Published var weeklyInjectionCount: Int = 0
    @Published var totalInjectionCount: Int = 0
    @Published var weightChange: Double = 0
    
    private var modelContext: ModelContext?
    
    func setup(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func updateData(
        medications: [Medication],
        injections: [InjectionRecord],
        weights: [WeightRecord]
    ) {
        activeMedications = medications.filter { $0.isActive }
        
        if let firstMed = activeMedications.first {
            daysOnMedication = Date().daysSince(firstMed.startDate)
        }
        
        recentInjections = Array(injections.prefix(5))
        todayInjection = injections.first { $0.injectionDate.isToday }
        
        totalInjectionCount = injections.count
        
        let weekAgo = Date().adding(days: -7)
        weeklyInjectionCount = injections.filter { $0.injectionDate >= weekAgo }.count
        
        if let lastInjection = injections.first,
           let medication = lastInjection.medication {
            let frequency = medication.frequency
            let intervalDays = max(1, 7 / frequency)
            nextInjectionDate = lastInjection.injectionDate.adding(days: intervalDays)
        }
        
        latestWeight = weights.first
        
        if weights.count >= 2,
           let latest = weights.first,
           let oldest = weights.last {
            weightChange = latest.weight - oldest.weight
        }
    }
    
    var countdownText: String {
        guard let nextDate = nextInjectionDate else {
            return "Add medication"
        }
        
        let now = Date()
        if nextDate <= now {
            return "Now!"
        }
        
        let days = nextDate.daysSince(now)
        let hours = Calendar.current.dateComponents([.hour], from: now, to: nextDate).hour ?? 0
        
        if days == 0 && hours > 0 {
            return "In \(hours)h"
        } else if days == 0 {
            return "Today"
        } else if days == 1 {
            return "Tomorrow"
        } else {
            return "In \(days) days"
        }
    }
    
    var weightChangeText: String {
        if weightChange > 0 {
            return "+\(String(format: "%.1f", weightChange)) lbs"
        } else if weightChange < 0 {
            return "\(String(format: "%.1f", weightChange)) lbs"
        } else {
            return "No change"
        }
    }
    
    var weightChangeColor: Color {
        if weightChange < 0 {
            return AppTheme.Colors.successGreen
        } else if weightChange > 0 {
            return AppTheme.Colors.warningOrange
        }
        return .secondary
    }
}
