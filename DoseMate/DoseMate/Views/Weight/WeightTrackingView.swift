import SwiftUI
import SwiftData

struct WeightTrackingView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = WeightViewModel()
    @State private var showingAddSheet = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.lg) {
                    if !viewModel.weightRecords.isEmpty {
                        chartSection
                        
                        statsSection
                    }
                    
                    if viewModel.weightRecords.isEmpty {
                        emptyState
                    } else {
                        historySection
                    }
                }
                .padding(AppTheme.Spacing.md)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Weight")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.useMetric.toggle()
                    } label: {
                        Text(viewModel.useMetric ? "kg" : "lbs")
                            .fontWeight(.medium)
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddWeightView(viewModel: viewModel)
            }
        }
        .onAppear {
            viewModel.setup(modelContext: modelContext)
        }
    }
    
    private var chartSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            Text("Trend")
                .font(.headline)
            
            if viewModel.weightRecords.count >= 2 {
                WeightChartView(
                    records: viewModel.weightRecords,
                    unit: viewModel.useMetric ? "kg" : "lbs"
                )
                .frame(height: 200)
                .padding(AppTheme.Spacing.md)
                .background(AppTheme.Colors.surface)
                .cornerRadius(AppTheme.CornerRadius.medium)
            }
        }
    }
    
    private var statsSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            Text("Statistics")
                .font(.headline)
            
            if let start = viewModel.oldestWeight, let current = viewModel.latestWeight {
                StatsCardView(
                    startWeight: start.weight,
                    currentWeight: current.weight,
                    unit: viewModel.useMetric ? "kg" : "lbs"
                )
            }
        }
    }
    
    private var emptyState: some View {
        EmptyStateView(
            icon: "scalemass",
            title: "No Weight Records",
            message: "Start tracking your weight to see trends and progress",
            actionTitle: "Add Weight",
            action: { showingAddSheet = true }
        )
        .frame(maxWidth: .infinity)
        .padding(.top, AppTheme.Spacing.xxl)
    }
    
    private var historySection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            Text("History")
                .font(.headline)
                .padding(.top, AppTheme.Spacing.md)
            
            LazyVStack(spacing: 0) {
                ForEach(viewModel.weightRecords) { record in
                    WeightRowView(record: record, unit: viewModel.useMetric ? "kg" : "lbs")
                    
                    if record.id != viewModel.weightRecords.last?.id {
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

#Preview {
    WeightTrackingView()
        .modelContainer(for: [WeightRecord.self])
}
