---
description: Design persistent application shell for SwiftUI apps
---

# Design Shell

You are helping the user design the application shell — persistent navigation and layout that wraps all sections. This is a screen design, not implementation code.

## Step 1: Check Prerequisites

First, verify prerequisites exist:

1. Read `product/product-overview.md` — Product name and description
2. Read `product/product-roadmap.md` — Sections for navigation
3. Check if `product/design-system/colors.json` and `product/design-system/typography.json` exist

If overview or roadmap are missing:

"Before designing the shell, you need to define your product and sections. Please run:
1. `/design-os/product-vision` — Define your product
2. `/design-os/product-roadmap` — Define your sections"

Stop here if overview or roadmap are missing.

If design tokens are missing, show a warning but continue:

"Note: Design tokens haven't been defined yet. I'll proceed with default styling, but you may want to run `/design-os/design-tokens` first for consistent colors and typography."

## Step 2: Analyze Product Structure

Review roadmap sections and present navigation options:

"I'm designing the shell for **[Product Name]**. Based on your roadmap, you have [N] sections:

1. **[Section 1]** — [Description]
2. **[Section 2]** — [Description]
3. **[Section 3]** — [Description]

Let's decide on the shell layout. Common SwiftUI patterns:

**A. Tab Bar Navigation** — Bottom tabs (iOS) or sidebar tabs (macOS)
   Best for: Apps with 3-5 main sections, content-first experiences
   SwiftUI: `TabView` with bottom tab bar on iOS, sidebar on macOS

**B. Sidebar Navigation** — Left sidebar navigation
   Best for: Apps with many sections, dashboard-style tools, iPad/Mac apps
   SwiftUI: `NavigationSplitView` with sidebar

**C. Top Navigation** — Navigation bar at top with section list
   Best for: Simpler apps, content-heavy applications
   SwiftUI: `NavigationView` with `.toolbar` and `Menu`

**D. Minimal Header** — Just header + user menu, sections accessed inline
   Best for: Single-purpose tools, wizard-style flows
   SwiftUI: Basic `VStack` layout with minimal chrome

Which pattern fits **[Product Name]** best? Also consider your target platform (iOS, macOS, or both)."

Wait for their response.

## Step 3: Gather Design Details

Use conversational questions to clarify:

- "Where should the user menu (avatar, profile, logout) appear?"
- "What should be the 'home' or default view when the app loads?"
- "Do you need search functionality in the shell?"
- "Should the shell adapt differently for iOS vs macOS?"
- "Any additional items in navigation? (Settings, Help, About, etc.)"

## Step 4: Present Shell Specification

Once you understand their preferences:

"Here's the shell design for **[Product Name]**:

**Layout Pattern:** [Tab Bar / Sidebar / Top Nav / Minimal]

**Navigation Structure:**
- [Nav Item 1] → [Section]
- [Nav Item 2] → [Section]
- [Nav Item 3] → [Section]
- [Additional items like Settings, Help]

**User Menu:**
- Location: [Top right toolbar / Sidebar bottom / Settings view]
- Contents: Avatar, profile name, logout button

**Platform-Specific Behavior:**
- iOS: [How it looks and behaves]
- macOS: [How it looks and behaves]

**Responsive Behavior:**
- iPhone portrait: [Layout]
- iPhone landscape: [Layout]
- iPad/Mac: [Layout]

Does this match what you had in mind?"

Iterate until approved.

## Step 5: Create Shell Specification

Create `product/shell/spec.md`:

```markdown
# Application Shell Specification

## Overview
[Description of shell design and its purpose]

## Layout Pattern
[Tab Bar / Sidebar / Top Navigation / Minimal]

## Navigation Structure
- [Nav Item 1] → [Section 1]
- [Nav Item 2] → [Section 2]
- [Nav Item 3] → [Section 3]
- [Any additional nav items]

## User Menu
[Description of user menu location and contents]

## Platform-Specific Behavior

### iOS
[How navigation appears and behaves on iPhone/iPad]

### macOS
[How navigation appears and behaves on Mac]

## Responsive Behavior
- **iPhone Portrait:** [Behavior]
- **iPhone Landscape:** [Behavior]
- **iPad:** [Behavior]
- **Mac:** [Behavior]

## Design Notes
[Any additional design decisions or notes]
```

## Step 6: Create Shell Components

Create SwiftUI shell components at `src/shell/components/`:

### AppShellView.swift
The main wrapper view that provides layout structure.

