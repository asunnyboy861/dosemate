import SwiftUI
import SwiftData

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @State private var showingExportSheet = false
    @State private var showingAbout = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Units") {
                    Toggle("Use Metric (kg)", isOn: $viewModel.useMetricUnits)
                        .onChange(of: viewModel.useMetricUnits) { _, _ in
                            viewModel.saveSettings()
                        }
                }
                
                Section("Notifications") {
                    Toggle("Enable Notifications", isOn: $viewModel.notificationsEnabled)
                        .onChange(of: viewModel.notificationsEnabled) { _, _ in
                            if viewModel.notificationsEnabled {
                                Task {
                                    await viewModel.requestNotificationPermission()
                                }
                            }
                            viewModel.saveSettings()
                        }
                    
                    Toggle("Daily Weight Reminder", isOn: Binding(
                        get: { viewModel.weightRemindersEnabled },
                        set: { viewModel.toggleWeightReminders($0) }
                    ))
                }
                
                Section("Health") {
                    HStack {
                        Label("HealthKit", systemImage: "heart.fill")
                        Spacer()
                        if viewModel.healthKitAuthorized {
                            Text("Connected")
                                .foregroundColor(.secondary)
                        } else {
                            Text("Not Connected")
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    if !viewModel.healthKitAuthorized {
                        Button("Connect to Health") {
                            Task {
                                await viewModel.requestHealthKitPermission()
                            }
                        }
                    } else {
                        Button("Sync from Health") {
                            Task {
                            }
                        }
                        .foregroundColor(AppTheme.Colors.primaryBlue)
                    }
                }
                
                Section("Data") {
                    Button {
                        showingExportSheet = true
                    } label: {
                        Label("Export Data", systemImage: "square.and.arrow.up")
                    }
                    
                    Button {
                    } label: {
                        Label("Generate Doctor Report", systemImage: "doc.text")
                    }
                }
                
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    Button {
                        showingAbout = true
                    } label: {
                        Text("About DoseMate")
                    }
                }
                
                Section {
                    VStack(spacing: AppTheme.Spacing.sm) {
                        Text("⚠️ Disclaimer")
                            .font(.headline)
                        
                        Text("DoseMate is not a medical device and does not provide medical advice. Always consult your healthcare provider for medical decisions.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppTheme.Spacing.sm)
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showingAbout) {
                AboutView()
            }
        }
    }
}

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: AppTheme.Spacing.lg) {
                Image(systemName: "pills.fill")
                    .font(.system(size: 64))
                    .foregroundColor(AppTheme.Colors.primaryBlue)
                    .padding(.top, AppTheme.Spacing.xxl)
                
                Text("DoseMate")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("GLP-1 Medication Tracker")
                    .font(.title3)
                    .foregroundColor(.secondary)
                
                Text("Version 1.0.0")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                VStack(spacing: AppTheme.Spacing.md) {
                    Text("Built by users, for users")
                        .font(.headline)
                    
                    Text("Created by people who actually use GLP-1 medications to better understand and track their treatment journey.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, AppTheme.Spacing.lg)
                }
                
                Spacer()
                
                Text("© 2026 DoseMate")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.bottom, AppTheme.Spacing.lg)
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
