import SwiftUI
import SwiftDesignOS

struct TaskListView: View {
    @ObservedObject var taskManager: TaskManager
    @Binding var selectedProject: Project?
    @State private var searchText = ""
    @State private var filter: FilterOption = .all
    
    enum FilterOption: String, CaseIterable {
        case all = "All"
        case today = "Today"
        case upcoming = "Upcoming"
        case completed = "Completed"
    }
    
    var filteredTasks: [TaskItem] {
        var filtered = taskManager.tasks
        
        if let selectedProject = selectedProject {
            filtered = filtered.filter { $0.projectId == selectedProject.id }
        }
        
        if !searchText.isEmpty {
            filtered = filtered.filter { task in
                task.title.localizedCaseInsensitiveContains(searchText) ||
                task.description.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        switch filter {
        case .all:
            break
        case .today:
            let today = Calendar.current.startOfDay(for: Date())
            filtered = filtered.filter { task in
                Calendar.current.isDate(task.dueDate, inSameDayAs: today)
            }
        case .upcoming:
            let today = Calendar.current.startOfDay(for: Date())
            filtered = filtered.filter { task in
                task.dueDate > today && !task.isCompleted
            }
        case .completed:
            filtered = filtered.filter { $0.isCompleted }
        }
        
        return filtered.sorted { $0.dueDate < $1.dueDate }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Card {
                VStack(spacing: 12) {
                    SDTextField(
                        "Search tasks",
                        text: $searchText,
                        placeholder: "Search by title or description",
                        icon: "magnifyingglass"
                    )
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(FilterOption.allCases, id: \.self) { option in
                                FilterChip(
                                    option: option,
                                    isSelected: filter == option
                                ) {
                                    filter = option
                                }
                            }
                        }
                        .padding(.horizontal, 4)
                    }
                }
            }
            .padding()
            
            if selectedProject != nil {
                HStack {
                    Text("Filtered by: \(selectedProject?.name ?? "")")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Button("Clear") {
                        selectedProject = nil
                    }
                    .font(.caption)
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }
            
            List {
                ForEach(filteredTasks) { task in
                    TaskRow(task: task, project: taskManager.getProject(id: task.projectId)) {
                        taskManager.toggleTask(task)
                    } onDelete: {
                        taskManager.deleteTask(task)
                    }
                }
                .onDelete(perform: deleteTasks)
            }
            .listStyle(.insetGrouped)
        }
        .background(Color(.systemGroupedBackground))
    }
    
    private func deleteTasks(offsets: IndexSet) {
        for index in offsets {
            taskManager.deleteTask(filteredTasks[index])
        }
    }
}

struct TaskRow: View {
    let task: TaskItem
    let project: Project?
    let onToggle: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        Card {
            HStack(alignment: .top, spacing: 12) {
                Button(action: onToggle) {
                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                        .font(.title2)
                        .foregroundStyle(task.isCompleted ? .green : .secondary)
                }
                .buttonStyle(PlainButtonStyle())
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(task.title)
                            .font(.headline)
                            .foregroundStyle(.primary)
                            .strikethrough(task.isCompleted)
                        
                        Spacer()
                        
                        Badge(task.priority.rawValue, variant: task.priority == .high ? .destructive : (task.priority == .medium ? .primary : .secondary))
                    }
                    
                    if !task.description.isEmpty {
                        Text(task.description)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }
                    
                    HStack(spacing: 8) {
                        HStack(spacing: 4) {
                            Image(systemName: "calendar")
                                .font(.caption2)
                            Text(dueDateText)
                                .font(.caption)
                        }
                        .foregroundStyle(isOverdue ? .red : .secondary)
                        
                        if let project = project {
                            HStack(spacing: 4) {
                                Image(systemName: project.icon)
                                    .font(.caption2)
                                    .foregroundStyle(project.color)
                                Text(project.name)
                                    .font(.caption)
                            }
                            .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
    
    private var isOverdue: Bool {
        !task.isCompleted && task.dueDate < Date()
    }
    
    private var dueDateText: String {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let taskDate = calendar.startOfDay(for: task.dueDate)
        
        if calendar.isDateInToday(task.dueDate) {
            return "Today"
        } else if calendar.isDateInTomorrow(task.dueDate) {
            return "Tomorrow"
        } else if task.dueDate < today {
            let days = calendar.dateComponents([.day], from: task.dueDate, to: today).day ?? 0
            return "\(days)d overdue"
        } else {
            let days = calendar.dateComponents([.day], from: today, to: task.dueDate).day ?? 0
            return "\(days)d left"
        }
    }
}

struct FilterChip: View {
    let option: TaskListView.FilterOption
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Text(option.rawValue)
                .font(.caption)
                .fontWeight(isSelected ? .semibold : .regular)
                .foregroundStyle(isSelected ? .white : .primary)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.accentColor : Color.secondary.opacity(0.1))
                .clipShape(Capsule())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    TaskListView(
        taskManager: TaskManager(),
        selectedProject: .constant(nil)
    )
}
