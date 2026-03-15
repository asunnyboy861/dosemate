import Foundation
import HealthKit

final class HealthKitManager: ObservableObject {
    static let shared = HealthKitManager()
    
    private let healthStore = HKHealthStore()
    
    @Published var isAuthorized = false
    @Published var isHealthKitAvailable = false
    
    private init() {
        isHealthKitAvailable = HKHealthStore.isHealthDataAvailable()
    }
    
    func requestAuthorization() async throws {
        guard isHealthKitAvailable else {
            throw HealthKitError.notAvailable
        }
        
        let typesToRead: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .bodyMass)!,
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
        ]
        
        let typesToWrite: Set<HKSampleType> = [
            HKObjectType.quantityType(forIdentifier: .bodyMass)!
        ]
        
        try await healthStore.requestAuthorization(toShare: typesToWrite, read: typesToRead)
        
        await MainActor.run {
            self.isAuthorized = true
        }
    }
    
    func saveWeight(weight: Double, date: Date, unit: String) async throws {
        guard let weightType = HKObjectType.quantityType(forIdentifier: .bodyMass) else {
            throw HealthKitError.typeNotAvailable
        }
        
        let weightInKg: Double
        if unit == "lbs" {
            weightInKg = weight * 0.453592
        } else {
            weightInKg = weight
        }
        
        let quantity = HKQuantity(unit: .gramUnit(with: .kilo), doubleValue: weightInKg)
        let sample = HKQuantitySample(
            type: weightType,
            quantity: quantity,
            start: date,
            end: date
        )
        
        try await healthStore.save(sample)
    }
    
    func fetchWeightData(from startDate: Date) async throws -> [(Date, Double)] {
        guard let weightType = HKObjectType.quantityType(forIdentifier: .bodyMass) else {
            throw HealthKitError.typeNotAvailable
        }
        
        let predicate = HKQuery.predicateForSamples(
            withStart: startDate,
            end: Date(),
            options: .strictStartDate
        )
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        
        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: weightType,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [sortDescriptor]
            ) { _, samples, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let quantitySamples = samples as? [HKQuantitySample] else {
                    continuation.resume(returning: [])
                    return
                }
                
                let results = quantitySamples.map { sample in
                    let weightInKg = sample.quantity.doubleValue(for: .gramUnit(with: .kilo))
                    let weightInLbs = weightInKg * 2.20462
                    return (sample.startDate, weightInLbs)
                }
                
                continuation.resume(returning: results)
            }
            
            healthStore.execute(query)
        }
    }
}

enum HealthKitError: LocalizedError {
    case notAvailable
    case typeNotAvailable
    case authorizationDenied
    
    var errorDescription: String? {
        switch self {
        case .notAvailable:
            return "HealthKit is not available on this device"
        case .typeNotAvailable:
            return "The requested health data type is not available"
        case .authorizationDenied:
            return "Health data access was denied"
        }
    }
}
