import Foundation
import SwiftUI
import SwiftData
import Combine

@MainActor
final class InjectionViewModel: ObservableObject {
    @Published var injections: [InjectionRecord] = []
    @Published var selectedInjection: InjectionRecord?
    @Published var isLoading = false
    @Published var showingAddSheet = false
    @Published var errorMessage: String?
    
    private var modelContext: ModelContext?
    
    func setup(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadInjections()
    }
    
    func loadInjections() {
        guard let modelContext = modelContext else { return }
        
        let descriptor = FetchDescriptor<InjectionRecord>(
            sortBy: [SortDescriptor(\.injectionDate, order: .reverse)]
        )
        
        do {
            injections = try modelContext.fetch(descriptor)
        } catch {
            errorMessage = "Failed to load injections: \(error.localizedDescription)"
        }
    }
    
    var todayInjections: [InjectionRecord] {
        injections.filter { $0.injectionDate.isToday }
    }
    
    var thisWeekInjections: [InjectionRecord] {
        let weekAgo = Date().adding(days: -7)
        return injections.filter { $0.injectionDate >= weekAgo }
    }
    
    var groupedByDate: [Date: [InjectionRecord]] {
        Dictionary(grouping: injections) { Calendar.current.startOfDay(for: $0.injectionDate) }
    }
    
    var sortedDates: [Date] {
        groupedByDate.keys.sorted(by: >)
    }
    
    func addInjection(
        medication: Medication,
        injectionDate: Date,
        dosage: Double,
        site: String,
        sideEffects: String = "",
        notes: String = "",
        mood: String = "",
        appetiteLevel: Int = 5
    ) {
        guard let modelContext = modelContext else { return }
        
        let record = InjectionRecord(
            injectionDate: injectionDate,
            dosage: dosage,
            site: site
        )
        record.sideEffects = sideEffects
        record.notes = notes
        record.mood = mood
        record.appetiteLevel = appetiteLevel
        record.medication = medication
        
        modelContext.insert(record)
        
        do {
            try modelContext.save()
            loadInjections()
        } catch {
            errorMessage = "Failed to save injection: \(error.localizedDescription)"
        }
    }
    
    func deleteInjection(_ injection: InjectionRecord) {
        guard let modelContext = modelContext else { return }
        
        modelContext.delete(injection)
        
        do {
            try modelContext.save()
            loadInjections()
        } catch {
            errorMessage = "Failed to delete injection: \(error.localizedDescription)"
        }
    }
}
