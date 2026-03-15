import SwiftUI

enum AppTheme {
    enum Colors {
        static let primaryBlue = Color(hex: "007AFF")
        static let successGreen = Color(hex: "34C759")
        static let warningOrange = Color(hex: "FF9500")
        static let errorRed = Color(hex: "FF3B30")
        
        static let surfaceLight = Color(hex: "F2F2F7")
        static let surfaceDark = Color(hex: "1C1C1E")
        
        static var surface: Color {
            Color(.systemBackground)
        }
        
        static var secondaryBackground: Color {
            Color(.secondarySystemBackground)
        }
        
        static var tertiaryBackground: Color {
            Color(.tertiarySystemBackground)
        }
        
        static var groupedBackground: Color {
            Color(.systemGroupedBackground)
        }
    }
    
    enum Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }
    
    enum CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let extraLarge: CGFloat = 20
    }
    
    enum Shadow {
        static let small = Color.black.opacity(0.05)
        static let medium = Color.black.opacity(0.1)
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct GlassCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .background(.ultraThinMaterial)
            .cornerRadius(AppTheme.CornerRadius.medium)
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    var isLoading: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppTheme.Spacing.md)
            .background(configuration.isPressed ? AppTheme.Colors.primaryBlue.opacity(0.8) : AppTheme.Colors.primaryBlue)
            .foregroundColor(.white)
            .cornerRadius(AppTheme.CornerRadius.medium)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {
    static var primary: PrimaryButtonStyle {
        PrimaryButtonStyle()
    }
    
    static func primary(isLoading: Bool) -> PrimaryButtonStyle {
        PrimaryButtonStyle(isLoading: isLoading)
    }
}

#Preview {
    VStack(spacing: 20) {
        GlassCard {
            Text("Glass Card")
                .padding()
        }
        
        Button {
        } label: {
            Text("Primary Button")
        }
        .buttonStyle(.primary)
        .padding(.horizontal)
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
