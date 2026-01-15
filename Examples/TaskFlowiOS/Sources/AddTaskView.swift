import SwiftUI
import SwiftDesignOS

struct AddTaskView: View {
    @ObservedObject var taskManager: TaskManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var description = ""
    @State private var priority: TaskItem.Priority = .medium
    @State private var dueDate = Date()
    @State private var selectedProjectId: UUID?
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    SDTextField(
                        "Task Title",
                        text: $title,
                        placeholder: "Enter task title",
                        icon: "text.alignleft"
                    )
                    
                    SDTextField(
                        "Description",
                        text: $description,
                        placeholder: "Add details...",
                        icon: "text.alignleft"
                    )
                } header: {
                    Text("Task Details")
                }
                
                Section {
                    Picker("Priority", selection: $priority) {
                        ForEach(TaskItem.Priority.allCases, id: \.self) { priority in
                            Text(priority.rawValue).tag(priority)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    DatePicker("Due Date", selection: $dueDate, displayedComponents: [.date])
                    
                    Picker("Project", selection: $selectedProjectId) {
                        Text("No Project").tag(nil as UUID?)
                        ForEach(taskManager.projects) { project in
                            HStack {
                                Image(systemName: project.icon)
                                    .foregroundStyle(project.color)
                                Text(project.name)
                            }
                            .tag(project.id as UUID?)
                        }
                    }
                } header: {
                    Text("Task Settings")
                }
            }
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    SDButton(
                        "Save",
                        variant: .primary,
                        size: .small
                    ) {
                        saveTask()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
    
    private func saveTask() {
        let task = TaskItem(
            id: UUID(),
            title: title,
            description: description,
            isCompleted: false,
            priority: priority,
            dueDate: dueDate,
            projectId: selectedProjectId ?? taskManager.projects.first?.id ?? UUID()
        )
        
        taskManager.addTask(task)
        dismiss()
    }
}

#Preview {
    AddTaskView(taskManager: TaskManager())
}
