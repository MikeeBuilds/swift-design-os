import SwiftUI
import SwiftDesignOS

struct ProjectListView: View {
    @ObservedObject var taskManager: TaskManager
    @Binding var selectedProject: Project?
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(taskManager.projects) { project in
                    ProjectCard(
                        project: project,
                        taskCount: taskManager.tasks.filter { $0.projectId == project.id }.count,
                        isSelected: selectedProject?.id == project.id
                    ) {
                        selectedProject = selectedProject?.id == project.id ? nil : project
                    } onDelete: {
                        taskManager.deleteProject(project)
                        if selectedProject?.id == project.id {
                            selectedProject = nil
                        }
                    }
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
    }
}

struct ProjectCard: View {
    let project: Project
    let taskCount: Int
    let isSelected: Bool
    let onTap: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        Card {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    ZStack {
                        Circle()
                            .fill(project.color.opacity(0.2))
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: project.icon)
                            .font(.title2)
                            .foregroundStyle(project.color)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(project.name)
                            .font(.headline)
                            .foregroundStyle(.primary)
                        
                        Text("\(taskCount) tasks")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    if isSelected {
                        Badge("Selected", variant: .success)
                    }
                }
                
                HStack(spacing: 12) {
                    SDButton(
                        "View Tasks",
                        variant: .primary,
                        size: .small
                    ) {
                        onTap()
                    }
                    
                    Spacer()
                    
                    Button(action: onDelete) {
                        Image(systemName: "trash")
                            .foregroundStyle(.red)
                    }
                }
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.accentColor : Color.clear, lineWidth: 2)
        )
    }
}

struct AddProjectView: View {
    @ObservedObject var taskManager: TaskManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var selectedColor: Color = .blue
    @State private var selectedIcon = "folder.fill"
    
    private let availableColors: [Color] = [.blue, .purple, .green, .orange, .red, .pink, .cyan, .indigo]
    private let availableIcons: [String] = [
        "folder.fill", "briefcase.fill", "house.fill", "heart.fill",
        "star.fill", "bolt.fill", "flame.fill", "leaf.fill",
        "cloud.fill", "sun.max.fill", "moon.fill", "paintbrush.fill"
    ]
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    SDTextField(
                        "Project Name",
                        text: $name,
                        placeholder: "Enter project name",
                        icon: "text.alignleft"
                    )
                } header: {
                    Text("Project Details")
                }
                
                Section {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))], spacing: 12) {
                        ForEach(availableColors, id: \.self) { color in
                            ColorCircle(color: color, isSelected: selectedColor == color) {
                                selectedColor = color
                            }
                        }
                    }
                } header: {
                    Text("Color")
                }
                
                Section {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))], spacing: 12) {
                        ForEach(availableIcons, id: \.self) { icon in
                            IconChoice(icon: icon, isSelected: selectedIcon == icon) {
                                selectedIcon = icon
                            }
                        }
                    }
                } header: {
                    Text("Icon")
                }
            }
            .navigationTitle("New Project")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    SDButton(
                        "Create",
                        variant: .primary,
                        size: .small
                    ) {
                        createProject()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
    
    private func createProject() {
        let project = Project(id: UUID(), name: name, color: selectedColor, icon: selectedIcon)
        taskManager.addProject(project)
        dismiss()
    }
}

struct ColorCircle: View {
    let color: Color
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                Circle()
                    .fill(color)
                    .frame(width: 40, height: 40)
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.caption)
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct IconChoice: View {
    let icon: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.secondary.opacity(0.1))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(isSelected ? .accentColor : .primary)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? Color.accentColor : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    NavigationStack {
        ProjectListView(taskManager: TaskManager(), selectedProject: .constant(nil))
    }
}
