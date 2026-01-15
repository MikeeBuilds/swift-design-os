# Counter macOS Example

A minimal counter application demonstrating Swift DesignOS integration on macOS 14+.

## Features Demonstrated

- **Swift DesignOS Components**: Uses `Card`, `Badge`, `SDButton`
- **macOS Layout**: `HSplitView` for sidebar and content
- **State Management**: `@State` for reactive UI updates
- **Keyboard Shortcuts**: Arrow keys for increment/decrement
- **Customization**: Dark mode and accent color selection
- **History Tracking**: Maintains counter change history
- **Alerts**: Native macOS alert dialogs
- **Design Tokens**: Uses macOS-specific colors and typography

## Project Structure

```
CounterExample/
├── Package.swift              # SPM configuration
├── README.md                 # This file
└── Sources/
    └── main.swift            # App entry point with all views
```

## Running the App

### Prerequisites

- Xcode 15.0+
- macOS 14.0+

### Setup

1. Navigate to Swift DesignOS root directory
2. Open the package:
   ```bash
   xed Examples/CounterExample
   ```
3. Press `Cmd + R` to build and run

### Building from Command Line

```bash
cd Examples/CounterExample
swift run
```

## Key Integration Points

### 1. Import Swift DesignOS

```swift
import SwiftDesignOS
```

### 2. macOS App Entry Point

```swift
@main
struct CounterApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.hiddenTitleBar)
    }
}
```

### 3. Sidebar Layout

```swift
HSplitView {
    sidebar
    
    mainContent
}
.frame(minWidth: 800, minHeight: 500)
```

### 4. Using Components

**Card Component:**
```swift
Card {
    VStack(spacing: 16) {
        Text("Title")
            .font(.headline)
        
        Text("Content")
    }
}
```

**Button Component:**
```swift
SDButton(
    "+ Increase",
    variant: .primary,
    size: .large
) {
    // Action
}
.keyboardShortcut(.upArrow, modifiers: [])
```

**Badge Component:**
```swift
Badge("#\(index)", variant: .outline)
```

## macOS-Specific Patterns

### Hidden Title Bar

```swift
.windowStyle(.hiddenTitleBar)
```

### Split View Layout

```swift
HSplitView {
    // Sidebar on left
    // Content on right
}
```

### Control Background Color

```swift
.background(Color(.controlBackgroundColor))
```

### Keyboard Shortcuts

```swift
.keyboardShortcut(.upArrow, modifiers: [])
.keyboardShortcut(.downArrow, modifiers: [])
```

### Alert Dialogs

```swift
.alert("Reset Counter", isPresented: $showAlert) {
    Button("Cancel", role: .cancel) { }
    Button("Reset", role: .destructive) {
        reset()
    }
} message: {
    Text("Are you sure?")
}
```

## Design Tokens

The app uses macOS-specific design tokens:

- **Colors**: 
  - `.controlBackgroundColor` - Standard control backgrounds
  - `.windowBackgroundColor` - Window background
  - `.accentColor` - User-selected accent
  
- **Typography**:
  - `.title` - Large headings
  - `.title2` - Secondary headings
  - `.headline` - Section headers
  - `.body` - Content text
  - `.caption` - Small labels

## State Management

```swift
@State private var counterValue: Int = 0
@State private var stepSize: Int = 1
@State private var history: [Int] = []
@State private var useDarkMode = false
@State private var accentColor: Color = .blue
```

All UI updates automatically when state changes.

## UI Components

### Sidebar

**Quick Stats Card:**
- Current counter value
- History size
- Highest recorded value

**Appearance Card:**
- Dark mode toggle
- Accent color picker (6 colors)

**About Card:**
- App name and description
- Version information

### Main Content

**Counter Display:**
- Large numeric display
- Change indicator (up/down arrows)
- Spring animation on value changes

**Step Size Selector:**
- Preset options: 1, 5, 10
- Custom text field input

