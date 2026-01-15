import SwiftUI

public enum ButtonVariant {
    case primary
    case secondary
    case ghost
    case outline
    case destructive
}

public struct SDButton<Label: View>: View {
    let variant: ButtonVariant
    let size: ButtonSize
    let action: () -> Void
    let label: Label
    @State private var isPressed = false
    
    public enum ButtonSize {
        case small, medium, large
    }
    
    public init(
        variant: ButtonVariant = .primary,
        size: ButtonSize = .medium,
        action: @escaping () -> Void,
        @ViewBuilder label: () -> Label
    ) {
        self.variant = variant
        self.size = size
        self.action = action
        self.label = label()
    }
    
    public var body: some View {
        Button(action: action) {
            label
                .font(font)
                .foregroundStyle(foregroundColor)
                .padding(padding)
                .frame(maxWidth: .infinity)
                .background(background)
                .overlay(overlay)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel(labelText)
    }
    
    private var font: Font {
        switch size {
        case .small: .caption
        case .medium: .body
        case .large: .headline
        }
    }
    
    private var foregroundColor: Color {
        switch variant {
        case .primary, .destructive: .white
        case .secondary, .outline: .primary
        case .ghost: .primary
        }
    }
    
    private var background: Color {
        switch variant {
        case .primary: Color.accentColor
        case .secondary: Color.secondary.opacity(0.15)
        case .destructive: Color.red
        case .ghost, .outline: Color.clear
        }
    }
    
    @ViewBuilder
    private var overlay: some View {
        if variant == .outline {
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(Color.accentColor, lineWidth: 1)
        }
    }
    
    private var padding: EdgeInsets {
        switch size {
        case .small: EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
        case .medium: EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
        case .large: EdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24)
        }
    }
    
    private var cornerRadius: CGFloat {
        8
    }
    
    private var labelText: String {
        "Button"
    }
}

public extension SDButton where Label == Text {
    init(
        _ title: String,
        variant: ButtonVariant = .primary,
        size: ButtonSize = .medium,
        action: @escaping () -> Void
    ) {
        self.variant = variant
        self.size = size
        self.action = action
        self.label = Text(title)
    }
}
