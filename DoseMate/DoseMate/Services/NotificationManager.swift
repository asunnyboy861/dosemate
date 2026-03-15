import Foundation
import UserNotifications

final class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    @Published var isAuthorized = false
    
    private init() {
        Task {
            await checkAuthorization()
        }
    }
    
    func checkAuthorization() async {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        await MainActor.run {
            isAuthorized = settings.authorizationStatus == .authorized
        }
    }
    
    func requestAuthorization() async throws {
        try await UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .badge, .sound]
        )
        await checkAuthorization()
    }
    
    func scheduleInjectionReminder(
        medicationName: String,
        nextInjectionDate: Date,
        dosage: String,
        identifier: String
    ) {
        let content = UNMutableNotificationContent()
        content.title = "💉 Time for Injection"
        content.body = "\(medicationName) - \(dosage)"
        content.sound = .default
        content.badge = 1
        
        let triggerDate = nextInjectionDate.addingTimeInterval(-15 * 60)
        
        guard triggerDate > Date() else { return }
        
        let components = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: triggerDate
        )
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func scheduleWeightReminder() {
        let content = UNMutableNotificationContent()
        content.title = "⚖️ Weight Check"
        content.body = "Don't forget to log your weight today!"
        content.sound = .default
        
        var components = DateComponents()
        components.hour = 9
        components.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: "weight-reminder",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func cancelReminder(identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    func cancelAllReminders() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
