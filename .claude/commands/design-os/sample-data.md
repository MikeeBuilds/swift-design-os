# Sample Data

You are helping the user create realistic sample data for a section of their Swift DesignOS product. This data will be used to populate screen designs. You will also generate Swift types based on the data structure.

## Step 1: Check Prerequisites

First, identify the target section and verify that `spec.md` exists for it.

Read `/product/product-roadmap.md` to get the list of available sections.

If there's only one section, auto-select it. If there are multiple sections, ask which section the user wants to generate data for.

Then check if `product/sections/[section-id]/spec.md` exists. If it doesn't:

"I don't see a specification for **[Section Title]** yet. Please run `/shape-section` first to define the section's requirements, then come back to generate sample data."

Stop here if the spec doesn't exist.

## Step 2: Check for Global Data Model

Check if `/product/data-model/data-model.md` exists.

**If it exists:**
- Read the file to understand the global entity definitions
- Entity names in your sample data should match the global data model
- Use the descriptions and relationships as a guide

**If it doesn't exist:**
Show a warning but continue:

"Note: A global data model hasn't been defined yet. I'll create entity structures based on the section spec, but for consistency across sections, consider running `/data-model` first."

## Step 3: Analyze the Specification

Read and analyze `product/sections/[section-id]/spec.md` to understand:

- What data entities are implied by the user flows?
- What fields/properties would each entity need?
- What sample values would be realistic and helpful for design?
- What actions can be taken on each entity? (These become callback closures in SwiftUI)

**If a global data model exists:** Cross-reference the spec with the data model. Use the same entity names and ensure consistency.

## Step 4: Present Data Structure

Present your proposed data structure to the user in human-friendly language. Non-technical users should understand how their data is being organized.

**If using global data model:**

"Based on the specification for **[Section Title]** and your global data model, here's how I'm organizing the data:

**Entities (from your data model):**

- **[Entity1]** — [Description from data model]
- **[Entity2]** — [Description from data model]

**Section-specific data:**

