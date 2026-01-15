import SwiftUI

public enum BadgeVariant {
    case primary
    case secondary
    case destructive
    case outline
    case success
}

public struct Badge: View {
    let text: String
    let variant: BadgeVariant
    
    public init(_ text: String, variant: BadgeVariant = .primary) {
        self.text = text
        self.variant = variant
    }
    
    public var body: some View {
        Text(text)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundStyle(foregroundColor)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(backgroundColor)
            .clipShape(Capsule())
            .overlay(overlay)
            .accessibilityLabel("\(text) badge")
    }
    
    private var foregroundColor: Color {
        switch variant {
        case .primary, .success: .white
        case .secondary, .outline: .primary
        case .destructive: .white
        }
    }
    
    private var backgroundColor: Color {
        switch variant {
        case .primary: Color.accentColor
        case .secondary: Color.secondary.opacity(0.2)
        case .destructive: Color.red
        case .outline: Color.clear
        case .success: Color.green
        }
    }
    
    @ViewBuilder
    private var overlay: some View {
        if variant == .outline {
            Capsule()
                .stroke(Color.accentColor, lineWidth: 1)
        }
    }
}

public extension Badge {
    init(iconName: String, variant: BadgeVariant = .default) {
        self.text = ""
        self.variant = variant
        self.body = Image(systemName: iconName)
            .font(.caption2)
            .foregroundStyle(foregroundColor)
            .padding(4)
            .background(backgroundColor)
            .clipShape(Circle())
            .overlay(overlay)
            .accessibilityLabel("badge")
    }
}
