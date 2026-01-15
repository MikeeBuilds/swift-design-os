# TaskFlow macOS Example

A complete task management application demonstrating Swift DesignOS integration on macOS 14+ with desktop-specific patterns.

## Features Demonstrated

- **Swift DesignOS Components**: Uses `SDButton`, `Card`, `Badge`, `SDTextField`
- **macOS Navigation**: `NavigationSplitView` with sidebar navigation
- **Window Management**: Window toolbar, custom window styles, resizable windows
- **Table Views**: SwiftUI `Table` with column layouts and context menus
- **Keyboard Shortcuts**: Command key shortcuts for common actions
- **Menu Bar Integration**: Custom menus and toolbar items
- **Sidebar Navigation**: macOS-style sidebar with sections and counts
- **Master-Detail Layout**: Three-pane navigation (Sidebar → List → Detail)
- **State Management**: `@Observable` and `@ObservedObject` for reactive data
- **Design Tokens**: Uses SwiftUI system colors and typography

## Project Structure

```
TaskFlowmacOS/
├── Package.swift                      # SPM configuration
├── README.md                        # This file
└── Sources/
    ├── main.swift                     # App entry point and data models
    ├── SidebarContentView.swift          # Sidebar navigation structure
    ├── TaskListContentView.swift       # Table-based task list
    ├── ProjectsContentView.swift        # Project grid and detail views
    └── SettingsContentView.swift       # macOS settings panel
```

## Running the App

### Prerequisites

- Xcode 15.0+
- macOS 14.0+ (Sonoma or later)
- Swift 6.0+

### Setup

1. Navigate to Swift DesignOS root directory
2. Open the package in Xcode:
   ```bash
   open Examples/TaskFlowmacOS
   ```
3. Select "My Mac (Designed for iPad)" target
4. Press `Cmd + R` to build and run

### Building from Command Line

```bash
cd Examples/TaskFlowmacOS
swift run
```

## Key Integration Points

### 1. macOS Window Management

```swift
WindowGroup {
    ContentView()
}
.windowStyle(.hiddenTitleBar)
.windowResizability(.contentSize)
.defaultSize(width: 1000, height: 700)
```

### 2. Toolbar Integration

```swift
.toolbar {
    ToolbarItemGroup(placement: .primaryAction) {
        SDButton("New Task", variant: .primary) {
            // Action
        }
        .keyboardShortcut("n", modifiers: [.command])
    }
    
    ToolbarItemGroup(placement: .automatic) {
        Menu {
            Button("All Tasks") { }
            Button("Today") { }
        } label: {
            Image(systemName: "sidebar.left")
        }
    }
}
```

### 3. Sidebar Navigation

```swift
NavigationSplitView {
    SidebarView(sidebarSelection: $sidebarSelection)
} detail: {
    DetailView(sidebarSelection: sidebarSelection)
}
.navigationSplitViewStyle(.balanced)
```

### 4. Table Views

```swift
Table(tasks, selection: $selectedTask) {
    TableColumn("Status") { task in
        Button(action: toggleTask) {
            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
        }
    }
    .width(50)
    
    TableColumn("Task") { task in
        Text(task.title)
    }
}
.tableStyle(.inset(alternatesRowBackgrounds: true))
.contextMenu(forSelectionType: TaskItem.self) { items in
    Button("Delete", role: .destructive) {
        deleteTask(items.first!)
    }
}
```

### 5. Context Menus

```swift
.contextMenu(forSelectionType: TaskItem.self) { items in
    if let task = items.first {
        Button("Mark Complete") {
            taskManager.toggleTask(task)
        }
        
        Button("Delete", role: .destructive) {
            taskManager.deleteTask(task)
        }
    }
} primaryAction: { task in
    taskManager.toggleTask(task)
}
```

### 6. Command Menu

```swift
.commands {
    CommandGroup(replacing: .newItem) {
        Button("New Task") {
            createNewTask()
        }
        .keyboardShortcut("n", modifiers: [.command])
    }
}
```

### 7. Keyboard Shortcuts

```swift
SDButton("New Task", variant: .primary) {
    createTask()
}
.keyboardShortcut("n", modifiers: [.command])
```

Available shortcuts:
- `Cmd + N`: New task
- `Cmd + Shift + N`: New project
- `Cmd + W`: Close window
- `Cmd + Q`: Quit app

## macOS-Specific Patterns

### Sidebar Layout

macOS apps commonly use a three-pane layout:

1. **Sidebar**: Navigation and filters
2. **Master List**: Items within selection
3. **Detail View**: Selected item details

```swift
NavigationSplitView {
    // Pane 1: Sidebar
    SidebarView(selection: $sidebarSelection)
} detail: {
    NavigationSplitView {
        // Pane 2: Master List
        TaskListView(projectId: selectedProject)
    } detail: {
        // Pane 3: Detail
        TaskDetailView(task: selectedTask)
    }
}
```

### Window Styles

```swift
.windowStyle(.hiddenTitleBar)
.windowResizability(.contentSize)
.defaultSize(width: 1000, height: 700)
```

### Form Styles

macOS forms use grouped style:

```swift
Form {
    Section {
        // Form content
    } header: {
        Text("Section Header")
    }
}
.formStyle(.grouped)
```