[Any additional data specific to this section's UI needs]

**What You Can Do:**

- View, edit, and delete [entities]
- [Other key actions from the spec]

**Sample Data:**

I'll create [X] realistic [Entity1] records with varied content to make your screen designs feel real.

Does this structure make sense? Any adjustments?"

**If no global data model:**

"Based on the specification for **[Section Title]**, here's how I'm proposing to organize your data:

**Data Models:**

- **[Entity1]** — [One sentence explaining what this represents]
- **[Entity2]** — [One sentence explanation]

**How They Connect:**

[Explain relationships in simple terms]

**What You Can Do:**

- View, edit, and delete [entities]
- [Other key actions from the spec]

**Sample Data:**

I'll create [X] realistic [Entity1] records with varied content to make your screen designs feel real.

Does this structure make sense for your product? Any adjustments?"

Ask clarifying questions if there are ambiguities about what data is needed.

## Step 5: Generate the Data File

Once the user approves the structure, create `product/sections/[section-id]/data.json` with:

- **A `_meta` section** - Human-readable descriptions of each data model and their relationships (displayed in the UI)
- **Realistic sample data** - Use believable names, dates, descriptions, etc.
- **Varied content** - Mix short and long text, different statuses, etc.
- **Edge cases** - Include at least one empty array, one long description, etc.
- **Swift-friendly structure** - Use consistent field names and types (camelCase)

### Required `_meta` Structure

Every data.json MUST include a `_meta` object at the top level with:

1. **`models`** - An object where each key is a model name and value is a plain-language description
2. **`relationships`** - An array of strings explaining how models connect to each other

Example structure:

```json
{
  "_meta": {
    "models": {
      "invoices": "Each invoice represents a bill you send to a client for work completed.",
      "lineItems": "Line items are the individual services or products listed on each invoice."
    },
    "relationships": [
      "Each Invoice contains one or more Line Items (the breakdown of charges)",
      "Invoices track which Client they belong to via the clientName field"
    ]
  },
  "invoices": [
    {
      "id": "inv-001",
      "invoiceNumber": "INV-2024-001",
      "clientName": "Acme Corp",
      "clientEmail": "billing@acme.com",
      "total": 1500.00,
      "status": "sent",
      "dueDate": "2024-02-15",
      "lineItems": [
        { "description": "Web Design", "quantity": 1, "rate": 1500.00 }
      ]
    }
  ]
}
```

The `_meta` descriptions should:
- Use plain, non-technical language
- Explain what each model represents in the context of user's product
- Describe relationships in terms of "contains", "belongs to", "links to", etc.
- **Match the global data model descriptions if one exists**

The data should directly support the user flows and UI requirements in the spec.

## Step 6: Generate Swift Types

After creating data.json, generate `product/sections/[section-id]/types.swift` based on the data structure.

### Type Generation Rules

1. **Infer types from the sample data values:**
   - Strings → `String`
   - Numbers → `Double` or `Int` based on context
   - Booleans → `Bool`
   - Arrays → `[TypeName]`
   - Objects → Create a named struct

2. **Use enums for status/option fields:**

   - If a field like `status` has known values, use an enum:

   ```swift
   enum InvoiceStatus: String, Codable {
       case draft
       case sent
       case paid
       case overdue
   }
   ```

   - Base this on the spec and the variety in sample data

3. **Create a View Model or State class for the main component:**
   - Include the data as a property (e.g., `invoices: [Invoice]`)
   - Include closure properties for each action (e.g., `onDelete: (String) -> Void`)
   - Consider using `ObservableObject` for SwiftUI integration

4. **Use consistent entity names:**
   - If a global data model exists, use the same entity names
   - This ensures consistency across sections
   - Use PascalCase for struct names: `Invoice`, `LineItem`
   - Use camelCase for property names: `clientName`, `dueDate`, `lineItems`

5. **Make types Codable for JSON serialization:**

   ```swift
   struct Invoice: Codable, Identifiable {
       let id: String
       let invoiceNumber: String
       let clientName: String
       let clientEmail: String
       let total: Double
       let status: InvoiceStatus
       let dueDate: Date
       let lineItems: [LineItem]
   }
   ```

6. **Add `Identifiable` conformance for SwiftUI lists:**
   - The `id` property should be unique for each item
   - Use `Identifiable` protocol for easy integration with `List` and `ForEach`

Example types.swift:

```swift
import Foundation
import SwiftUI

// =============================================================================
// Data Types
// =============================================================================

enum InvoiceStatus: String, Codable, CaseIterable {
    case draft
    case sent
    case paid
    case overdue

    var displayName: String {
        switch self {
        case .draft: return "Draft"
        case .sent: return "Sent"
        case .paid: return "Paid"
        case .overdue: return "Overdue"
        }
    }
}

struct LineItem: Codable, Identifiable {
    let id: String
    let description: String
    let quantity: Int
    let rate: Double

    var subtotal: Double {
        Double(quantity) * rate
    }
}

struct Invoice: Codable, Identifiable {
    let id: String
    let invoiceNumber: String
    let clientName: String
    let clientEmail: String
    let total: Double
    let status: InvoiceStatus
    let dueDate: Date
    let lineItems: [LineItem]

    var formattedTotal: String {
        String(format: "$%.2f", total)
    }

    var formattedDueDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: dueDate)
    }
}

// =============================================================================
// View Model
// =============================================================================

@Observable
class InvoiceListViewModel {
    var invoices: [Invoice]

    init(invoices: [Invoice] = []) {
        self.invoices = invoices
    }

    // Actions
    var onView: ((String) -> Void)?
    var onEdit: ((String) -> Void)?
    var onDelete: ((String) -> Void)?
    var onArchive: ((String) -> Void)?
    var onCreate: (() -> Void)?

    func deleteInvoice(id: String) {
        invoices.removeAll { $0.id == id }
        onDelete?(id)
    }
}

// =============================================================================
// View Protocol
// =============================================================================

protocol InvoiceListView: View {
    var viewModel: InvoiceListViewModel { get }
}
```

### Naming Conventions

- Use PascalCase for struct/enum names: `Invoice`, `LineItem`, `InvoiceStatus`
- Use camelCase for property names: `clientName`, `dueDate`, `lineItems`
- Use `@Observable` macro (iOS 17+) or `ObservableObject` for view models
- Add computed properties for formatted display values
- Use `Identifiable` protocol for models used in SwiftUI lists
- **Match entity names from the global data model if one exists**

### SwiftUI-Specific Considerations

- Use `Codable` for easy JSON parsing from data.json
- Add `Identifiable` conformance for seamless List integration
- Consider computed properties for formatted display values (dates, currency)
- Use `@Observable` (iOS 17+) for modern state management
- Model actions as closures rather than delegate patterns
- Add `displayName` computed properties for enums to show user-friendly labels

## Step 7: Confirm and Next Steps

Let the user know:

"I've created two files for **[Section Title]**:

1. `product/sections/[section-id]/data.json` - Sample data with [X] records

2. `product/sections/[section-id]/types.swift` - Swift structs and view models

The types include:

- `[Entity]` - The main data type (Codable, Identifiable)
- `[Entity]Status` - Enum for status fields with display names
- `[SectionName]ViewModel` - Observable class with data and action closures
- Computed properties for formatted display values

When you're ready, run `/design-screen` to create the screen design for this section."

## Important Notes

- Generate realistic, believable sample data - not "Lorem ipsum" or "Test 123"
- Include 5-10 sample records for main entities (enough to show a realistic list)
- Include edge cases: empty arrays, long text, different statuses
- Keep field names clear and Swift-friendly (camelCase)
- The data structure should directly map to the spec's user flows
- Always generate types.swift alongside data.json
- Action closures should cover all actions mentioned in the spec
- Use `@Observable` macro for iOS 17+ or `ObservableObject` for backward compatibility
- **Use entity names from the global data model for consistency across sections**
- Add `Identifiable` conformance for SwiftUI List/ForEach integration
- Include computed properties for formatted display (currency, dates, etc.)
- Make all types Codable for easy JSON parsing
