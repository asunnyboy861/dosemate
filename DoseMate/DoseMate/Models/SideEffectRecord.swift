import Foundation
import SwiftData

@Model
final class SideEffectRecord {
    var id: UUID
    var date: Date
    var symptom: String
    var severity: Int
    var duration: String
    var notes: String
    var createdAt: Date
    
    init(
        date: Date = Date(),
        symptom: String,
        severity: Int
    ) {
        self.id = UUID()
        self.date = date
        self.symptom = symptom
        self.severity = severity
        self.duration = ""
        self.notes = ""
        self.createdAt = Date()
    }
}
