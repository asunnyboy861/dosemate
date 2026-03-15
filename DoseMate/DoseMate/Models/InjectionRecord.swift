import Foundation
import SwiftData

@Model
final class InjectionRecord {
    var id: UUID
    var injectionDate: Date
    var dosage: Double
    var site: String
    var sideEffects: String
    var notes: String
    var mood: String
    var appetiteLevel: Int
    var createdAt: Date
    
    var medication: Medication?
    
    init(
        injectionDate: Date = Date(),
        dosage: Double,
        site: String = "Abdomen"
    ) {
        self.id = UUID()
        self.injectionDate = injectionDate
        self.dosage = dosage
        self.site = site
        self.sideEffects = ""
        self.notes = ""
        self.mood = ""
        self.appetiteLevel = 5
        self.createdAt = Date()
    }
}
