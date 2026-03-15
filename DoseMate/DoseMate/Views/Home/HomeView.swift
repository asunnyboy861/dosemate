import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = HomeViewModel()
    @Binding var selectedTab: Int
    @Query(sort: \Medication.startDate, order: .reverse) private var medications: [Medication]
    @Query(sort: \InjectionRecord.injectionDate, order: .reverse) private var injections: [InjectionRecord]
    @Query(sort: \WeightRecord.date, order: .reverse) private var weights: [WeightRecord]
    

    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.lg) {
                    headerSection
                    
                    if medications.filter({ $0.isActive }).isEmpty {
                        emptyStateSection
                    } else {
                        dashboardSection
                    }
                    
                    quickActionsSection
                    
                    recentActivitySection
                }
                .padding(AppTheme.Spacing.md)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("DoseMate")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                    } label: {
                        Image(systemName: "bell.badge")
                    }
                }
            }
        }

        .onAppear {
            viewModel.setup(modelContext: modelContext)
        }
        .onChange(of: medications) { _, newValue in
            viewModel.updateData(
                medications: newValue,
                injections: injections,
                weights: weights
            )
        }
        .onChange(of: injections) { _, newValue in
            viewModel.updateData(
                medications: medications,
                injections: newValue,
                weights: weights
            )
        }
        .onChange(of: weights) { _, newValue in
            viewModel.updateData(
                medications: medications,
                injections: injections,
                weights: newValue
            )
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: AppTheme.Spacing.sm) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Next Injection")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text(viewModel.countdownText)
                        .font(.title2)
                        .fontWeight(.bold)
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(viewModel.nextInjectionDate != nil ? AppTheme.Colors.primaryBlue.opacity(0.2) : Color.gray.opacity(0.2), lineWidth: 8)
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: "syringe.fill")
                        .font(.title2)
                        .foregroundColor(viewModel.nextInjectionDate != nil ? AppTheme.Colors.primaryBlue : .gray)
                }
            }
            .padding(AppTheme.Spacing.md)
            .background(AppTheme.Colors.surface)
            .cornerRadius(AppTheme.CornerRadius.medium)
        }
    }
    
    private var emptyStateSection: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            Image(systemName: "pills.fill")
                .font(.system(size: 48))
                .foregroundColor(AppTheme.Colors.primaryBlue)
            
            Text("Welcome to DoseMate!")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Start by adding your GLP-1 medication to track your injections and weight progress.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(AppTheme.Spacing.xl)
        .frame(maxWidth: .infinity)
        .background(AppTheme.Colors.surface)
        .cornerRadius(AppTheme.CornerRadius.medium)
    }
    
    private var dashboardSection: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: AppTheme.Spacing.md) {
                DashboardCard(
                    title: "Days on Med",
                    value: "\(viewModel.daysOnMedication)",
                    subtitle: "Days",
                    icon: "calendar",
                    iconColor: AppTheme.Colors.primaryBlue
                )
                
                DashboardCard(
                    title: "This Week",
                    value: "\(viewModel.weeklyInjectionCount)",
                    subtitle: "Injections",
                    icon: "syringe.fill",
                    iconColor: AppTheme.Colors.successGreen
                )
                
                if let weight = viewModel.latestWeight {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            ZStack {
                                Circle()
                                    .fill(AppTheme.Colors.warningOrange.opacity(0.1))
                                    .frame(width: 36, height: 36)
                                Image(systemName: "scalemass.fill")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(AppTheme.Colors.warningOrange)
                            }
                            Spacer()
                        }
                        Text("\(String(format: "%.1f", weight.weight))")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text(weight.unit)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        if viewModel.weightChange != 0 {
                            Text(viewModel.weightChangeText)
                                .font(.caption)
                                .foregroundColor(viewModel.weightChangeColor)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(AppTheme.Spacing.md)
                    .background(AppTheme.Colors.surface)
                    .cornerRadius(AppTheme.CornerRadius.medium)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                } else {
                    DashboardCard(
                        title: "Weight",
                        value: "--",
                        subtitle: "Not logged",
                        icon: "scalemass.fill",
                        iconColor: AppTheme.Colors.warningOrange
                    )
                }
                
                DashboardCard(
                    title: "Total Doses",
                    value: "\(viewModel.totalInjectionCount)",
                    subtitle: "All time",
                    icon: "pills.fill",
                    iconColor: .purple
                )
            }
        }
    }
    
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            Text("Quick Actions")
                .font(.headline)
                .padding(.horizontal, AppTheme.Spacing.xs)
            
            HStack(spacing: AppTheme.Spacing.md) {
                QuickActionButton(
                icon: "plus.circle.fill",
                title: "Add Injection",
                color: AppTheme.Colors.primaryBlue
            ) {
                selectedTab = 2 // Switch to Injections tab
            }
            
            QuickActionButton(
                icon: "pills",
                title: "Add Medication",
                color: .purple
            ) {
                selectedTab = 1 // Switch to Medications tab
            }
            
            QuickActionButton(
                icon: "scalemass",
                title: "Log Weight",
                color: AppTheme.Colors.warningOrange
            ) {
                selectedTab = 3 // Switch to Weight tab
            }
            }
        }
    }
    
    private var recentActivitySection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            Text("Recent Activity")
                .font(.headline)
                .padding(.horizontal, AppTheme.Spacing.xs)
            
            if injections.isEmpty {
                Text("No recent activity")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(AppTheme.Spacing.lg)
                    .background(AppTheme.Colors.surface)
                    .cornerRadius(AppTheme.CornerRadius.medium)
            } else {
                VStack(spacing: 0) {
                    ForEach(injections.prefix(5)) { injection in
                        InjectionRowView(injection: injection)
                        
                        if injection.id != injections.prefix(5).last?.id {
                            Divider()
                        }
                    }
                }
                .padding(AppTheme.Spacing.md)
                .background(AppTheme.Colors.surface)
                .cornerRadius(AppTheme.CornerRadius.medium)
            }
        }
    }
}

struct QuickActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: AppTheme.Spacing.sm) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.1))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding(AppTheme.Spacing.sm)
            .background(AppTheme.Colors.surface)
            .cornerRadius(AppTheme.CornerRadius.medium)
        }
    }
}

#Preview {
    HomeView(selectedTab: .constant(0))
        .modelContainer(for: [Medication.self, InjectionRecord.self, WeightRecord.self])
}
