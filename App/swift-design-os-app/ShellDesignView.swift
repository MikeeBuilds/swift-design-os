import SwiftUI

struct ShellDesignView: View {
    @State private var selectedShell: Shell?
    @State private var shells: [Shell] = [
        Shell(
            id: "mobile-nav",
            name: "Mobile Navigation",
            description: "Bottom tab navigation shell",
            platform: .iOS,
            components: ["Header", "Tab Bar", "Content Area"]
        ),
        Shell(
            id: "web-nav",
            name: "Web Navigation",
            description: "Top navigation bar with sidebar",
            platform: .web,
            components: ["Header", "Sidebar", "Content Area", "Footer"]
        ),
        Shell(
            id: "desktop-app",
            name: "Desktop App",
            description: "Three-panel layout with sidebar",
            platform: .desktop,
            components: ["Sidebar", "Main Content", "Details Panel"]
        )
    ]
    
    var body: some View {
        HSplitView {
            shellList
            
            if let selectedShell = selectedShell {
                shellPreview(selectedShell)
            } else {
                shellPlaceholder
            }
        }
        .navigationTitle("Shell Designer")
    }
    
    var shellList: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Shells")
                .font(.headline)
                .padding(.horizontal)
                .padding(.top)
            
            List(shells, id: \.id, selection: $selectedShell) { shell in
                HStack {
                    Image(systemName: shell.platform.icon)
                        .foregroundColor(.blue)
                        .frame(width: 24)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(shell.name)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        Text(shell.description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: shell.platform.badgeIcon)
                        .font(.caption)
                        .foregroundColor(shell.platform.color)
                }
                .padding(.vertical, 6)
            }
        }
        .frame(minWidth: 250)
    }
    
    func shellPreview(_ shell: Shell) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                shellHeader(shell)
                
                previewCanvas(shell)
                
                componentList(shell)
                
                Spacer()
            }
            .padding()
        }
        .frame(minWidth: 500)
    }
    
    func shellHeader(_ shell: Shell) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: shell.platform.icon)
                    .foregroundColor(.blue)
                    .font(.title2)
                
                Text(shell.name)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Image(systemName: shell.platform.badgeIcon)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(shell.platform.color.opacity(0.1))
                    .foregroundColor(shell.platform.color)
                    .cornerRadius(6)
            }
            
            Text(shell.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    func previewCanvas(_ shell: Shell) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Live Preview")
                    .font(.headline)
                Spacer()
                Button(action: {}) {
                    Label("Edit", systemImage: "pencil")
                        .font(.caption)
                }
                .buttonStyle(.bordered)
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
                    .frame(height: 400)
                
                shellPreviewContent(shell)
                    .padding(20)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    @ViewBuilder
    func shellPreviewContent(_ shell: Shell) -> some View {
        switch shell.id {
        case "mobile-nav":
            mobileNavPreview
        case "web-nav":
            webNavPreview
        case "desktop-app":
            desktopPreview
        default:
            Text("No preview available")
                .foregroundColor(.secondary)
        }
    }
    
    var mobileNavPreview: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.blue)
                .frame(height: 44)
                .overlay(
                    Text("App Title")
                        .font(.headline)
                        .foregroundColor(.white)
                )
            
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 200)
                .overlay(
                    Text("Content")
                        .foregroundColor(.secondary)
                )
            
            HStack(spacing: 0) {
                ForEach(0..<3) { _ in
                    VStack(spacing: 4) {
                        Circle()
                            .fill(Color.gray)
                            .frame(width: 20, height: 20)
                        Text("Tab")
                            .font(.caption2)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(8)
            .background(Color(.systemBackground))
        }
        .frame(width: 300, height: 400)
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    var webNavPreview: some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(Color.blue.opacity(0.1))
                .frame(width: 60)
                .overlay(
                    VStack(spacing: 8) {
                        ForEach(0..<4) { _ in
                            Rectangle()
                                .fill(Color.blue.opacity(0.3))
                                .frame(height: 20)
                        }
                    }
                )
            
            VStack(spacing: 0) {
                Rectangle()
                    .fill(Color.blue)
                    .frame(height: 50)
                    .overlay(
                        Text("Navigation")
                            .foregroundColor(.white)
                    )
                
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 250)
                    .overlay(
                        Text("Content")
                            .foregroundColor(.secondary)
                    )
            }
            .frame(maxWidth: .infinity)
        }
        .frame(width: 400, height: 350)
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    var desktopPreview: some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(Color.blue.opacity(0.1))
                .frame(width: 80)
                .overlay(
                    VStack(spacing: 8) {
                        ForEach(0..<5) { _ in
                            Rectangle()
                                .fill(Color.blue.opacity(0.3))
                                .frame(height: 24)
                        }
                    }
                )
            
            VStack(spacing: 0) {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 300)
                    .overlay(
                        Text("Main Content")
                            .foregroundColor(.secondary)
                    )
            }
            .frame(maxWidth: .infinity)
            
            Rectangle()
                .fill(Color.gray.opacity(0.1))
                .frame(width: 150)
                .overlay(
                    VStack(spacing: 8) {
                        ForEach(0..<3) { _ in
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 30)
                        }
                    }
                )
        }
        .frame(width: 450, height: 350)
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    func componentList(_ shell: Shell) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Components")
                .font(.headline)
            
            VStack(spacing: 8) {
                ForEach(shell.components, id: \.self) { component in
                    HStack {
                        Image(systemName: "square.grid.2x2")
                            .foregroundColor(.blue)
                        Text(component)
                            .font(.subheadline)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    var shellPlaceholder: some View {
        VStack(spacing: 16) {
            Image(systemName: "rectangle.3.group")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.3))
            Text("Select a shell to preview")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(minWidth: 500)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct Shell: Identifiable {
    var id: String
    var name: String
    var description: String
    var platform: Platform
    var components: [String]
}

enum Platform: String, CaseIterable {
    case iOS = "iOS"
    case web = "Web"
    case desktop = "Desktop"
    
    var icon: String {
        switch self {
        case .iOS: return "iphone"
        case .web: return "globe"
        case .desktop: return "desktopcomputer"
        }
    }
    
    var badgeIcon: String {
        switch self {
        case .iOS: return "app.badge"
        case .web: return "safari"
        case .desktop: return "macwindow"
        }
    }
    
    var color: Color {
        switch self {
        case .iOS: return .blue
        case .web: return .green
        case .desktop: return .purple
        }
    }
}

#Preview {
    NavigationView {
        ShellDesignView()
    }
}
