import Foundation
import SwiftUI

enum AppConstants {
    enum InjectionSites {
        static let all = ["Abdomen", "Thigh", "Upper Arm", "Buttock"]
    }
    
    enum MedicationNames {
        static let common = [
            "Mounjaro",
            "Zepbound",
            "Wegovy",
            "Ozempic",
            "Trulicity",
            "Victoza",
            "Saxenda",
            "Rybelsus",
            "Other"
        ]
    }
    
    enum DosageUnits {
        static let all = ["mg", "mcg", "units"]
    }
    
    enum MoodOptions {
        static let all = ["Great", "Good", "Okay", "Bad", "Terrible"]
    }
    
    enum SideEffects {
        static let common = [
            "Nausea",
            "Vomiting",
            "Diarrhea",
            "Constipation",
            "Headache",
            "Fatigue",
            "Dizziness",
            "Injection Site Reaction",
            "Loss of Appetite",
            "Stomach Pain",
            "Acid Reflux",
            "Other"
        ]
    }
}
