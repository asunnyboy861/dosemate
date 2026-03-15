import SwiftUI
import SwiftData

struct InjectionHistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = InjectionViewModel()
    @State private var showingAddSheet = false
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.injections.isEmpty {
                    emptyState
                } else {
                    injectionList
                }
            }
            .navigationTitle("Injections")
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
                AddInjectionView(viewModel: viewModel)
            }
        }
        .onAppear {
            viewModel.setup(modelContext: modelContext)
        }
    }
    
    private var emptyState: some View {
        EmptyStateView(
            icon: "syringe",
            title: "No Injections",
            message: "Record your first injection to track your progress",
            actionTitle: "Add Injection",
            action: { showingAddSheet = true }
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
    
    private var injectionList: some View {
        List {
            ForEach(viewModel.sortedDates, id: \.self) { date in
                Section {
                    if let injections = viewModel.groupedByDate[date] {
                        ForEach(injections) { injection in
                            InjectionRowView(injection: injection)
                        }
                        .onDelete { indexSet in
                            let injectionsForDate = injections
                            for index in indexSet {
                                viewModel.deleteInjection(injectionsForDate[index])
                            }
                        }
                    }
                } header: {
                    Text(dateHeaderText(for: date))
                }
            }
        }
        .listStyle(.insetGrouped)
    }
    
    private func dateHeaderText(for date: Date) -> String {
        if date.isToday {
            return "Today"
        } else if date.isYesterday {
            return "Yesterday"
        } else {
            return date.formattedMedium
        }
    }
}

struct AddInjectionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var viewModel: InjectionViewModel
    
    @Query(sort: \Medication.name) private var medications: [Medication]
    
    @State private var selectedMedication: Medication?
    @State private var injectionDate = Date()
    @State private var dosage: Double = 2.5
    @State private var injectionSite = "Abdomen"
    @State private var sideEffects = ""
    @State private var notes = ""
    @State private var mood = ""
    @State private var appetiteLevel = 5
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Medication") {
                    if medications.isEmpty {
                        Text("No medications added yet")
                            .foregroundColor(.secondary)
                    } else {
                        Picker("Select Medication", selection: $selectedMedication) {
                            Text("Choose medication").tag(nil as Medication?)
                            ForEach(medications) { med in
                                Text(med.name).tag(med as Medication?)
                            }
                        }
                    }
                }
                
                Section("Injection Details") {
                    DatePicker("Date & Time", selection: $injectionDate)
                    
                    if let medication = selectedMedication {
                        HStack {
                            Text("Dosage")
                            Spacer()
                            TextField("Amount", value: $dosage, format: .number)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                            Text(medication.dosageUnit)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Picker("Injection Site", selection: $injectionSite) {
                        ForEach(AppConstants.InjectionSites.all, id: \.self) { site in
                            Text(site).tag(site)
                        }
                    }
                }
                
                Section("How are you feeling?") {
                    Picker("Mood", selection: $mood) {
                        Text("Select mood").tag("")
                        ForEach(AppConstants.MoodOptions.all, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Appetite Level: \(appetiteLevel)/10")
                        Slider(value: Binding(
                            get: { Double(appetiteLevel) },
                            set: { appetiteLevel = Int($0) }
                        ), in: 1...10, step: 1)
                    }
                }
                
                Section("Side Effects (Optional)") {
                    TextField("Describe any side effects", text: $sideEffects, axis: .vertical)
                        .lineLimit(3)
                }
                
                Section("Notes") {
                    TextField("Additional notes", text: $notes, axis: .vertical)
                        .lineLimit(3)
                }
            }
            .navigationTitle("Record Injection")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveInjection()
                    }
                    .disabled(selectedMedication == nil)
                }
            }
        }
    }
    
    private func saveInjection() {
        guard let medication = selectedMedication else { return }
        
        viewModel.addInjection(
            medication: medication,
            injectionDate: injectionDate,
            dosage: dosage,
            site: injectionSite,
            sideEffects: sideEffects,
            notes: notes,
            mood: mood,
            appetiteLevel: appetiteLevel
        )
        
        if let nextDate = Calendar.current.date(byAdding: .day, value: 7 / medication.frequency, to: injectionDate) {
            NotificationManager.shared.scheduleInjectionReminder(
                medicationName: medication.name,
                nextInjectionDate: nextDate,
                dosage: "\(String(format: "%.1f", dosage)) \(medication.dosageUnit)",
                identifier: medication.id.uuidString
            )
        }
        
        dismiss()
    }
}

#Preview {
    InjectionHistoryView()
        .modelContainer(for: [Medication.self, InjectionRecord.self])
}
