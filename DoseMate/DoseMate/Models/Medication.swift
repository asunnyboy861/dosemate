import Foundation
import SwiftData

@Model
final class Medication {
    var id: UUID
    var name: String
    var dosage: Double
    var dosageUnit: String
    var frequency: Int
    var injectionSite: String
    var startDate: Date
    var notes: String
    var isActive: Bool
    var createdAt: Date
    
    @Relationship(deleteRule: .cascade, inverse: \InjectionRecord.medication)
    var injectionRecords: [InjectionRecord]
    
    init(
        name: String,
        dosage: Double,
        dosageUnit: String = "mg",
        frequency: Int = 1,
        injectionSite: String = "Abdomen"
    ) {
        self.id = UUID()
        self.name = name
        self.dosage = dosage
        self.dosageUnit = dosageUnit
        self.frequency = frequency
        self.injectionSite = injectionSite
        self.startDate = Date()
        self.notes = ""
        self.isActive = true
        self.createdAt = Date()
        self.injectionRecords = []
    }
}
