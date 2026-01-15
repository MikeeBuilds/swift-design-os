# TaskFlow iOS Example

A complete task management application demonstrating Swift DesignOS integration on iOS 17+.

## Features Demonstrated

- **Swift DesignOS Components**: Uses `SDButton`, `Card`, `Badge`, `SDTextField`
- **State Management**: `@Observable` and `@ObservedObject` for reactive data
- **Navigation**: `TabView` and `NavigationStack` for app structure
- **Data Binding**: Two-way binding with `@State` and `@Binding`
- **Lists & Forms**: SwiftUI `List` and `Form` for data display and entry
- **Sheets**: Modal sheets for adding tasks and projects
- **Design Tokens**: Uses SwiftUI system colors and typography
- **Swipe Actions**: Native swipe-to-delete functionality
- **Date Handling**: Calendar integration with date filtering
- **Accessibility**: Full VoiceOver support

## Project Structure

```
TaskFlowiOS/
├── Package.swift                    # SPM configuration
├── README.md                      # This file
└── Sources/
    ├── main.swift                  # App entry point and data models
    ├── TaskListView.swift          # Task list with filters and search
    ├── AddTaskView.swift          # New task form
    ├── ProjectListView.swift        # Project management with color/icon picker
    └── CalendarView.swift         # Calendar view and settings
```

## Running the App

### Prerequisites

- Xcode 15.0+
- iOS 17.0+ simulator or device
- Swift 6.0+

### Setup

1. Navigate to the Swift DesignOS root directory
2. Open the package in Xcode:
   ```bash
   open Examples/TaskFlowiOS
   ```
3. Select iOS simulator or device
4. Press `Cmd + R` to build and run

### Building from Command Line

```bash
cd Examples/TaskFlowiOS
swift run
```

### Adding Swift DesignOS as a Dependency

In Xcode:
1. File → Add Package Dependencies
2. Choose "Add Local Package"
3. Navigate to the `swift-design-os` directory
4. Select version rule (e.g., "Up to Next Major Version")
5. Add package to your target

## Key Integration Points

### 1. Importing Swift DesignOS

```swift
import SwiftDesignOS
```

### 2. Using Components

**Button Component:**
```swift
SDButton(
    "Add Task",
    variant: .primary,
    size: .medium
) {
    // Action handler
}
```

Available variants: `.primary`, `.secondary`, `.ghost`, `.outline`, `.destructive`
Available sizes: `.small`, `.medium`, `.large`

**Card Component:**
```swift
Card {
    Text("Content goes here")
        .font(.headline)
        .foregroundStyle(.primary)
}
```

Cards support optional header and footer:
```swift
Card(header: {
    Text("Header")
}) content: {
    Text("Content")
} footer: {
    Text("Footer")
}
```

**Badge Component:**
```swift
Badge("High Priority", variant: .destructive)
```

Available variants: `.primary`, `.secondary`, `.destructive`, `.outline`, `.success`

**Text Field Component:**
```swift
SDTextField(
    "Task Title",
    text: $title,
    placeholder: "Enter task title",
    icon: "text.alignleft"
)
```

### 3. State Management

```swift
@Observable
class TaskManager {
    var tasks: [TaskItem] = []
    
    func addTask(_ task: TaskItem) {
        tasks.append(task)
    }
    
    func toggleTask(_ task: TaskItem) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
        }
    }
}
```

Use with `@ObservedObject` in views:
```swift
@ObservedObject var taskManager: TaskManager
```

### 4. Navigation Structure

```swift
TabView(selection: $selectedTab) {
    TaskListView(taskManager: taskManager)
        .tabItem {
            Label("Tasks", systemImage: "checkmark.circle")
        }
        .tag(Tab.tasks)
}
```

### 5. Sheet Modals

```swift
@State private var showingAddTask = false

.sheet(isPresented: $showingAddTask) {
    AddTaskView(taskManager: taskManager)
}
```

## Design Tokens Usage

The app uses SwiftUI's built-in design system:

- **Colors**: `.accentColor`, `.secondary`, `.primary`, `.red`, `.green`, `.blue`, `.purple`
- **Typography**: `.largeTitle`, `.title`, `.headline`, `.body`, `.caption`
- **System Colors**: `.systemGroupedBackground` for grouped lists

## Data Flow

```
TaskManager (@Observable)
    ↓
Holds state for tasks and projects
    ↓
Views observe changes via @ObservedObject
    ↓
User actions trigger state updates
    ↓
Views automatically re-render
```

## Screen Breakdown

### Main Screen (ContentView)
- Tab-based navigation
- 4 tabs: Tasks, Projects, Calendar, Settings
- Global task manager instance

### Tasks Tab
- Search functionality with real-time filtering
- Filter chips (All, Today, Upcoming, Completed)
- Task list with swipe-to-delete
- Add task button in toolbar
- Task completion toggle
- Project filtering support

