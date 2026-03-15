import SwiftUI

enum FeedbackSubject: String, CaseIterable, Identifiable {
    case bugReport = "Bug Report"
    case featureRequest = "Feature Request"
    case generalFeedback = "General Feedback"
    case accountIssue = "Account Issue"
    case billingQuestion = "Billing Question"
    case other = "Other"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .bugReport:
            return "ladybug.fill"
        case .featureRequest:
            return "lightbulb.fill"
        case .generalFeedback:
            return "message.fill"
        case .accountIssue:
            return "person.crop.circle.badge.exclamationmark"
        case .billingQuestion:
            return "creditcard.fill"
        case .other:
            return "ellipsis.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .bugReport:
            return .red
        case .featureRequest:
            return .yellow
        case .generalFeedback:
            return .blue
        case .accountIssue:
            return .orange
        case .billingQuestion:
            return .green
        case .other:
            return .gray
        }
    }
}

struct ContactSupportView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedSubject: FeedbackSubject = .generalFeedback
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var message: String = ""
    @State private var isSubmitting = false
    @State private var showSuccessAlert = false
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    
    private let feedbackAPIURL = "https://feedback-board.iocompile67692.workers.dev/api/feedback"
    private let appName = "DoseMate"
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !email.trimmingCharacters(in: .whitespaces).isEmpty &&
        email.contains("@") &&
        !message.trimmingCharacters(in: .whitespaces).isEmpty &&
        message.count >= 10
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                        Text("How can we help?")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: AppTheme.Spacing.md) {
                                ForEach(FeedbackSubject.allCases) { subject in
                                    SubjectButton(
                                        subject: subject,
                                        isSelected: selectedSubject == subject
                                    ) {
                                        withAnimation(.spring(response: 0.3)) {
                                            selectedSubject = subject
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, AppTheme.Spacing.xs)
                        }
                    }
                    .padding(.vertical, AppTheme.Spacing.sm)
                }
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
                
                Section("Your Information") {
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(AppTheme.Colors.primaryBlue)
                            .frame(width: 24)
                        
                        TextField("Your Name", text: $name)
                            .textContentType(.name)
                            .autocapitalization(.words)
                    }
                    
                    HStack {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(AppTheme.Colors.primaryBlue)
                            .frame(width: 24)
                        
                        TextField("Your Email", text: $email)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                    }
                }
                
                Section("Message") {
                    ZStack(alignment: .topLeading) {
                        if message.isEmpty {
                            Text("Please describe your issue or feedback in detail...")
                                .foregroundColor(.secondary)
                                .padding(.top, 8)
                                .padding(.leading, 4)
                        }
                        
                        TextEditor(text: $message)
                            .frame(minHeight: 120)
                            .scrollContentBackground(.hidden)
                    }
                    
                    HStack {
                        Spacer()
                        Text("\(message.count) characters")
                            .font(.caption)
                            .foregroundColor(message.count < 10 ? AppTheme.Colors.errorRed : .secondary)
                    }
                }
                
                Section {
                    Button(action: submitFeedback) {
                        HStack {
                            Spacer()
                            
                            if isSubmitting {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Image(systemName: "paperplane.fill")
                                Text("Send Feedback")
                            }
                            
                            Spacer()
                        }
                    }
                    .disabled(!isFormValid || isSubmitting)
                    .listRowBackground(
                        isFormValid && !isSubmitting ? AppTheme.Colors.primaryBlue : Color.gray.opacity(0.3)
                    )
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                }
                .listRowInsets(EdgeInsets())
                
                Section {
                    VStack(spacing: AppTheme.Spacing.sm) {
                        HStack {
                            Image(systemName: "clock.fill")
                                .foregroundColor(.secondary)
                            Text("Typical response time: 24-48 hours")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        HStack {
                            Image(systemName: "shield.fill")
                                .foregroundColor(.secondary)
                            Text("Your information is secure and private")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppTheme.Spacing.sm)
                }
                .listRowBackground(Color.clear)
            }
            .navigationTitle("Contact Support")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .disabled(isSubmitting)
                }
            }
            .alert("Thank You!", isPresented: $showSuccessAlert) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("Your feedback has been sent successfully. We'll get back to you soon.")
            }
            .alert("Error", isPresented: $showErrorAlert) {
                Button("OK", role: .cancel) {}
                Button("Try Again") {
                    submitFeedback()
                }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func submitFeedback() {
        guard isFormValid else { return }
        
        isSubmitting = true
        
        let feedbackData: [String: Any] = [
            "name": name.trimmingCharacters(in: .whitespaces),
            "email": email.trimmingCharacters(in: .whitespaces).lowercased(),
            "subject": selectedSubject.rawValue,
            "message": message.trimmingCharacters(in: .whitespaces),
            "app_name": appName
        ]
        
        guard let url = URL(string: feedbackAPIURL),
              let jsonData = try? JSONSerialization.data(withJSONObject: feedbackData) else {
            showError(message: "Failed to prepare request. Please try again.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isSubmitting = false
                
                if let error = error {
                    showError(message: "Network error: \(error.localizedDescription)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    showError(message: "Invalid server response. Please try again.")
                    return
                }
                
                if (200...299).contains(httpResponse.statusCode) {
                    showSuccessAlert = true
                } else {
                    showError(message: "Server error (\(httpResponse.statusCode)). Please try again later.")
                }
            }
        }.resume()
    }
    
    private func showError(message: String) {
        errorMessage = message
        showErrorAlert = true
    }
}

struct SubjectButton: View {
    let subject: FeedbackSubject
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: AppTheme.Spacing.sm) {
                Image(systemName: subject.icon)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .white : subject.color)
                    .frame(width: 56, height: 56)
                    .background(
                        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                            .fill(isSelected ? subject.color : subject.color.opacity(0.15))
                    )
                
                Text(subject.rawValue)
                    .font(.caption)
                    .fontWeight(isSelected ? .semibold : .medium)
                    .foregroundColor(isSelected ? subject.color : .primary)
                    .lineLimit(1)
                    .frame(width: 80)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ContactSupportView()
}
