import SwiftUI

struct SectionsView: View {
    @State private var sections: [Section] = [
        Section(
            id: "auth",
            name: "Authentication",
            description: "Login, signup, and password recovery flows",
            status: .completed,
            screens: ["Login", "Signup", "Forgot Password"]
        ),
        Section(
            id: "dashboard",
            name: "Dashboard",
            description: "Main dashboard with overview and metrics",
            status: .inProgress,
            screens: ["Overview", "Analytics", "Reports"]
        ),
        Section(
            id: "profile",
            name: "Profile",
            description: "User profile and settings management",
            status: .planned,
            screens: ["Profile", "Settings", "Preferences"]
        )
    ]
    
    @State private var searchText: String = ""
    
    var filteredSections: [Section] {
        if searchText.isEmpty {
            return sections
        }
        return sections.filter { section in
            section.name.localizedCaseInsensitiveContains(searchText) ||
            section.description.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            searchBar
            
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(filteredSections) { section in
                        NavigationLink(destination: SectionDetailView(section: section)) {
                            SectionCard(section: section)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Sections")
    }
    
    var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search sections", text: $searchText)
                .textFieldStyle(.plain)
            
            if !searchText.isEmpty {
                Button(action: { searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding()
    }
}

struct SectionCard: View {
    let section: Section
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(section.name)
                        .font(.headline)
                    
                    Text(section.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                sectionStatusBadge
            }
            
            HStack {
                Label("\(section.screens.count)", systemImage: "rectangle.on.rectangle")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    var sectionStatusBadge: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(section.status.color)
                .frame(width: 8, height: 8)
            Text(section.status.rawValue)
                .font(.caption)
                .fontWeight(.medium)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(section.status.backgroundColor)
        .cornerRadius(12)
    }
}

struct Section: Identifiable, Codable {
    var id: String
    var name: String
    var description: String
    var status: SectionStatus
    var screens: [String]
}

enum SectionStatus: String, Codable, CaseIterable {
    case completed = "Completed"
    case inProgress = "In Progress"
    case planned = "Planned"
    case blocked = "Blocked"
    
    var color: Color {
        switch self {
        case .completed: return .green
        case .inProgress: return .blue
        case .planned: return .orange
        case .blocked: return .red
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .completed: return Color.green.opacity(0.1)
        case .inProgress: return Color.blue.opacity(0.1)
        case .planned: return Color.orange.opacity(0.1)
        case .blocked: return Color.red.opacity(0.1)
        }
    }
}

#Preview {
    NavigationView {
        SectionsView()
    }
}