### Toolbar Placement

```swift
.toolbar {
    ToolbarItemGroup(placement: .primaryAction) {
        // Primary actions
    }
    
    ToolbarItemGroup(placement: .automatic) {
        // Automatic positioning
    }
    
    ToolbarItemGroup(placement: .cancellationAction) {
        // Cancel button
    }
    
    ToolbarItemGroup(placement: .confirmationAction) {
        // Confirm/save button
    }
}
```

## Screen Breakdown

### Main Window

**Sidebar Sections:**
- Tasks: All Tasks, Today, Upcoming
- Projects: List of all projects
- App: Projects navigation, Settings

**Toolbar Items:**
- New Task button (primary action)
- View switcher menu

### All Tasks View

- Search bar at top
- Table with columns: Status, Task, Priority, Due Date, Project
- Click row to select task
- Right-click for context menu
- Click status circle to toggle completion

### Today View

- Date display
- Task count summary
- Filtered to today's tasks only
- Visual empty state when no tasks

### Upcoming View

- Future tasks only
- Sorted by due date
- Excludes completed tasks
- Visual empty state when caught up

### Projects View

- Grid of project cards
- Each card shows:
  - Project icon and color
  - Task count
  - Progress bar
  - View/Delete buttons
- Click project to see tasks
- Detail panel shows project tasks

### Settings View

- Form-based layout
- Display preferences
- Task preferences
- Statistics panel
- Data management options

## Design Tokens Usage

The app uses SwiftUI's macOS design system:

- **Colors**: `.accentColor`, `.secondary`, `.primary`, `.red`, `.green`, `.blue`, `.purple`
- **Typography**: `.largeTitle`, `.title`, `.headline`, `.body`, `.caption`
- **Spacing**: Standard macOS spacing (8pt, 12pt, 16pt)
- **Corner Radius**: 10pt for cards, 8pt for buttons

## Adaptability

The app adapts to:

- **Light/Dark Mode**: Uses system colors
- **Window Size**: Responsive sidebar width and column sizes
- **Display Scale**: Supports Retina displays
- **Keyboard Navigation**: Full keyboard support

## Testing Features

To test the app:

1. **Create Task**: Press `Cmd + N`, fill details, save
2. **Toggle Task**: Click status circle in table
3. **Delete Task**: Right-click task, select Delete
4. **Navigate Sidebar**: Click different sidebar items
5. **Search Tasks**: Type in search field
6. **Create Project**: Click "New Project", fill form
7. **View Project Tasks**: Click project card, see tasks in detail
8. **Change Settings**: Open Settings, adjust preferences
9. **Use Keyboard Shortcuts**: Try `Cmd + N`, `Cmd + W`
10. **Resize Window**: Drag window edge to resize

## Platform-Specific Considerations

### Window Management

- Hidden title bar for custom toolbar
- Minimum window size enforced
- Resizable by user
- Supports fullscreen mode

### Menu Bar

- App menu with standard items (About, Preferences, Quit)
- File menu with New Task/New Project
- Edit menu with keyboard shortcuts
- View menu with display options

### Accessibility

- Full VoiceOver support
- Keyboard navigation through table rows
- Reduced motion option support
- High contrast mode support

## Patterns Demonstrated

### Three-Pane Navigation

```swift
NavigationSplitView {
    SidebarView()
} detail: {
    NavigationSplitView {
        MasterListView()
    } detail: {
        DetailView()
    }
}
```

### Table with Selection

```swift
Table(items, selection: $selectedItem) {
    TableColumn("Name") { item in
        Text(item.name)
    }
}
.tableStyle(.inset(alternatesRowBackgrounds: true))
```

### Grid Layout

```swift
LazyVGrid(columns: [
    GridItem(.adaptive(minimum: 280), spacing: 16)
], spacing: 16) {
    ForEach(items) { item in
        CardView(item: item)
    }
}
```

### Form in Sheet

```swift
.sheet(isPresented: $showingSheet) {
    NavigationStack {
        Form {
            Section {
                // Form fields
            }
        }
        .formStyle(.grouped)
        .navigationTitle("Title")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") { save() }
            }
        }
    }
    .frame(width: 500, height: 400)
}
```

## Next Steps

To extend this example:

1. Add Core Data persistence
2. Implement drag-and-drop for tasks
3. Add Quick Look previews
4. Include Spotlight integration
5. Add Touch Bar support (for Intel Macs)
6. Implement widget support
7. Add iCloud sync
8. Include keyboard shortcut customization
9. Add export to CSV/PDF
10. Implement task templates

## Troubleshooting

**Build fails:**
- Ensure Swift DesignOS is at root directory
- Check Xcode version is 15.0 or higher
- Clean build folder: Product → Clean Build Folder (Cmd + Shift + K)
- Verify macOS deployment target is 14.0+

**Window not appearing:**
- Check if app is in full screen
- Verify window is not minimized
- Check display arrangement

**Table not responding:**
- Verify data model conforms to `Identifiable`
- Check table selection binding
- Ensure table style is correct

**Sidebar not updating:**
- Verify sidebar selection binding
- Check for state mutations
- Ensure `@ObservedObject` is used

## License

This example is part of Swift DesignOS project and is released under the MIT License.
