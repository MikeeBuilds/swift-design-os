import SwiftUI
import SwiftDesignOS

struct TodayView: View {
    @ObservedObject var taskManager: TaskManager
    
    var todayTasks: [TaskItem] {
        taskManager.tasksForDate(Date())
            .sorted { $0.priority == .high && $1.priority != .high }
    }
    
    var completedCount: Int {
        todayTasks.filter { $0.isCompleted }.count
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                HeaderCard(
                    title: "Today",
                    subtitle: "\(todayTasks.count) tasks",
                    icon: "calendar.circle.fill",
                    color: .accentColor
                )
                
                if todayTasks.isEmpty {
                    EmptyState(
                        icon: "checkmark.circle",
                        message: "All done!",
                        detail: "No tasks for today"
                    )
                } else {
                    VStack(spacing: 12) {
                        ForEach(todayTasks) { task in
                            CompactTaskRow(task: task, project: taskManager.getProject(id: task.projectId)) {
                                taskManager.toggleTask(task)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

struct HeaderCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        Card {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(color)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                    
                    Text(subtitle)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
        }
    }
}

struct CompactTaskRow: View {
    let task: TaskItem
    let project: Project?
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .stroke(task.priority.watchColor, lineWidth: 3)
                        .frame(width: 28, height: 28)
                    
                    if task.isCompleted {
                        Image(systemName: "checkmark")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                    }
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(task.title)
                        .font(.body)
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                        .strikethrough(task.isCompleted)
                    
                    if task.priority == .high {
                        Badge("!", variant: .destructive)
                            .font(.caption2)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 2)
                    }
                }
                
                Spacer()
                
                if let project = project {
                    Circle()
                        .fill(project.watchColor)
                        .frame(width: 8, height: 8)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    TodayView(taskManager: TaskManager())
}
