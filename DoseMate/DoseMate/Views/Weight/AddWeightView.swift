import SwiftUI
import SwiftData

struct AddWeightView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var viewModel: WeightViewModel
    
    @State private var weightText = ""
    @State private var date = Date()
    
    private var unit: String {
        viewModel.useMetric ? "kg" : "lbs"
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Weight Details") {
                    HStack {
                        TextField("Weight (\(unit))", text: $weightText)
                            .keyboardType(.decimalPad)
                        
                        Text(unit)
                            .foregroundColor(.secondary)
                    }
                    
                    DatePicker("Date & Time", selection: $date, displayedComponents: [.date, .hourAndMinute])
                }
            }
            .navigationTitle("Log Weight")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveWeight()
                        dismiss()
                    }
                    .disabled(weightText.isEmpty || Double(weightText) == nil)
                }
            }
        }
    }
    
    private func saveWeight() {
        guard let weightValue = Double(weightText) else { return }
        
        let weightRecord = WeightRecord(
            date: date,
            weight: weightValue,
            unit: unit
        )
        
        modelContext.insert(weightRecord)
    }
}

#Preview {
    AddWeightView(viewModel: WeightViewModel())
        .modelContainer(for: WeightRecord.self)
}
