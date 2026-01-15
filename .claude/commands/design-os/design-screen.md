# Design Screen

You are helping the user create a screen design for a section of their product. The screen design will be a props-based SwiftUI view that can be exported and integrated into any SwiftUI codebase.

## Step 1: Check Prerequisites

First, identify the target section and verify that `spec.md`, `data.json`, and `types.swift` all exist.

Read `/product/product-roadmap.md` to get the list of available sections.

If there's only one section, auto-select it. If there are multiple sections, use the AskUserQuestion tool to ask which section the user wants to create a screen design for.

Then verify all required files exist:

- `product/sections/[section-id]/spec.md`
- `product/sections/[section-id]/data.json`
- `product/sections/[section-id]/types.swift`

If spec.md doesn't exist:

"I don't see a specification for **[Section Title]** yet. Please run `/shape-section` first to define the section's requirements."

If data.json or types.swift don't exist:

"I don't see sample data for **[Section Title]** yet. Please run `/sample-data` first to create sample data and types for the screen designs."

Stop here if any file is missing.

## Step 2: Check for Design System and Shell

Check for optional enhancements:

**Design Tokens:**
- Check if `/product/design-system/colors.json` exists
- Check if `/product/design-system/typography.json` exists

If design tokens exist, read them and use them for styling. If they don't exist, show a warning:

"Note: Design tokens haven't been defined yet. I'll use default styling, but for consistent branding, consider running `/design-tokens` first."

**Shell:**
- Check if `src/shell/components/AppShell.swift` exists

If shell exists, the screen design will render inside the shell in Design OS. If not, show a warning:

"Note: An application shell hasn't been designed yet. The screen design will render standalone. Consider running `/design-shell` first to see section screen designs in the full app context."

## Step 3: Analyze Requirements

Read and analyze all three files:

1. **spec.md** - Understand the user flows and UI requirements
2. **data.json** - Understand the data structure and sample content
3. **types.swift** - Understand the Swift structs and available callbacks

Identify what views are needed based on the spec. Common patterns:

- List/dashboard view (showing multiple items)
- Detail view (showing a single item)
- Form/create view (for adding/editing)

## Step 4: Clarify the Screen Design Scope

If the spec implies multiple views, use the AskUserQuestion tool to confirm which view to build first:

"The specification suggests a few different views for **[Section Title]**:

1. **[View 1]** - [Brief description]
2. **[View 2]** - [Brief description]

Which view should I create first?"

If there's only one obvious view, proceed directly.

## Step 5: Invoke the SwiftUI Design Skill

Before creating the screen design, read the `swift-ios` skill to ensure high-quality SwiftUI design output.

Read the file at `.claude/skills/swift-ios/SKILL.md` and follow its guidance for creating production-grade SwiftUI interfaces.

## Step 6: Create the Props-Based SwiftUI View

Create the main view file at `src/sections/[section-id]/components/[ViewName].swift`.

### View Structure

The view MUST:

- Import types from the types.swift file
- Accept all data via properties (never import data.json directly)
- Accept callback properties for all actions
- Be fully self-contained and portable
- Conform to `View` protocol
- Use SwiftUI preview for development

Example:

```swift
import SwiftUI

public struct InvoiceListView: View {
    // MARK: - Properties
    let invoices: [Invoice]
    let onView: (String) -> Void
    let onEdit: (String) -> Void
    let onDelete: (String) -> Void
    let onCreate: () -> Void

    // MARK: - Body
    public var body: some View {
        VStack(spacing: 0) {
            header
            content
        }
    }

    // MARK: - Header
    private var header: some View {
        HStack {
            Text("Invoices")
                .font(.title2)
                .fontWeight(.bold)

            Spacer()

            Button(action: onCreate) {
                Label("Create", systemImage: "plus")
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
    }

    // MARK: - Content
    private var content: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(invoices) { invoice in
                    InvoiceRow(
                        invoice: invoice,
                        onView: { onView(invoice.id) },
                        onEdit: { onEdit(invoice.id) },
                        onDelete: { onDelete(invoice.id) }
                    )
                }
            }
            .padding()
        }
    }
}

// MARK: - Preview
#Preview {
    InvoiceListView(
        invoices: [
            Invoice(id: "1", clientName: "Acme Corp", amount: 5000.0),
            Invoice(id: "2", clientName: "Tech Inc", amount: 3200.0)
        ],
        onView: { id in print("View: \(id)") },
        onEdit: { id in print("Edit: \(id)") },
        onDelete: { id in print("Delete: \(id)") },
        onCreate: { print("Create new") }
    )
}
```

### Design Requirements

- **Mobile responsive:** Use SwiftUI's adaptive layouts (e.g., `HStack`, `LazyVStack`, `GeometryReader`, adaptive padding) and ensure the design works on iPhone SE, iPhone Pro Max, iPad, and macOS
- **Light & dark mode:** SwiftUI automatically supports dark mode through semantic colors like `.primary`, `.secondary`, `.background`, `.secondarySystemBackground`
- **Use design tokens:** If defined, apply the product's color palette and typography through custom Color extensions
- **Follow the swift-ios skill:** Create production-ready SwiftUI views following Apple's Human Interface Guidelines

### Applying Design Tokens

**If `/product/design-system/colors.json` exists:**
Create a Color extension or use semantic colors based on the primary/secondary/neutral palette
Example: If primary is `blue`, use custom Color extensions like `Color.bluePrimary`, `Color.blueAccent`

