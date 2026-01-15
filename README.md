# Swift DesignOS

> **The missing design process between your product idea and your Swift/SwiftUI codebase.**

Swift DesignOS is the Swift/SwiftUI implementation of DesignOS - a product planning and design tool that helps you define your product vision, structure your data model, design your UI, and export production-ready components for implementation.

---

## Why Swift DesignOS?

### The Problem

AI coding tools are incredible at building fast. But results often miss the mark. You describe what you want, the agent builds *something*, but it's not what you envisioned. The UI looks generic. Features get half-implemented. You spend as much time fixing and redirecting as you would have spent building.

**The core issue:** We're asking coding agents to figure out what to build *and* build it simultaneously. Design decisions get made on the fly, buried in code, impossible to adjust without starting over. There's no spec. No shared understanding. No source of truth for what "done" looks like.

### The Solution

Swift DesignOS powers a guided design and architecture process. You + AI, working together through structured steps:

1. **Product Planning** — Define your vision, break down your roadmap, and model your data
2. **Design System** — Choose colors, typography, and design your application shell
3. **Section Design** — For each feature area: specify requirements, generate sample data, and design screens
4. **Export** — Generate a complete handoff package for implementation

Each step is a conversation. The AI asks questions, you provide direction, and together you shape a product that matches your vision—before any implementation begins.

---

## Platforms

Swift DesignOS supports all Apple platforms:

- **iOS** 17.0+
- **macOS** 14.0+
- **watchOS** 10.0+
- **tvOS** 17.0+

---

## Getting Started

### Via Swift Package Index (Recommended)

Once published to the Swift Package Index, Swift DesignOS can be easily discovered and installed:

**In Xcode:**
1. Open your Xcode project
2. Go to **File → Add Package Dependencies...**
3. Search for "swift-design-os" or "SwiftDesignOS"
4. Select the package from search results
5. Choose version rule (e.g., "Up to Next Major Version")
6. Click "Add Package"
7. Select targets to add the package to
8. Click "Add Package"

**Command Line:**
```bash
# Add Swift DesignOS dependency
swift package add dependency: https://github.com/YOUR_ORG/swift-design-os.git

# Resolve dependencies
swift package resolve

# Build your project
swift build
```

### As a Planning Tool (Mac App)

```bash
# Clone this repository
git clone https://github.com/YOUR_ORG/swift-design-os.git
cd swift-design-os

# Open the Xcode project
open App/swift-design-os-app/swift-design-os-app.xcodeproj
```

The app will launch and guide you through the 7-step planning process.

### As a Library (Local SPM Package)

Add Swift DesignOS as a local dependency to any of your iOS/macOS/watchOS/tvOS projects:

1. **File → Add Package Dependencies** in Xcode
2. **Choose Add Local Package** and select the `swift-design-os` directory
3. **Import modules**: `import SwiftDesignOS`

The core library (`SwiftDesignOS`) provides:
- Data models (`ProductOverview`, `Section`, `Entity`, etc.)
- Data loaders (`loadProductData()`, `loadSectionData()`)
- Export generators (when implemented)

---

## Publishing Swift DesignOS to Swift Package Index

### Overview

Swift DesignOS can be published to the Swift Package Index (SPI) to make it discoverable and installable by other developers through Xcode's package manager.

**Swift Package Index** is a free, public search engine for Swift packages that:
- Requires no authentication or account
- Indexes packages from public git repositories
- Appears in Xcode's "Add Package Dependencies" search
- Provides package metadata, documentation, and version history

This guide covers the complete publishing process.

---

### Prerequisites

Before publishing, ensure you have:

- **Swift 6.0+** installed
- **Xcode 15.4+** (for Swift 6.0 support)
- **Public GitHub repository** with the package
- **Valid Package.swift** in root directory
- **LICENSE file** in repository root
- **Semantic version tags** (e.g., `1.0.0`, `0.1.0`)
- **Git repository accessible** via HTTPS

**Platform Support:**
Swift DesignOS supports:
- iOS 17.0+
- macOS 14.0+
- watchOS 10.0+
- tvOS 17.0+

---

### Step 1: Prepare Package.swift

Ensure your Package.swift is properly configured with metadata:

