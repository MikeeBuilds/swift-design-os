import SwiftUI
import SwiftDesignOS

struct SidebarContentView: View {
    @ObservedObject var taskManager: TaskManager
    @Binding var selectedTask: TaskItem?
    @Binding var sidebarSelection: TaskFlowmacOSApp.SidebarItem
    
    var body: some View {
        NavigationSplitView {
            SidebarView(
                sidebarSelection: $sidebarSelection,
                taskManager: taskManager
            )
        } detail: {
            DetailView(
                sidebarSelection: sidebarSelection,
                taskManager: taskManager,
                selectedTask: $selectedTask
            )
        }
        .navigationSplitViewStyle(.balanced)
    }
}

struct SidebarView: View {
    @Binding var sidebarSelection: TaskFlowmacOSApp.SidebarItem
    @ObservedObject var taskManager: TaskManager
    
    var body: some View {
        List(selection: $sidebarSelection) {
            Section("Tasks") {
                ForEach([TaskFlowmacOSApp.SidebarItem.allTasks, .today, .upcoming], id: \.self) { item in
                    SidebarRow(item: item, count: taskCount(for: item))
                }
            }
            
            Section("Projects") {
                ForEach(taskManager.projects) { project in
                    ProjectSidebarRow(project: project) {
                        sidebarSelection = .projects
                    }
                }
            }
            
            Section("App") {
                ForEach([TaskFlowmacOSApp.SidebarItem.projects, .settings], id: \.self) { item in
                    SidebarRow(item: item)
                }
            }
        }
        .listStyle(.sidebar)
        .navigationSplitViewColumnWidth(min: 180, ideal: 200)
    }
    
    private func taskCount(for item: TaskFlowmacOSApp.SidebarItem) -> Int {
        switch item {
        case .allTasks:
            return taskManager.tasks.count
        case .today:
            let today = Calendar.current.startOfDay(for: Date())
            return taskManager.tasks.filter {
                Calendar.current.isDate($0.dueDate, inSameDayAs: today)
            }.count
        case .upcoming:
            let today = Calendar.current.startOfDay(for: Date())
            return taskManager.tasks.filter {
                $0.dueDate > today && !$0.isCompleted
            }.count
        default:
            return 0
        }
    }
}

struct SidebarRow: View {
    let item: TaskFlowmacOSApp.SidebarItem
    var count: Int? = nil
    let onTap: (() -> Void)? = nil
    
    var body: some View {
        Button(action: { onTap?() }) {
            HStack {
                Image(systemName: item.icon)
                    .foregroundStyle(.secondary)
                    .frame(width: 20)
                
                Text(item.rawValue)
                
                Spacer()
                
                if let count = count {
                    Badge("\(count)", variant: .secondary)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .foregroundStyle(.primary)
        .padding(.vertical, 4)
    }
}

struct ProjectSidebarRow: View {
    let project: Project
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                ZStack {
                    Circle()
                        .fill(project.color.opacity(0.2))
                        .frame(width: 28, height: 28)
                    
                    Image(systemName: project.icon)
                        .font(.caption)
                        .foregroundStyle(project.color)
                }
                
                Text(project.name)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .foregroundStyle(.primary)
        .padding(.vertical, 4)
    }
}

struct DetailView: View {
    let sidebarSelection: TaskFlowmacOSApp.SidebarItem
    @ObservedObject var taskManager: TaskManager
    @Binding var selectedTask: TaskItem?
    
    var body: some View {
        Group {
            switch sidebarSelection {
            case .allTasks:
                TaskListContentView(taskManager: taskManager, selectedTask: $selectedTask)
            case .today:
                TodayContentView(taskManager: taskManager, selectedTask: $selectedTask)
            case .upcoming:
                UpcomingContentView(taskManager: taskManager, selectedTask: $selectedTask)
            case .projects:
                ProjectsContentView(taskManager: taskManager, selectedTask: $selectedTask)
            case .settings:
                SettingsContentView(taskManager: taskManager)
            }
        }
        .frame(minWidth: 600)
        .toolbar {
            ToolbarItemGroup(placement: .automatic) {
                if sidebarSelection == .allTasks || sidebarSelection == .today || sidebarSelection == .upcoming {
                    Spacer()
                    
                    Menu {
                        Button("All") {
                            sidebarSelection = .allTasks
                        }
                        Button("Today") {
                            sidebarSelection = .today
                        }
                        Button("Upcoming") {
                            sidebarSelection = .upcoming
                        }
                    } label: {
                        Text(sidebarSelection.rawValue)
                            .fontWeight(.semibold)
                    }
                }
            }
        }
    }
}

#Preview {
    SidebarContentView(
        taskManager: TaskManager(),
        selectedTask: .constant(nil),
        sidebarSelection: .constant(.allTasks)
    )
}
