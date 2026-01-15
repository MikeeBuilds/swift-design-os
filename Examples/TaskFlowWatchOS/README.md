# TaskFlow watchOS Example

A complete task management application demonstrating Swift DesignOS integration on watchOS 10+ with watch-specific patterns.

## Features Demonstrated

- **Swift DesignOS Components**: Uses `SDButton`, `Card`, `Badge`, `SDTextField` (adapted for watch)
- **watchOS Navigation**: `TabView` with bottom tab bar
- **Digital Crown Support**: Scrollable lists with crown scrolling
- **Compact Layouts**: Optimized for small 42mm and 44mm screens
- **Watch Colors**: Uses ClockKit `WatchColor` enum for consistent colors
- **Sheets**: Full-screen and half-sheet presentations
- **Touch Interactions**: Large touch targets and gesture-based actions
- **Simplified UI**: Minimal information density for readability
- **Battery Awareness**: Optimized for limited battery life

## Project Structure

```
TaskFlowWatchOS/
├── Package.swift                       # SPM configuration
├── README.md                         # This file
└── Sources/
    ├── main.swift                       # App entry point and data models
    ├── TodayView.swift                  # Today's tasks view
    ├── UpcomingView.swift               # Upcoming tasks list
    ├── ProjectsView.swift               # Project grid and details
    └── SettingsView.swift              # Settings and preferences
```

## Running the App

### Prerequisites

- Xcode 15.0+
- watchOS 10.0+ simulator or device
- Apple Watch Series 4 or later (recommended)
- Swift 6.0+

### Setup

1. Navigate to Swift DesignOS root directory
2. Open the package in Xcode:
   ```bash
   open Examples/TaskFlowWatchOS
   ```
3. Select watchOS scheme
4. Choose "My Watch (44mm)" or "My Watch (41mm)"
5. Press `Cmd + R` to build and run

### Building from Command Line

```bash
cd Examples/TaskFlowWatchOS
swift run
```

## Key Integration Points

### 1. Watch App Entry Point

```swift
@main
struct TaskFlowWatchOSApp: App {
    @StateObject private var taskManager = TaskManager()
    @State private var selectedTab: Tab = .today
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $selectedTab) {
                // Tab views
            }
        }
        .windowStyle(.plain)
    }
}
```

### 2. Using Components (Watch Adapted)

**Card for watchOS:**
```swift
Card {
    HStack(spacing: 8) {
        Image(systemName: "calendar")
            .font(.title2)
        
        Text("Today's Tasks")
            .font(.body)
    }
    .padding(.horizontal, 12)
    .padding(.vertical, 8)
}
```

**Badge for watchOS:**
```swift
Badge("!", variant: .destructive)
    .font(.caption2)
    .padding(.horizontal, 4)
    .padding(.vertical, 2)
```

### 3. Watch Color System

```swift
enum WatchColor: String, Codable {
    case blue, purple, green, orange, red, pink, cyan, indigo, yellow, black, gray
}

// Use in views:
Circle()
    .fill(project.watchColor)
    .frame(width: 44, height: 44)
```

### 4. Digital Crown Support

The Digital Crown automatically scrolls scrollable views:

```swift
ScrollView {
    VStack(spacing: 12) {
        ForEach(tasks) { task in
            TaskRow(task: task)
        }
    }
}
```

Scrolling works via:
- Digital Crown rotation
- Swipe gestures
- Tap to scroll

### 5. Touch-Friendly Interactions

```swift
Button(action: toggleTask) {
    HStack(spacing: 10) {
        // Large touch target (minimum 44x44 points)
        Circle()
            .frame(width: 28, height: 28)
        
        Text(task.title)
            .font(.body)
    }
    .contentShape(Rectangle())
}
```

### 6. Full-Screen Sheets

```swift
.sheet(item: $showingDetail) { task in
    TaskDetailSheet(task: task)
}
```

For half-height sheets:
```swift
.sheet(isPresented: $showingSheet) {
    HalfSheetView()
} content: {
    // Content
}
.presentationDetents([.medium, .large])
```

## watchOS-Specific Patterns

### Compact Design Principles

1. **Focus on Essential Information**
   - Show only what's needed at glance
   - Remove decorative elements
   - Use concise text

2. **Large Touch Targets**
   - Minimum 44x44 points
   - Generous padding
   - Clear visual hierarchy

3. **Optimized Scrolling**
   - Short lists (5-10 items max)
   - Snap to nearest item
   - Crown-friendly scrolling

