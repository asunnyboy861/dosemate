import SwiftUI
import SwiftData

struct MedicationListView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = MedicationViewModel()
    @State private var showingAddSheet = false
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.medications.isEmpty {
                    emptyState
                } else {
                    medicationList
                }
            }
            .navigationTitle("Medications")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddMedicationView()
            }

        }
        .onAppear {
            viewModel.setup(modelContext: modelContext)
        }
    }
    
    private var emptyState: some View {
        EmptyStateView(
            icon: "pills",
            title: "No Medications",
            message: "Add your GLP-1 medication to start tracking",
            actionTitle: "Add Medication",
            action: { showingAddSheet = true }
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
    
    private var medicationList: some View {
        List {
            if !viewModel.activeMedications.isEmpty {
                Section("Active") {
                    ForEach(viewModel.activeMedications) { medication in
                        MedicationCard(medication: medication)
                    }
                    .onDelete { indexSet in
                        deleteMedications(at: indexSet, from: viewModel.activeMedications)
                    }
                }
            }
            
            if !viewModel.inactiveMedications.isEmpty {
                Section("Inactive") {
                    ForEach(viewModel.inactiveMedications) { medication in
                        MedicationCard(medication: medication)
                    }
                    .onDelete { indexSet in
                        deleteMedications(at: indexSet, from: viewModel.inactiveMedications)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
    }
    
    private func deleteMedications(at offsets: IndexSet, from medications: [Medication]) {
        for index in offsets {
            let medication = medications[index]
            viewModel.deleteMedication(medication)
        }
    }
}

#Preview {
    MedicationListView()
        .modelContainer(for: [Medication.self, InjectionRecord.self])
}