```swift
// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "SwiftDesignOS",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .watchOS(.v10),
        .tvOS(.v17)
    ],
    products: [
        .library(
            name: "SwiftDesignOS",
            targets: ["SwiftDesignOS"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-markdown.git", from: "0.3.0")
    ],
    targets: [
        .target(
            name: "SwiftDesignOS",
            dependencies: [
                .product(name: "Markdown", package: "swift-markdown")
            ]
        )
    ]
)
```

**Key Requirements:**
- `swift-tools-version: 6.0` at the top
- All dependencies specified with valid URLs
- Library product defined
- Platforms match your supported versions

**Validate Package.swift:**
```bash
# Verify Package.swift is valid
swift package dump-package

# This should output valid JSON with package structure
```

---

### Step 2: Create Semantic Version Tag

Create and push a git tag for your release:

```bash
# Tag your release (follow SemVer 2.0: MAJOR.MINOR.PATCH)
git tag 1.0.0

# Push tag to remote
git push origin 1.0.0
```

**Important Rules:**
- Tag format: `1.0.0`, `0.1.5` (no "v" prefix)
- Tags must follow semantic versioning
- Each tag creates a new indexed version
- Tags should point to stable commits

**Verify Tags:**
```bash
# List all local tags
git tag -l

# Verify remote tags exist
git ls-remote --tags origin
```

---

### Step 3: Verify Package Builds

Test that your package builds successfully:

```bash
# Build the package
swift build

# Run tests
swift test

# Verify package resolves
swift package resolve
```

Ensure:
- No build errors
- All tests pass
- Dependencies are accessible
- Package.swift is valid

---

### Step 4: Register on Swift Package Index

