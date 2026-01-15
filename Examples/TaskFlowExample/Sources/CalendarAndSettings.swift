import SwiftUI
import SwiftDesignOS

struct CalendarView: View {
    @ObservedObject var taskManager: TaskManager
    @State private var selectedDate = Date()
    
    var tasksForSelectedDate: [TaskItem] {
        let startOfDay = Calendar.current.startOfDay(for: selectedDate)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
        
        return taskManager.tasks.filter { task in
            task.dueDate >= startOfDay && task.dueDate < endOfDay
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(.graphical)
                .padding()
                .background(Color(.secondarySystemBackground))
            
            Divider()
            
            if tasksForSelectedDate.isEmpty {
                noTasksForDate
            } else {
                taskList
            }
        }
        .navigationTitle("Calendar")
    }
    
    private var noTasksForDate: some View {
        VStack(spacing: 20) {
            Image(systemName: "calendar.badge.checkmark")
                .font(.system(size: 50))
                .foregroundStyle(.secondary)
            
            Text("No tasks scheduled")
                .font(.title3)
                .fontWeight(.semibold)
            
            Text("Tasks scheduled for this date will appear here")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var taskList: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(tasksForSelectedDate) { task in
                    TaskCalendarRow(task: task)
                }
            }
            .padding()
        }
    }
}

struct TaskCalendarRow: View {
    let task: TaskItem
    @ObservedObject var taskManager = TaskManager()
    
    var body: some View {
        Card {
            HStack(alignment: .top, spacing: 12) {
                VStack(spacing: 4) {
                    Text(dayNumber)
                        .font(.title2)
                        .fontWeight(.bold)
                    Text(dayName)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                .frame(width: 44)
                
                Divider()
                    .frame(height: 50)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(task.title)
                        .font(.headline)
                    
                    Text(task.description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                    
                    HStack(spacing: 8) {
                        PriorityBadge(priority: task.priority)
                        Text(timeString)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
            }
            .padding(.vertical, 8)
        }
    }
    
    private var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: task.dueDate)
    }
    
    private var dayName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: task.dueDate)
    }
    
    private var timeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: task.dueDate)
    }
}

struct SettingsView: View {
    @AppStorage("darkMode") private var darkMode = false
    @AppStorage("notifications") private var notifications = true
    @AppStorage("hapticFeedback") private var hapticFeedback = true
    
    var body: some View {
        List {
            Section("Appearance") {
                Toggle("Dark Mode", isOn: $darkMode)
                    .tint(.accentColor)
            }
            
            Section("Notifications") {
                Toggle("Task Reminders", isOn: $notifications)
                    .tint(.accentColor)
                
                Toggle("Haptic Feedback", isOn: $hapticFeedback)
                    .tint(.accentColor)
            }
            
            Section {
                HStack {
                    Text("Version")
                    Spacer()
                    Text("1.0.0")
                        .foregroundStyle(.secondary)
                }
                
                HStack {
                    Text("Build")
                    Spacer()
                    Text("1")
                        .foregroundStyle(.secondary)
                }
            }
            
            Section("About") {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("TaskFlow")
                            .font(.headline)
                        Text("A modern task management app")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "checkmark.circle.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.green)
                }
                .padding(.vertical, 8)
            }
        }
        .navigationTitle("Settings")
    }
}
