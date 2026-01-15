import SwiftUI
import SwiftDesignOS

@main
struct TaskFlowApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State private var selectedTab: Tab = .tasks
    @StateObject private var taskManager = TaskManager()
    
    enum Tab: String, CaseIterable {
        case tasks = "Tasks"
        case projects = "Projects"
        case calendar = "Calendar"
        case settings = "Settings"
        
        var icon: String {
            switch self {
            case .tasks: return "checkmark.circle"
            case .projects: return "folder"
            case .calendar: return "calendar"
            case .settings: return "gearshape"
            }
        }
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            TaskListView(taskManager: taskManager)
                .tabItem {
                    Label(Tab.tasks.rawValue, systemImage: Tab.tasks.icon)
                }
                .tag(Tab.tasks)
            
            ProjectListView(taskManager: taskManager)
                .tabItem {
                    Label(Tab.projects.rawValue, systemImage: Tab.projects.icon)
                }
                .tag(Tab.projects)
            
            CalendarView(taskManager: taskManager)
                .tabItem {
                    Label(Tab.calendar.rawValue, systemImage: Tab.calendar.icon)
                }
                .tag(Tab.calendar)
            
            SettingsView()
                .tabItem {
                    Label(Tab.settings.rawValue, systemImage: Tab.settings.icon)
                }
                .tag(Tab.settings)
        }
    }
}
