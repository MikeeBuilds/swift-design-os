import SwiftUI

public struct SDTextField: View {
    @Binding var text: String
    let title: String?
    let placeholder: String
    let icon: String?
    let isSecure: Bool
    let keyboardType: UIKeyboardType
    let onSubmit: (() -> Void)?
    
    @FocusState private var isFocused: Bool
    @State private var showPassword: Bool = false
    
    public init(
        _ title: String,
        text: Binding<String>,
        placeholder: String = "",
        icon: String? = nil,
        isSecure: Bool = false,
        keyboardType: UIKeyboardType = .default,
        onSubmit: (() -> Void)? = nil
    ) {
        self.title = title
        self._text = text
        self.placeholder = placeholder
        self.icon = icon
        self.isSecure = isSecure
        self.keyboardType = keyboardType
        self.onSubmit = onSubmit
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let title = title {
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)
            }
            
            HStack(spacing: 12) {
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundStyle(isFocused ? .accentColor : .secondary)
                        .frame(width: 20)
                }
                
                if isSecure && !showPassword {
                    SecureField(placeholder, text: $text)
                        .focused($isFocused)
                        .autocapitalization(.none)
                } else {
                    TextField(placeholder, text: $text)
                        .focused($isFocused)
                        .keyboardType(keyboardType)
                        .autocapitalization(.none)
                        .onSubmit {
                            onSubmit?()
                        }
                }
                
                if isSecure {
                    Button(action: { showPassword.toggle() }) {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(12)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(borderColor, lineWidth: isFocused ? 2 : 1)
            )
        }
        .accessibilityElement(children: .combine)
    }
    
    private var borderColor: Color {
        if isFocused {
            return .accentColor
        } else if !text.isEmpty {
            return .accentColor.opacity(0.5)
        } else {
            return Color.gray.opacity(0.3)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        SDTextField(
            "Username",
            text: .constant(""),
            placeholder: "Enter your username",
            icon: "person"
        )
        
        SDTextField(
            "Password",
            text: .constant(""),
            placeholder: "Enter your password",
            icon: "lock",
            isSecure: true
        )
        
        SDTextField(
            "Email",
            text: .constant("test@example.com"),
            placeholder: "Enter your email",
            icon: "envelope",
            keyboardType: .emailAddress
        )
    }
    .padding()
}
