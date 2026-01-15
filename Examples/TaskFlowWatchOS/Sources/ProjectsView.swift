import SwiftUI
import SwiftDesignOS

struct ProjectsView: View {
    @ObservedObject var taskManager: TaskManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                HeaderCard(
                    title: "Projects",
                    subtitle: "\(taskManager.projects.count)",
                    icon: "folder.circle.fill",
                    color: .purple
                )
                
                VStack(spacing: 12) {
                    ForEach(taskManager.projects) { project in
                        ProjectSummaryCard(project: project)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct ProjectSummaryCard: View {
    let project: Project
    
    var taskCount: Int {
        taskManager.tasks.filter { $0.projectId == project.id }.count
    }
    
    var body: some View {
        NavigationLink(destination: ProjectDetailView(project: project)) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(project.watchColor)
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: project.icon)
                        .font(.title2)
                        .foregroundStyle(.white)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(project.name)
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                    
                    Text("\(taskCount) tasks")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .contentShape(Rectangle())
        }
    }
}

struct ProjectDetailView: View {
    let project: Project
    @ObservedObject var taskManager: TaskManager
    
    var projectTasks: [TaskItem] {
        taskManager.tasks.filter { $0.projectId == project.id }
            .sorted { $0.dueDate < $1.dueDate }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Card {
                    HStack(spacing: 12) {
                        Image(systemName: project.icon)
                            .font(.title2)
                            .foregroundStyle(project.color)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(project.name)
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundStyle(.primary)
                            
                            Text("\(projectTasks.count) tasks")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
            }
            
            if projectTasks.isEmpty {
                EmptyState(
                    icon: "tray",
                    message: "No tasks",
                    detail: "in this project"
                )
            } else {
                VStack(spacing: 12) {
                    ForEach(projectTasks) { task in
                        CompactTaskRow(task: task, project: project) {
                            taskManager.toggleTask(task)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    ProjectsView(taskManager: TaskManager())
}

#Preview("Project Detail") {
    NavigationStack {
        ProjectDetailView(
            project: Project(id: UUID(), name: "Work", color: .purple, icon: "briefcase.fill")
        )
    }
    .environmentObject(TaskManager())
}
