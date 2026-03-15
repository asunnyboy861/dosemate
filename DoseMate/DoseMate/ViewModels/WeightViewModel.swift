import Foundation
import SwiftUI
import SwiftData
import Combine

@MainActor
final class WeightViewModel: ObservableObject {
    @Published var weightRecords: [WeightRecord] = []
    @Published var isLoading = false
    @Published var showingAddSheet = false
    @Published var useMetric = false
    @Published var errorMessage: String?
    
    private var modelContext: ModelContext?
    
    func setup(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadWeights()
    }
    
    func loadWeights() {
        guard let modelContext = modelContext else { return }
        
        let descriptor = FetchDescriptor<WeightRecord>(
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        
        do {
            weightRecords = try modelContext.fetch(descriptor)
        } catch {
            errorMessage = "Failed to load weights: \(error.localizedDescription)"
        }
    }
    
    var latestWeight: WeightRecord? {
        weightRecords.first
    }
    
    var oldestWeight: WeightRecord? {
        weightRecords.last
    }
    
    var totalWeightChange: Double? {
        guard let latest = latestWeight, let oldest = oldestWeight else {
            return nil
        }
        return latest.weight - oldest.weight
    }
    
    var averageWeight: Double? {
        guard !weightRecords.isEmpty else { return nil }
        return weightRecords.reduce(0) { $0 + $1.weight } / Double(weightRecords.count)
    }
    
    var chartData: [(Date, Double)] {
        weightRecords
            .sorted { $0.date < $1.date }
            .map { ($0.date, useMetric ? $0.weight * 0.453592 : $0.weight) }
    }
    
    func addWeight(date: Date, weight: Double, notes: String = "") {
        guard let modelContext = modelContext else { return }
        
        let unit = useMetric ? "kg" : "lbs"
        let record = WeightRecord(date: date, weight: weight, unit: unit)
        record.notes = notes
        
        modelContext.insert(record)
        
        do {
            try modelContext.save()
            loadWeights()
            
            Task {
                try? await HealthKitManager.shared.saveWeight(
                    weight: weight,
                    date: date,
                    unit: unit
                )
            }
        } catch {
            errorMessage = "Failed to save weight: \(error.localizedDescription)"
        }
    }
    
    func deleteWeight(_ weight: WeightRecord) {
        guard let modelContext = modelContext else { return }
        
        modelContext.delete(weight)
        
        do {
            try modelContext.save()
            loadWeights()
        } catch {
            errorMessage = "Failed to delete weight: \(error.localizedDescription)"
        }
    }
    
    func syncFromHealthKit() async {
        guard let modelContext = modelContext else { return }
        
        let startDate = Date().adding(days: -90)
        
        do {
            let healthKitData = try await HealthKitManager.shared.fetchWeightData(from: startDate)
            
            for (date, weight) in healthKitData {
                let record = WeightRecord(date: date, weight: weight, unit: "lbs")
                modelContext.insert(record)
            }
            
            try modelContext.save()
            loadWeights()
        } catch {
            errorMessage = "Failed to sync from HealthKit: \(error.localizedDescription)"
        }
    }
}
