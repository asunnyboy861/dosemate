import SwiftUI
import SwiftData
import HealthKit

@main
struct DoseMateApp: App {
    @StateObject private var healthKitManager = HealthKitManager.shared
    @StateObject private var notificationManager = NotificationManager.shared
    
    init() {
        setupAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(healthKitManager)
                .environmentObject(notificationManager)
                .onAppear {
                    Task {
                        await setupPermissions()
                    }
                }
        }
        .modelContainer(for: [
            Medication.self,
            InjectionRecord.self,
            WeightRecord.self,
            SideEffectRecord.self
        ])
    }
    
    private func setupAppearance() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor.systemBackground
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = UIColor.systemBackground
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
    }
    
    private func setupPermissions() async {
        if healthKitManager.isHealthKitAvailable && !healthKitManager.isAuthorized {
            do {
                try await healthKitManager.requestAuthorization()
                print("✅ HealthKit authorized")
            } catch {
                print("❌ HealthKit authorization failed: \(error)")
            }
        }
        
        if !notificationManager.isAuthorized {
            do {
                try await notificationManager.requestAuthorization()
                print("✅ Notifications authorized")
            } catch {
                print("❌ Notification authorization failed: \(error)")
            }
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var healthKitManager: HealthKitManager
    @EnvironmentObject var notificationManager: NotificationManager
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(selectedTab: $selectedTab)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            MedicationListView()
                .tabItem {
                    Label("Medications", systemImage: "pills.fill")
                }
                .tag(1)
            
            InjectionHistoryView()
                .tabItem {
                    Label("Injections", systemImage: "syringe.fill")
                }
                .tag(2)
            
            WeightTrackingView()
                .tabItem {
                    Label("Weight", systemImage: "scalemass.fill")
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(4)
        }
        .tint(AppTheme.Colors.primaryBlue)
    }
}

#Preview {
    ContentView()
        .environmentObject(HealthKitManager.shared)
        .environmentObject(NotificationManager.shared)
        .modelContainer(for: [
            Medication.self,
            InjectionRecord.self,
            WeightRecord.self,
            SideEffectRecord.self
        ])
}
