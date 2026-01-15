# Swift DesignOS Usage Guide

This guide explains how to use Swift DesignOS as both a library and a planning tool.

---

## Table of Contents

1. [Installation](#installation)
2. [Using as a Library](#using-as-a-library)
3. [Using as a Planning Tool](#using-as-a-planning-tool)
4. [API Reference](#api-reference)
5. [Example Workflows](#example-workflows)
6. [Best Practices](#best-practices)

---

## Installation

### Swift Package Manager

Add Swift DesignOS to your project:

```bash
# Xcode → File → Add Package Dependencies...
# Enter: https://github.com/YOUR_ORG/swift-design-os.git
# Select version rule (e.g., "Up to Next Major Version")
# Add to your target
```

Requirements:
- iOS 17.0+, macOS 14.0+, watchOS 10.0+, tvOS 17.0+
- Swift 6.0+
- Xcode 15+

### Manual Installation

```bash
git clone https://github.com/YOUR_ORG/swift-design-os.git
cd swift-design-os

# Add as local package in Xcode
# File → Add Package Dependencies → Add Local Package...
# Select swift-design-os directory
```

---

## Using as a Library

### Core Models

Swift DesignOS provides data models for representing product designs:

```swift
import SwiftDesignOS

// Product overview
let product = ProductOverview(
    name: "TaskFlow",
    description: "Team task management app",
    problems: [
        "Teams struggle with task coordination",
        "Remote work requires better tools"
    ],
    solutions: [
        "Centralized task dashboard",
        "Real-time collaboration"
    ],
    features: [
        "Daily task feed",
        "Project organization",
        "Team assignments"
    ]
)

// Section specification
let section = Section(
    id: "daily-feed",
    name: "Daily Feed",
    overview: "Shows today's tasks for the team",
    userFlows: [
        "View today's tasks",
        "Mark task as complete",
        "Add new task"
    ],
    uiRequirements: [
        "List view with task cards",
        "Quick actions (complete, defer)",
        "Filter by priority"
    ]
)

// Entity definition
let entity = Entity(
    name: "Task",
    properties: [
        Property(name: "id", type: "UUID"),
        Property(name: "title", type: "String"),
        Property(name: "status", type: "TaskStatus"),
        Property(name: "dueDate", type: "Date", optional: true)
    ],
    relationships: [
        Relationship(to: "Project", type: "many-to-one")
    ]
)
```

### Data Loaders

Load product definitions from markdown files:

```swift
import SwiftDesignOS

// Load product overview
let productData = try loadProductData(from: "product/product-overview.md")

// Load data model
let dataModel = try loadDataModel(from: "product/data-model/data-model.md")

// Load section specification
let sectionData = try loadSectionData(from: "product/sections/dashboard/spec.md")

// Load design system
let designSystem = try loadDesignSystem(from: "product/design-system/")
```

### SwiftUI Components

Swift DesignOS includes reusable SwiftUI components:

```swift
import SwiftDesignOS
import SwiftUI

// Button component
Button("Get Started") {
    // Handle tap
}
.buttonStyle(.primary)

// Card component
Card {
    VStack {
        Text("Daily Tasks")
            .font(.title)
        Text("5 tasks due today")
            .font(.subheadline)
    }
}

// Badge component
Badge("In Progress", variant: .info)

// Dialog component
Dialog(
    isPresented: $showDialog,
    title: "Delete Task",
    message: "Are you sure you want to delete this task?",
    primaryButton: ("Delete", .destructive) { /* action */ },
    secondaryButton: ("Cancel", .cancel) { /* action */ }
)
```

### Export Generation

Generate implementation packages:

```swift
import SwiftDesignOS

let exporter = Exporter()

// Generate export package
let exportPackage = try exporter.generateExport(
    product: product,
    sections: sections,
    designSystem: designSystem
)

// Save to file
try exportPackage.save(to: "product-plan.zip")
```

---

## Using as a Planning Tool

### Mac App Interface

The Xcode app provides a guided 10-step workflow:

1. **Product Vision** — Define your app's identity
2. **Product Roadmap** — Break into development sections
3. **Data Model** — Specify entities and relationships
4. **Design Tokens** — Choose colors, typography, and patterns
5. **Application Shell** — Design navigation structure
6. **Shape Section** — Define section requirements (repeat per section)
7. **Sample Data** — Generate test data (repeat per section)
8. **Design Screen** — Create SwiftUI views (repeat per section)
9. **Screenshot Design** — Capture visual documentation (optional)
10. **Export Product** — Generate implementation package

### Running the App

```bash
# Clone repository
git clone https://github.com/YOUR_ORG/swift-design-os.git
cd swift-design-os

# Open Xcode project
open App/swift-design-os-app/swift-design-os-app.xcodeproj

# Run in Xcode (⌘R)
```

### CLI Commands

Use commands from `.claude/commands/design-os/`:

```bash
# Define product vision
/claude/commands/design-os/product-vision.md

# Create roadmap
/claude/commands/design-os/product-roadmap.md

# Specify data model
/claude/commands/design-os/data-model.md

# Choose design tokens
/claude/commands/design-os/design-tokens.md

# Design application shell
/claude/commands/design-os/design-shell.md

# Define a section
/claude/commands/design-os/shape-section.md [section-id]

# Generate sample data
/claude/commands/design-os/sample-data.md [section-id]

# Design screens
/claude/commands/design-os/design-screen.md [section-id]

# Generate screenshots
/claude/commands/design-os/screenshot-design.md [section-id]

# Export package
/claude/commands/design-os/export-product.md
```

---

## API Reference

### Data Models

#### `ProductOverview`

Represents the overall product vision.

```swift
struct ProductOverview: Codable {
    let name: String
    let description: String
    let problems: [String]
    let solutions: [String]
    let features: [String]
}
```

#### `Section`

Represents a development section (feature area).

```swift
struct Section: Codable, Identifiable {
    let id: String
    let name: String
    let overview: String
    let userFlows: [String]
    let uiRequirements: [String]
    let components: [String]
}
```

#### `Entity`

Represents a data model entity.

```swift
struct Entity: Codable, Identifiable {
    let id: UUID
    let name: String
    let description: String
    let properties: [Property]
    let relationships: [Relationship]
}
```

#### `DesignSystem`

Represents the visual design system.

```swift
struct DesignSystem: Codable {
    let colors: ColorPalette
    let typography: Typography
    let spacing: Spacing
    let borderRadius: BorderRadius
}
```

### Loaders

#### `loadProductData(from:)`

Load product overview from markdown file.

```swift
func loadProductData(from path: String) throws -> ProductOverview
```

**Parameters:**
- `path`: File path to product overview markdown

**Returns:** `ProductOverview` object

**Throws:** File not found, parse errors

#### `loadSectionData(from:)`

Load section specification from markdown file.

```swift
func loadSectionData(from path: String) throws -> Section
```

**Parameters:**
- `path`: File path to section spec markdown

**Returns:** `Section` object

**Throws:** File not found, parse errors

#### `loadDesignSystem(from:)`

Load design system from JSON files.

```swift
func loadDesignSystem(from path: String) throws -> DesignSystem
```

**Parameters:**
- `path`: Directory path containing `colors.json` and `typography.json`

**Returns:** `DesignSystem` object

**Throws:** File not found, JSON parse errors

### Components

#### `Button`

Standardized button component.

```swift
Button("Get Started") {
    // Action
}
.buttonStyle(.primary)
```

**Variants:**
- `.primary` — Main action button
- `.secondary` — Secondary action
- `.destructive` — Destructive action

#### `Card`

Container component with rounded corners and shadow.

```swift
Card {
    // Content
}
```

#### `Badge`

Status indicator component.

```swift
Badge("In Progress", variant: .info)
```

**Variants:**
- `.info` — Blue
- `.success` — Green
- `.warning` — Orange
- `.error` — Red

#### `Dialog`

Modal dialog component.

```swift
Dialog(
    isPresented: $showDialog,
    title: "Delete Task",
    message: "Are you sure?",
    primaryButton: ("Delete", .destructive) { /* action */ },
    secondaryButton: ("Cancel", .cancel) { /* action */ }
)
```

### Export

#### `Exporter.generateExport(product:sections:designSystem:)`

Generate complete export package.

```swift
func generateExport(
    product: ProductOverview,
    sections: [Section],
    designSystem: DesignSystem
) throws -> ExportPackage
```

**Parameters:**
- `product`: Product overview
- `sections`: Array of section definitions
- `designSystem`: Design system specification

**Returns:** `ExportPackage` object

**Throws:** Validation errors, file system errors

---

## Example Workflows

### Workflow 1: Create New Product

1. **Define Vision**
   ```swift
   let product = ProductOverview(
       name: "TaskFlow",
       description: "Team task management app",
       problems: ["Poor coordination"],
       solutions: ["Centralized dashboard"],
       features: ["Daily feed", "Projects"]
   )
   ```

2. **Create Roadmap**
   ```swift
   let sections = [
       Section(id: "daily-feed", name: "Daily Feed", ...),
       Section(id: "projects", name: "Projects", ...)
   ]
   ```

3. **Define Data Model**
   ```swift
   let task = Entity(name: "Task", ...)
   let project = Entity(name: "Project", ...)
   let dataModel = DataModel(entities: [task, project])
   ```

4. **Choose Design System**
   ```swift
   let designSystem = DesignSystem(
       colors: .bluePalette,
       typography: .sfPro
   )
   ```

5. **Export**
   ```swift
   let export = try exporter.generateExport(
       product: product,
       sections: sections,
       designSystem: designSystem
   )
   ```

### Workflow 2: Use in Existing Project

```swift
import SwiftDesignOS
import SwiftUI

struct TaskListApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                DailyFeedView()
                    .tabItem { Label("Feed", systemImage: "tray") }
                ProjectsView()
                    .tabItem { Label("Projects", systemImage: "folder") }
                SettingsView()
                    .tabItem { Label("Settings", systemImage: "gear") }
            }
        }
    }
}

struct DailyFeedView: View {
    @State private var tasks: [Task] = []
    
    var body: some View {
        NavigationView {
            List(tasks) { task in
                TaskRow(task: task)
            }
            .navigationTitle("Today")
        }
    }
}
```

### Workflow 3: Generate Component Library

```swift
import SwiftDesignOS

// Define component using design system
struct TaskCard: View {
    let task: Task
    let onTap: (Task.ID) -> Void
    let onComplete: (Task.ID) -> Void
    
    var body: some View {
        Card {
            VStack(alignment: .leading, spacing: 8) {
                Text(task.title)
                    .font(.headline)
                Text(task.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack {
                    Badge(task.status, variant: statusVariant(task.status))
                    Spacer()
                    Button("Complete") {
                        onComplete(task.id)
                    }
                    .buttonStyle(.secondary)
                }
            }
        }
        .onTapGesture {
            onTap(task.id)
        }
    }
    
    private func statusVariant(_ status: TaskStatus) -> BadgeVariant {
        switch status {
        case .pending: return .info
        case .inProgress: return .warning
        case .completed: return .success
        }
    }
}
```

---

## Best Practices

### 1. Props-Based Components

Always pass data via properties:

```swift
// ✅ Good: Props-based
struct TaskList: View {
    let tasks: [Task]
    let onTaskTap: (Task.ID) -> Void
    let onTaskDelete: (Task.ID) -> Void
    
    var body: some View {
        List(tasks) { task in
            TaskRow(task: task, onTap: onTaskTap)
        }
    }
}

// ❌ Bad: Direct data import
struct TaskList: View {
    let tasks = loadTasksFromFile()  // Not portable!
    
    var body: some View {
        // ...
    }
}
```

### 2. Design Token Usage

Always use design system tokens:

```swift
// ✅ Good: Use design tokens
Text("Title")
    .font(.title)
    .foregroundColor(designSystem.colors.primary)

// ❌ Bad: Hardcoded values
Text("Title")
    .font(.system(size: 24, weight: .bold))
    .foregroundColor(Color(hex: "#007AFF"))
```

### 3. Multi-Platform Considerations

Use size classes and platform-specific layouts:

```swift
struct TaskListView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        if horizontalSizeClass == .compact {
            // iPhone layout
            List(tasks) { task in
                TaskRow(task: task)
            }
        } else {
            // iPad/Mac layout
            HSplitView {
                TaskList(tasks: tasks)
                TaskDetail(selectedTask: selectedTask)
            }
        }
    }
}
```

### 4. Light & Dark Mode

Support both themes:

```swift
struct Card: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color(.systemBackground))
            .shadow(radius: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(.separator), lineWidth: 1)
            )
    }
}
```

### 5. Accessibility

Make components accessible:

```swift
Button("Complete Task") {
    completeTask()
}
.accessibilityLabel("Complete task")
.accessibilityHint("Marks task as done")
.accessibilityAddTraits(.isButton)
```

### 6. Testing

Write tests for components:

```swift
@MainActor
struct TaskRowTests: XCTestCase {
    func testTaskRowDisplaysTitle() {
        let task = Task(id: UUID(), title: "Test Task", ...)
        let view = TaskRow(task: task, onTap: { _ in })
        
        // Verify title is displayed
    }
    
    func testTaskRowOnTap() {
        var tappedTaskID: UUID?
        let task = Task(id: UUID(), title: "Test Task", ...)
        let view = TaskRow(
            task: task,
            onTap: { tappedTaskID = $0 }
        )
        
        // Tap and verify callback
    }
}
```

---

## Troubleshooting

### Package Not Found

**Problem:** Swift Package Manager can't find Swift DesignOS.

**Solution:**
```bash
# Clear SwiftPM cache
rm -rf ~/Library/Developer/Xcode/DerivedData/*/SourcePackages

# Re-add package in Xcode
# File → Add Package Dependencies...
```

### Build Errors

**Problem:** Compilation errors on specific platforms.

**Solution:**
- Check minimum deployment targets match Package.swift
- Verify Swift version (6.0+ required)
- Ensure Xcode 15+ installed

### Missing Components

**Problem:** Component not found after import.

**Solution:**
```swift
// Verify import
import SwiftDesignOS

// Check public API
let button = Button("Test") { }
```

---

## Resources

- [Full Documentation](../README.md)
- [Components Reference](components.md)
- [Examples](examples.md)
- [GitHub Setup](github-setup.md)
- [Publishing Guide](PUBLISHING.md)

---

**Need Help?**
- Open an [issue](../.github/ISSUE_TEMPLATE.md)
- Join [Discussions](https://github.com/YOUR_ORG/swift-design-os/discussions)
