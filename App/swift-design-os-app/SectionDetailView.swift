import SwiftUI

struct SectionDetailView: View {
    let section: Section
    @State private var selectedTab: DetailTab = .spec
    
    enum DetailTab: String, CaseIterable {
        case spec = "Spec"
        case data = "Data"
        case screens = "Screens"
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                sectionHeader
                
                tabBar
                
                tabContent
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(section.name)
    }
    
    var sectionHeader: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(section.name)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(section.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                sectionStatusBadge
            }
            
            HStack(spacing: 20) {
                Label("\(section.screens.count) screens", systemImage: "rectangle.on.rectangle")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Label("ID: \(section.id)", systemImage: "number")
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
    
    var tabBar: some View {
        HStack(spacing: 0) {
            ForEach(DetailTab.allCases, id: \.self) { tab in
                Button(action: { selectedTab = tab }) {
                    Text(tab.rawValue)
                        .font(.subheadline)
                        .fontWeight(selectedTab == tab ? .semibold : .regular)
                        .foregroundColor(selectedTab == tab ? .blue : .secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                }
                .overlay(
                    Rectangle()
                        .fill(Color.blue)
                        .frame(height: 2)
                        .opacity(selectedTab == tab ? 1 : 0),
                    alignment: .bottom
                )
            }
        }
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
    
    @ViewBuilder
    var tabContent: some View {
        switch selectedTab {
        case .spec:
            specTab
        case .data:
            dataTab
        case .screens:
            screensTab
        }
    }
    
    var specTab: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Specification")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 12) {
                specRow("Section ID", section.id)
                specRow("Name", section.name)
                specRow("Status", section.status.rawValue)
                specRow("Screens", "\(section.screens.count)")
                specRow("Description", section.description)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
        }
    }
    
    func specRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(width: 100, alignment: .leading)
            
            Text(value)
                .font(.subheadline)
            
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
    
    var dataTab: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Data Model")
                .font(.headline)
            
            VStack(spacing: 12) {
                dataFieldRow("user_id", "String", "Unique user identifier")
                dataFieldRow("created_at", "Date", "Timestamp of creation")
                dataFieldRow("updated_at", "Date", "Last update timestamp")
                dataFieldRow("status", "Enum", "Current state")
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
        }
    }
    
    func dataFieldRow(_ name: String, _ type: String, _ description: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.blue)
                
                Text(type)
                    .font(.caption)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(4)
            }
            
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
    
    var screensTab: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Screen Designs")
                .font(.headline)
            
            VStack(spacing: 12) {
                ForEach(section.screens, id: \.self) { screen in
                    screenCard(screen)
                }
            }
        }
    }
    
    func screenCard(_ screenName: String) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(screenName)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text("\(section.name) screen")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "play.rectangle.fill")
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
    }
}

#Preview {
    NavigationView {
        SectionDetailView(
            section: Section(
                id: "auth",
                name: "Authentication",
                description: "Login, signup, and password recovery flows",
                status: .completed,
                screens: ["Login", "Signup", "Forgot Password"]
            )
        )
    }
}
