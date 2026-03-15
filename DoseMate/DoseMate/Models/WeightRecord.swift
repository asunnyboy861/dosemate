import Foundation
import SwiftData

@Model
final class WeightRecord {
    var id: UUID
    var date: Date
    var weight: Double
    var unit: String
    var notes: String
    var createdAt: Date
    
    init(
        date: Date = Date(),
        weight: Double,
        unit: String = "lbs"
    ) {
        self.id = UUID()
        self.date = date
        self.weight = weight
        self.unit = unit
        self.notes = ""
        self.createdAt = Date()
    }
}