**If `/product/design-system/typography.json` exists:**
- Use the specified font families and weights
- Reference them in comments for clarity

**If design tokens don't exist:**
- Use SwiftUI's semantic colors (`.primary`, `.secondary`, `.systemBlue`, etc.)
- Use system fonts (`.headline`, `.body`, `.caption`, etc.)

### What to Include

- Implement ALL user flows and UI requirements from the spec
- Use the prop data (not hardcoded values)
- Include realistic UI states (hover on macOS, pressed states, disabled states)
- Use the callback properties for all interactive elements
- Handle optional callbacks gracefully

### What NOT to Include

- No direct data import statements - data comes via properties
- No features not specified in the spec
- No navigation logic - callbacks handle navigation intent
- No navigation elements (shell handles navigation)

## Step 7: Create Sub-Views (If Needed)

For complex views, break down into sub-views. Each sub-view should also be props-based.

Create sub-views at `src/sections/[section-id]/components/[SubView].swift`.

Example:

```swift
import SwiftUI

public struct InvoiceRow: View {
    let invoice: Invoice
    let onView: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void

    public var body: some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(invoice.clientName)
                    .font(.headline)

                Text(invoice.invoiceNumber)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            HStack(spacing: 8) {
                Button("View", action: onView)
                    .buttonStyle(.bordered)

                Button("Edit", action: onEdit)
                    .buttonStyle(.bordered)

                Button("Delete", action: onDelete)
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    InvoiceRow(
        invoice: Invoice(id: "1", clientName: "Acme Corp", amount: 5000.0),
        onView: { print("View") },
        onEdit: { print("Edit") },
        onDelete: { print("Delete") }
    )
}
```

Then import and use in the main view:

```swift
private var content: some View {
    ScrollView {
        LazyVStack(spacing: 12) {
            ForEach(invoices) { invoice in
                InvoiceRow(
                    invoice: invoice,
                    onView: { onView(invoice.id) },
                    onEdit: { onEdit(invoice.id) },
                    onDelete: { onDelete(invoice.id) }
                )
            }
        }
        .padding()
    }
}
```

## Step 8: Create the Preview Wrapper

Create a preview wrapper at `src/sections/[section-id]/[ViewName].swift` (note: this is in the section root, not in components/).

This wrapper is what Design OS renders. It imports the sample data and feeds it to the props-based view.

Example:

```swift
import SwiftUI
import SwiftDesignOS

struct InvoiceListPreview: View {
    var body: some View {
        InvoiceListView(
            invoices: sampleData.invoices,
            onView: { id in
                print("View invoice: \(id)")
            },
            onEdit: { id in
                print("Edit invoice: \(id)")
            },
            onDelete: { id in
                print("Delete invoice: \(id)")
            },
            onCreate: {
                print("Create new invoice")
            }
        )
    }
}

#Preview {
    InvoiceListPreview()
}
```

The preview wrapper:

- Imports SwiftDesignOS framework
- Imports sample data from data.json (via sampleData property)
- Passes data to the view via properties
- Provides print handlers for callbacks (for testing interactions)
- Is NOT exported to the user's codebase - it's only for Design OS
- **Will render inside the shell** if one has been designed

## Step 9: Create View Index

Create an index file at `src/sections/[section-id]/components/index.swift` to cleanly export all views.

Example:

```swift
@_exported import SwiftUI

public struct InvoiceViews {
    public struct List {
        public typealias View = InvoiceListView
        public typealias Row = InvoiceRow
    }

    // Add other view groups as needed
}
```

Or simpler:

```swift
@_exported import SwiftUI

public typealias InvoiceListView = InvoiceListView
public typealias InvoiceRow = InvoiceRow
```

## Step 10: Confirm and Next Steps

Let the user know:

"I've created the screen design for **[Section Title]**:

**Exportable views** (props-based, portable):

- `src/sections/[section-id]/components/[ViewName].swift`
- `src/sections/[section-id]/components/[SubView].swift` (if created)
- `src/sections/[section-id]/components/index.swift`

**Preview wrapper** (for Design OS only):

- `src/sections/[section-id]/[ViewName].swift`

**Important:** Restart your app to see the changes.

[If shell exists]: The screen design will render inside your application shell, showing the full app experience.

[If design tokens exist]: I've applied your color palette ([primary], [secondary], [neutral]) and typography choices.

**Next steps:**

- Run `/screenshot-design` to capture a screenshot of this screen design for documentation
- If the spec calls for additional views, run `/design-screen` again to create them
- When all sections are complete, run `/export-product` to generate the complete export package"

If the spec indicates additional views are needed:

"The specification also calls for [other view(s)]. Run `/design-screen` again to create those, then `/screenshot-design` to capture each one."

## Important Notes

- ALWAYS read the `swift-ios` skill before creating screen designs
- Views MUST be props-based - never import data.json in exportable views
- The preview wrapper is the ONLY file that imports sample data
- Use Swift structs from types.swift for all properties
- Callbacks should be closures, optional when appropriate
- Always remind the user to restart the app after creating files
- Sub-views should also be props-based for maximum portability
- Apply design tokens when available for consistent branding
- Screen designs render inside the shell when viewed in Design OS (if shell exists)
- Use SwiftUI's built-in adaptive layouts for mobile responsiveness
- Use semantic colors for automatic light/dark mode support
- Include `#Preview` macros for development-time previews