1. Visit [swiftpackageindex.com/add-a-package](https://swiftpackageindex.com/add-a-package)
2. Enter your repository URL: `https://github.com/YOUR_ORG/swift-design-os.git`
3. Click "Add Package"
4. **No account or authentication required** - it's completely open and free

The Swift Package Index will:
- Validate your repository accessibility
- Parse Package.swift
- Identify semantic version tags
- Index your package automatically

---

### Step 5: Upload Package Files

Your package files are already in your git repository! No separate upload needed:

- Source code is in your GitHub repository
- Package.swift defines the package structure
- Tags define version releases
- SPI indexes directly from your git repo

**Just ensure:**
- Repository is public
- Tags are pushed to remote
- Package.swift is valid
- No access restrictions on git

---

### Step 6: Publish and Verify

Wait for Swift Package Index to process your package (typically 1-5 minutes):

1. **Check Package Page:**
   - Visit: `https://swiftpackageindex.com/packages/swiftdesignos`
   - Verify package name, description, and version appear

2. **Verify Search Results:**
   - Go to [swiftpackageindex.com](https://swiftpackageindex.com)
   - Search for "swift-design-os"
   - Confirm your package appears

3. **Test in Xcode:**
   - Open any Xcode project
   - File → Add Package Dependencies...
   - Search for "swift-design-os"
   - Package should appear in search results!

---

### Step 7: Test Installation

Verify users can install the package:

**Via Xcode:**
```bash
# Create test project
xcrun swift package init --type executable

# Open in Xcode
xed .

# File → Add Package Dependencies...
# Search for "swift-design-os"
# Add package
# Build to verify
```

**Via Command Line:**
```bash
# Add dependency
swift package add dependency: https://github.com/YOUR_ORG/swift-design-os.git

# Resolve
swift package resolve

# Build
swift build
```

---

### Troubleshooting Publishing

**Problem: Package not validated by SPI**
```bash
# Check Package.swift validity
swift package dump-package

# Verify tag exists
git ls-remote --tags origin

# Check if repo is public
curl -I https://github.com/YOUR_ORG/swift-design-os.git
```

**Problem: Package not appearing in search results**
- Wait 24-48 hours for SPI re-indexing
- Verify tags follow SemVer format (no "v" prefix)
- Ensure repository is public
- Check SPI status page for indexing errors

**Problem: Missing license in SPI display**
- Add LICENSE file to repository root
- Common licenses: MIT, Apache-2.0, BSD-3-Clause

**Problem: Build fails after adding package**
- Verify platform versions match
- Check Swift tools version
- Ensure all dependencies are accessible
- Clean build folder and retry

---

## Using Swift DesignOS in Xcode

### Finding Package in Search Results

Once published to the Swift Package Index:

1. Open your Xcode project
2. Go to **File → Add Package Dependencies...**
3. In the search bar, type: `swift-design-os`
4. Wait for search results to load
5. **Swift DesignOS** should appear with:
   - Package name: SwiftDesignOS
   - Description: The missing design process between your product idea and your Swift/SwiftUI codebase.
   - Repository: GitHub link

![Xcode Package Search](docs/images/xcode-package-search.png)

### Adding as Local Package

If you want to use Swift DesignOS from your local clone:

**Method 1: Drag and Drop**
1. In Xcode, locate your project navigator
2. Drag the `swift-design-os` folder into your project
3. Select "Add to: [Your Project Name]"
4. In the dialog, choose:
   - **Added folders**: Create groups
   - **Add to targets**: Select targets that should use the library
5. Click "Finish"

**Method 2: Add Local Package Menu**
1. Go to **File → Add Package Dependencies...**
2. Click "Add Local Package..." button (usually bottom or side panel)
3. Navigate to and select the `swift-design-os` directory
4. Click "Add Package"
5. Xcode will parse Package.swift and show available products

### Import Statements

Once added, import in your Swift files:

```swift
import SwiftUI
import SwiftDesignOS  // Import the package

struct ContentView: View {
    var body: some View {
        // Use Swift DesignOS components
        Card {
            Text("Hello from Swift DesignOS!")
        }
    }
}
```

### Xcode Integration Workflow

```
1. Open Project
   ↓
2. File → Add Package Dependencies...
   ↓
3. Search "swift-design-os" (or Add Local Package)
   ↓
4. Select package and version
   ↓
5. Choose targets to add to
   ↓
6. Import SwiftDesignOS in code
   ↓
7. Use components and APIs
```

---

## Using Swift DesignOS via SPM (Command Line)

### Adding Dependencies

**Important:** Swift Package Manager doesn't have a `swift package add` command. Instead, you manually edit your `Package.swift` file to add dependencies.

**Edit Package.swift directly:**

```swift
// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "MyApp",
    dependencies: [
        // Remote package - from version (recommended)
        .package(url: "https://github.com/YOUR_ORG/swift-design-os.git", from: "1.0.0"),
        
        // Remote package - exact version
        .package(url: "https://github.com/YOUR_ORG/swift-design-os.git", exact: "1.2.3"),
        
        // Remote package - version range
        .package(url: "https://github.com/YOUR_ORG/swift-design-os.git", "1.0.0"..<"2.0.0"),
        
        // Local package
        .package(path: "../swift-design-os"),
    ],
    targets: [
        .executableTarget(
            name: "MyApp",
            dependencies: [
                .product(name: "SwiftDesignOS", package: "SwiftDesignOS")
            ]
        )
    ]
)
```

**Dependency Version Options:**
- `from: "1.0.0"` → Allows 1.0.0 to <2.0.0 (recommended)
- `exact: "1.0.0"` → Only version 1.0.0
- `"1.0.0"..<"2.0.0"` → Custom version range
- `branch: "main"` → Always use main branch
- `revision: "abc123"` → Specific commit (reproducible)
- `.package(path: "../local")` → Local package path

### Resolving Dependencies

After editing `Package.swift`, resolve your dependencies:

```bash
# Download and resolve all dependencies
swift package resolve

# Force using versions from Package.resolved
swift package resolve --force-resolved-versions

# Skip checking remote for updates
swift package resolve --skip-update
```

This will:
- Download package sources to `~/Library/org.swift.swiftpm/cache`
- Build dependency graph
- Resolve version constraints
- Create `Package.resolved` file

### Building with Dependencies

Build your project with all dependencies:

```bash
# Basic build
swift build

# Build with specific configuration
swift build -c release

# Build specific target
swift build --target MyApp

# Build with verbose output
swift build -v

# Clean and rebuild
swift package clean && swift build
```

### Full SPM Workflow Example

```bash
# 1. Create new Swift project
swift package init --type executable --name MyApp

# 2. Edit Package.swift to add Swift DesignOS dependency
# Open Package.swift and add:
# .package(url: "https://github.com/YOUR_ORG/swift-design-os.git", from: "1.0.0")

# 3. Resolve dependencies
swift package resolve

# 4. Build project
swift build

# 5. Run application
swift run
```

### Adding Target Dependencies

For multiple targets, add dependencies per target:

**Or edit Package.swift manually:**
```swift
targets: [
    .executableTarget(
        name: "MyApp",
        dependencies: [
            .product(name: "SwiftDesignOS", package: "SwiftDesignOS")
        ]
    ),
    .testTarget(
        name: "MyAppTests",
        dependencies: ["MyApp", "SwiftDesignOS"]
    )
]
```

### Managing Dependencies

```bash
# Update all dependencies to latest eligible versions
swift package update

# Update specific dependency
swift package update SwiftDesignOS

# Reset Package.resolved
rm Package.resolved
swift package resolve

# Reset package state (for troubleshooting)
swift package reset

# Clean build artifacts
swift package clean

# Show dependency tree
swift package show-dependencies
```

### Useful SPM Commands

```bash
# Show available schemes
swift package describe --type json

# Dump package manifest as JSON
swift package dump-package

# List all targets
swift package dump-package | jq '.targets[].name'

# Show dependency graph
swift package dump-package | jq '.dependencies'
```

---

## Verification Checklist

After publishing Swift DesignOS, verify everything works:

### 1. Swift Package Index Verification

- [ ] Package appears at: `https://swiftpackageindex.com/packages/swiftdesignos`
- [ ] Package name and description are correct
- [ ] All version tags are indexed (check Versions tab)
- [ ] License is detected and displayed
- [ ] Platform compatibility is shown (iOS, macOS, watchOS, tvOS)
- [ ] Repository URL links correctly
- [ ] Package appears in search results for "swift-design-os"

### 2. Xcode Installation Test

- [ ] Open a new Xcode project
- [ ] Go to File → Add Package Dependencies...
- [ ] Search for "swift-design-os"
- [ ] Package appears in search results
- [ ] Can select package and choose version
- [ ] Package successfully downloads
- [ ] Package appears in project navigator under "Package Dependencies"
- [ ] `import SwiftDesignOS` statement works without errors
- [ ] Build succeeds with no errors

### 3. Platform Compatibility Testing

Test on each platform:

**iOS:**
- [ ] Create iOS app project
- [ ] Add Swift DesignOS via SPM
- [ ] Build and run on iOS Simulator (iPhone)
- [ ] Build and run on iPad Simulator
- [ ] Verify minimum iOS version (17.0+) works

**macOS:**
- [ ] Create macOS app project
- [ ] Add Swift DesignOS via SPM
- [ ] Build and run on Mac (Intel or Apple Silicon)
- [ ] Verify minimum macOS version (14.0+) works

**watchOS:**
- [ ] Create watchOS app project
- [ ] Add Swift DesignOS via SPM
- [ ] Build and run on Apple Watch Simulator
- [ ] Verify minimum watchOS version (10.0+) works

**tvOS:**
- [ ] Create tvOS app project
- [ ] Add Swift DesignOS via SPM
- [ ] Build and run on Apple TV Simulator
- [ ] Verify minimum tvOS version (17.0+) works

### 4. Command Line Testing

- [ ] Create new Swift package: `swift package init`
- [ ] Add dependency: `swift package add dependency: https://github.com/YOUR_ORG/swift-design-os.git`
- [ ] Resolve dependencies: `swift package resolve`
- [ ] Build successfully: `swift build`
- [ ] No build errors or warnings

### 5. Component Testing

- [ ] Can import Swift DesignOS components
- [ ] Card component works
- [ ] Button (SDButton) component works
- [ ] Badge component works
- [ ] TextField (SDTextField) component works
- [ ] All other components are accessible

### 6. Documentation Verification

- [ ] README is up to date with latest installation instructions
- [ ] All examples in Examples/ build successfully
- [ ] Documentation is clear and accurate
- [ ] Links in README are correct

### 7. Release Notes

- [ ] CHANGELOG.md is updated with release notes
- [ ] GitHub release created with changelog
- [ ] Breaking changes (if any) are documented
- [ ] Migration guide provided for major versions

---

## Example Projects

Swift DesignOS includes example projects demonstrating real-world usage:

### TaskFlowExample

**Location:** `Examples/TaskFlowExample/`

**Platform:** iOS 17.0+

A complete task management application showcasing:

- Swift DesignOS components (SDButton, Card, Badge, SDTextField)
- @Observable and @ObservedObject for state management
- TabView and NavigationStack for app structure
- SwiftUI Lists and Forms
- Sheet modals and data binding

**Key Features:**
- Task list with filtering
- Project management
- Calendar integration
- Settings configuration

**Run Example:**
```bash
cd Examples/TaskFlowExample
xed .
# Press Cmd + R to build and run
```

**Documentation:** See `Examples/TaskFlowExample/README.md` for detailed setup and usage.

### CounterExample

**Location:** `Examples/CounterExample/`

**Platform:** iOS 17.0+

A simple counter app demonstrating:
- Basic component usage
- State management with @State
- Reactive UI updates

### WatchFaceExample

**Location:** `Examples/WatchFaceExample/`

**Platform:** watchOS 10.0+

An Apple Watch face example showcasing:
- SwiftUI for watchOS
- Compact layouts
- Swift DesignOS components on small screens

**Building Examples:**

Each example is a standalone Swift package:

```bash
# Navigate to example directory
cd Examples/TaskFlowExample

# Open in Xcode
xed .

# Or build from command line
swift run
```

---

## GitHub Repository

The complete source code, documentation, and examples are available on GitHub:

**Repository:** https://github.com/YOUR_ORG/swift-design-os

**Key Directories:**
- `Sources/SwiftDesignOS/` - Core library implementation
- `App/swift-design-os-app/` - Mac app for planning
- `Examples/` - Example projects (TaskFlow, Counter, WatchFace)
- `.claude/commands/design-os/` - AI workflow commands
- `product/` - Portable design definitions

**Issues & Support:**
- Report bugs: [GitHub Issues](https://github.com/YOUR_ORG/swift-design-os/issues)
- Feature requests: [GitHub Discussions](https://github.com/YOUR_ORG/swift-design-os/discussions)
- Contributing: See [CONTRIBUTING.md](CONTRIBUTING.md)

**Releases:**
- All releases: [GitHub Releases](https://github.com/YOUR_ORG/swift-design-os/releases)
- Latest release: Check main README badge
- Changelog: [CHANGELOG.md](CHANGELOG.md)

---

## The Swift DesignOS Workflow

### Phase 1: Product Planning

#### 1. Product Vision (`/product-vision`)
Define your product's core identity and purpose.

Run: `/product-vision`

This command guides you through:
- **Product name** — A clear, memorable name for your app
- **Description** — 1-3 sentence product description
- **Problems & Solutions** — What pain points are you addressing?
- **Key Features** — What makes your product unique?

The command is conversational. It asks clarifying questions to help you think through your product:

> "What would you like to call this app?"
> "What's the single biggest pain point you're addressing?"
> "Who is the primary user of this app?"

**Creates:** `product/product-overview.md`

#### 2. Product Roadmap (`/product-roadmap`)
Break your product into 3-5 development sections.

Run: `/product-roadmap`

Each section should be:
- **Self-contained** — Can be designed and built independently
- **Distinct** — Covers a specific feature area
- **Prioritized** — Ordered by importance

**Creates:** `product/product-roadmap.md`

#### 3. Data Model (`/data-model`)
Define the core entities and relationships in your system.

Run: `/data-model`

The command helps you identify:
- **Core entities** — The "nouns" of your system (e.g., User, Task, Project)
- **Entity descriptions** — What is each entity?
- **Relationships** — How do entities connect? (User has many Tasks, Tasks belong to Projects, etc.)

Keep the data model minimal. Swift's type system will handle the implementation details.

**Creates:** `product/data-model/data-model.md`

#### 4. Design Tokens (`/design-tokens`)
Choose your app's visual design language.

Run: `/design-tokens`

For SwiftUI, this means selecting:

- **Color Palette** — From SwiftUI system colors
  - Primary accent (e.g., `.blue`, `.purple`, `.green`)
  - Secondary colors (e.g., `.cyan`, `.indigo`)
  - Neutral palette (e.g., `.gray`, `.zinc`)

- **Typography** — From SF Pro and iOS/macOS system fonts
  - Headings (e.g., `.title`, `.title2`, `.largeTitle`)
  - Body text (e.g., `.body`, `.callout`)
  - Monospace (e.g., `.monospaced`, `.monospacedDigit`)

All SwiftUI views will automatically use these design tokens.

**Creates:**
- `product/design-system/colors.json`
- `product/design-system/typography.json`

#### 5. Application Shell (`/design-shell`)
Design the persistent navigation and layout that wraps all sections.

Run: `/design-shell`

Define:
- **Navigation structure** — Tab bar, sidebar, top navigation?
- **Layout pattern** — How does content flow? (Master/detail, split view, etc.)
- **Shell components** — AppShell, navigation, user menu

**Creates:** `product/shell/spec.md`

---

### Phase 2: Section Design

Repeat these steps for each section in your roadmap:

#### 6. Shape Section (`/shape-section`)
Define what each section does.

Run: `/shape-section [section-id]`

The command establishes:
- **Overview** — What is this section for? (2-3 sentences)
- **User Flows** — Main actions and interactions step-by-step
- **UI Requirements** — Specific layouts, patterns, components needed
- **Scope boundaries** — What's intentionally excluded?

Example output for an "Invoices" section:
- List all invoices
- View invoice details
- Create new invoice
- Edit existing invoice
- Delete invoice

**Creates:** `product/sections/[section-id]/spec.md`

#### 7. Sample Data (`/sample-data`)
Generate realistic sample data based on the section specification.

Run: `/sample-data [section-id]`

The command analyzes your spec and proposes:
- **Swift types** — `struct Invoice`, `struct Task`, etc.
- **Sample records** — 5-10 realistic entries
- **Varied content** — Different statuses, dates, text lengths
- **Edge cases** — Empty arrays, long text, special characters

The sample data makes your screen designs feel real and helps catch issues early.

**Creates:**
- `product/sections/[section-id]/data.json` — Sample data
- `product/sections/[section-id]/types.swift` — Swift structs

#### 8. Design Screen (`/design-screen`)
Build actual SwiftUI views for the section.

Run: `/design-screen [section-id]`

This is where your spec comes to life. The command guides you to create:

**Exportable Components** (props-based, portable):
```swift
struct InvoiceListView: View {
    let invoices: [Invoice]
    let onView: (Invoice.ID) -> Void
    let onEdit: (Invoice.ID) -> Void
    let onDelete: (Invoice.ID) -> Void

    var body: some View {
        List(invoices) { invoice in
            InvoiceRow(invoice: invoice)
                .onTapGesture {
                    onView(invoice.id)
                }
        }
        // ... more UI
    }
}
```

**Key Principles:**
- **Props-based** — Components accept data and callbacks via properties, never import data directly
- **Design tokens** — Use colors and typography from your design system
- **Mobile responsive** — Adaptive layouts using SwiftUI's size classes
- **Light & dark mode** — All views support both modes
- **SF Symbols** — Use Apple's native icon system

**Creates:** `src/sections/[section-id]/components/[ViewName].swift`

---

### Phase 3: Export

#### 9. Screenshot Design (Optional)
Capture visual documentation of your screen designs.

Run: `/screenshot-design [section-id]`

Screenshots are useful for:
- Visual reference during implementation
- Documentation and handoff materials
- Comparing designs across sections

**Creates:** `product/sections/[section-id]/[screen-name].png`

#### 10. Export Product (`/export-product`)
Generate a complete handoff package for implementation.

Run: `/export-product`

This command:
1. **Checks prerequisites** — Verifies required files exist
2. **Gathers all design assets** — Components, types, data, tokens
3. **Generates implementation instructions** — Including ready-to-use prompts
4. **Generates test instructions** — TDD specs for each section
5. **Creates a ZIP file** — `product-plan.zip` for easy download

**What's Included:**

**Ready-to-Use Prompts:**
- `product-plan/prompts/one-shot-prompt.md` — Full implementation in one session
- `product-plan/prompts/section-prompt.md` — Section-by-section template

**Implementation Instructions:**
- `product-plan/instructions/one-shot-instructions.md` — All milestones combined
- `product-plan/instructions/incremental/` — Milestone-by-milestone guides

**Design System:**
- `product-plan/design-system/tokens.css` — CSS custom properties for SwiftUI
- `product-plan/design-system/typography.json` — Font selections

**Data Model:**
- `product-plan/data-model/README.md` — Entity descriptions
- `product-plan/data-model/types.swift` — Swift interfaces
- `product-plan/data-model/sample-data.json` — Combined sample data

**Shell Components:**
- `product-plan/shell/` — AppShell, navigation, user menu

**Section Components:**
For each section:
- `product-plan/sections/[section-id]/components/` — Exportable SwiftUI views
- `product-plan/sections/[section-id]/types.swift` — Section-specific types
- `product-plan/sections/[section-id]/sample-data.json` — Test data
- `product-plan/sections/[section-id]/tests.md` — TDD test specifications

---

## What Makes Swift DesignOS Powerful

### 1. Structured, Sequential Workflow

Clear 10-step process. Each step builds on the previous:
- Product vision informs the roadmap
- Roadmap shapes the data model
- Data model constrains component design
- Design tokens apply consistently across sections
- Sections build on foundation you established

You can't skip ahead without completion.

### 2. Separation of Concerns

Three distinct layers:
- **Swift DesignOS App** — Fixed design system (neutral grays + accent color)
- **Product Design** — Uses your design tokens
- **Export Package** — Portable, framework-agnostic specifications

This ensures planning artifacts never mix with production code.

### 3. Markdown-First Data Format

Human-readable and versionable:
- Easy to edit in any text editor
- Compatible with Git
- AI-friendly for code generation
- Parsed at build time for SwiftUI consumption

### 4. Props-Based Architecture

All screen design components accept data via props:

```swift
// ✅ Correct: Props-based, portable
struct TaskList: View {
    let tasks: [Task]
    let onTap: (Task.ID) -> Void
    let onDelete: (Task.ID) -> Void

    var body: some View {
        // Component logic
    }
}

// ❌ Wrong: Direct data import
struct TaskList: View {
    // Hardcoded data - not portable!
    let tasks = loadTasksFromFile()
}
```

This means exported components work in **any** SwiftUI project.

### 5. SwiftUI Native

Built with Apple's native technologies:
- **SwiftUI** — Declarative, type-safe UI framework
- **SF Symbols** — 5,000+ Apple-designed icons
- **Swift Data** — Codable, Identifiable, Observable for iOS 17+
- **System Colors** — Platform-native color palette
- **Preview** — Live editing with `#Preview` macros

No Tailwind CSS, no React, no external dependencies.

### 6. Multi-Platform Support

One package works across all Apple platforms:
- iPhone, iPad, and iPod touch
- Mac computers (Apple Silicon and Intel)
- Apple Watch
- Apple TV

Write once, deploy everywhere.

### 7. AI Integration

**Ralph TUI Integration:**
Swift DesignOS integrates with Ralph TUI for autonomous development:

- **What is Ralph TUI?** — An AI agent orchestration tool
- **How to Install** — See `RALPH_TUI.md` in this repo
- **How it Works** — Ralph TUI can orchestrate Xcode to automatically implement your Swift DesignOS plans

**Usage:**
1. Define your product in Swift DesignOS
2. Export the `product-plan.zip` package
3. Open Ralph TUI and point it at the exported package
4. Ralph TUI's AI agent will build the entire app autonomously
5. Changes are auto-committed and tracked

**Benefits:**
- Fully automated implementation from your plans
- No manual coding required
- Consistent code quality
- Real-time progress tracking

---

## Project Structure

```
swift-design-os/
├── Package.swift                    # SPM package definition
├── Sources/SwiftDesignOS/          # Core library
│   ├── Models/                     # Data structures
│   │   ├── Product.swift
│   │   └── Section.swift
│   ├── Loaders/                    # File parsing
│   │   ├── ProductLoader.swift
│   │   ├── DataModelLoader.swift
│   │   ├── DesignSystemLoader.swift
│   │   ├── ShellLoader.swift
│   │   └── SectionLoader.swift
│   ├── Components/                 # Reusable SwiftUI views
│   │   ├── AppLayout.swift
│   │   ├── PhaseNav.swift
│   │   ├── Button.swift
│   │   ├── Card.swift
│   │   ├── Dialog.swift
│   │   ├── Badge.swift
│   │   └── TextField.swift
│   ├── Generators/                 # Export generation
│   ├── Utilities/                   # Helper functions
│   └── SwiftDesignOS.swift          # Public API
├── App/swift-design-os-app/          # Xcode project (planning UI)
│   ├── App.swift                  # Entry point
│   ├── MainTabView.swift           # Navigation
│   ├── ProductView.swift            # Product overview
│   ├── DataModelView.swift          # Data model editor
│   ├── DesignSystemView.swift        # Design tokens
│   ├── SectionsView.swift           # Section list
│   ├── SectionDetailView.swift       # Section details
│   ├── ShellDesignView.swift        # Shell designer
│   └── ExportView.swift            # Export generation
├── product/                          # Portable definitions
│   ├── product-overview.md        # Product vision
│   ├── product-roadmap.md         # Section breakdown
│   ├── data-model/
│   │   └── data-model.md        # Entity definitions
│   ├── design-system/
│   │   ├── colors.json            # Color palette
│   │   └── typography.json         # Font selections
│   ├── shell/
│   │   └── spec.md                # Shell specification
│   └── sections/
│       └── [section-name]/           # One per section
│           ├── spec.md              # Requirements
│           ├── data.json            # Sample data
│           ├── types.swift           # Swift structs
│           └── *.png               # Screenshots
├── .claude/commands/design-os/          # AI workflow commands
│   ├── product-vision.md            # Product definition
│   ├── product-roadmap.md           # Sections breakdown
│   ├── data-model.md               # Entity definitions
│   ├── design-tokens.md            # Design system
│   ├── design-shell.md             # Shell design
│   ├── shape-section.md            # Section specs
│   ├── sample-data.md              # Sample generation
│   ├── design-screen.md            # View creation
│   ├── screenshot-design.md         # Image capture
│   └── export-product.md           # Package generation
├── .gitignore                          # Ignore rules
├── RALPH_TUI.md                      # Ralph TUI docs
└── README.md                          # This file
```

---

## Comparing Swift DesignOS vs Original DesignOS

| Feature | DesignOS (React/Tailwind) | Swift DesignOS (SwiftUI) |
|---------|---------------------------|------------------|
| **Platform** | Web (React) | Apple (iOS, macOS, watchOS, tvOS) |
| **Language** | TypeScript | Swift |
| **Styling** | Tailwind CSS v4 | SwiftUI modifiers |
| **Icons** | Lucide React (1000+) | SF Symbols (5000+) |
| **Components** | Shadcn UI | Native SwiftUI |
| **Routing** | React Router | SwiftUI Navigation |
| **Build Tool** | Vite | Xcode / SPM |
| **Export Format** | React components | SwiftUI views |
| **Screenshot** | Playwright | UIGraphicsImageRenderer |
| **AI Integration** | Claude commands | Ralph TUI + commands |

**What's Preserved:**
- ✅ Sequential planning workflow
- ✅ Separation of concerns (tool vs product)
- ✅ Markdown-first data format
- ✅ Props-based component architecture
- ✅ Conversational AI commands
- ✅ Portable export packages
- ✅ Test specifications

**What's Adapted:**
- ✅ Native Apple platform technologies
- ✅ SwiftUI design patterns
- ✅ SF Symbols icon system
- ✅ Multi-platform support (iOS, macOS, watchOS, tvOS)
- ✅ Ralph TUI integration for autonomous development
- ✅ Swift-specific implementation guidance

---

## Implementation Examples

### Example: TaskFlow App

Built-in 2 hours following the full workflow:

**Product Vision:**
> A task management app for teams.

**Roadmap Sections:**
1. Daily Feed — Shows today's tasks
2. Task List — Full task management
3. Projects — Organize tasks by project
4. Settings — Preferences and configuration

**Data Model:**
- Task (title, description, status, dueDate, project)
- Project (name, color, icon)
- User (name, avatar)

**Design System:**
- Primary: `.blue`
- Secondary: `.indigo`
- Neutral: `.gray`
- Typography: `.title` + `.body`

**Result:**
Complete SwiftUI app with 4 functional sections, all screens designed, export package ready for autonomous implementation via Ralph TUI.

---

## Contributing

Swift DesignOS is open source. Contributions are welcome!

To contribute:
1. Fork this repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly on all platforms
5. Submit a pull request

---

## License

MIT License — see [LICENSE](LICENSE) file for details.

---

## Created by

Based on [DesignOS](https://github.com/buildermethods/design-os) by Brian Casel

Swift DesignOS is the Apple-native implementation of the same powerful planning methodology.

---

## Support

For questions, issues, or feature requests:
- Open an issue on GitHub
- Discuss in community

Happy building with Swift DesignOS! 🚀
