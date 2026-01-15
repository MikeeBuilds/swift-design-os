import SwiftUI
import SwiftDesignOS

struct ProjectsContentView: View {
    @ObservedObject var taskManager: TaskManager
    @Binding var selectedTask: TaskItem?
    @State private var selectedProject: Project?
    @State private var showingAddProject = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Projects")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("\(taskManager.projects.count) projects with \(taskManager.tasks.count) tasks")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                SDButton(
                    "New Project",
                    variant: .primary,
                    size: .medium
                ) {
                    showingAddProject = true
                }
                .keyboardShortcut("n", modifiers: [.command, .shift])
            }
            .padding()
            
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: 280), spacing: 16)
                ], spacing: 16) {
                    ForEach(taskManager.projects) { project in
                        ProjectCardLarge(
                            project: project,
                            taskCount: taskManager.tasksForProject(project.id).count
                        ) {
                            selectedProject = project
                        } onDelete: {
                            taskManager.deleteProject(project)
                            selectedProject = nil
                        }
                    }
                }
                .padding()
            }
            
            if let selectedProject = selectedProject {
                Divider()
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: selectedProject.icon)
                            .font(.title2)
                            .foregroundStyle(selectedProject.color)
                        
                        Text(selectedProject.name)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Button("Close") {
                            selectedProject = nil
                        }
                        .buttonStyle(.plain)
                    }
                    .padding()
                    
                    let projectTasks = taskManager.tasksForProject(selectedProject.id)
                    
                    if projectTasks.isEmpty {
                        ContentUnavailableView {
                            Label("No tasks in project", systemImage: "tray")
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        Table(projectTasks, selection: $selectedTask) {
                            TableColumn("Status") { task in
                                Button(action: { taskManager.toggleTask(task) }) {
                                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                        .font(.title3)
                                        .foregroundStyle(task.isCompleted ? .green : .secondary)
                                }
                                .buttonStyle(.plain)
                            }
                            .width(50)
                            
                            TableColumn("Task") { task in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(task.title)
                                        .font(.body)
                                        .foregroundStyle(.primary)
                                        .strikethrough(task.isCompleted)
                                    
                                    if !task.description.isEmpty {
                                        Text(task.description)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                            .lineLimit(1)
                                    }
                                }
                            }
                            
                            TableColumn("Priority") { task in
                                Badge(task.priority.rawValue, variant: task.priority == .high ? .destructive : .secondary)
                            }
                            .width(80)
                            
                            TableColumn("Due Date") { task in
                                Text(formattedDate(task.dueDate))
                                    .font(.body)
                                    .foregroundStyle(isOverdue(task) ? .red : .primary)
                            }
                            .width(120)
                        }
                        .tableStyle(.inset(alternatesRowBackgrounds: true))
                        .padding(.horizontal)
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddProject) {
            AddProjectSheet(taskManager: taskManager)
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    private func isOverdue(_ task: TaskItem) -> Bool {
        !task.isCompleted && task.dueDate < Date()
    }
}

struct ProjectCardLarge: View {
    let project: Project
    let taskCount: Int
    let onTap: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        Card {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    ZStack {
                        Circle()
                            .fill(project.color.opacity(0.15))
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: project.icon)
                            .font(.title)
                            .foregroundStyle(project.color)
                    }
                    
                    Spacer()
                    
                    Menu {
                        Button("Delete Project") {
                            onDelete()
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(project.name)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                    
                    Text("\(taskCount) tasks")
                        .font(.body)
                        .foregroundStyle(.secondary)
                    
                    let completedCount = taskCount
                    if taskCount > 0 {
                        ProgressView(value: Double(completedCount), total: Double(taskCount))
                            .tint(.accentColor)
                    }
                }
                
                HStack(spacing: 12) {
                    SDButton(
                        "View Tasks",
                        variant: .primary,
                        size: .medium
                    ) {
                        onTap()
                    }
                    
                    Button(action: onDelete) {
                        Text("Delete")
                            .foregroundStyle(.red)
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
    }
}

struct AddProjectSheet: View {
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
            .formStyle(.grouped)
            .navigationTitle("New Project")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    SDButton(
                        "Create",
                        variant: .primary,
                        size: .medium
                    ) {
                        createProject()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
        .frame(width: 500, height: 400)
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
        .buttonStyle(.plain)
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
        .buttonStyle(.plain)
    }
}

#Preview {
    ProjectsContentView(
        taskManager: TaskManager(),
        selectedTask: .constant(nil)
    )
}
