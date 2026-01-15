import SwiftUI
import SwiftDesignOS

@main
struct TaskFlowmacOSApp: App {
    @StateObject private var taskManager = TaskManager()
    @State private var selectedTask: TaskItem?
    @State private var sidebarSelection: SidebarItem = .allTasks
    
    enum SidebarItem: String, CaseIterable {
        case allTasks = "All Tasks"
        case today = "Today"
        case upcoming = "Upcoming"
        case projects = "Projects"
        case settings = "Settings"
        
        var icon: String {
            switch self {
            case .allTasks: return "list.bullet"
            case .today: return "calendar"
            case .upcoming: return "clock"
            case .projects: return "folder"
            case .settings: return "gear"
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            SidebarContentView(
                taskManager: taskManager,
                selectedTask: $selectedTask,
                sidebarSelection: $sidebarSelection
            )
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    SDButton(
                        "New Task",
                        variant: .primary,
                        size: .medium
                    ) {
                        selectedTask = TaskItem(
                            id: UUID(),
                            title: "",
                            description: "",
                            isCompleted: false,
                            priority: .medium,
                            dueDate: Date(),
                            projectId: taskManager.projects.first?.id ?? UUID()
                        )
                    }
                    .keyboardShortcut("n", modifiers: [.command])
                }
                
                ToolbarItemGroup(placement: .automatic) {
                    Menu {
                        Button("All Tasks") {
                            sidebarSelection = .allTasks
                        }
                        Button("Today") {
                            sidebarSelection = .today
                        }
                        Button("Upcoming") {
                            sidebarSelection = .upcoming
                        }
                        Divider()
                        Button("Projects") {
                            sidebarSelection = .projects
                        }
                        Button("Settings") {
                            sidebarSelection = .settings
                        }
                    } label: {
                        Image(systemName: "sidebar.left")
                    }
                }
            }
            .windowStyle(.hiddenTitleBar)
        }
        .windowResizability(.contentSize)
        .defaultSize(width: 1000, height: 700)
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("New Task") {
                    selectedTask = TaskItem(
                        id: UUID(),
                        title: "",
                        description: "",
                        isCompleted: false,
                        priority: .medium,
                        dueDate: Date(),
                        projectId: taskManager.projects.first?.id ?? UUID()
                    )
                }
                .keyboardShortcut("n", modifiers: [.command])
            }
        }
    }
}

@Observable
class TaskManager {
    var tasks: [TaskItem] = []
    var projects: [Project] = []
    
    init() {
        loadSampleData()
    }
    
    private func loadSampleData() {
        let personalProject = Project(id: UUID(), name: "Personal", color: .blue, icon: "person.circle.fill")
        let workProject = Project(id: UUID(), name: "Work", color: .purple, icon: "briefcase.fill")
        let homeProject = Project(id: UUID(), name: "Home", color: .green, icon: "house.fill")
        
        projects = [personalProject, workProject, homeProject]
        
        tasks = [
            TaskItem(id: UUID(), title: "Review project proposal", description: "Go through Q1 project proposal and provide feedback", isCompleted: false, priority: .high, dueDate: Date().addingTimeInterval(86400), projectId: workProject.id),
            TaskItem(id: UUID(), title: "Buy groceries", description: "Milk, eggs, bread, vegetables", isCompleted: false, priority: .medium, dueDate: Date().addingTimeInterval(172800), projectId: homeProject.id),
            TaskItem(id: UUID(), title: "Schedule dentist appointment", description: "Annual checkup", isCompleted: true, priority: .low, dueDate: Date().addingTimeInterval(-86400), projectId: personalProject.id),
            TaskItem(id: UUID(), title: "Complete design system", description: "Finish color palette and typography definitions", isCompleted: false, priority: .high, dueDate: Date().addingTimeInterval(43200), projectId: workProject.id),
            TaskItem(id: UUID(), title: "Call mom", description: "Weekly check-in call", isCompleted: false, priority: .medium, dueDate: Date().addingTimeInterval(3600), projectId: personalProject.id),
            TaskItem(id: UUID(), title: "Water plants", description: "Living room and bedroom plants", isCompleted: false, priority: .low, dueDate: Date().addingTimeInterval(259200), projectId: homeProject.id),
            TaskItem(id: UUID(), title: "Prepare presentation", description: "Create slides for Monday meeting", isCompleted: false, priority: .high, dueDate: Date().addingTimeInterval(129600), projectId: workProject.id),
            TaskItem(id: UUID(), title: "Book flights", description: "Summer vacation planning", isCompleted: false, priority: .medium, dueDate: Date().addingTimeInterval(604800), projectId: personalProject.id),
            TaskItem(id: UUID(), title: "Organize garage", description: "Weekend project", isCompleted: false, priority: .low, dueDate: Date().addingTimeInterval(345600), projectId: homeProject.id),
            TaskItem(id: UUID(), title: "Update documentation", description: "API docs need refresh", isCompleted: true, priority: .high, dueDate: Date().addingTimeInterval(-172800), projectId: workProject.id),
        ]
    }
    
    func addTask(_ task: TaskItem) {
        tasks.append(task)
    }
    
    func updateTask(_ task: TaskItem) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
        }
    }
    
    func toggleTask(_ task: TaskItem) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
        }
    }
    
    func deleteTask(_ task: TaskItem) {
        tasks.removeAll { $0.id == task.id }
    }
    
    func addProject(_ project: Project) {
        projects.append(project)
    }
    
    func deleteProject(_ project: Project) {
        projects.removeAll { $0.id == project.id }
        tasks.removeAll { $0.projectId == project.id }
    }
    
    func getProject(id: UUID) -> Project? {
        projects.first { $0.id == id }
    }
    
    func tasksForProject(_ projectId: UUID) -> [TaskItem] {
        tasks.filter { $0.projectId == projectId }
    }
}

struct TaskItem: Identifiable, Codable {
    let id: UUID
    var title: String
    var description: String
    var isCompleted: Bool
    var priority: Priority
    var dueDate: Date
    var projectId: UUID
    
    enum Priority: String, CaseIterable, Codable {
        case high = "High"
        case medium = "Medium"
        case low = "Low"
        
        var color: Color {
            switch self {
            case .high: return .red
            case .medium: return .orange
            case .low: return .green
            }
        }
    }
}

struct Project: Identifiable, Codable {
    let id: UUID
    var name: String
    var color: Color
    var icon: String
    
    init(id: UUID, name: String, color: Color, icon: String) {
        self.id = id
        self.name = name
        self.color = color
        self.icon = icon
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, icon
        case colorHex = "color"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        icon = try container.decode(String.self, forKey: .icon)
        
        if let colorHex = try container.decodeIfPresent(String.self, forKey: .colorHex) {
            color = Color(hex: colorHex) ?? .blue
        } else {
            color = .blue
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(icon, forKey: .icon)
        
        if let hex = color.toHex() {
            try container.encode(hex, forKey: .colorHex)
        }
    }
}

extension Color {
    init?(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    func toHex() -> String? {
        guard let components = UIColor(self).cgColor.components, components.count >= 3 else {
            return nil
        }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        return String(format: "#%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
    }
}
