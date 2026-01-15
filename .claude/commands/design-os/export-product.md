# Export Product

Generate a complete handoff package for Swift/SwiftUI implementation.

## When to Export

You're ready to export when:
- Product vision and roadmap are defined
- At least one section has screen designs
- You're satisfied with your design direction

You can export at any point—it doesn't have to be "complete." Exporting generates a snapshot of your current designs. You can always export again later as you add more sections.

## What Gets Created

Exporting generates a complete `product-plan/` directory structure:

```
product-plan/
├── README.md                      # Quick start guide
├── product-overview.md            # Product summary
├── prompts/                       # Ready-to-use prompts
│   ├── one-shot-prompt.md         # Prompt for full implementation
│   └── section-prompt.md          # Prompt template for section-by-section
├── instructions/                  # Implementation guides
│   ├── one-shot-instructions.md   # All milestones combined
│   └── incremental/               # Milestone-by-milestone implementation
│       ├── 01-foundation.md         # Design tokens, data types, routing
│       ├── 02-shell.md              # Application shell implementation
│       └── [NN]-[section-id].md   # Section-specific instructions
├── design-system/                 # Design tokens
│   ├── tokens.swift                # SwiftUI color/typography definitions
│   └── fonts.md                 # Font integration guide
├── data-model/                    # Types and sample data
│   ├── README.md                  # Entity descriptions
│   ├── types.swift                 # Swift interfaces
│   └── sample-data.json           # Combined sample data
├── shell/                         # Shell components
│   ├── README.md                  # Design intent
│   └── components/               # Exportable SwiftUI views
│       ├── AppShell.swift
│       ├── MainNav.swift
│       ├── UserMenu.swift
│       └── index.swift
└── sections/                      # Section components
    └── [section-id]/
        ├── README.md                  # Feature overview, user flows
        ├── tests.md                   # TDD test specifications
        ├── components/
        │   ├── [ViewName].swift   # Exportable SwiftUI views
        │   └── index.swift
        ├── types.swift                # Section-specific types
        └── sample-data.json          # Test data
```

## Implementation

Run `/export-product` to generate the complete package. This command will:

1. **Check prerequisites** — Verify all required files exist
2. **Gather design assets** — Components, types, data, tokens
3. **Generate prompts** — One-shot and section templates
4. **Generate instructions** — Milestone-by-milestone guides
5. **Create test specifications** — TDD specs per section
6. **Package everything** — Create `product-plan.zip` file

## Using the Export

Two implementation strategies:

### Option A: One-Shot (Recommended for Smaller Projects)

1. Copy the `product-plan/` directory to your codebase
2. Open your AI coding agent (Claude Code, Cursor, etc.)
3. Use the `one-shot-prompt.md` with the entire package
4. Answer agent's clarifying questions about authentication, data persistence, and tech stack
5. Let the agent implement everything at once

**When to use:**
- Smaller projects (3-5 sections)
- Single developer
- Fast prototype validation

### Option B: Incremental (Recommended for Larger Projects)

1. Copy the `product-plan/` directory to your codebase
2. Use the `section-prompt.md` template for each section
3. Follow the milestone-by-milestone instructions:
   - `01-foundation.md` — Design tokens, data types, routing setup
   - `02-shell.md` — Application shell implementation
   - `03-[section-id].md` — Implement each section sequentially

**When to use:**
- Larger projects (6+ sections)
- Team development
- Systematic implementation with testing at each stage

## What's Included in Export

### Prompts

The prompts are ready-to-copy into any AI coding agent. They include:

**Variable Placeholders**:
- `{{product_name}}` — Your product name
- `{{platforms}}` — Target platforms (iOS, macOS, watchOS, tvOS)
- `{{primary_color}}` — Your primary design token

**Clarifying Questions**:
The prompts will instruct the AI agent to ask about:
- **Authentication** — How do users sign in? (Apple ID, email/password, biometrics, etc.)
- **User Modeling** — How are users represented? (structs, database schema)
- **Data Persistence** — Core Data, Realm, SQLite, in-memory, or custom backend?
- **Networking** — URLSession, Alamofire, or GraphQL clients?

### Implementation Instructions

Each milestone includes:
- **Overview** — What this milestone accomplishes
- **Prerequisites** — What needs to be in place first
- **Step-by-step guide** — Clear implementation steps
- **Code organization** — File structure recommendations
- **Testing notes** — What to verify

Swift-Specific guidance includes:
- SwiftUI best practices (view modifiers, state management)
- Platform considerations (iOS vs macOS differences)
- Navigation patterns (NavigationStack, TabView, etc.)
- Memory management (@State, @Published, @Observable)
- Error handling and loading states

### Test Specifications

Each `tests.md` includes framework-agnostic TDD specifications:

**User Flow Tests:**
- Success paths (happy paths through key interactions)
- Failure paths (error states, edge cases)

**Empty State Tests:**
- What to display when no records exist (first-time users, after deletions)
- How empty states look visually

**Component Interaction Tests:**
- Verify buttons, gestures, and interactive elements work as expected
- Confirm accessibility labels are correct

### Design System

**SwiftUI Design Tokens:**
```swift
// product-plan/design-system/tokens.swift
import SwiftUI

@Observable
struct DesignTokens {
    let primary: Color
    let secondary: Color
    let neutral: Color
    
    init(from json: ColorTokens) {
        self.primary = Color(hex: json.primary)
        self.secondary = Color(hex: json.secondary)
        self.neutral = Color(hex: json.neutral)
    }
    
    static let `default` = DesignTokens(
        primary: .blue,
        secondary: .indigo,
        neutral: .gray
    )
}
```

**Font Integration:**
SF Pro fonts require proper setup in Xcode or via SF Symbols.

### Data Model

Swift types matching your entity definitions with Codable support for JSON parsing.

### Components

All SwiftUI views are:
- **Props-based** — Accept data and callbacks via properties
- **Portable** — Work with any SwiftUI project, no DesignOS dependencies
- **Complete** — Full styling, responsive design, light/dark mode
- **Production-ready** — Not prototypes, but actual implementation components

### Shell

Navigation and layout components ready to integrate into your app.

## Next Steps After Export

1. **Copy `product-plan/`** to your project directory
2. **Choose your implementation strategy** (one-shot vs incremental)
3. **Open your AI coding agent** and provide the prompt
4. **Answer clarifying questions** about auth, data persistence, networking
5. **Follow the implementation instructions** step-by-step
6. **Write tests based on** `tests.md` specifications
7. **Integrate components** by wiring up callbacks to routing and API calls
8. **Replace sample data** with real data from your backend
9. **Build for all platforms** — iOS, macOS, watchOS, tvOS

## Notes

- Exported components assume you'll handle:
  - **Error handling** and loading states
  - **Empty states** when no records exist
  - **API integration** and data fetching
  - **Proper navigation** routing between views
- The export package includes all context your implementation agent needs
- No need to explain requirements twice—the package is self-documenting
