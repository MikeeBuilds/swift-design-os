# Swift DesignOS Components Documentation

Swift DesignOS provides reusable SwiftUI components for building planning interfaces.

## Components

### AppLayout

Main layout wrapper for planning application.

```swift
import SwiftUI
import SwiftDesignOS

struct MyView: View {
    var body: some View {
        AppLayout(title: "My Product") {
            VStack {
                Text("Content")
            }
        }
    }
}
```

**Parameters:**
- `title: String` — Page title
- `content: () -> Content` — Content view

### PhaseNav

Navigation component for workflow phases.

```swift
struct WorkflowView: View {
    @State private var currentPhase: Phase = .productVision

    var body: some View {
        PhaseNav(currentPhase: $currentPhase)
        // Phase-specific content
    }
}
```

**Parameters:**
- `currentPhase: Binding<Phase>` — Currently selected phase
- `phases: [Phase]?` — Optional custom phases list

### Button

Styled button with multiple variants.

```swift
// Primary button
Button(action: { /* action */ }) {
    Text("Continue")
}
.buttonStyle(.primary)

// Secondary button
Button(action: { /* action */ }) {
    Text("Cancel")
}
.buttonStyle(.secondary)

// Destructive button
Button(action: { /* action */ }) {
    Text("Delete")
}
.buttonStyle(.destructive)

// Disabled button
Button(action: { /* action */ }) {
    Text("Save")
}
.buttonStyle(.primary)
.disabled(true)
```

**Button Styles:**
- `.primary` — Main action buttons
- `.secondary` — Secondary actions
- `.destructive` — Dangerous actions (delete, remove)
- `.ghost` — Minimal styling

### Card

Card container for grouping content.

```swift
DesignOSCard {
    VStack(alignment: .leading, spacing: 12) {
        Text("Card Title")
            .font(.headline)

        Text("Card description goes here")
            .font(.body)
            .foregroundColor(.secondary)
    }
    .padding()
}
```

**Modifiers:**
- `.padding()` — Internal padding
- `.background()` — Custom background color
- `.cornerRadius()` — Custom corner radius

### Dialog

Modal dialog for confirmations and prompts.

```swift
struct MyView: View {
    @State private var showDialog = false

    var body: some View {
        Button("Show Dialog") {
            showDialog = true
        }
        .sheet(isPresented: $showDialog) {
            Dialog(
                title: "Confirm Action",
                message: "Are you sure you want to proceed?",
                primaryAction: DialogAction(
                    title: "Yes, Proceed",
                    style: .primary
                ) {
                    // Handle confirm
                    showDialog = false
                },
                secondaryAction: DialogAction(
                    title: "Cancel",
                    style: .secondary
                ) {
                    // Handle cancel
                    showDialog = false
                }
            )
        }
    }
}
```

**Parameters:**
- `title: String` — Dialog title
- `message: String?` — Optional message
- `primaryAction: DialogAction` — Primary button action
- `secondaryAction: DialogAction?` — Optional secondary action

### Badge

Status badge for displaying tags or categories.

```swift
HStack {
    Text("Item")
    Badge("New", color: .blue)
    Badge("Important", color: .red)
}
```

**Parameters:**
- `text: String` — Badge text
- `color: Color?` — Optional custom color

### TextField

Styled text input field.

```swift
struct FormView: View {
    @State private var name = ""

    var body: some View {
        TextField("Product Name", text: $name)
            .textFieldStyle(.rounded)
            .padding()
    }
}
```

**Field Styles:**
- `.rounded` — Rounded corners
- `.plain` — No border
- `.underlined` — Bottom border only

**Validation:**

```swift
TextField("Email", text: $email)
    .textFieldStyle(.rounded)
    .autocapitalization(.never)
    .keyboardType(.emailAddress)
    .textContentType(.emailAddress)
```

## Layout Components

### VStack with Spacing

Use custom spacing system:

