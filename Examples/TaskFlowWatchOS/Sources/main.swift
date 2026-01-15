import SwiftUI
import SwiftDesignOS
import ClockKit

@main
struct TaskFlowWatchOSApp: App {
    @StateObject private var taskManager = TaskManager()
    @State private var selectedTab: Tab = .today
    
    enum Tab: String, CaseIterable {
        case today = "Today"
        case upcoming = "Upcoming"
        case projects = "Projects"
        case settings = "Settings"
        
        var icon: String {
            switch self {
            case .today: return "calendar"
            case .upcoming: return "clock"
            case .projects: return "folder"
            case .settings: return "gearshape"
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $selectedTab) {
                TodayView(taskManager: taskManager)
                    .tabItem {
                        Label("Today", systemImage: Tab.today.icon)
                    }
                    .tag(Tab.today)
                
                UpcomingView(taskManager: taskManager)
                    .tabItem {
                        Label("Upcoming", systemImage: Tab.upcoming.icon)
                    }
                    .tag(Tab.upcoming)
                
                ProjectsView(taskManager: taskManager)
                    .tabItem {
                        Label("Projects", systemImage: Tab.projects.icon)
                    }
                    .tag(Tab.projects)
                
                SettingsView(taskManager: taskManager)
                    .tabItem {
                        Label("Settings", systemImage: Tab.settings.icon)
                    }
                    .tag(Tab.settings)
            }
        }
        .windowStyle(.plain)
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
        
        let today = Calendar.current.startOfDay(for: Date())
        
        tasks = [
            TaskItem(id: UUID(), title: "Meeting", description: "Team standup at 10am", isCompleted: false, priority: .high, dueDate: Date(), projectId: workProject.id),
            TaskItem(id: UUID(), title: "Groceries", description: "Buy milk and bread", isCompleted: false, priority: .medium, dueDate: Date(), projectId: homeProject.id),
            TaskItem(id: UUID(), title: "Call Mom", description: "Weekly check-in", isCompleted: true, priority: .low, dueDate: Date().addingTimeInterval(-7200), projectId: personalProject.id),
            TaskItem(id: UUID(), title: "Dentist", description: "3pm appointment", isCompleted: false, priority: .high, dueDate: Date().addingTimeInterval(43200), projectId: personalProject.id),
            TaskItem(id: UUID(), title: "Workout", description: "30 min cardio", isCompleted: false, priority: .medium, dueDate: Date().addingTimeInterval(86400), projectId: personalProject.id),
            TaskItem(id: UUID(), title: "Read book", description: "Chapter 5", isCompleted: false, priority: .low, dueDate: Date().addingTimeInterval(172800), projectId: personalProject.id),
        ]
    }
    
    func addTask(_ task: TaskItem) {
        tasks.append(task)
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
    
    func getProject(id: UUID) -> Project? {
        projects.first { $0.id == id }
    }
    
    func tasksForDate(_ date: Date) -> [TaskItem] {
        tasks.filter {
            Calendar.current.isDate($0.dueDate, inSameDayAs: date)
        }
    }
    
    func upcomingTasks(limit: Int = 10) -> [TaskItem] {
        let today = Calendar.current.startOfDay(for: Date())
        return tasks.filter {
            $0.dueDate > today && !$0.isCompleted
        }.sorted { $0.dueDate < $1.dueDate }
            .prefix(limit)
            .map { $0 }
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
        
        var watchColor: WatchColor {
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
    var watchColor: WatchColor
    
    init(id: UUID, name: String, color: Color, icon: String) {
        self.id = id
        self.name = name
        self.color = color
        self.icon = icon
        self.watchColor = mapToWatchColor(color)
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, icon
        case colorHex = "color"
        case watchColorName = "watchColor"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        icon = try container.decode(String.self, forKey: .icon)
        
        if let watchColorName = try container.decodeIfPresent(String.self, forKey: .watchColorName) {
            watchColor = WatchColor(rawValue: watchColorName) ?? .blue
            color = mapToSystemColor(watchColor)
        } else {
            watchColor = .blue
            color = .blue
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(icon, forKey: .icon)
        try container.encode(watchColor.rawValue, forKey: .watchColorName)
    }
    
    private func mapToWatchColor(_ color: Color) -> WatchColor {
        if color == .blue { return .blue }
        if color == .purple { return .purple }
        if color == .green { return .green }
        if color == .orange { return .orange }
        if color == .red { return .red }
        if color == .pink { return .pink }
        if color == .cyan { return .cyan }
        if color == .indigo { return .indigo }
        return .blue
    }
    
    private func mapToSystemColor(_ watchColor: WatchColor) -> Color {
        switch watchColor {
        case .blue: return .blue
        case .purple: return .purple
        case .green: return .green
        case .orange: return .orange
        case .red: return .red
        case .pink: return .pink
        case .cyan: return .cyan
        case .indigo: return .indigo
        case .yellow: return .yellow
        case .black: return .black
        case .gray: return .gray
        }
    }
}

enum WatchColor: String, Codable {
    case blue, purple, green, orange, red, pink, cyan, indigo, yellow, black, gray
}
