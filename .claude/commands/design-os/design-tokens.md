# Design Tokens

You are helping the user choose colors and typography for their Swift/SwiftUI product. These design tokens will be used consistently across all screen designs and the application shell.

## Step 1: Check Prerequisites

First, verify that the product overview exists:

Read `/product/product-overview.md` to understand what the product is.

If it doesn't exist:

"Before defining your design system, you'll need to establish your product vision. Please run `/product-vision` first."

Stop here if the prerequisite is missing.

## Step 2: Explain the Process

"Let's define the visual identity for **[Product Name]**.

I'll help you choose:
1. **Colors** — A primary accent, secondary accent, and neutral palette from SwiftUI's system colors
2. **Typography** — Fonts from SF Pro and available system fonts for headings, body text, and code

These will be applied consistently across all your screen designs and the application shell.

Do you have any existing brand colors or fonts in mind, or would you like suggestions?"

Wait for their response.

## Step 3: Choose Colors

Help the user select from SwiftUI's system colors. Present options based on their product type:

"For colors, we'll pick from SwiftUI's built-in Color palette so they work seamlessly with your screen designs and native system appearance.

**Primary color** (main accent, buttons, links):
Popular choices from SwiftUI system colors:
- `blue` — Professional, trustworthy
- `indigo` — Modern, vibrant
- `purple` — Creative, luxurious
- `pink` — Friendly, playful
- `red` — Bold, attention-grabbing
- `orange` — Energetic, warm
- `yellow` — Optimistic, bright
- `green` — Fresh, growth-oriented
- `mint` — Clean, modern
- `teal` — Balanced, sophisticated
- `cyan` — Cool, futuristic

**Secondary color** (complementary accent, tags, highlights):
Should complement your primary — often a different hue or a lighter/darker variation

**Neutral color** (backgrounds, text, borders):
SwiftUI system options:
- `gray` — Classic neutral
- `white` — Clean, minimal
- `black` — Bold, high contrast

Based on [Product Name], I'd suggest:
- **Primary:** [suggestion] — [why it fits]
- **Secondary:** [suggestion] — [why it complements]
- **Neutral:** [suggestion] — [why it works]

What feels right for your product?"

Use AskUserQuestion to gather their preferences if they're unsure:

- "What vibe are you going for? Professional, playful, modern, minimal?"
- "Any colors you definitely want to avoid?"
- "Light mode, dark mode, or both? (SwiftUI adapts automatically)"
- "Should this match Apple's design guidelines or stand out?"

## Step 4: Choose Typography

Help the user select from SF Pro and other available system fonts:

"For typography, we'll use SF Pro and other system fonts available in iOS/macOS for native performance and accessibility.

**Heading font** (titles, section headers):
SwiftUI system options:
- `.largeTitle` style with SF Pro — Apple's default for large titles
- `.title` style with SF Pro — Standard for titles
- `.title2`, `.title3` — Smaller heading variations
Custom font options (using `.font(.custom(...))`):
- `SFProDisplay-Bold` — Bold, impactful headings
- `SFProText-Semibold` — Strong, readable headings
- `NewYork-Regular` — Editorial style (iOS only)

**Body font** (paragraphs, UI text):
SwiftUI system options:
- `.body` style with SF Pro — Default body text
- `.callout` — Slightly smaller body text
- `.subheadline` — Secondary text
- `.footnote` — Smaller supporting text

**Mono font** (code, technical content):
SwiftUI system options:
- `.system(.monospaced)` — System monospaced font
- `.system(.monospaced).design(.monospaced)` — Explicit monospace design
Custom options:
- `Menlo-Regular` — Classic code font
- `SF Mono-Regular` — Apple's monospaced font
- `CourierNewPSMT` — Traditional monospace

My suggestions for [Product Name]:
- **Heading:** [suggestion] — [why]
- **Body:** [suggestion] — [why]
- **Mono:** [suggestion] — [why]

What do you prefer?"

## Step 5: Present Final Choices