4. **Battery Optimization**
   - Reduce animations
   - Limit background refresh
   - Efficient data loading

### Screen Layouts

**Header Pattern:**
```swift
struct HeaderCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        Card {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(color)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    Text(subtitle)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}
```

**Compact Task Row:**
```swift
struct CompactTaskRow: View {
    let task: TaskItem
    let project: Project?
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .stroke(priorityColor, lineWidth: 3)
                        .frame(width: 28, height: 28)
                    
                    if task.isCompleted {
                        Image(systemName: "checkmark")
                            .font(.caption2)
                            .foregroundStyle(.white)
                    }
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(task.title)
                        .font(.body)
                        .lineLimit(1)
                }
            }
        }
    }
}
```

**Empty State:**
```swift
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
            
            Text(detail)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(24)
    }
}
```

### Digital Crown Interactions

The Digital Crown enhances navigation:

```swift
ScrollView {
    VStack(spacing: 12) {
        ForEach(tasks) { task in
            TaskRow(task: task)
        }
    }
}
```

**Automatic Behaviors:**
- Crown rotation scrolls content
- Crown press activates focus
- Haptic feedback on snap

**Custom Crown Actions:**
```swift
.focusable()
.digitalCrownRotation($crownRotation) { delta in
    // Custom crown handling
}
```

### Complications (Optional Advanced Feature)

To add complications:

1. Create complication controller
2. Implement timeline provider
3. Register with ClockKit

```swift
struct TaskFlowComplication: View {
    var body: some View {
        Text("\(taskCount)")
            .font(.system(.caption))
    }
}
```

### Background Execution Limitations

watchOS has strict background limits:

**Allowed Background Activities:**
- Complication updates
- Background app refresh
- Location updates (with permission)

**Limitations:**
- Maximum 30 seconds per session
- Limited to 4 sessions per hour
- Must request additional time

**Best Practices:**
```swift
class BackgroundTaskManager: NSObject, WKExtendedRuntimeSessionDelegate {
    func scheduleBackgroundTask() {
        WKApplication.shared().scheduleBackgroundRefresh(
            withPreferredDate: Date().addingTimeInterval(3600),
            userInfo: ["refresh": "tasks"]
        )
    }
}
```

## Screen Breakdown

### Today Tab

- Header with task count
- Maximum 5-8 tasks shown
- Completion toggle by tapping
- Priority indicators
- Project color dot

### Upcoming Tab

- Shows next 10 tasks
- Days remaining display
- Tap to view detail
- Long-press to toggle
- Empty state when caught up

### Projects Tab

- Grid of project cards (2 per row)
- Project icon and color
- Task count per project
- Tap to view project tasks
- Scrollable list

### Settings Tab

- Toggle for notifications
- Default priority selector
- About screen
- Simple, touch-friendly

## Design Tokens for watchOS

### Colors (WatchColor)

```swift
enum WatchColor: String {
    case blue       // #007AFF
    case purple     // #5856D6
    case green      // #34C759
    case orange     // #FF9500
    case red        // #FF453A
    case pink       // #FF2D55
    case cyan       // #5AC8FA
    case indigo     // #5856D6
    case yellow     // #FFCC00
    case black      // #000000
    case gray       // #8E8E93
}
```

### Typography

```swift
// Use smaller fonts for watch
.font(.caption)          // 11pt
.font(.caption2)         // 10pt
.font(.callout)          // 14pt
.font(.body)             // 16pt
.font(.title3)           // 20pt
.font(.title2)           // 22pt
.font(.title)            // 28pt
```

### Spacing

```swift
// Generous spacing for touch targets
.padding(.horizontal, 12)  // Side padding
.padding(.vertical, 8)     // Top/bottom padding
.spacing(12)                 // Between items
```

## Patterns Demonstrated

### Tab-Based Navigation

```swift
TabView(selection: $selectedTab) {
    TodayView()
        .tabItem {
            Label("Today", systemImage: "calendar")
        }
        .tag(Tab.today)
    
    UpcomingView()
        .tabItem {
            Label("Upcoming", systemImage: "clock")
        }
        .tag(Tab.upcoming)
}
```

### List with Crown Scrolling

```swift
ScrollView {
    VStack(spacing: 12) {
        ForEach(tasks) { task in
            TaskRow(task: task)
        }
    }
}
```

### Sheet Presentation

```swift
.sheet(item: $showingDetail) { task in
    NavigationStack {
        TaskDetailSheet(task: task)
    }
}
```

### State Management

