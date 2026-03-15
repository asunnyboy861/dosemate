import SwiftUI
import SwiftData

struct AddMedicationView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = MedicationViewModel()
    
    @State private var name = ""
    @State private var dosage: Double = 2.5
    @State private var dosageUnit = "mg"
    @State private var frequency = 1
    @State private var injectionSite = "Abdomen"
    @State private var notes = ""
    
    let frequencyOptions = [1, 2, 3, 4, 5, 6, 7]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Medication") {
                    Picker("Name", selection: $name) {
                        Text("Select").tag("")
                        ForEach(AppConstants.MedicationNames.common, id: \.self) { medName in
                            Text(medName).tag(medName)
                        }
                    }
                }
                
                Section("Dosage") {
                    HStack {
                        TextField("Amount", value: $dosage, format: .number)
                            .keyboardType(.decimalPad)
                        
                        Picker("Unit", selection: $dosageUnit) {
                            ForEach(AppConstants.DosageUnits.all, id: \.self) { unit in
                                Text(unit).tag(unit)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                    
                    Picker("Frequency", selection: $frequency) {
                        ForEach(frequencyOptions, id: \.self) { freq in
                            Text("\(freq) time\(freq > 1 ? "s" : "")/week").tag(freq)
                        }
                    }
                }
                
                Section("Injection") {
                    Picker("Site", selection: $injectionSite) {
                        ForEach(AppConstants.InjectionSites.all, id: \.self) { site in
                            Text(site).tag(site)
                        }
                    }
                }
                
                Section("Notes") {
                    TextField("Optional notes", text: $notes, axis: .vertical)
                        .lineLimit(3)
                }
            }
            .navigationTitle("Add Medication")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveMedication()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
        .onAppear {
            viewModel.setup(modelContext: modelContext)
        }
    }
    
    private func saveMedication() {
        let medication = Medication(
            name: name,
            dosage: dosage,
            dosageUnit: dosageUnit,
            frequency: frequency,
            injectionSite: injectionSite
        )
        medication.notes = notes
        
        modelContext.insert(medication)
        dismiss()
    }
}

#Preview {
    AddMedicationView()
        .modelContainer(for: Medication.self)
}