**Action Buttons:**
- Increase button (primary variant)
- Decrease button (secondary variant)
- Keyboard shortcuts: ↑ and ↓ arrows

**Reset Button:**
- Destructive variant
- Confirmation alert

**History Section:**
- List of previous values
- Clear history button
- Scrollable view with 200pt height

## User Interactions

### Keyboard Shortcuts

- **↑ Arrow**: Increase counter by step size
- **↓ Arrow**: Decrease counter by step size
- **Cmd + Q**: Quit app

### Mouse Interactions

- **Click buttons**: Increment/decrement counter
- **Click step options**: Change step size
- **Click color swatches**: Change accent color
- **Click reset**: Show confirmation dialog

### Visual Feedback

- **Animations**: Spring animation on counter value changes
- **Hover effects**: Buttons respond to mouse hover
- **Content transitions**: Numeric text transition on counter changes
- **Selection indicators**: Borders on selected items

## Custom Views

The app includes custom SwiftUI views built with Swift DesignOS:

**StepOption:** Square button for step selection
```swift
struct StepOption: View {
    let value: Int
    let isSelected: Bool
    let action: () -> Void
}
```

**ColorOption:** Color swatch picker
```swift
struct ColorOption: View {
    let color: Color
    let isSelected: Bool
    let action: () -> Void
}
```

**HistoryRow:** Individual history entry
```swift
struct HistoryRow: View {
    let index: Int
    let value: Int
}
```

## Dark Mode Support

The app supports dark mode through:

```swift
@State private var useDarkMode = false

.preferredColorScheme(useDarkMode ? .dark : .light)
```

Toggle in sidebar switches between light and dark appearance. All system colors automatically adapt.

## Accent Color Customization

Users can choose from 6 accent colors:

- Blue (default)
- Green
- Orange
- Purple
- Red
- Pink

Accent color applies to:
- Counter value display
- Selected UI elements
- Button highlights
- Toggle switches

## Adaptability

The app adapts to:

- **Window size**: Flexible layout with minimum constraints
- **Color scheme**: Light and dark mode
- **System theme**: Respects macOS appearance settings
- **Dynamic Type**: Uses system font sizing

## Testing Features

To test the app:

1. **Increment Counter**: Click "+ Increase" or press ↑ arrow
2. **Decrement Counter**: Click "− Decrease" or press ↓ arrow
3. **Change Step Size**: Click step options or enter custom value
4. **Toggle Dark Mode**: Switch in sidebar Appearance section
5. **Change Accent Color**: Click color swatches in sidebar
6. **Reset Counter**: Click "Reset Counter" and confirm
7. **View History**: Scroll through past values in history section
8. **Clear History**: Click "Clear" button in history section

## Performance Considerations

- **LazyVStack**: Efficient rendering of history list
- **Content transitions**: Smooth numeric value changes
- **Animation optimization**: Spring animation for natural feel
- **State management**: Minimal state updates for performance

## Troubleshooting

**Build fails:**
- Ensure Swift DesignOS is at root directory
- Check Xcode version is 15.0 or higher
- Verify macOS version is 14.0+

**Window doesn't appear:**
- Check build log for errors
- Ensure macOS target is selected
- Try running from Xcode instead of command line

**Colors don't update:**
- Verify `.accentColor()` modifier on WindowGroup
- Check state variable is properly marked `@State`
- Ensure color options trigger state changes

**Keyboard shortcuts don't work:**
- Ensure window has focus
- Check `.keyboardShortcut()` modifiers are correct
- Verify modifier keys are properly set

## Extending the Example

To add features:

1. **Persistence**: Save counter to UserDefaults or Core Data
2. **Multiple Counters**: Support for multiple named counters
3. **Data Export**: Export history to CSV
4. **Notifications**: Alert on reaching certain values
5. **Custom Themes**: Add more color schemes
6. **Graph Visualization**: Plot counter history as chart

## License

This example is part of Swift DesignOS project.
