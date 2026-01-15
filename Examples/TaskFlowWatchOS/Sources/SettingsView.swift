import SwiftUI
import SwiftDesignOS

struct SettingsView: View {
    @ObservedObject var taskManager: TaskManager
    @AppStorage("notificationEnabled") private var notificationsEnabled = true
    @AppStorage("defaultPriority") private var defaultPriority = "medium"
    @State private var showingAbout = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                HeaderCard(
                    title: "Settings",
                    subtitle: "",
                    icon: "gearshape.circle.fill",
                    color: .gray
                )
                
                VStack(spacing: 16) {
                    ToggleRow(
                        icon: "bell.fill",
                        title: "Notifications",
                        subtitle: "Task reminders",
                        isOn: $notificationsEnabled
                    )
                    
                    NavigationLink(destination: PrioritySelectionView()) {
                        SettingsRow(
                            icon: "exclamationmark.triangle.fill",
                            title: "Default Priority",
                            subtitle: defaultPriority
                        )
                    }
                    
                    Button(action: { showingAbout = true }) {
                        SettingsRow(
                            icon: "info.circle.fill",
                            title: "About",
                            subtitle: "TaskFlow v1.0"
                        )
                    }
                }
                .padding(.horizontal)
            }
        }
        .sheet(isPresented: $showingAbout) {
            AboutView()
        }
    }
}

struct ToggleRow: View {
    let icon: String
    let title: String
    let subtitle: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.accentColor)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .tint(.accentColor)
        }
        .contentShape(Rectangle())
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.gray)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                
                Text(subtitle)
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

struct PrioritySelectionView: View {
    @AppStorage("defaultPriority") private var defaultPriority = "medium"
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(TaskItem.Priority.allCases, id: \.self) { priority in
                        Button(action: {
                            defaultPriority = priority.rawValue
                            dismiss()
                        }) {
                            HStack(spacing: 12) {
                                Circle()
                                    .fill(priority.watchColor)
                                    .frame(width: 24, height: 24)
                                
                                Text(priority.rawValue)
                                    .font(.body)
                                    .foregroundStyle(.primary)
                                    .fontWeight(.semibold)
                                
                                Spacer()
                                
                                if defaultPriority == priority.rawValue {
                                    Image(systemName: "checkmark")
                                        .font(.caption)
                                        .foregroundStyle(.accentColor)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
            .navigationTitle("Priority")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    Spacer()
                    
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(.accentColor)
                    
                    VStack(spacing: 8) {
                        Text("TaskFlow")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("for Apple Watch")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        Text("Version 1.0.0")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    
                    Card {
                        Text("A beautiful task management app built with Swift DesignOS")
                            .font(.caption)
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                    }
                    
                    Spacer()
                }
            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct EmptyState: View {
    let icon: String
    let message: String
    let detail: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 40))
                .foregroundStyle(.secondary)
            
            Text(message)
                .font(.body)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
            
            Text(detail)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(24)
    }
}

#Preview {
    SettingsView(taskManager: TaskManager())
}

#Preview("Priority Selection") {
    NavigationStack {
        PrioritySelectionView()
    }
}
