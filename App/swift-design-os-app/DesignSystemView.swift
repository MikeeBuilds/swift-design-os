import SwiftUI

struct DesignSystemView: View {
    @State private var designTokens = DesignSystem()
    @State private var selectedCategory: TokenCategory = .colors
    
    enum TokenCategory: String, CaseIterable {
        case colors = "Colors"
        case typography = "Typography"
        case spacing = "Spacing"
        case borders = "Borders"
        case shadows = "Shadows"
    }
    
    var body: some View {
        VStack(spacing: 0) {
            categoryPicker
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    contentForCategory(selectedCategory)
                }
                .padding()
            }
        }
        .navigationTitle("Design System")
    }
    
    var categoryPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(TokenCategory.allCases, id: \.self) { category in
                    Button(action: { selectedCategory = category }) {
                        Text(category.rawValue)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(selectedCategory == category ? Color.blue : Color(.systemGray6))
                            .foregroundColor(selectedCategory == category ? .white : .primary)
                            .cornerRadius(20)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .background(Color(.systemBackground))
        .shadow(color: .black.opacity(0.05), radius: 1, y: 1)
    }
    
    @ViewBuilder
    func contentForCategory(_ category: TokenCategory) -> some View {
        switch category {
        case .colors:
            colorsSection
        case .typography:
            typographySection
        case .spacing:
            spacingSection
        case .borders:
            bordersSection
        case .shadows:
            shadowsSection
        }
    }
    
    var colorsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Color Tokens")
                .font(.headline)
            
            VStack(spacing: 12) {
                colorRow("Primary", designTokens.primaryColor)
                colorRow("Secondary", designTokens.secondaryColor)
                colorRow("Accent", designTokens.accentColor)
                colorRow("Background", designTokens.backgroundColor)
                colorRow("Surface", designTokens.surfaceColor)
                colorRow("Text Primary", designTokens.textColor)
                colorRow("Text Secondary", designTokens.secondaryTextColor)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    func colorRow(_ name: String, _ color: Color) -> some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 30, height: 30)
                .overlay(
                    Circle()
                        .stroke(Color.black.opacity(0.1), lineWidth: 1)
                )
            
            Text(name)
                .font(.subheadline)
            
            Spacer()
            
            Color(hex: color.toHex() ?? "#000000")
                .frame(width: 80, height: 30)
                .cornerRadius(6)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
    
    var typographySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Typography Tokens")
                .font(.headline)
            
            VStack(spacing: 12) {
                typographyRow("Heading 1", designTokens.h1, size: 28, weight: .bold)
                typographyRow("Heading 2", designTokens.h2, size: 24, weight: .bold)
                typographyRow("Heading 3", designTokens.h3, size: 20, weight: .semibold)
                typographyRow("Body", designTokens.body, size: 16, weight: .regular)
                typographyRow("Caption", designTokens.caption, size: 12, weight: .regular)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    func typographyRow(_ name: String, _ font: Font, size: CGFloat, weight: Font.Weight) -> some View {
        HStack {
            Text(name)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text("Sample")
                .font(font)
            
            Spacer()
            
            Text("\(Int(size))pt")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
    
    var spacingSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Spacing Tokens")
                .font(.headline)
            
            VStack(spacing: 12) {
                spacingRow("Extra Small", designTokens.spacingXS)
                spacingRow("Small", designTokens.spacingS)
                spacingRow("Medium", designTokens.spacingM)
                spacingRow("Large", designTokens.spacingL)
                spacingRow("Extra Large", designTokens.spacingXL)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    func spacingRow(_ name: String, _ spacing: CGFloat) -> some View {
        HStack {
            Text(name)
                .font(.subheadline)
                .frame(width: 100, alignment: .leading)
            
            Rectangle()
                .fill(Color.blue.opacity(0.3))
                .frame(width: spacing, height: 20)
            
            Text("\(Int(spacing))pt")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
    
    var bordersSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Border Tokens")
                .font(.headline)
            
            VStack(spacing: 12) {
                borderRow("Thin", 1)
                borderRow("Medium", 2)
                borderRow("Thick", 4)
            }
            
            VStack(spacing: 12) {
                Text("Border Radius")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                radiusRow("Small", designTokens.radiusS)
                radiusRow("Medium", designTokens.radiusM)
                radiusRow("Large", designTokens.radiusL)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    func borderRow(_ name: String, _ width: CGFloat) -> some View {
        HStack {
            Text(name)
                .font(.subheadline)
                .frame(width: 80, alignment: .leading)
            
            Rectangle()
                .stroke(Color.black, lineWidth: width)
                .frame(height: 30)
            
            Text("\(Int(width))pt")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
    
    func radiusRow(_ name: String, _ radius: CGFloat) -> some View {
        HStack {
            Text(name)
                .font(.subheadline)
                .frame(width: 80, alignment: .leading)
            
            Rectangle()
                .fill(Color.blue.opacity(0.3))
                .frame(width: 40, height: 40)
                .cornerRadius(radius)
            
            Text("\(Int(radius))pt")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
    
    var shadowsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Shadow Tokens")
                .font(.headline)
            
            VStack(spacing: 12) {
                shadowRow("Small", designTokens.shadowSmall)
                shadowRow("Medium", designTokens.shadowMedium)
                shadowRow("Large", designTokens.shadowLarge)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    func shadowRow(_ name: String, _ shadow: Shadow) -> some View {
        HStack {
            Text(name)
                .font(.subheadline)
                .frame(width: 80, alignment: .leading)
            
            Rectangle()
                .fill(Color.white)
                .shadow(color: Color.black.opacity(shadow.opacity), radius: shadow.radius, x: shadow.x, y: shadow.y)
                .frame(width: 60, height: 40)
            
            Text("r: \(shadow.radius)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

struct DesignSystem {
    var primaryColor: Color = .blue
    var secondaryColor: Color = .purple
    var accentColor: Color = .orange
    var backgroundColor: Color = Color(.systemBackground)
    var surfaceColor: Color = Color(.secondarySystemBackground)
    var textColor: Color = .primary
    var secondaryTextColor: Color = .secondary
    
    var h1: Font = .system(size: 28, weight: .bold)
    var h2: Font = .system(size: 24, weight: .bold)
    var h3: Font = .system(size: 20, weight: .semibold)
    var body: Font = .system(size: 16, weight: .regular)
    var caption: Font = .system(size: 12, weight: .regular)
    
    var spacingXS: CGFloat = 4
    var spacingS: CGFloat = 8
    var spacingM: CGFloat = 16
    var spacingL: CGFloat = 24
    var spacingXL: CGFloat = 32
    
    var radiusS: CGFloat = 4
    var radiusM: CGFloat = 8
    var radiusL: CGFloat = 16
    
    var shadowSmall: Shadow = Shadow(radius: 2, x: 0, y: 1, opacity: 0.1)
    var shadowMedium: Shadow = Shadow(radius: 4, x: 0, y: 2, opacity: 0.15)
    var shadowLarge: Shadow = Shadow(radius: 8, x: 0, y: 4, opacity: 0.2)
}

struct Shadow {
    var radius: CGFloat
    var x: CGFloat
    var y: CGFloat
    var opacity: Double
}

struct Color: View {
    let hex: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "doc.on.doc")
                .font(.caption)
            Text(hex)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

extension Color {
    func toHex() -> String? {
        let uic = UIColor(self)
        guard let components = uic.cgColor.components, components.count >= 3 else {
            return nil
        }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)
        
        if components.count >= 4 {
            a = Float(components[3])
        }
        
        if a != Float(1.0) {
            return String(format: "#%02lX%02lX%02lX%02lX",
                          lroundf(r * 255),
                          lroundf(g * 255),
                          lroundf(b * 255),
                          lroundf(a * 255))
        } else {
            return String(format: "#%02lX%02lX%02lX",
                          lroundf(r * 255),
                          lroundf(g * 255),
                          lroundf(b * 255))
        }
    }
}

#Preview {
    NavigationView {
        DesignSystemView()
    }
}
