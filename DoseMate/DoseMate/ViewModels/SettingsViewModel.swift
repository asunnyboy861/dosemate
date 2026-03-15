import Foundation
import SwiftUI
import Combine

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var useMetricUnits = false
    @Published var notificationsEnabled = true
    @Published var weightRemindersEnabled = false
    @Published var healthKitEnabled = false
    @Published var healthKitAuthorized = false
    
    private let userDefaults = UserDefaults.standard
    
    init() {
        loadSettings()
    }
    
    func loadSettings() {
        useMetricUnits = userDefaults.bool(forKey: "useMetricUnits")
        notificationsEnabled = userDefaults.bool(forKey: "notificationsEnabled")
        weightRemindersEnabled = userDefaults.bool(forKey: "weightRemindersEnabled")
        healthKitEnabled = userDefaults.bool(forKey: "healthKitEnabled")
        healthKitAuthorized = HealthKitManager.shared.isAuthorized
    }
    
    func saveSettings() {
        userDefaults.set(useMetricUnits, forKey: "useMetricUnits")
        userDefaults.set(notificationsEnabled, forKey: "notificationsEnabled")
        userDefaults.set(weightRemindersEnabled, forKey: "weightRemindersEnabled")
        userDefaults.set(healthKitEnabled, forKey: "healthKitEnabled")
    }
    
    func requestNotificationPermission() async {
        do {
            try await NotificationManager.shared.requestAuthorization()
            notificationsEnabled = true
            saveSettings()
        } catch {
            notificationsEnabled = false
            print("Notification permission denied: \(error)")
        }
    }
    
    func requestHealthKitPermission() async {
        do {
            try await HealthKitManager.shared.requestAuthorization()
            healthKitAuthorized = true
            healthKitEnabled = true
            saveSettings()
        } catch {
            healthKitAuthorized = false
            print("HealthKit permission denied: \(error)")
        }
    }
    
    func toggleWeightReminders(_ enabled: Bool) {
        weightRemindersEnabled = enabled
        saveSettings()
        
        if enabled {
            NotificationManager.shared.scheduleWeightReminder()
        } else {
            NotificationManager.shared.cancelReminder(identifier: "weight-reminder")
        }
    }
    
    func exportData() -> String {
        let csv = "Type,Date,Value,Notes\n"
        
        return csv
    }
    
    var weightUnit: String {
        useMetricUnits ? "kg" : "lbs"
    }
}