### Projects Tab
- Project list with custom color and icon
- Task count per project
- Project selection for filtering tasks
- Add project functionality
- Delete project with confirmation

### Calendar Tab
- Date picker with graphical calendar
- Tasks scheduled for selected date
- Visual task cards
- Empty state handling

### Settings Tab
- Appearance mode (Automatic/Light/Dark)
- Notification preferences
- Default priority selection
- About screen with app info

## Patterns Demonstrated

### Props-Based Components

```swift
struct TaskRow: View {
    let task: TaskItem
    let project: Project?
    let onToggle: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        // Component implementation
    }
}
```

### List with Filtering

```swift
var filteredTasks: [TaskItem] {
    var filtered = taskManager.tasks
    
    // Apply project filter
    if let selectedProject = selectedProject {
        filtered = filtered.filter { $0.projectId == selectedProject.id }
    }
    
    // Apply search filter
    if !searchText.isEmpty {
        filtered = filtered.filter { task in
            task.title.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    // Apply status filter
    switch filter {
    case .completed:
        filtered = filtered.filter { $0.isCompleted }
    case .today:
        filtered = filtered.filter { /* today condition */ }
    default:
        break
    }
    
    return filtered.sorted { $0.dueDate < $1.dueDate }
}
```

### Form Validation

```swift
SDButton(
    "Save",
    variant: .primary,
    size: .small
) {
    saveTask()
}
.disabled(title.isEmpty)
```

### Swipe Actions

```swift
TaskRow(task: task, project: project) {
    // Toggle action
} onDelete: {
    // Delete action
}
```

Inside TaskRow:
```swift
.swipeActions(edge: .trailing, allowsFullSwipe: true) {
    Button(role: .destructive) {
        onDelete()
    } label: {
        Label("Delete", systemImage: "trash")
    }
}
```

## Custom Views

The app includes several custom views built with Swift DesignOS components:

- **TaskRow**: Individual task display with completion toggle
- **PriorityBadge**: Colored priority indicators
- **FilterChip**: Horizontal filter selector
- **ProjectCard**: Project display with icon and color
- **ColorCircle**: Color selection UI
- **IconChoice**: Icon picker grid
- **CalendarView**: Date-based task viewing
- **SettingsView**: App preferences

## Testing Features

To test the app:

1. **Add Task**: Tap "+ New Task", fill form, save
2. **Complete Task**: Tap circle icon on task row
3. **Delete Task**: Swipe left on task, tap Delete
4. **Filter Tasks**: Tap filter chips to change view
5. **Search**: Type in search field to filter tasks
6. **Create Project**: Go to Projects tab, tap "+"
7. **Select Project**: Tap project card to filter tasks
8. **View Calendar**: Select dates to see scheduled tasks
9. **Change Settings**: Toggle appearance, set preferences

## Adaptability

The app adapts to:

- **Light/Dark Mode**: Uses system colors
- **Dynamic Type**: Respects font size preferences
- **Device Size**: Works on iPhone (all sizes) and iPad
- **Orientation**: Supports portrait and landscape
- **Accessibility**: Full VoiceOver support with proper labels

## Error Handling

The app handles errors gracefully:

- Empty task titles disabled save button
- Missing projects default to first available
- Search handles case-insensitive matching
- Date calculations account for timezone
- Deletion cascades to related tasks

## Next Steps

To extend this example:

1. Add CloudKit sync for real data persistence
2. Implement drag-and-drop task reordering
3. Add task subtasks and notes
4. Include task reminders with local notifications
5. Add widget support for Home Screen
6. Implement task sharing and collaboration
7. Add Siri shortcuts for quick task creation
8. Include analytics and crash reporting

## Troubleshooting

**Build fails:**
- Ensure Swift DesignOS is at root directory
- Check Xcode version is 15.0 or higher
- Clean build folder: Product → Clean Build Folder (Cmd + Shift + K)
- Verify iOS deployment target is 17.0+

**Components not found:**
- Verify `import SwiftDesignOS` is present in file
- Check Package.swift dependency path is correct: `"../.."`

**Runtime errors:**
- Ensure iOS simulator is running iOS 17+
- Check for missing `@ObservedObject` wrappers
- Verify state mutations are within `@Observable` classes
- Confirm all @State variables are initialized

**Package resolution issues:**
- Delete `.build` folder: `rm -rf .build`
- Clean Xcode derived data
- Re-add package dependency
- Use "Add Local Package" option

## Platform-Specific Considerations

### iPad Support

- Split view navigation possible
- Larger touch targets
- Landscape orientation optimization
- Keyboard shortcuts (Cmd + N for new task)

### iPhone Support

- Compact layouts
- Tab bar navigation
- Swipe gestures primary interaction
- Sheet presentation style adapts

## License

This example is part of Swift DesignOS project and is released under the MIT License.
