import Foundation
import SwiftUI
import SwiftData
import Combine

@MainActor
final class MedicationViewModel: ObservableObject {
    @Published var medications: [Medication] = []
    @Published var selectedMedication: Medication?
    @Published var isLoading = false
    @Published var showingAddSheet = false
    @Published var errorMessage: String?
    
    private var modelContext: ModelContext?
    
    func setup(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadMedications()
    }
    
    func loadMedications() {
        guard let modelContext = modelContext else { return }
        
        let descriptor = FetchDescriptor<Medication>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        
        do {
            medications = try modelContext.fetch(descriptor)
        } catch {
            errorMessage = "Failed to load medications: \(error.localizedDescription)"
        }
    }
    
    var activeMedications: [Medication] {
        medications.filter { $0.isActive }
    }
    
    var inactiveMedications: [Medication] {
        medications.filter { !$0.isActive }
    }
    
    func addMedication(
        name: String,
        dosage: Double,
        dosageUnit: String,
        frequency: Int,
        injectionSite: String
    ) {
        guard let modelContext = modelContext else { return }
        
        let medication = Medication(
            name: name,
            dosage: dosage,
            dosageUnit: dosageUnit,
            frequency: frequency,
            injectionSite: injectionSite
        )
        
        modelContext.insert(medication)
        
        do {
            try modelContext.save()
            loadMedications()
        } catch {
            errorMessage = "Failed to save medication: \(error.localizedDescription)"
        }
    }
    
    func updateMedication(_ medication: Medication) {
        guard let modelContext = modelContext else { return }
        
        do {
            try modelContext.save()
            loadMedications()
        } catch {
            errorMessage = "Failed to update medication: \(error.localizedDescription)"
        }
    }
    
    func deleteMedication(_ medication: Medication) {
        guard let modelContext = modelContext else { return }
        
        modelContext.delete(medication)
        
        do {
            try modelContext.save()
            loadMedications()
        } catch {
            errorMessage = "Failed to delete medication: \(error.localizedDescription)"
        }
    }
    
    func toggleActive(_ medication: Medication) {
        medication.isActive.toggle()
        updateMedication(medication)
    }
}
