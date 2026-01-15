import SwiftUI
import SwiftDesignOS

struct ProjectListView: View {
    @ObservedObject var taskManager: TaskManager
    @State private var showAddProject = false
    @State private var projects: [Project] = []
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(projects) { project in
                    NavigationLink {
                        ProjectDetailView(project: project, taskManager: taskManager)
                    } label: {
                        ProjectRow(project: project)
                    }
                }
            }
            .navigationTitle("Projects")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    SDButton(
                        "+",
                        variant: .primary,
                        size: .small
                    ) {
                        showAddProject = true
                    }
                }
            }
            .sheet(isPresented: $showAddProject) {
                AddProjectView(projects: $projects)
            }
            .onAppear {
                loadProjects()
            }
        }
    }
    
    private func loadProjects() {
        projects = [
            Project(id: UUID(), name: "Work", color: .blue, icon: "briefcase", taskCount: 5),
            Project(id: UUID(), name: "Personal", color: .green, icon: "person", taskCount: 8),
            Project(id: UUID(), name: "Learning", color: .purple, icon: "book", taskCount: 3)
        ]
    }
}

struct ProjectRow: View {
    let project: Project
    
    var body: some View {
        HStack(spacing: 12) {
            Card {
                Image(systemName: project.icon)
                    .font(.title2)
                    .foregroundStyle(project.color)
                    .frame(width: 44, height: 44)
                    .background(project.color.opacity(0.2))
                    .clipShape(Circle())
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(project.name)
                    .font(.body)
                    .fontWeight(.semibold)
                
                Text("\(project.taskCount) tasks")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

struct ProjectDetailView: View {
    let project: Project
    @ObservedObject var taskManager: TaskManager
    
    var projectTasks: [TaskItem] {
        taskManager.tasks.filter { $0.projectId == project.id }
    }
    
    var body: some View {
        List {
            ForEach(projectTasks) { task in
                TaskRow(task: task) {
                    taskManager.toggleTaskCompletion(id: task.id)
                }
            }
        }
        .navigationTitle(project.name)
    }
}

struct Project: Identifiable, Codable {
    var id: UUID
    var name: String
    var color: Color
    var icon: String
    var taskCount: Int
    
    init(id: UUID, name: String, color: Color, icon: String, taskCount: Int) {
        self.id = id
        self.name = name
        self.color = color
        self.icon = icon
        self.taskCount = taskCount
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, icon, taskCount
        case color = "colorName"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        icon = try container.decode(String.self, forKey: .icon)
        taskCount = try container.decode(Int.self, forKey: .taskCount)
        
        let colorName = try container.decode(String.self, forKey: .color)
        color = color(for: colorName)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(icon, forKey: .icon)
        try container.encode(taskCount, forKey: .taskCount)
        try container.encode(colorName, forKey: .color)
    }
    
    private var colorName: String {
        switch color {
        case .blue: return "blue"
        case .green: return "green"
        case .purple: return "purple"
        case .orange: return "orange"
        case .red: return "red"
        default: return "gray"
        }
    }
    
    private func color(for name: String) -> Color {
        switch name {
        case "blue": return .blue
        case "green": return .green
        case "purple": return .purple
        case "orange": return .orange
        case "red": return .red
        default: return .gray
        }
    }
}

struct AddProjectView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var projects: [Project]
    
    @State private var name = ""
    @State private var selectedColor = Color.blue
    @State private var selectedIcon = "folder"
    
    let colors: [Color] = [.blue, .green, .purple, .orange, .red]
    let icons = ["folder", "star", "heart", "book", "briefcase", "person", "house", "cloud"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    SDTextField(
                        "Project Name",
                        text: $name,
                        placeholder: "Enter project name"
                    )
                }
                
                Section("Color") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 12) {
                        ForEach(colors, id: \.self) { color in
                            ColorCircle(color: color, isSelected: selectedColor == color) {
                                selectedColor = color
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section("Icon") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
                        ForEach(icons, id: \.self) { icon in
                            IconChoice(icon: icon, isSelected: selectedIcon == icon) {
                                selectedIcon = icon
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section {
                    Button(action: saveProject) {
                        HStack {
                            Spacer()
                            Text("Create Project")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    .disabled(name.isEmpty)
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
            }
        }
    }
    
    private func saveProject() {
        let project = Project(
            id: UUID(),
            name: name,
            color: selectedColor,
            icon: selectedIcon,
            taskCount: 0
        )
        projects.append(project)
        dismiss()
    }
}

struct ColorCircle: View {
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Circle()
                .fill(color)
                .frame(width: 40, height: 40)
                .overlay(
                    Circle()
                        .stroke(Color.primary, lineWidth: isSelected ? 3 : 0)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct IconChoice: View {
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.title2)
                .frame(width: 50, height: 50)
                .background(isSelected ? Color.accentColor.opacity(0.2) : Color(.secondarySystemBackground))
                .foregroundStyle(isSelected ? .accentColor : .primary)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(PlainButtonStyle())
    }
}
