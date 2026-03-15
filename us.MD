# DoseMate - GLP-1 Medication Tracker
## US Market iOS App Development Operation Guide

**Document Version**: 1.0  
**Created Date**: March 15, 2026  
**Target Market**: United States  
**Target iOS Version**: iOS 17.0+ (Recommended) / iOS 15.0+ (Compatible)  
**Technology Stack**: Swift + SwiftUI + SwiftData + HealthKit + Charts

---

## Table of Contents

1. [Project Overview & Market Analysis](#1-project-overview--market-analysis)
2. [GitHub Open-Source Projects Analysis](#2-github-open-source-projects-analysis)
3. [US Market Competitor Analysis](#3-us-market-competitor-analysis)
4. [Apple App Store Guidelines](#4-apple-app-store-guidelines)
5. [US Market UI/UX Design Standards](#5-us-market-uiux-design-standards)
6. [Technical Implementation Architecture](#6-technical-implementation-architecture)
7. [Code Generation Rules & Standards](#7-code-generation-rules--standards)
8. [Implementation Process](#8-implementation-process)
9. [Testing & Validation Standards](#9-testing--validation-standards)
10. [UI Acceptance Criteria](#10-ui-acceptance-criteria)

---

## 1. Project Overview & Market Analysis

### 1.1 GLP-1 Medication Market Background

GLP-1 (Glucagon-like peptide-1) receptor agonists are a class of medications used for treating type 2 diabetes and obesity. Key medications include:

| Medication | Brand Names | Type | Primary Use |
|------------|------------|------|-------------|
| Semaglutide | Ozempic, Wegovy | Injection | Diabetes, Weight Loss |
| Tirzepatide | Mounjaro, Zepbound | Injection | Diabetes, Weight Loss |
| Liraglutide | Victoza, Saxenda | Injection | Diabetes, Weight Loss |
| Dulaglutide | Trulicity | Injection | Diabetes |

**Market Size**: The US GLP-1 market represents over 70% of global sales, with estimated 15+ million users currently on these medications for diabetes treatment or weight management.

### 1.2 Target User Demographics

| Segment | Description |
|---------|-------------|
| **Primary Users** | Adults using GLP-1 medications (Mounjaro, Zepbound, Wegovy, Ozempic) |
| **Age Range** | 25-65 years old |
| **Tech Savvy** | Comfortable with smartphone apps and health tracking |
| **Needs** | Injection tracking, weight progress, side effect monitoring |
| **Pain Points** | Existing apps built by non-users, subscription costs, complex interfaces |

### 1.3 Core Value Proposition

**DoseMate** - Created by users, for users. Built by two people who are actually on GLP-1 medications, this app addresses real pain points that technical developers often miss.

---

## 2. GitHub Open-Source Projects Analysis

### 2.1 Health Tracking Projects

| Project Name | Technology Stack | Stars | Core Functions | Development Value |
|--------------|------------------|-------|----------------|-------------------|
| HealthTrack | SwiftUI + HealthKit + Charts | Low | Steps tracking, Weight trends | HIGH |
| WellPath-V2-Mobile-Swift | Swift/SwiftUI + Apple Charts + HealthKit | New | Health tracking platform | HIGH |
| iOS-HealthSync | Swift + HealthKit | Medium | Health metrics + Nutrition API | MEDIUM-HIGH |
| Swift-Project | SwiftUI + Apple Health | New | Fitness progress, Visualization | MEDIUM |

### 2.2 Medication Tracking Projects

| Project Name | Technology Stack | Stars | Core Functions | Development Value |
|--------------|------------------|-------|----------------|-------------------|
| **Pain-Meds-Buddy-Public** | SwiftUI + CoreData | New | Drug tracking, Dose reminders | **VERY HIGH** |
| MedMinder | Swift + SwiftUI | Medium | Medication reminders | HIGH |
| reminder-app | Swift + UIKit | New | Medication reminders | MEDIUM |
| Mediminder | Swift 4 | Old | Medication reminders | LOW |

### 2.3 Weight Tracking Projects

| Project Name | Technology Stack | Core Functions | Development Value |
|--------------|------------------|----------------|-------------------|
| WeightTracker | SwiftUI | Weight logging, Trend charts | HIGH |
| DietMonitor | Swift + SwiftUI + Spring Boot | Calorie tracking, Weight monitoring | MEDIUM |
| HydrateTrackerApp | SwiftUI | Water tracking, Reminders | MEDIUM |

### 2.4 Best Reference Project: Pain-Meds-Buddy-Public

This project is the most valuable reference for secondary development:

**Core Architecture**:
- **Home Page**: Summary of all medications with progress ring showing next dose time
- **Medication List**: Display all configured medications with icon recognition
- **Add Medication**: Set medication name, dosage, duration, interval
- **Dose Recording**: Record each dose with "Active" and "History" views
- **Reminder Function**: Push notifications when dose interval is due

**Technology Stack** (must convert to native Swift):
- ~~CoreData~~ → **SwiftData** (iOS 17+)
- ~~UIKit components~~ → **Pure SwiftUI**
- ~~Custom Combine implementations~~ → **Native Swift Concurrency**

**Data Models** (reference for conversion):
```swift
// Original CoreData Entity - Convert to SwiftData
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
    
    @Relationship(deleteRule: .cascade, inverse: \InjectionRecord.medication)
    var injectionRecords: [InjectionRecord]
}

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
    
    var medication: Medication?
}
```

### 2.5 GitHub Projects for Secondary Development

| Project | URL | License | Commercial Use |
|---------|-----|---------|----------------|
| Pain-Meds-Buddy-Public | github.com/JulesMoorhouse/Pain-Meds-Buddy-Public | MIT | ✅ Free to use |
| HealthTrack | github.com/sahaj1519/HealthTrack | Not specified | ⚠️ Need to confirm |
| WellPath-V2-Mobile-Swift | github.com/keegs-3/WellPath-V2-Mobile-Swift | Not specified | ⚠️ Need to confirm |
| WeightTracker | github.com/RyuichiNariyama/WeightTracker | Not specified | ⚠️ Need to confirm |

**Recommendation**: Prioritize MIT licensed projects or contact authors for commercial authorization.

---

## 3. US Market Competitor Analysis

### 3.1 Existing GLP-1 Tracker Apps

| App Name | Rating | Price | Strengths | Weaknesses |
|----------|--------|-------|----------|------------|
| GLP 1 Tracker by GlucoPal | 4.8 | Free (Subscription) | Full features, Beautiful UI | Expensive subscription |
| GLP1 Tracker (Hussain Mustafa) | 4.8 | Free (Subscription) | Detailed injection records | High cost ($4.99-$79.99) |
| Existing GLP-1 Apps | 3.0-4.5 | Various | Basic tracking | Non-user perspective, incomplete features |

### 3.2 Market Gaps & Opportunities

| Gap | Opportunity | Priority |
|-----|-------------|----------|
| Subscription fatigue | Free with optional one-time purchase | HIGH |
| Non-user developers | Build by actual GLP-1 users | HIGH |
| Complex interfaces | Simple, intuitive design | HIGH |
| Missing features | Add side effect tracking, doctor reports | MEDIUM |
| HealthKit integration | Sync with Apple Health | MEDIUM |

### 3.3 Key Differentiators for DoseMate

1. **User-Centric Design**: Built by actual GLP-1 users who understand real pain points
2. **No Subscription**: One-time purchase model with lifetime access
3. **Smart Reminders**: AI-powered reminders based on dosage schedule
4. **Doctor Reports**: Export PDF reports for healthcare providers
5. **HealthKit Integration**: Sync weight data with Apple Health

---

## 4. Apple App Store Guidelines

### 4.1 Health & Medical App Requirements

| Requirement | Description | Implementation |
|-------------|-------------|----------------|
| **Privacy Policy** | Required for all health apps | Add to App Store Connect |
| **Data Collection Disclosure** | Must disclose all collected data | Info.plist + App Store listing |
| **No Medical Claims** | Cannot claim to treat/diagnose | Disclaimer in app |
| **HealthKit Permissions** | Required for health data | Proper authorization flow |
| **Age Rating** | Typically 12+ for health apps | Configure in App Store Connect |

### 4.2 Required Info.plist Keys

```xml
<!-- HealthKit Usage Description -->
<key>NSHealthShareUsageDescription</key>
<string>DoseMate needs access to your health data to sync weight information and provide comprehensive health insights.</string>

<key>NSHealthUpdateUsageDescription</key>
<string>DoseMate needs permission to save your injection records and weight data to Apple Health.</string>

<!-- Notifications -->
<key>UIBackgroundModes</key>
<array>
    <string>remote-notification</string>
</array>

<!-- Privacy -->
<key>NSPrivacyAccessedAPITypes</key>
<array>
    <dict>
        <key>NSPrivacyAccessedAPIType</key>
        <string>NSPrivacyAccessedAPICategoryUserDefaults</string>
    </dict>
</array>
```

### 4.3 App Store Review Guidelines - Key Points

| Guideline | Requirement | How to Address |
|-----------|-------------|----------------|
| **Section 1.1** | App must be functional | Thorough testing before submission |
| **Section 2.3** | Accurate metadata | Clear, non-misleading descriptions |
| **Section 3.1** | In-app purchases must work | Test all purchase flows |
| **Section 5.1** | Privacy requirements | Clear privacy policy, user consent |
| **Health Apps** | No false claims | Disclaimer: "Not medical advice" |

### 4.4 Apple Review Rejection Prevention

| Common Rejection | Prevention |
|------------------|-------------|
| Missing privacy policy | Add privacy policy URL in App Store Connect |
| Crash on launch | Test extensively on all target devices |
| Incomplete functionality | Implement all advertised features |
| Misleading description | Ensure description matches functionality |
| Health data issues | Proper authorization, clear data usage |

---

## 5. US Market UI/UX Design Standards

### 5.1 Current US Market Design Trends

| Trend | Description | Implementation |
|-------|-------------|----------------|
| **Liquid Glass** | iOS 18 new glassmorphism | Use `.glassMaterial` in SwiftUI |
| **Minimalism** | Clean, focused interfaces | Reduce visual clutter |
| **Large Typography** | Bold, readable text | Use SF Pro Display |
| **Rounded Corners** | 20-44pt radius | Consistent cornerRadius |
| **Dark Mode** | Full dark support | Test all views in dark mode |

### 5.2 Color Palette Recommendation

| Color | Hex Code | Usage |
|-------|----------|-------|
| Primary Blue | #007AFF | Main actions, highlights |
| Success Green | #34C759 | Positive feedback, weight loss |
| Warning Orange | #FF9500 | Side effects, cautions |
| Error Red | #FF3B30 | Errors, severe side effects |
| Background | System (Adaptive) | Automatic light/dark |
| Surface | #F2F2F7 (Light) / #1C1C1E (Dark) | Cards, containers |

### 5.3 Typography Standards (SF Pro)

| Style | Size | Weight | Usage |
|-------|------|--------|-------|
| Large Title | 34pt | Bold | Screen titles |
| Title 1 | 28pt | Bold | Section headers |
| Title 2 | 22pt | Bold | Card titles |
| Title 3 | 20pt | Semibold | Subsection headers |
| Headline | 17pt | Semibold | Important labels |
| Body | 17pt | Regular | Main content |
| Callout | 16pt | Regular | Secondary content |
| Subheadline | 15pt | Regular | Supporting text |
| Footnote | 13pt | Regular | Timestamps, captions |
| Caption | 12pt | Regular | Minor details |

### 5.4 Spacing System (8pt Grid)

| Spacing | Value | Usage |
|---------|-------|-------|
| xs | 4pt | Icon padding |
| sm | 8pt | Inner element spacing |
| md | 16pt | Standard margins |
| lg | 24pt | Section spacing |
| xl | 32pt | Major section breaks |
| xxl | 48pt | Screen padding top/bottom |

### 5.5 Navigation Structure

```
Tab Bar (Main Navigation)
├── Home (Dashboard)
│   ├── Today's status card
│   ├── Next injection countdown
│   ├── Quick add button
│   └── Recent activity
├── Medications
│   ├── Active medications list
│   ├── Add new medication
│   └── Medication details
├── Injections
│   ├── Injection history
│   ├── Calendar view
│   └── Add injection
├── Weight
│   ├── Weight chart
│   ├── Statistics
│   └── Add weight
└── Settings
    ├── Profile
    ├── Notifications
    ├── Units (lbs/kg)
    ├── HealthKit sync
    └── Export data
```

### 5.6 Component Library

| Component | Description | States |
|-----------|-------------|--------|
| PrimaryButton | Main CTA button | Default, Pressed, Disabled, Loading |
| SecondaryButton | Secondary actions | Default, Pressed, Disabled |
| MedicationCard | Medication display | Active, Inactive |
| InjectionRow | Injection history item | Normal, With side effects |
| WeightChart | Weight trend visualization | Loading, Loaded, Empty |
| ReminderCard | Upcoming reminder | Pending, Completed |
| SideEffectBadge | Side effect indicator | Mild, Moderate, Severe |

---

## 6. Technical Implementation Architecture

### 6.1 Technology Stack

| Category | Technology | Version | Notes |
|----------|------------|---------|-------|
| **UI Framework** | SwiftUI | iOS 17+ | Primary UI framework |
| **Data Persistence** | SwiftData | iOS 17+ | Core Data replacement |
| **Health Data** | HealthKit | iOS 15+ | Apple Health integration |
| **Charts** | Swift Charts | iOS 16+ | Native chart framework |
| **Notifications** | UserNotifications | iOS 15+ | Local notifications |
| **Data Sync** | CloudKit | iOS 15+ | Optional sync |
| **PDF Generation** | PDFKit | iOS 15+ | Doctor reports |

### 6.2 Architecture Pattern: MVVM

```
┌─────────────────────────────────────────────────────┐
│                    Architecture                      │
└─────────────────────────────────────────────────────┘

┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│    View     │ ←── │  ViewModel  │ ←── │    Model    │
│  (SwiftUI)  │     │ (Observable)│     │ (SwiftData) │
└─────────────┘     └─────────────┘     └─────────────┘
                           ↓
                    ┌─────────────┐
                    │  Services   │
                    │ - HealthKit │
                    │ - Notifs    │
                    │ - PDF       │
                    └─────────────┘
```

### 6.3 File Structure

```
DoseMate/
├── App/
│   ├── DoseMateApp.swift
│   └── AppDelegate.swift
├── Models/
│   ├── Medication.swift
│   ├── InjectionRecord.swift
│   ├── WeightRecord.swift
│   └── SideEffectRecord.swift
├── ViewModels/
│   ├── HomeViewModel.swift
│   ├── MedicationViewModel.swift
│   ├── InjectionViewModel.swift
│   ├── WeightViewModel.swift
│   └── SettingsViewModel.swift
├── Views/
│   ├── Home/
│   │   ├── HomeView.swift
│   │   ├── DashboardCard.swift
│   │   └── QuickAddButton.swift
│   ├── Medications/
│   │   ├── MedicationListView.swift
│   │   ├── MedicationDetailView.swift
│   │   └── AddMedicationView.swift
│   ├── Injections/
│   │   ├── InjectionHistoryView.swift
│   │   ├── InjectionCalendarView.swift
│   │   └── AddInjectionView.swift
│   ├── Weight/
│   │   ├── WeightChartView.swift
│   │   ├── WeightListView.swift
│   │   └── AddWeightView.swift
│   └── Settings/
│       ├── SettingsView.swift
│       └── ProfileView.swift
├── Components/
│   ├── PrimaryButton.swift
│   ├── MedicationCard.swift
│   ├── InjectionRow.swift
│   ├── WeightChart.swift
│   └── SideEffectBadge.swift
├── Services/
│   ├── HealthKitManager.swift
│   ├── NotificationManager.swift
│   ├── PDFGenerator.swift
│   └── DataExporter.swift
├── Utilities/
│   ├── Constants.swift
│   ├── Extensions.swift
│   └── Theme.swift
└── Resources/
    ├── Assets.xcassets
    └── Localizable.strings
```

### 6.4 Data Models (SwiftData)

```swift
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
    
    init(name: String, dosage: Double, dosageUnit: String = "mg", frequency: Int = 1) {
        self.id = UUID()
        self.name = name
        self.dosage = dosage
        self.dosageUnit = dosageUnit
        self.frequency = frequency
        self.injectionSite = "Abdomen"
        self.startDate = Date()
        self.isActive = true
        self.createdAt = Date()
    }
}

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
    
    init(injectionDate: Date, dosage: Double, site: String) {
        self.id = UUID()
        self.injectionDate = injectionDate
        self.dosage = dosage
        self.site = site
        self.appetiteLevel = 5
        self.createdAt = Date()
    }
}

@Model
final class WeightRecord {
    var id: UUID
    var date: Date
    var weight: Double
    var unit: String
    var notes: String
    var createdAt: Date
    
    init(date: Date, weight: Double, unit: String = "lbs") {
        self.id = UUID()
        self.date = date
        self.weight = weight
        self.unit = unit
        self.createdAt = Date()
    }
}

@Model
final class SideEffectRecord {
    var id: UUID
    var date: Date
    var symptom: String
    var severity: Int
    var duration: String
    var notes: String
    var createdAt: Date
    
    init(date: Date, symptom: String, severity: Int) {
        self.id = UUID()
        self.date = date
        self.symptom = symptom
        self.severity = severity
        self.createdAt = Date()
    }
}
```

---

## 7. Code Generation Rules & Standards

### 7.1 Module Organization Principle

**Rule**: One function = One module (Single Responsibility)

| Module Type | Naming Convention | Example |
|-------------|-------------------|---------|
| Views | `{Feature}View.swift` | `InjectionHistoryView.swift` |
| ViewModels | `{Feature}ViewModel.swift` | `InjectionViewModel.swift` |
| Models | `{Entity}Model.swift` | `MedicationModel.swift` |
| Services | `{Feature}Service.swift` | `HealthKitService.swift` |
| Components | `{ComponentName}.swift` | `PrimaryButton.swift` |

### 7.2 Code Reuse Principle

**Rule**: Combine similar code, follow "Three Rule" (extract after 3 repetitions)

| Scenario | Action |
|----------|--------|
| Similar code appears 3 times | Extract to reusable component |
| Similar logic in multiple ViewModels | Extract to shared Service |
| Repeated UI patterns | Create Component |
| Repeated data operations | Create Repository |

**Example - Button Component**:
```swift
// Instead of repeating button styles:
struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var isLoading: Bool = false
    var isDisabled: Bool = false
    
    var body: some View {
        Button(action: action) {
            HStack {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                }
                Text(title)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(isDisabled ? Color.gray : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        .disabled(isDisabled || isLoading)
    }
}
```

### 7.3 Code Cleanup Principle

**Rule**: Clean up deprecated code when replacing

| Step | Action |
|------|--------|
| 1. Mark deprecated | Add `@available(*, deprecated)` |
| 2. Verify no impact | Run tests, check all usages |
| 3. Remove completely | Delete old code |
| 4. Commit with message | "Clean up: Removed deprecated [component]" |

### 7.4 Open Source Integration Rules

**Rule**: Use GitHub projects as reference, convert to native Swift

| Source | Action |
|--------|--------|
| UIKit code | Convert to SwiftUI |
| CoreData code | Convert to SwiftData |
| Third-party libraries | Replace with native frameworks |
| Custom implementations | Use Apple frameworks |

**Allowed Libraries (Native)**:
- SwiftUI (UI)
- SwiftData (Persistence)
- HealthKit (Health data)
- Charts (Visualization)
- UserNotifications (Reminders)
- PDFKit (Report generation)
- CloudKit (Sync)

### 7.5 Native Code Priority Rule

**Rule**: Always prefer native Apple frameworks

| Need | Native Solution | Avoid |
|------|----------------|-------|
| UI | SwiftUI | UIKit (unless required) |
| Data | SwiftData | CoreData, SQLite |
| Charts | Swift Charts | Charts libraries |
| HTTP | URLSession | Alamofire (for simple needs) |
| Images | SF Symbols | Custom icons |

---

## 8. Implementation Process

### 8.1 Development Phases

```
┌─────────────────────────────────────────────────────────────┐
│                   DoseMate Development                      │
└─────────────────────────────────────────────────────────────┘

Phase 1: Project Setup (Week 1)
│
├─ 1.1 Environment
│   ├─ Install Xcode 15+
│   ├─ Configure Apple Developer account
│   └─ Create Git repository
│
├─ 1.2 Requirements
│   ├─ Confirm MVP features
│   ├─ Design data models
│   └─ Create UI mockups
│
└─ 1.3 Dependencies
    ├─ Configure Swift Package Manager
    ├─ Set HealthKit entitlements
    └─ Configure notification capabilities

Phase 2: Core Features (Weeks 2-3)
│
├─ 2.1 Data Layer
│   ├─ Implement SwiftData models
│   ├─ Create Repository layer
│   └─ Implement CRUD operations
│
├─ 2.2 Business Logic
│   ├─ Medication management
│   ├─ Injection recording
│   └─ Weight tracking
│
└─ 2.3 UI Layer
    ├─ Implement tab navigation
    ├─ Create home dashboard
    └─ Build medication list

Phase 3: Advanced Features (Week 4)
│
├─ 3.1 Side Effects
│   ├─ Side effect recording
│   └─ Statistics view
│
├─ 3.2 Charts
│   ├─ Weight trend chart
│   └─ Injection calendar
│
└─ 3.3 Reminders
    ├─ Notification authorization
    ├─ Injection reminders
    └─ Weight log reminders

Phase 4: Integration (Week 5)
│
├─ 4.1 HealthKit
│   ├─ Weight sync
│   └─ Data sharing
│
├─ 4.2 Export
│   ├─ CSV export
│   └─ PDF reports
│
└─ 4.3 Polish
    ├─ Dark mode
    └─ Accessibility

Phase 5: Testing & Launch (Week 6)
│
├─ 5.1 Testing
│   ├─ Unit tests
│   ├─ UI tests
│   └─ Performance tests
│
├─ 5.2 Beta
│   ├─ TestFlight setup
│   └─ Collect feedback
│
└─ 5.3 Launch
    ├─ App Store screenshots
    ├─ Write description
    └─ Submit for review
```

### 8.2 Feature Implementation Order

| Priority | Feature | Complexity | Estimated Time |
|----------|---------|------------|----------------|
| P0 | Medication CRUD | Medium | 2 days |
| P0 | Injection recording | Medium | 2 days |
| P0 | Weight logging | Medium | 2 days |
| P1 | Weight chart | Low | 1 day |
| P1 | Reminders | Medium | 2 days |
| P1 | Side effects | Low | 1 day |
| P2 | HealthKit | High | 2 days |
| P2 | PDF export | Medium | 1 day |
| P2 | Settings | Low | 1 day |

### 8.3 Implementation Checklist

- [ ] Project structure created
- [ ] SwiftData models implemented
- [ ] Home dashboard completed
- [ ] Medication management done
- [ ] Injection tracking done
- [ ] Weight logging done
- [ ] Charts implemented
- [ ] Reminders configured
- [ ] Side effects tracking done
- [ ] HealthKit integration
- [ ] PDF export working
- [ ] Settings page completed
- [ ] Dark mode support
- [ ] Accessibility compliance

---

## 9. Testing & Validation Standards

### 9.1 Unit Testing Requirements

| Test Type | Coverage Target | Tools |
|-----------|----------------|-------|
| Model tests | 90%+ | XCTest |
| ViewModel tests | 80%+ | XCTest |
| Service tests | 80%+ | XCTest |

**Example Test**:
```swift
import XCTest
@testable import DoseMate

final class MedicationModelTests: XCTestCase {
    
    func testMedicationCreation() {
        let medication = Medication(
            name: "Mounjaro",
            dosage: 2.5,
            dosageUnit: "mg",
            frequency: 1
        )
        
        XCTAssertEqual(medication.name, "Mounjaro")
        XCTAssertEqual(medication.dosage, 2.5)
        XCTAssertEqual(medication.dosageUnit, "mg")
        XCTAssertTrue(medication.isActive)
    }
    
    func testInjectionRecordCalculation() {
        // Test injection interval calculation
    }
}
```

### 9.2 UI Testing Requirements

| Test Scenario | Validation |
|---------------|------------|
| Add medication | Form submission works |
| Record injection | Data saved correctly |
| View weight chart | Chart renders with data |
| Notification | Reminder fires correctly |
| Dark mode | All views render correctly |

### 9.3 Performance Standards

| Metric | Target |
|--------|--------|
| App launch time | < 2 seconds |
| View transition | < 300ms |
| Chart render | < 500ms |
| Memory usage | < 100MB |
| Battery impact | Minimal |

### 9.4 Device Compatibility

| Device | Minimum iOS | Recommended iOS |
|--------|-------------|----------------|
| iPhone 15 Pro | iOS 17 | iOS 18 |
| iPhone 15 | iOS 17 | iOS 18 |
| iPhone 14 | iOS 16 | iOS 18 |
| iPhone 13 | iOS 15 | iOS 18 |
| iPhone SE | iOS 15 | iOS 18 |

---

## 10. UI Acceptance Criteria

### 10.1 General UI Standards

| Criterion | Requirement |
|-----------|-------------|
| Consistency | All screens follow same design language |
| Typography | Use SF Pro, follow size hierarchy |
| Colors | Use defined color palette |
| Spacing | Follow 8pt grid system |
| Icons | Use SF Symbols exclusively |
| Accessibility | VoiceOver compatible, Dynamic Type |

### 10.2 Screen-Specific Criteria

#### Home Dashboard
- [ ] Shows today's injection status prominently
- [ ] Displays next injection countdown
- [ ] Quick add button accessible within 2 taps
- [ ] Recent activity list renders correctly
- [ ] Empty states display helpful messages

#### Medication List
- [ ] All medications display with correct info
- [ ] Active/inactive status clearly visible
- [ ] Add medication flow works correctly
- [ ] Edit/delete functionality works
- [ ] Pull to refresh works

#### Injection Recording
- [ ] Date/time picker functions correctly
- [ ] Dosage input accepts decimal values
- [ ] Site selection works (Abdomen, Thigh, Arm, Buttock)
- [ ] Side effects can be logged
- [ ] Save operation completes successfully

#### Weight Tracking
- [ ] Chart displays historical data correctly
- [ ] Unit toggle (lbs/kg) works
- [ ] Statistics calculate accurately
- [ ] Add weight form validates input
- [ ] Data persists after app restart

#### Settings
- [ ] All settings save correctly
- [ ] Notification preferences work
- [ ] Unit preferences apply globally
- [ ] Export functions work
- [ ] HealthKit permissions can be managed

### 10.3 Visual Checkpoints

| Screen | Checkpoint | Validation |
|--------|------------|------------|
| Home | Dashboard card layout | Matches Figma |
| Home | Quick action buttons | Properly spaced |
| Medications | Card shadows | Consistent |
| Injections | List layout | Proper indentation |
| Weight | Chart colors | Match palette |
| Settings | Toggle alignment | Consistent |

### 10.4 Dark Mode Requirements

| Element | Light Mode | Dark Mode |
|---------|-----------|-----------|
| Background | White (#FFFFFF) | Black (#000000) |
| Surface | #F2F2F7 | #1C1C1E |
| Text Primary | #000000 | #FFFFFF |
| Text Secondary | #8E8E93 | #8E8E93 |
| Accent | #007AFF | #0A84FF |

### 10.5 Accessibility Requirements

| Requirement | Standard |
|-------------|----------|
| VoiceOver | All elements labeled |
| Dynamic Type | Supports all sizes |
| Contrast | WCAG AA minimum |
| Touch targets | Minimum 44x44pt |

---

## Appendix A: Third-Party Libraries (Native)

| Category | Framework | iOS Version |
|----------|-----------|--------------|
| UI | SwiftUI | iOS 13+ |
| Data | SwiftData | iOS 17+ |
| Charts | Swift Charts | iOS 16+ |
| Health | HealthKit | iOS 15+ |
| Notifications | UserNotifications | iOS 15+ |
| PDF | PDFKit | iOS 15+ |
| Calendar | EventKit | iOS 15+ |

## Appendix B: API Reference

| Service | Purpose | Required |
|---------|---------|---------|
| HealthKit | Weight data sync | Optional |
| UserNotifications | Reminders | Required |
| PDFKit | Report generation | Optional |

## Appendix C: Error Codes

| Code | Description | Solution |
|------|-------------|----------|
| E001 | HealthKit not available | Show alert, disable sync |
| E002 | Notification denied | Guide to settings |
| E003 | Save failed | Retry with error message |
| E004 | Export failed | Check storage space |

---

**Document End**

**Next Steps**:
1. Review and understand the technical architecture
2. Start implementing core data models
3. Build MVP features following the implementation order
4. Test on multiple devices before launch
5. Submit to App Store with proper metadata
