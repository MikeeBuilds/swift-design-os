# Swift DesignOS Examples

This directory contains three complete example applications demonstrating Swift DesignOS integration across Apple platforms.

## Available Examples

### 1. TaskFlowiOS
**Platform**: iOS 17+ (iPhone, iPad)

A complete task management application with:
- Tab-based navigation (Tasks, Projects, Calendar, Settings)
- Full Swift DesignOS component usage
- Swipe-to-delete actions
- Search and filtering
- Sheet-based forms
- Data binding with @Observable

**Directory**: `TaskFlowiOS/`
**README**: [TaskFlowiOS/README.md](./TaskFlowiOS/README.md)

### 2. TaskFlowmacOS
**Platform**: macOS 14+ (Apple Silicon and Intel)

A desktop-native task manager with:
- Sidebar navigation with NavigationSplitView
- Table-based task lists
- Toolbar integration with keyboard shortcuts
- Menu bar commands
- Three-pane layout (Sidebar → List → Detail)
- macOS-specific design patterns

**Directory**: `TaskFlowmacOS/`
**README**: [TaskFlowmacOS/README.md](./TaskFlowmacOS/README.md)

### 3. TaskFlowWatchOS
**Platform**: watchOS 10+ (Apple Watch Series 4+)

A watch-optimized task manager with:
- Tab-based navigation (Today, Upcoming, Projects, Settings)
- Digital Crown scrolling support
- Watch-specific color system
- Compact layouts for small screens
- Battery-optimized rendering
- Background execution considerations

**Directory**: `TaskFlowWatchOS/`
**README**: [TaskFlowWatchOS/README.md](./TaskFlowWatchOS/README.md)

## Running the Examples

### Prerequisites

- **Swift DesignOS**: Must be in parent directory
- **Xcode**: Version 15.0 or higher
- **Swift**: Version 6.0 or higher
- **Platform SDK**:
  - iOS examples: iOS 17.0+
  - macOS examples: macOS 14.0+
  - watchOS examples: watchOS 10.0+

### Quick Start

```bash
# Navigate to example directory
cd Examples/TaskFlowiOS

# Open in Xcode
open .

# Or build from command line
swift run
```

### Adding Swift DesignOS Dependency

Each example has Swift DesignOS configured as a local package dependency in `Package.swift`:

```swift
dependencies: [
    .package(name: "SwiftDesignOS", path: "../..")
]
```

This allows the examples to import Swift DesignOS components:

```swift
import SwiftDesignOS
```

## Common Patterns Across Examples

All three examples demonstrate:

### Swift DesignOS Components

```swift
// Button
SDButton("Action", variant: .primary, size: .medium) {
    // Handle tap
}

// Card
Card {
    Text("Content inside card")
}

// Badge
Badge("Label", variant: .secondary)

// Text Field
SDTextField("Label", text: $text, placeholder: "Placeholder", icon: "icon")
```

### State Management

```swift
@Observable
class DataManager {
    var items: [Item] = []
    
    func addItem(_ item: Item) {
        items.append(item)
    }
}

@ObservedObject var dataManager: DataManager
```

### Navigation Patterns

Each platform uses its native navigation:

- **iOS**: `TabView` with `NavigationStack`
- **macOS**: `NavigationSplitView` with sidebar
- **watchOS**: `TabView` with simplified views

## Platform-Specific Features

### iOS Features

- Tab bar navigation
- Sheet presentations
- Swipe actions on list items
- Pull-to-refresh
- Large touch targets
- iPad-specific layouts

### macOS Features

- Sidebar navigation
- Toolbar with keyboard shortcuts
- Menu bar integration
- Table views with context menus
- Command menu customization
- Window management

### watchOS Features

- Digital Crown support
- Watch color system
- Compact layouts
- Battery optimization
- Limited background execution
- Complication support (documented)

## Data Model

All examples share similar data structures:

```swift
// Task Item
struct TaskItem: Identifiable, Codable {
    let id: UUID
    var title: String
    var description: String
    var isCompleted: Bool
    var priority: Priority
    var dueDate: Date
    var projectId: UUID
}

// Project
struct Project: Identifiable, Codable {
    let id: UUID
    var name: String
    var color: Color
    var icon: String
}

// Priority
enum Priority: String, CaseIterable, Codable {
    case high = "High"
    case medium = "Medium"
    case low = "Low"
}
```

## Building for Production

When adapting these examples for production:

1. **Replace Sample Data**: Connect to real data sources
2. **Add Persistence**: Implement Core Data or Swift Data
3. **Add Network**: Integrate API calls
4. **Add Authentication**: Implement login/registration
5. **Add Analytics**: Track user behavior
6. **Add Crash Reporting**: Monitor errors
7. **Add Localization**: Support multiple languages
8. **Add Tests**: Unit and UI tests
9. **Add CI/CD**: Automated builds and deployment
10. **Add Documentation**: API docs and user guides

## Testing

Each example includes:
- Sample data for immediate functionality
- Preview macros for Xcode canvas
- Full navigation flows
- Empty states handling
- Error states
- Loading states

### Manual Testing Checklist

- [ ] All views render without errors
- [ ] Navigation flows work end-to-end
- [ ] State updates trigger UI refreshes
- [ ] Platform-specific features work
- [ ] Dark mode adapts correctly
- [ ] Accessibility with VoiceOver
- [ ] Performance is acceptable
- [ ] Memory usage is reasonable
- [ ] Battery impact (watchOS)

## Troubleshooting

### Common Issues

**Swift DesignOS not found:**
- Verify Package.swift points to `"../.."`
- Check parent directory structure
- Clean build folder and rebuild

**Build fails:**
- Check Xcode version requirement (15.0+)
- Verify Swift version (6.0+)
- Clean derived data
- Restart Xcode

**Simulator issues:**
- Test on physical device when possible
- Check simulator iOS/watchOS/macOS version
- Reset simulator content and settings

**Components not displaying:**
- Ensure `import SwiftDesignOS` is present
- Verify component parameters match API
- Check platform compatibility

## Learning Path

Recommended order for learning Swift DesignOS:

1. Start with **TaskFlowiOS** for basic patterns
2. Explore **TaskFlowmacOS** for desktop navigation
3. Study **TaskFlowWatchOS** for constraint-based design
4. Compare component usage across all three
5. Adapt patterns to your own project

## Contributing

Found an issue? Want to improve an example?

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test on all platforms
5. Submit a pull request

## License

All examples are part of Swift DesignOS project and are released under the MIT License.

## Additional Resources

- [Swift DesignOS Main README](../README.md)
- [Swift DesignOS Documentation](../docs/)
- [Apple SwiftUI Documentation](https://developer.apple.com/documentation/swiftui/)
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)

---

Happy building with Swift DesignOS! 🚀
