import SwiftUI
import SwiftDesignOS

struct TaskListContentView: View {
    @ObservedObject var taskManager: TaskManager
    @Binding var selectedTask: TaskItem?
    @State private var searchText = ""
    
    var filteredTasks: [TaskItem] {
        let filtered = taskManager.tasks
        
        if !searchText.isEmpty {
            return filtered.filter { task in
                task.title.localizedCaseInsensitiveContains(searchText) ||
                task.description.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return filtered.sorted { $0.dueDate < $1.dueDate }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Card {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)
                    
                    TextField("Search tasks", text: $searchText)
                        .textFieldStyle(.plain)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
            }
            .padding()
            
            Table(filteredTasks, selection: $selectedTask) {
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
                
                TableColumn("Project") { task in
                    if let project = taskManager.getProject(id: task.projectId) {
                        HStack(spacing: 6) {
                            Image(systemName: project.icon)
                                .font(.caption)
                                .foregroundStyle(project.color)
                            Text(project.name)
                                .font(.body)
                        }
                    }
                }
            }
            .tableStyle(.inset(alternatesRowBackgrounds: true))
            .contextMenu(forSelectionType: TaskItem.self) { items in
                if let task = items.first {
                    Button("Mark Complete") {
                        taskManager.toggleTask(task)
                    }
                    
                    Button("Delete", role: .destructive) {
                        taskManager.deleteTask(task)
                    }
                }
            } primaryAction: { task in
                taskManager.toggleTask(task)
            }
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let taskDate = calendar.startOfDay(for: date)
        
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInTomorrow(date) {
            return "Tomorrow"
        } else if date < today {
            let days = calendar.dateComponents([.day], from: date, to: today).day ?? 0
            return "\(days)d ago"
        } else {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter.string(from: date)
        }
    }
    
    private func isOverdue(_ task: TaskItem) -> Bool {
        !task.isCompleted && task.dueDate < Date()
    }
}

struct TodayContentView: View {
    @ObservedObject var taskManager: TaskManager
    @Binding var selectedTask: TaskItem?
    
    var todayTasks: [TaskItem] {
        let today = Calendar.current.startOfDay(for: Date())
        return taskManager.tasks.filter {
            Calendar.current.isDate($0.dueDate, inSameDayAs: today)
        }.sorted { $0.dueDate < $1.dueDate }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Card {
                HStack {
                    Image(systemName: "calendar.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.accentColor)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Today")
                            .font(.title3)
                            .fontWeight(.bold)
                        Text("\(todayTasks.count) tasks")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    Text(DateFormatter.shortDate.string(from: Date()))
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
                .padding()
            }
            .padding()
            
            if todayTasks.isEmpty {
                ContentUnavailableView {
                    Label("No tasks today", systemImage: "calendar.badge.checkmark")
                } description: {
                    Text("Enjoy your free time!")
                }
            } else {
                TaskListContentView(taskManager: taskManager, selectedTask: $selectedTask)
            }
        }
    }
}

struct UpcomingContentView: View {
    @ObservedObject var taskManager: TaskManager
    @Binding var selectedTask: TaskItem?
    
    var upcomingTasks: [TaskItem] {
        let today = Calendar.current.startOfDay(for: Date())
        return taskManager.tasks.filter {
            $0.dueDate > today && !$0.isCompleted
        }.sorted { $0.dueDate < $1.dueDate }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Card {
                HStack {
                    Image(systemName: "clock.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.orange)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Upcoming")
                            .font(.title3)
                            .fontWeight(.bold)
                        Text("\(upcomingTasks.count) tasks")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .padding()
            
            if upcomingTasks.isEmpty {
                ContentUnavailableView {
                    Label("No upcoming tasks", systemImage: "tray")
                } description: {
                    Text("All caught up!")
                }
            } else {
                TaskListContentView(taskManager: taskManager, selectedTask: $selectedTask)
            }
        }
    }
}
