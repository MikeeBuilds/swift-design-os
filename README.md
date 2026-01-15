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

### As a Planning Tool (Mac App)

```bash
# Clone this repository
git clone https://github.com/YOUR_ORG/swift-design-os.git
cd swift-design-os

# Open the Xcode project
open App/swift-design-os-app/swift-design-os-app.xcodeproj
```

The app will launch and guide you through the 7-step planning process.

### As a Library (SPM Package)

Add Swift DesignOS as a dependency to any of your iOS/macOS/watchOS/tvOS projects:

1. **File → Add Package Dependencies** in Xcode
2. **Choose Add Local Package** and select the `swift-design-os` directory
3. **Import modules**: `import SwiftDesignOS`

The core library (`SwiftDesignOS`) provides:
- Data models (`ProductOverview`, `Section`, `Entity`, etc.)
- Data loaders (`loadProductData()`, `loadSectionData()`)
- Export generators (when implemented)

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
