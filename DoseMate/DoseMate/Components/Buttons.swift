import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var isLoading: Bool = false
    var isDisabled: Bool = false
    var icon: String? = nil
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppTheme.Spacing.sm) {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                } else if let icon = icon {
                    Image(systemName: icon)
                }
                
                Text(title)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppTheme.Spacing.md)
            .background(isDisabled ? Color.gray : AppTheme.Colors.primaryBlue)
            .foregroundColor(.white)
            .cornerRadius(AppTheme.CornerRadius.medium)
        }
        .disabled(isDisabled || isLoading)
    }
}

struct SecondaryButton: View {
    let title: String
    let action: () -> Void
    var icon: String? = nil
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppTheme.Spacing.sm) {
                if let icon = icon {
                    Image(systemName: icon)
                }
                
                Text(title)
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppTheme.Spacing.md)
            .background(AppTheme.Colors.secondaryBackground)
            .foregroundColor(AppTheme.Colors.primaryBlue)
            .cornerRadius(AppTheme.CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                    .stroke(AppTheme.Colors.primaryBlue, lineWidth: 1)
            )
        }
    }
}

struct DestructiveButton: View {
    let title: String
    let action: () -> Void
    var icon: String? = nil
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppTheme.Spacing.sm) {
                if let icon = icon {
                    Image(systemName: icon)
                }
                
                Text(title)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppTheme.Spacing.md)
            .background(AppTheme.Colors.errorRed)
            .foregroundColor(.white)
            .cornerRadius(AppTheme.CornerRadius.medium)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        PrimaryButton(title: "Save", action: {})
        PrimaryButton(title: "Loading...", action: {}, isLoading: true)
        PrimaryButton(title: "Disabled", action: {}, isDisabled: true)
        SecondaryButton(title: "Cancel", action: {})
        DestructiveButton(title: "Delete", action: {})
    }
    .padding()
}