```swift
VStack(alignment: .leading, spacing: 16) {
    Text("First")
    Text("Second")
}
```

### HStack with Spacing

```swift
HStack(spacing: 8) {
    Text("Label")
    Spacer()
    Button("Action") {}
}
```

### Spacer

Push content to edges:

```swift
HStack {
    Text("Left aligned")
    Spacer()
    Text("Right aligned")
}
```

## Icons

Use SF Symbols for icons:

```swift
Image(systemName: "checkmark.circle.fill")
Image(systemName: "star.fill")
Image(systemName: "chevron.right")
```

**Common Icons:**
- `checkmark.circle.fill` — Success state
- `xmark.circle.fill` — Error state
- `star.fill` — Favorites/highlight
- `chevron.right` — Navigation
- `plus.circle.fill` — Add action
- `trash.fill` — Delete action
- `pencil` — Edit action

## Colors

Use SwiftUI system colors:

```swift
// Accent colors
.foregroundColor(.blue)
.foregroundColor(.green)
.foregroundColor(.purple)

// Neutral colors
.foregroundColor(.gray)
.foregroundColor(.secondary) // Secondary text
.foregroundColor(.tertiary) // Tertiary text
```

**System Colors:**
- `.blue`, `.cyan`, `.green`, `.indigo`, `.mint`, `.orange`, `.pink`, `.purple`, `.red`, `.teal`, `.yellow` — Accent colors
- `.gray`, `.zinc` — Neutral colors
- `.primary`, `.secondary`, `.tertiary` — Semantic text colors

## Typography

Use SF Pro typography system:

```swift
// Headings
Text("Large Title")
    .font(.largeTitle)
Text("Title")
    .font(.title)
Text("Title2")
    .font(.title2)
Text("Title3")
    .font(.title3)

// Body
Text("Headline")
    .font(.headline)
Text("Subheadline")
    .font(.subheadline)
Text("Body")
    .font(.body)
Text("Callout")
    .font(.callout)
Text("Footnote")
    .font(.footnote)
Text("Caption")
    .font(.caption)
Text("Caption2")
    .font(.caption2)

// Monospace
Text("Code")
    .font(.monospaced)
    .font(.monospacedDigit)
```

## Responsive Design

Use size classes for adaptive layouts:

```swift
struct ResponsiveView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass

    var body: some View {
        if horizontalSizeClass == .compact {
            // iPhone layout
            VStack { }
        } else {
            // iPad/Mac layout
            HStack { }
        }
    }
}
```

## Light and Dark Mode

All components support both themes automatically:

```swift
@Environment(\.colorScheme) var colorScheme

struct MyView: View {
    var body: some View {
        VStack {
            Text("Content")
                .background(colorScheme == .dark ? .black : .white)
        }
    }
}
```

## Modifiers

Common modifiers for styling:

```swift
Text("Styled Text")
    .padding()                    // Add padding
    .padding(.horizontal, 16)       // Horizontal padding
    .background(Color.blue.opacity(0.1))  // Background
    .cornerRadius(8)               // Rounded corners
    .shadow(radius: 2)             // Drop shadow
    .overlay(Color.blue, lineWidth: 1)  // Border
```

## Animations

Simple animations:

```swift
struct AnimatedView: View {
    @State private var isExpanded = false

    var body: some View {
        VStack {
            Text("Content")
        }
        .frame(height: isExpanded ? 200 : 100)
        .animation(.easeInOut(duration: 0.3), value: isExpanded)
    }
}
```

## Accessibility

Add accessibility labels:

```swift
Button("Delete") { }
    .accessibilityLabel("Delete item")
    .accessibilityHint("Removes the item from the list")

Image(systemName: "star.fill")
    .accessibilityLabel("Favorite")
```

## Examples

See [Examples Documentation](./examples.md) for complete usage examples.

## API Reference

For full API documentation, see inline code comments in `Sources/SwiftDesignOS/Components/`.