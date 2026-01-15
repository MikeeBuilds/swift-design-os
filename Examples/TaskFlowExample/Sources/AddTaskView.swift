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
                        placeholder: "Enter task title"
                    )
                    
                    SDTextField(
                        "Description",
                        text: $description,
                        placeholder: "Add details (optional)",
                        icon: "text.alignleft"
                    )
                }
                
                Section {
                    DatePicker("Due Date", selection: $dueDate)
                    
                    Picker("Priority", selection: $priority) {
                        ForEach(TaskItem.Priority.allCases, id: \.self) { priority in
                            Text(priority.rawValue.capitalized).tag(priority)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section {
                    Button(action: saveTask) {
                        HStack {
                            Spacer()
                            Text("Save Task")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    .disabled(title.isEmpty)
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
            }
        }
    }
    
    private func saveTask() {
        let task = TaskItem(
            id: UUID(),
            title: title,
            description: description,
            priority: priority,
            dueDate: dueDate,
            projectId: selectedProjectId ?? UUID(),
            isCompleted: false
        )
        taskManager.addTask(task)
        dismiss()
    }
}
