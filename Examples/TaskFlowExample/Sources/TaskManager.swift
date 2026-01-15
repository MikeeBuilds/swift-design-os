import SwiftUI
import SwiftDesignOS

@Observable
class TaskManager {
    var tasks: [TaskItem] = []
    
    init() {
        loadSampleData()
    }
    
    func addTask(_ task: TaskItem) {
        tasks.append(task)
    }
    
    func updateTask(_ task: TaskItem) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
        }
    }
    
    func deleteTask(id: UUID) {
        tasks.removeAll { $0.id == id }
    }
    
    func toggleTaskCompletion(id: UUID) {
        if let index = tasks.firstIndex(where: { $0.id == id }) {
            tasks[index].isCompleted.toggle()
        }
    }
    
    private func loadSampleData() {
        tasks = [
            TaskItem(
                id: UUID(),
                title: "Design TaskFlow app",
                description: "Create task management app with SwiftUI",
                priority: .high,
                dueDate: Date().addingTimeInterval(86400),
                projectId: UUID(),
                isCompleted: false
            ),
            TaskItem(
                id: UUID(),
                title: "Review pull requests",
                description: "Check and approve pending PRs",
                priority: .medium,
                dueDate: Date().addingTimeInterval(172800),
                projectId: UUID(),
                isCompleted: true
            ),
            TaskItem(
                id: UUID(),
                title: "Update documentation",
                description: "Add README and setup instructions",
                priority: .low,
                dueDate: Date().addingTimeInterval(259200),
                projectId: UUID(),
                isCompleted: false
            )
        ]
    }
}

struct TaskItem: Identifiable, Codable {
    var id: UUID
    var title: String
    var description: String
    var priority: Priority
    var dueDate: Date
    var projectId: UUID
    var isCompleted: Bool
    
    enum Priority: String, Codable, CaseIterable {
        case low, medium, high
    }
}
