import SwiftUI

// MARK: - Design System & Modern Theme Tokens

enum AppTheme {
    // Primary Brand Gradients
    static let primaryGradient = LinearGradient(
        colors: [Color(red: 0.42, green: 0.36, blue: 0.98), Color(red: 0.12, green: 0.65, blue: 0.95)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let cardGradient = LinearGradient(
        colors: [Color.white.opacity(0.08), Color.white.opacity(0.02)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let goldGradient = LinearGradient(
        colors: [Color(red: 0.98, green: 0.75, blue: 0.20), Color(red: 0.95, green: 0.55, blue: 0.10)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let emeraldGradient = LinearGradient(
        colors: [Color(red: 0.10, green: 0.82, blue: 0.55), Color(red: 0.05, green: 0.65, blue: 0.45)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let coralGradient = LinearGradient(
        colors: [Color(red: 0.98, green: 0.35, blue: 0.40), Color(red: 0.85, green: 0.20, blue: 0.30)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // Palette Colors
    static let brandIndigo = Color(red: 0.42, green: 0.36, blue: 0.98)
    static let brandCyan   = Color(red: 0.12, green: 0.65, blue: 0.95)
    static let brandEmerald = Color(red: 0.10, green: 0.82, blue: 0.55)
    static let brandAmber  = Color(red: 0.98, green: 0.75, blue: 0.20)
    static let brandCoral  = Color(red: 0.98, green: 0.35, blue: 0.40)
}

// MARK: - Custom Card Modifiers

struct GlassCardModifier: ViewModifier {
    var cornerRadius: CGFloat = 18

    func body(content: Content) -> some View {
        content
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [Color.primary.opacity(0.08), Color.clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 4)
    }
}

extension View {
    func modernCard(cornerRadius: CGFloat = 18) -> some View {
        self.modifier(GlassCardModifier(cornerRadius: cornerRadius))
    }
}
