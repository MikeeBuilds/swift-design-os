import SwiftUI
import SwiftDesignOS

struct CalendarView: View {
    @ObservedObject var taskManager: TaskManager
    @State private var selectedDate = Date()
    
    var tasksForDate: [TaskItem] {
        taskManager.tasks.filter { task in
            Calendar.current.isDate(task.dueDate, inSameDayAs: selectedDate)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Card {
                DatePicker(
                    "Select Date",
                    selection: $selectedDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
            }
            .padding()
            
            List {
                if tasksForDate.isEmpty {
                    ContentUnavailableView {
                        Label("No tasks scheduled", systemImage: "calendar.badge.exclamationmark")
                    } description: {
                        Text("Select a different date or add new tasks")
                    }
                } else {
                    ForEach(tasksForDate) { task in
                        TaskRow(
                            task: task,
                            project: taskManager.getProject(id: task.projectId)
                        ) {
                            taskManager.toggleTask(task)
                        } onDelete: {
                            taskManager.deleteTask(task)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
        }
        .background(Color(.systemGroupedBackground))
    }
}

struct SettingsView: View {
    @ObservedObject var taskManager: TaskManager
    @AppStorage("appearanceMode") private var appearanceMode = "automatic"
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("defaultPriority") private var defaultPriority = "medium"
    @State private var showingAbout = false
    
    var body: some View {
        List {
            Section {
                Picker("Appearance", selection: $appearanceMode) {
                    Text("Automatic").tag("automatic")
                    Text("Light").tag("light")
                    Text("Dark").tag("dark")
                }
                .pickerStyle(.menu)
            } header: {
                Text("Display")
            }
            
            Section {
                Toggle("Enable Notifications", isOn: $notificationsEnabled)
                
                Picker("Default Priority", selection: $defaultPriority) {
                    ForEach(TaskItem.Priority.allCases, id: \.rawValue) { priority in
                        Text(priority.rawValue).tag(priority.rawValue)
                    }
                }
                .pickerStyle(.menu)
            } header: {
                Text("Preferences")
            }
            
            Section {
                Button(action: { showingAbout = true }) {
                    HStack {
                        Text("About TaskFlow")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Button(role: .destructive) {
                } label: {
                    Text("Clear All Data")
                }
            } header: {
                Text("About")
            }
        }
        .listStyle(.insetGrouped)
        .sheet(isPresented: $showingAbout) {
            AboutView()
        }
    }
}

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.accentColor)
                
                VStack(spacing: 8) {
                    Text("TaskFlow")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Version 1.0.0")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Text("A beautiful task management app built with Swift DesignOS")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()
                
                Card {
                    VStack(spacing: 12) {
                        Link("GitHub Repository", destination: URL(string: "https://github.com/MikeeBuilds/swift-design-os")!)
                            .buttonStyle(.plain)
                        
                        Link("Report Issue", destination: URL(string: "https://github.com/MikeeBuilds/swift-design-os/issues")!)
                            .buttonStyle(.plain)
                    }
                }
                .padding()
                
                Spacer()
            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    CalendarView(taskManager: TaskManager())
}

#Preview {
    SettingsView(taskManager: TaskManager())
}
