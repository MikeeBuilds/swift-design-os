import SwiftUI
import SwiftDesignOS

struct AddProjectView: View {
    @ObservedObject var taskManager: TaskManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var selectedColor: Color = .blue
    @State private var selectedIcon = "folder.fill"
    
    private let availableColors: [Color] = [.blue, .purple, .green, .orange, .red, .pink, .cyan, .indigo]
    private let availableIcons: [String] = [
        "folder.fill", "briefcase.fill", "house.fill", "heart.fill",
        "star.fill", "bolt.fill", "flame.fill", "leaf.fill",
        "cloud.fill", "sun.max.fill", "moon.fill", "paintbrush.fill"
    ]
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    SDTextField(
                        "Project Name",
                        text: $name,
                        placeholder: "Enter project name",
                        icon: "text.alignleft"
                    )
                } header: {
                    Text("Project Details")
                }
                
                Section {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))], spacing: 12) {
                        ForEach(availableColors, id: \.self) { color in
                            ColorCircle(color: color, isSelected: selectedColor == color) {
                                selectedColor = color
                            }
                        }
                    }
                } header: {
                    Text("Color")
                }
                
                Section {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))], spacing: 12) {
                        ForEach(availableIcons, id: \.self) { icon in
                            IconChoice(icon: icon, isSelected: selectedIcon == icon) {
                                selectedIcon = icon
                            }
                        }
                    }
                } header: {
                    Text("Icon")
                }
            }
            .navigationTitle("New Project")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    SDButton(
                        "Create",
                        variant: .primary,
                        size: .small
                    ) {
                        createProject()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
    
    private func createProject() {
        let project = Project(id: UUID(), name: name, color: selectedColor, icon: selectedIcon)
        taskManager.addProject(project)
        dismiss()
    }
}
