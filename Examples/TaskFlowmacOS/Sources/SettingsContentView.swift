import SwiftUI
import SwiftDesignOS

struct SettingsContentView: View {
    @ObservedObject var taskManager: TaskManager
    @AppStorage("appearanceMode") private var appearanceMode = "automatic"
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("defaultPriority") private var defaultPriority = "medium"
    @AppStorage("showCompletedTasks") private var showCompletedTasks = true
    
    var body: some View {
        Form {
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
                
                Toggle("Show Completed Tasks", isOn: $showCompletedTasks)
            } header: {
                Text("Preferences")
            }
            
            Section {
                HStack {
                    Text("Tasks")
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("\(taskManager.tasks.count)")
                        .foregroundStyle(.primary)
                }
                
                HStack {
                    Text("Projects")
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("\(taskManager.projects.count)")
                        .foregroundStyle(.primary)
                }
                
                HStack {
                    Text("Completed")
                        .foregroundStyle(.secondary)
                    Spacer()
                    let completed = taskManager.tasks.filter { $0.isCompleted }.count
                    Text("\(completed)")
                        .foregroundStyle(.green)
                }
            } header: {
                Text("Statistics")
            }
            
            Section {
                Button(action: {}) {
                    HStack {
                        Text("Clear All Data")
                        Spacer()
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundStyle(.orange)
                    }
                }
                .foregroundStyle(.red)
                
                Button(action: {}) {
                    HStack {
                        Text("Export Data")
                        Spacer()
                        Image(systemName: "square.and.arrow.up")
                            .foregroundStyle(.blue)
                    }
                }
            } header: {
                Text("Data Management")
            }
        }
        .formStyle(.grouped)
        .navigationTitle("Settings")
        .frame(minWidth: 500)
    }
}

#Preview {
    SettingsContentView(taskManager: TaskManager())
}