```swift
struct AppShellView<Content: View>: View {
    let navigationItems: [NavigationItem]
    let selectedItem: Binding<String?>
    let user: UserProfile?
    let onLogout: () -> Void
    let content: () -> Content

    var body: some View {
        // Layout structure based on pattern
        // Sidebar/TabView/TopNav + content area
    }
}

struct NavigationItem: Identifiable {
    let id: String
    let label: String
    let systemImage: String
    let tag: String
}

struct UserProfile {
    let name: String
    let avatarUrl: URL?
}
```

### MainNavigationView.swift
The navigation component (TabView or NavigationSplitView based on chosen pattern).

### UserMenuView.swift
The user menu with avatar and logout button.

### index.swift
Export all components.

**Component Requirements:**
- Use SwiftUI standard components and modifiers
- Accept all data and callbacks as properties (portable)
- Support iOS 17+ and macOS 15+ using `.if #available` when needed
- Use SF Symbols for icons (systemImage parameter)
- Support Dark Mode automatically with `.preferredColorScheme(nil)`
- Be platform-aware with `#if os(macOS)` and `#if os(iOS)`
- Follow Apple Human Interface Guidelines

## Step 7: Create Shell Preview

Create `src/shell/ShellPreview.swift` — a preview wrapper for viewing the shell in Design OS:

```swift
import SwiftUI

struct ShellPreview: View {
    @State private var selectedTab: String = "section-1"

    let navigationItems = [
        NavigationItem(
            id: "section-1",
            label: "[Section 1]",
            systemImage: "[sf-symbol-1]",
            tag: "section-1"
        ),
        NavigationItem(
            id: "section-2",
            label: "[Section 2]",
            systemImage: "[sf-symbol-2]",
            tag: "section-2"
        ),
        NavigationItem(
            id: "section-3",
            label: "[Section 3]",
            systemImage: "[sf-symbol-3]",
            tag: "section-3"
        ),
    ]

    let user = UserProfile(
        name: "Alex Morgan",
        avatarUrl: nil
    )

    var body: some View {
        AppShellView(
            navigationItems: navigationItems,
            selectedItem: $selectedTab,
            user: user,
            onLogout: { print("Logout") }
        ) {
            VStack {
                Text("Content Area")
                    .font(.title)
                    .padding()

                Text("Section content will render here.")
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    ShellPreview()
}
```

## Step 8: Apply Design Tokens

If design tokens exist, apply them to shell components:

**Colors:**
- Read `product/design-system/colors.json`
- Parse JSON into SwiftUI `Color` extensions or named constants
- Use primary color for active navigation items, key accents
- Use secondary color for hover states, subtle highlights
- Use neutral color for backgrounds, borders, text

**Typography:**
- Read `product/design-system/typography.json`
- Apply font family to `.font(.custom(_:size:))` or use standard iOS fonts
- Apply heading font to navigation items and titles
- Apply body font to other text

Example of applying design tokens:
```swift
extension Color {
    static let appPrimary = Color(hex: "#[primary-color]")
    static let appSecondary = Color(hex: "#[secondary-color]")
    static let appBackground = Color(hex: "#[background-color]")
}
```

## Step 9: Confirm Completion

Let the user know:

"I've designed the application shell for **[Product Name]**:

**Created files:**
- `product/shell/spec.md` — Shell specification
- `src/shell/components/AppShellView.swift` — Main shell wrapper
- `src/shell/components/MainNavigationView.swift` — Navigation component
- `src/shell/components/UserMenuView.swift` — User menu component
- `src/shell/components/index.swift` — Component exports
- `src/shell/ShellPreview.swift` — Preview wrapper

**Shell features:**
- [Layout pattern] layout
- Navigation for all [N] sections
- User menu with avatar and logout
- Platform-aware design (iOS/macOS)
- Responsive behavior across device sizes
- Dark mode support
- SF Symbols for consistent iconography

**Important:** Restart your dev server to see the changes.

When you design section screens with `/design-os/design-screen`, they will render inside this shell, showing the full app experience.

Next: Run `/design-os/shape-section` to start designing your first section."

## Important Notes

- The shell is a screen design — it demonstrates navigation and layout design
- Components are property-based and portable to the user's codebase
- The preview wrapper is for Design OS only — not exported
- Apply design tokens when available for consistent styling
- Keep the shell focused on navigation chrome — no authentication UI
- Section screen designs will render inside the shell's content area
- SwiftUI automatically handles dark mode, accessibility, and platform adaptation
- Use SF Symbols from Apple's standard set for consistency with platform guidelines
