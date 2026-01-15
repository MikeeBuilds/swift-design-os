# Shape Section

Define a detailed section specification for your Swift DesignOS product.

## Overview

This command guides you through creating a comprehensive section specification that will be saved to `product/sections/[section-id]/spec.md`. A section represents a major feature area of your product (e.g., User Profile, Settings, Dashboard).

## Interactive Process

### Step 1: Section Identification

**Let's start by understanding which section you want to define:**

1. What is the **section name**? (e.g., "User Profile", "Settings", "Dashboard")
2. What is the **section ID**? (lowercase, hyphenated; e.g., "user-profile", "app-settings")

### Step 2: Section Overview

**Now, let's describe this section in a clear, concise way:**

Please provide a **2-3 sentence overview** that explains:
- What this section does
- Who it serves
- What value it provides

*Example:*
> "The User Profile section allows users to manage their personal information, preferences, and account settings. It serves all authenticated users and provides a centralized location for identity management. This section ensures users can customize their experience and maintain control over their data."

### Step 3: User Flows and Interactions

**Let's map out the key user journeys through this section:**

For each primary user flow, describe:
1. **Flow name** (e.g., "Edit Profile", "Change Password")
2. **Starting point** (e.g., "From Settings → User Profile → Edit Profile")
3. **Step-by-step interactions** (numbered list of screens, actions, and decisions)
4. **Completion criteria** (how does the user know they're done?)
5. **Edge cases** (what happens if validation fails, network errors, etc.)

*Ask clarifying questions as needed:*
- What happens if the user cancels mid-flow?
- Are there confirmation dialogs?
- What error states should we handle?
- Is there a success feedback mechanism?

### Step 4: UI Requirements

**Now, let's define the visual and structural requirements:**

**Layout Patterns:**
- What layout patterns does this section use? (e.g., Form-based, Navigation-based, List-based, Tab-based, Modal-based)
- Screen orientation requirements? (Portrait, Landscape, Both)
- Adaptive layout needs? (iPhone, iPad, macOS, etc.)

**SwiftUI Components Needed:**
List the specific SwiftUI components required:
- Navigation components (NavigationView, NavigationStack, TabView)
- List/Collection components (List, ScrollView, LazyVStack)
- Form components (TextField, SecureField, Picker, Toggle, Slider)
- Display components (Text, Image, AsyncImage, Spacer)
- Feedback components (Alert, Sheet, Toast, ProgressView)
- Custom components (e.g., AvatarView, CardView, StatCard)

**Screen List:**
For each screen:
1. **Screen name** (e.g., "Profile Detail Screen")
2. **Primary purpose** (1-2 sentences)
3. **Key elements** (buttons, inputs, content)
4. **Navigation entry/exit** (how users get here and leave)
5. **State dependencies** (what data does this screen need?)

**Design Patterns:**
- MVC, MVVM, or another pattern?
- ObservableObject vs. Observable macro?
- State management approach (StateObject, Binding, EnvironmentObject)?

### Step 5: Scope Boundaries

**Let's clarify what's in scope and what's out of scope:**

**In Scope:**
- List all features, screens, and interactions included in this section
- Define integration points with other sections
- Identify data models this section manages

**Out of Scope:**
- What features are explicitly NOT included?
- What edge cases will be deferred to future iterations?
- What integrations are out of scope for this section?

### Step 6: Technical Considerations

**Finally, let's address technical details:**

**Data Models:**
- What Swift structs/classes are needed?
- Are there Codable requirements?
- Do we need Core Data or SwiftData persistence?

**Networking:**
- Does this section require API calls?
- What endpoints will be used?
- Caching strategy?

**Persistence:**
- UserDefaults, AppStorage, or custom storage?
- What data needs to persist across app launches?

**Accessibility:**
- VoiceOver support requirements?
- Dynamic Type support?
- Color contrast considerations?

## Output

The specification will be saved to:
```
product/sections/[section-id]/spec.md
```

The file will include:
- Section overview (2-3 sentences)
- User flows with step-by-step interactions
- UI requirements (layouts, patterns, components)
- Screen specifications
- Scope boundaries
- Technical considerations

## Example Specification Structure

```markdown
# [Section Name]

## Overview
[2-3 sentences describing the section]

## User Flows

### [Flow Name]
**Starting Point:** [Where users begin]
**Steps:**
1. [First step]
2. [Second step]
...
**Completion:** [How users know they're done]
**Edge Cases:** [Error states, validation, etc.]

## UI Requirements

### Layout Patterns
- [List patterns used]

### SwiftUI Components
- [List components needed]

### Screens

#### [Screen Name]
**Purpose:** [What this screen does]
**Key Elements:** [Buttons, inputs, content]
**Navigation:** [Entry/exit points]
**State:** [Data dependencies]

### Design Patterns
- [Architecture pattern]
- [State management approach]

## Scope Boundaries

### In Scope
- [Features and interactions included]

### Out of Scope
- [Features explicitly excluded]

## Technical Considerations

### Data Models
- [Structs/classes needed]

### Networking
- [API endpoints, caching]

### Persistence
- [Storage strategy]

### Accessibility
- [VoiceOver, Dynamic Type support]
```

## Notes

- Be conversational and ask clarifying questions throughout
- Adapt language for Swift/SwiftUI development
- Consider iOS/macOS/watchOS/tvOS platform differences
- Reference Design System components where applicable
- Ensure spec is detailed enough for AI implementation agents