Once they've made decisions:

"Here's your design system:

**Colors:**
- Primary: `[color]`
- Secondary: `[color]`
- Neutral: `[color]`

**Typography:**
- Heading: [Font Name/Style]
- Body: [Font Name/Style]
- Mono: [Font Name/Style]

Does this look good? Ready to save it?"

## Step 6: Create the Files

Once approved, create two files:

**File 1:** `/product/design-system/colors.json`
```json
{
  "primary": "[color]",
  "secondary": "[color]",
  "neutral": "[color]"
}
```

**File 2:** `/product/design-system/typography.json`
```json
{
  "heading": "[Font Name/Style]",
  "body": "[Font Name/Style]",
  "mono": "[Font Name/Style]"
}
```

## Step 7: Confirm Completion

Let the user know:

"I've saved your design tokens:
- `/product/design-system/colors.json`
- `/product/design-system/typography.json`

**Your palette:**
- Primary: `[color]` — for buttons, links, key actions
- Secondary: `[color]` — for tags, highlights, secondary elements
- Neutral: `[color]` — for backgrounds, text, borders

**Your fonts:**
- [Heading Font/Style] for headings
- [Body Font/Style] for body text
- [Mono Font/Style] for code

These will be used when creating screen designs for your sections.

Next step: Run `/design-shell` to design your application's navigation and layout."

## Reference: SwiftUI System Colors

SwiftUI's built-in Color enum includes:
- **Standard Colors:** `red`, `orange`, `yellow`, `green`, `mint`, `teal`, `cyan`, `blue`, `indigo`, `purple`, `pink`, `brown`, `gray`, `black`, `white`
- **Semantic Colors:** `primary`, `secondary`, `accentColor` — adapt to light/dark mode automatically
- **Context Colors:** `background`, `foreground`, `fill`, `stroke` — context-appropriate colors

Each standard color has semantic variants with `.opacity()` modifier.

## Reference: SF Pro Font Styles

SwiftUI's `Font.TextStyle` enum includes:
- `.largeTitle` — 34pt, bold
- `.title` — 28pt, bold
- `.title2` — 22pt, bold
- `.title3` — 20pt, semibold
- `.headline` — 17pt, semibold
- `.body` — 17pt, regular
- `.callout` — 16pt, regular
- `.subheadline` — 15pt, regular
- `.footnote` — 13pt, regular
- `.caption` — 12pt, regular
- `.caption2` — 11pt, regular

Custom font example: `.font(.custom("SFProDisplay-Regular", size: 24))`

## Reference: Popular SwiftUI Font Pairings

- **Apple Native:** `.largeTitle` + `.body` + `.system(.monospaced)`
- **Professional:** `.title` + `.body` + `Menlo-Regular`
- **Modern & Clean:** `.title2` + `.callout` + `SF Mono-Regular`
- **Bold & Impactful:** `.largeTitle` + `.body` + `.system(.monospaced)`
- **Editorial:** `NewYork-Regular` + `.body` + `CourierNewPSMT`
- **Developer-Focused:** `.title` + `.body` + `SF Mono-Regular`

## SwiftUI Implementation Notes

- Colors can use semantic variants for automatic light/dark mode adaptation
- Font styles automatically scale with user's text size preferences (Dynamic Type)
- Use `.foregroundStyle(.primary)` and `.foregroundStyle(.secondary)` for text colors instead of hardcoded values
- SF Pro is the system font and requires no additional setup
- Custom fonts must be added to the app target's resources
- Always prefer system fonts over custom fonts for accessibility and performance

## Important Notes

- Colors should be SwiftUI Color names (not hex codes)
- Font styles should use SwiftUI's TextStyles or exact system font names
- Keep suggestions contextual to the product type and platform
- The mono font is optional but recommended for any product with code/technical content
- Design tokens apply to screen designs only — Swift DesignOS app keeps its own aesthetic
- SwiftUI automatically adapts colors and typography for light/dark mode and accessibility preferences