```swift
@Observable
class TaskManager {
    var tasks: [TaskItem] = []
    
    func tasksForDate(_ date: Date) -> [TaskItem] {
        tasks.filter {
            Calendar.current.isDate($0.dueDate, inSameDayAs: date)
        }
    }
    
    func upcomingTasks(limit: Int = 10) -> [TaskItem] {
        tasks.filter {
            $0.dueDate > Date() && !$0.isCompleted
        }.prefix(limit)
    }
}
```

## Testing Features

To test the app:

1. **Navigate Tabs**: Tap bottom tab icons
2. **Toggle Task**: Tap task row to complete
3. **Scroll List**: Rotate Digital Crown
4. **Swipe Navigation**: Swipe up/down to scroll
5. **View Detail**: Tap task for full details
6. **Change Settings**: Toggle notifications, set priority
7. **Battery Test**: Run on actual device
8. **Different Sizes**: Test on 41mm and 45mm
9. **Force Touch**: Use Xcode's touch simulator
10. **Background Launch**: Trigger from complication

## Adaptability

The app adapts to:

- **Screen Sizes**: 40mm, 41mm, 44mm, 45mm
- **Watch Series**: Optimized for Series 4+
- **Accessibility**: VoiceOver with reduced motion
- **Always On Display**: Optimized brightness
- **Battery States**: Reduced animations when low

## watchOS Limitations & Workarounds

### Limitation: Background Execution

**Problem:** watchOS severely limits background time

**Workaround:** Use complications for updates
```swift
func updateComplication() {
    let server = CLKComplicationServer.sharedInstance()
    
    for family in CLKComplicationFamily.allCases {
        if let complication = server.activeComplications(ofFamily: family).first {
            let timeline = CLKComplicationTimeline(entry: complicationEntry)
            server.reloadTimeline(for: complication)
        }
    }
}
```

### Limitation: Small Screen

**Problem:** Limited space for information

**Workaround:** Progressive disclosure
```swift
// Show summary first
Text("\(taskCount) tasks")

// Detail on tap
.onTapGesture {
    showingFullList = true
}
```

### Limitation: No Keyboard

**Problem:** Can't type on watch

**Workaround:** Force touch input with selection lists
```swift
Picker("Priority", selection: $priority) {
    ForEach(priorities, id: \.self) { priority in
        Text(priority.rawValue).tag(priority)
    }
}
```

### Limitation: Limited Connectivity

**Problem:** Watch may not have iPhone connection

**Workaround:** Cache data locally
```swift
@AppStorage("cachedTasks") private var cachedTasks: Data?

func syncTasks() {
    if WCSession.default.isReachable {
        // Sync with iPhone
    } else {
        // Use cached data
        loadCachedTasks()
    }
}
```

## Next Steps

To extend this example:

1. Add complications for at-a-glance updates
2. Implement Watch connectivity with iPhone app
3. Add haptic feedback on task completion
4. Include Siri shortcuts for quick task creation
5. Add background refresh scheduling
6. Implement custom crown actions
7. Add force touch gestures
8. Include always-on display optimizations
9. Add localized strings
10. Implement complication configuration screen

## Troubleshooting

**Build fails:**
- Ensure Swift DesignOS is at root directory
- Check Xcode version is 15.0 or higher
- Clean build folder: Product → Clean Build Folder (Cmd + Shift + K)
- Verify watchOS deployment target is 10.0+

**Simulator issues:**
- Test on actual device when possible
- Force Touch Bar in simulator
- Check simulator screen size matches watch

**Touch targets too small:**
- Ensure minimum 44x44 points
- Add generous padding
- Increase button sizes

**Battery drain:**
- Reduce animation duration
- Limit background refreshes
- Optimize image loading
- Use efficient SwiftUI layouts

**Scrolling issues:**
- Test with Digital Crown
- Verify ScrollView parent
- Check for conflicting gestures

## Performance Optimizations

### Memory

```swift
// Limit list items
ForEach(tasks.prefix(10)) { task in
    TaskRow(task: task)
}

// Use @State sparingly
@State private var isVisible = false
```

### Rendering

```swift
// Disable animations when battery low
@Environment(\.scenePhase) private var scenePhase

var animationDisabled: Bool {
    WKInterfaceDevice.current().batteryState == .critical
}

.animation(animationDisabled ? nil : .default)
```

### Battery

```swift
// Check battery state
let battery = WKInterfaceDevice.current().batteryState
switch battery {
case .critical:
    // Reduce features
case .low:
    // Warn user
default:
    // Full functionality
}
```

## License

This example is part of Swift DesignOS project and is released under MIT License.
