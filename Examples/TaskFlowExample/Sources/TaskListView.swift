import SwiftUI
import SwiftDesignOS

struct TaskListView: View {
    @ObservedObject var taskManager: TaskManager
    @State private var showAddTask = false
    @State private var filter: TaskFilter = .all
    @State private var searchText = ""
    
    enum TaskFilter: String, CaseIterable {
        case all = "All"
        case today = "Today"
        case upcoming = "Upcoming"
        case completed = "Completed"
    }
    
    var filteredTasks: [TaskItem] {
        let tasks = taskManager.tasks
        
        let textFiltered = searchText.isEmpty ? tasks : tasks.filter {
            $0.title.localizedCaseInsensitiveContains(searchText)
        }
        
        let statusFiltered: [TaskItem]
        switch filter {
        case .all:
            statusFiltered = textFiltered.filter { !$0.isCompleted }
        case .today:
            let today = Calendar.current.startOfDay(for: Date())
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
            statusFiltered = textFiltered.filter { task in
                !task.isCompleted && task.dueDate >= today && task.dueDate < tomorrow
            }
        case .upcoming:
            statusFiltered = textFiltered.filter { task in
                !task.isCompleted && task.dueDate > Date()
            }
        case .completed:
            statusFiltered = textFiltered.filter { $0.isCompleted }
        }
        
        return statusFiltered.sorted { $0.dueDate < $1.dueDate }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                searchHeader
                
                filterPicker
                
                if filteredTasks.isEmpty {
                    emptyState
                } else {
                    taskList
                }
            }
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    SDButton(
                        "+ New Task",
                        variant: .primary,
                        size: .small
                    ) {
                        showAddTask = true
                    }
                }
            }
            .sheet(isPresented: $showAddTask) {
                AddTaskView(taskManager: taskManager)
            }
        }
    }
    
    private var searchHeader: some View {
        SDTextField(
            "Search tasks",
            text: $searchText,
            placeholder: "Search...",
            icon: "magnifyingglass"
        )
        .padding()
    }
    
    private var filterPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(TaskFilter.allCases, id: \.self) { filterOption in
                    FilterChip(
                        title: filterOption.rawValue,
                        isSelected: filter == filterOption
                    ) {
                        filter = filterOption
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
    }
    
    private var taskList: some View {
        List {
            ForEach(filteredTasks) { task in
                TaskRow(task: task) {
                    taskManager.toggleTaskCompletion(id: task.id)
                }
            }
            .onDelete { indexSet in
                for index in indexSet {
                    taskManager.deleteTask(id: filteredTasks[index].id)
                }
            }
        }
        .listStyle(.insetGrouped)
    }
    
    private var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.dashed")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
            
            Text("No tasks found")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text(searchText.isEmpty && filter == .all
                 ? "Tap + to create your first task"
                 : "Try adjusting your filters")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct TaskRow: View {
    let task: TaskItem
    let onToggle: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: onToggle) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(task.isCompleted ? .green : .secondary)
            }
            .buttonStyle(PlainButtonStyle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.body)
                    .fontWeight(.medium)
                    .strikethrough(task.isCompleted)
                    .foregroundStyle(task.isCompleted ? .secondary : .primary)
                
                Text(task.description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                
                HStack(spacing: 8) {
                    PriorityBadge(priority: task.priority)
                    DateBadge(dueDate: task.dueDate)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct PriorityBadge: View {
    let priority: TaskItem.Priority
    
    var body: some View {
        Badge(
            priority.rawValue.capitalized,
            variant: priorityVariant
        )
    }
    
    private var priorityVariant: BadgeVariant {
        switch priority {
        case .high: return .destructive
        case .medium: return .secondary
        case .low: return .outline
        }
    }
}

struct DateBadge: View {
    let dueDate: Date
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "calendar")
            Text(formattedDate)
        }
        .font(.caption2)
        .foregroundStyle(.secondary)
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: dueDate)
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.accentColor : Color(.secondarySystemBackground))
                .foregroundStyle(isSelected ? .white : .primary)
                .clipShape(Capsule())
        }
        .buttonStyle(PlainButtonStyle())
    }
}
