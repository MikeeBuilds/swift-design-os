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

## Project Structure

```
TaskFlowExample/
├── Package.swift                    # SPM configuration
├── README.md                      # This file
└── Sources/
    ├── main.swift                  # App entry point
    ├── TaskManager.swift           # Task data model
    ├── TaskListView.swift          # Task list with filters
    ├── AddTaskView.swift          # New task form
    ├── ProjectListView.swift        # Project management
    └── CalendarAndSettings.swift   # Calendar and settings views
```

## Running the App

### Prerequisites

- Xcode 15.0+
- iOS 17.0+ simulator or device

### Setup

1. Navigate to the Swift DesignOS root directory
2. Open the package in Xcode:
   ```bash
   xed Examples/TaskFlowExample
   ```
3. Select iOS simulator or device
4. Press `Cmd + R` to build and run

### Building from Command Line

```bash
cd Examples/TaskFlowExample
swift run
```

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
    // Action
}
```

**Card Component:**
```swift
Card {
    Text("Content goes here")
}
```

**Badge Component:**
```swift
Badge("High Priority", variant: .destructive)
```

**Text Field Component:**
```swift
SDTextField(
    "Task Title",
    text: $title,
    placeholder: "Enter task",
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
}
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

## Design Tokens Usage

The app uses SwiftUI's built-in design system:

- **Colors**: `.accentColor`, `.secondary`, `.primary`, `.red`, `.green`
- **Typography**: `.largeTitle`, `.title`, `.headline`, `.body`, `.caption`
- **System**: `.secondarySystemBackground` for cards and sections

## Data Flow

```
TaskManager (Observable)
    ↓
Holds state for tasks
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

### Tasks Tab
- Search functionality
- Filter chips (All, Today, Upcoming, Completed)
- Task list with swipe-to-delete
- Add task button
- Task completion toggle

### Projects Tab
- Project list with color and icon
- Task count per project
- Project detail view
- Add project functionality

### Calendar Tab
- Date picker
- Tasks scheduled for selected date
- Visual task cards

### Settings Tab
- Appearance toggle
- Notification preferences
- App information

## Patterns Demonstrated

### Props-Based Components
```swift
struct TaskRow: View {
    let task: TaskItem
    let onToggle: () -> Void
    
    var body: some View {
        // Component logic
    }
}
```

### List with Filtering
```swift
var filteredTasks: [TaskItem] {
    tasks.filter { /* condition */ }
        .sorted { /* sort order */ }
}
```

### Form Validation
```swift
Button(action: saveTask) {
    // Button content
}
.disabled(title.isEmpty)
```

### Sheet Modals
```swift
.sheet(isPresented: $showAddTask) {
    AddTaskView(taskManager: taskManager)
}
```

## Custom Views

The app includes several custom views built with Swift DesignOS components:

- **TaskRow**: Individual task display
- **PriorityBadge**: Colored priority indicators
- **DateBadge**: Formatted date display
- **FilterChip**: Horizontal filter selector
- **ProjectRow**: Project display with icon
- **ColorCircle**: Color selection UI
- **IconChoice**: Icon picker grid

## Testing Features

To test the app:

1. **Add Task**: Tap "+ New Task", fill form, save
2. **Complete Task**: Tap circle icon on task row
3. **Delete Task**: Swipe left on task, tap Delete
4. **Filter Tasks**: Tap filter chips to change view
5. **Search**: Type in search field to filter
6. **Create Project**: Go to Projects tab, tap "+"
7. **View Calendar**: Select dates to see scheduled tasks

## Adaptability

The app adapts to:
- **Light/Dark Mode**: Uses system colors
- **Dynamic Type**: Respects font size preferences
- **Device Size**: Works on iPhone and iPad
- **Orientation**: Supports portrait and landscape

## Next Steps

To extend this example:
1. Add CloudKit sync for real data persistence
2. Implement drag-and-drop task reordering
3. Add task subtasks and notes
4. Include task reminders with local notifications
5. Add widget support for Home Screen
6. Implement task sharing and collaboration

## Troubleshooting

**Build fails:**
- Ensure Swift DesignOS is at root directory
- Check Xcode version is 15.0 or higher
- Clean build folder: `Cmd + Shift + K`

**Components not found:**
- Verify `import SwiftDesignOS` is present
- Check Package.swift dependency path is correct

**Runtime errors:**
- Ensure iOS simulator is running iOS 17+
- Check for missing `@ObservedObject` wrappers
- Verify state mutations are within `@Observable` classes

## License

This example is part of Swift DesignOS project.
