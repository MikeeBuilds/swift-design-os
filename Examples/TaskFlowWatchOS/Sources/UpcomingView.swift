import SwiftUI
import SwiftDesignOS

struct UpcomingView: View {
    @ObservedObject var taskManager: TaskManager
    @State private var showingTaskDetail: TaskItem?
    
    var upcomingTasks: [TaskItem] {
        taskManager.upcomingTasks(limit: 20)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                HeaderCard(
                    title: "Upcoming",
                    subtitle: "\(upcomingTasks.count) tasks",
                    icon: "clock.circle.fill",
                    color: .orange
                )
                
                if upcomingTasks.isEmpty {
                    EmptyState(
                        icon: "tray",
                        message: "All caught up",
                        detail: "No upcoming tasks"
                    )
                } else {
                    VStack(spacing: 12) {
                        ForEach(upcomingTasks) { task in
                            UpcomingTaskRow(task: task, project: taskManager.getProject(id: task.projectId)) {
                                taskManager.toggleTask(task)
                            } onDetail: {
                                showingTaskDetail = task
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .sheet(item: $showingTaskDetail) { task in
            TaskDetailSheet(task: task, project: taskManager.getProject(id: task.projectId))
        }
    }
}

struct UpcomingTaskRow: View {
    let task: TaskItem
    let project: Project?
    let onToggle: () -> Void
    let onDetail: () -> Void
    
    var daysRemaining: Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let taskDate = calendar.startOfDay(for: task.dueDate)
        return calendar.dateComponents([.day], from: today, to: taskDate).day ?? 0
    }
    
    var body: some View {
        Button(action: onDetail) {
            HStack(spacing: 10) {
                VStack(spacing: 4) {
                    Text("\(daysRemaining)d")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundStyle(.secondary)
                    
                    HStack(spacing: 6) {
                        ZStack {
                            Circle()
                                .stroke(task.priority.watchColor, lineWidth: 2)
                                .frame(width: 24, height: 24)
                            
                            if task.isCompleted {
                                Image(systemName: "checkmark")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(task.title)
                                .font(.callout)
                                .foregroundStyle(.primary)
                                .lineLimit(1)
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: onToggle) {
                        Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                            .foregroundStyle(.accentColor)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

struct TaskDetailSheet: View {
    let task: TaskItem
    let project: Project?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    HeaderCard(
                        title: task.title,
                        subtitle: project?.name ?? "No Project",
                        icon: project?.icon ?? "circle",
                        color: task.priority.color
                    )
                    
                    Card {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Description", systemImage: "text.alignleft")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            Text(task.description.isEmpty ? "No description" : task.description)
                                .font(.body)
                                .foregroundStyle(.primary)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Priority", systemImage: "exclamationmark.circle")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        Badge(task.priority.rawValue, variant: task.priority == .high ? .destructive : .secondary)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Due Date", systemImage: "calendar")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        Text(formatDate(task.dueDate))
                            .font(.body)
                            .foregroundStyle(.primary)
                    }
                    
                    Button(action: {
                        taskManager.toggleTask(task)
                        dismiss()
                    }) {
                        Text(task.isCompleted ? "Mark Incomplete" : "Mark Complete")
                            .font(.body)
                            .foregroundStyle(.white)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()
        }
        .navigationTitle("Task Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Close") {
                    dismiss()
                }
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    UpcomingView(taskManager: TaskManager())
}
