# Screenshot Design

You are helping user capture a screenshot of a SwiftUI screen design for documentation. This command adapts the screenshot process for SwiftUI's native capabilities.

## Step 1: Identify Target Screen

First, ask user which screen design they want to screenshot:

"Which screen design would you like me to screenshot? I can see these available views in your project:"

Check available screens:
- List all view files in `src/sections/*/components/*.swift`
- Check for preview wrappers in `src/sections/*/*.swift`

If there's only one section and screen, auto-select it. If there are multiple, use conversational approach:

"Which section's screen design should we screenshot?
- [Section 1] - [Brief description]
- [Section 2] - [Brief description]"

Then confirm the specific screen name if multiple views exist in that section.

## Step 2: Check for Existing Screenshots

Before capturing, check if a screenshot already exists:

- Look for existing file at `product/sections/[section-id]/[screen-name].png`

If screenshot exists:

"I see there's already a screenshot for **[Screen Name]**. Would you like to:
- **Replace** it with a new capture
- **Keep** the existing one"

If user wants to replace, proceed. If keep, inform user of location and exit.

## Step 3: Determine Capture Method

Check if automated screenshot capture is available:

**Automated (Preferred):**
- Check if Xcode project has screenshot automation scripts
- Check if Swift UI Testing framework is available
- Look for `screenshot.sh` or similar scripts in project root

**Manual (Fallback):**
If automation isn't available, guide user through manual capture process.

## Step 4: Automated Screenshot Capture (If Available)

If automation exists, provide clear instructions:

"I'll capture a full-page screenshot of **[Screen Name]** using SwiftUI's native screenshot capabilities."

**Execution Steps:**

1. **Open the SwiftUI preview** or run the app
2. **Navigate to the target screen** using ralph-tui or direct navigation
3. **Use SwiftUI's snapshot capability:**

   For macOS:
   ```swift
   // Using ImageRenderer (iOS 16+, macOS 13+)
   let renderer = ImageRenderer(content: yourView)
   let image = renderer.uiImage
   ```

   For iOS Simulator:
   ```bash
   xcrun simctl io booted screenshot /path/to/save.png
   ```

4. **Save to correct location:** `product/sections/[section-id]/[screen-name].png`

5. **Verify capture:** Check that file was created successfully

**Integration with ralph-tui:**

If ralph-tui is configured (check for `.ralph-tui/config.json`):

"The screenshot will capture **[Screen Name]** as it appears within the app shell. Use ralph-tui to navigate to the screen if needed."

## Step 5: Manual Screenshot Capture Guide

If automation is not available, provide detailed manual instructions:

"Automated screenshot capture isn't currently configured. Here's how to capture the screenshot manually:"

### Option A: Xcode Simulator (iOS)

1. **Open your app** in Xcode
2. **Run the app** on iOS Simulator
3. **Navigate to the screen** using ralph-tui or direct app navigation
4. **Capture the screenshot:**
   - Press `Cmd + S` in simulator
   - Or use menu: `File → Save Screen`
   - Screenshot saves to `~/Desktop/` by default
5. **Move the screenshot:**
   - Rename file to `[screen-name].png`
   - Move to: `product/sections/[section-id]/[screen-name].png`

### Option B: macOS App

1. **Run the app** on macOS
2. **Navigate to the screen**
3. **Use built-in screenshot:**
   - Press `Cmd + Shift + 4` then Space for window capture
   - Or `Cmd + Shift + 4` for selection
4. **Move and rename** screenshot to correct location

### Option C: Swift Programmatically (Advanced)

Provide code snippet for programmatic capture:

```swift
import SwiftUI

// Add this helper function to capture SwiftUI views
extension View {
    func screenshot() -> UIImage? {
        let window = UIApplication.shared.windows.first
        let renderer = UIGraphicsImageRenderer(bounds: window?.bounds ?? .zero)
        return renderer.image { _ in
            window?.rootViewController?.view.drawHierarchy(in: window?.bounds ?? .zero, afterScreenUpdates: true)
        }
    }
}
```

## Step 6: Verify Screenshot Quality

After capture, verify the screenshot meets quality standards:

**Checklist:**
- ✅ Full screen visible (not cropped)
- ✅ Text is readable
- ✅ Colors and design tokens applied correctly
- ✅ Shows proper dark/light mode (if applicable)
- ✅ Resolution appropriate for documentation (at least 2x for Retina)

**If issues detected:**

"I notice the screenshot might have some quality issues. Would you like me to help recapture with better settings? Common fixes:
- Ensure simulator/device is at 100% scale
- Check that the screen is fully loaded before capturing
- Verify the screenshot includes the entire view"

## Step 7: Update Design Documentation (Optional)

If the section has a `spec.md`, you can optionally reference the screenshot:

Add to `product/sections/[section-id]/spec.md`:

```markdown
## Screenshots

**Main Screen:** `![Screen Name](./[screen-name].png)`

*The above screenshot shows the [description of what's visible].*
```

Only add this if user confirms they want screenshot documentation updated.

## Step 8: Confirm and Next Steps

Let user know:

"Screenshot saved to `product/sections/[section-id]/[screen-name].png`.

**Quality check:** ✅ [Pass/Fail based on verification]

**Next steps:**
- Run `/export-product` when all sections and screenshots are complete
- Screenshot other screens in this section if needed: `/screenshot-design`
- Continue designing screens: `/design-screen`

**Tip:** Screenshots are used in the export package to help implementation teams understand the intended UI."

## Important Notes

- **SwiftUI capabilities:** Prioritize native SwiftUI screenshot methods (ImageRenderer, UIGraphicsImageRenderer)
- **Path format:** Always save to `product/sections/[section-id]/[screen-name].png`
- **Resolution:** Ensure high-quality screenshots for documentation purposes
- **Manual fallback:** Always provide clear manual instructions when automation unavailable
- **ralph-tui integration:** Mention navigation through ralph-tui when applicable
- **Conversational approach:** Guide users through the process step-by-step
- **Quality verification:** Always verify screenshot quality before completion
- **Design system:** Screenshots should reflect applied design tokens if they exist
- **Multiple views:** If section has multiple screens, offer to capture all of them
