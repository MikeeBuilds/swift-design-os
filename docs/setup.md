# Swift DesignOS Setup Guide

This guide helps you set up Swift DesignOS for development or as a dependency in your project.

## Prerequisites

- **macOS 14.0+** (for development)
- **Xcode 16.0+** (includes Swift 6.0)
- **Git** (for cloning repository)

## Development Setup

### 1. Clone Repository

```bash
git clone https://github.com/YOUR_ORG/swift-design-os.git
cd swift-design-os
```

### 2. Install Dependencies

```bash
# Install SwiftLint for code quality
brew install swiftlint

# Install SwiftFormat for code formatting
brew install swiftformat
```

### 3. Build Package

```bash
# Debug build
swift build

# Release build
swift build -c release

# Build for specific platform
swift build --target swift-design-os-app
```

### 4. Run Tests

```bash
# Run all tests
swift test

# Run tests with coverage
swift test --enable-code-coverage

# Run tests for specific target
swift test --filter SwiftDesignOSTests
```

## Using as a Swift Package Dependency

### Xcode Project Setup

1. Open your Xcode project
2. Navigate to **File → Add Package Dependencies...**
3. Choose one of:
   - **Add Local Package** (for local development)
   - **Enter package URL** (for remote): `https://github.com/YOUR_ORG/swift-design-os.git`
4. Select `SwiftDesignOS` library
5. Add to your target

### Swift Package Manager Setup

Add to your `Package.swift`:

```swift
// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "YourApp",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    dependencies: [
        .package(
            url: "https://github.com/YOUR_ORG/swift-design-os.git",
            .upToNextMajor(from: "1.0.0")
        )
    ],
    targets: [
        .target(
            name: "YourApp",
            dependencies: ["SwiftDesignOS"]
        )
    ]
)
```

## Using the Planning App

The planning app helps you design products before implementation.

### Open Planning App

```bash
open App/swift-design-os-app/swift-design-os-app.xcodeproj
```

### The Workflow

The app guides you through 10 steps:

1. **Product Vision** — Define your product
2. **Product Roadmap** — Break into sections
3. **Data Model** — Define entities
4. **Design Tokens** — Choose colors/typography
5. **Shell Design** — Design navigation
6. **Shape Section** — Define section requirements
7. **Sample Data** — Generate test data
8. **Design Screen** — Build SwiftUI views
9. **Screenshot Design** — Capture visual docs (optional)
10. **Export Product** — Generate handoff package

## Using as a Library

Import and use Swift DesignOS in your Swift code:

```swift
import SwiftUI
import SwiftDesignOS

struct ContentView: View {
    var body: some View {
        DesignOSCard {
            VStack {
                Text("Welcome to Swift DesignOS")
                    .font(.title)
                Text("Build products the right way")
                    .font(.body)
            }
        }
    }
}
```

## Available Components

Swift DesignOS provides these reusable SwiftUI components:

- **AppLayout** — Main app layout wrapper
- **PhaseNav** — Navigation between workflow phases
- **Button** — Styled button components
- **Card** — Card container components
- **Dialog** — Modal dialogs
- **Badge** — Status badges
- **TextField** — Input fields

See [Components Documentation](./components.md) for usage examples.

## Data Loaders

Load product and section data from markdown files:

```swift
import SwiftDesignOS

// Load product overview
let product = try ProductLoader.load(from: "product/product-overview.md")

// Load data model
let dataModel = try DataModelLoader.load(from: "product/data-model/data-model.md")

// Load design system
let designSystem = try DesignSystemLoader.load(
    colorsPath: "product/design-system/colors.json",
    typographyPath: "product/design-system/typography.json"
)

// Load section
let section = try SectionLoader.load(from: "product/sections/your-section/spec.md")
```

## Platform-Specific Notes

### iOS

```swift
import SwiftUI
import SwiftDesignOS

struct iOSApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

### macOS

```swift
import SwiftUI
import SwiftDesignOS

struct MacApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.hiddenTitleBar)
    }
}
```

### watchOS

```swift
import SwiftUI
import SwiftDesignOS

struct WatchApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

### tvOS

```swift
import SwiftUI
import SwiftDesignOS

struct TVApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

## Development Workflow

### Code Quality

Before committing, run:

```bash
# Format code
swiftformat Sources Tests

# Check linting
swiftlint

# Run tests
swift test
```

### Git Workflow

1. Create feature branch: `git checkout -b feature/your-feature`
2. Make changes
3. Run quality checks
4. Commit changes: `git commit -m "feat: your feature description"`
5. Push to fork: `git push origin feature/your-feature`
6. Create Pull Request

### Branch Protection Rules

- **Main** — Protected, require PR review
- **Develop** — Protected, require PR review
- **Feature/** — Feature development branches
- **Hotfix/** — Emergency fixes from release tags

## Troubleshooting

### Build Failures

**Problem:** Build fails with "SDK not found"

**Solution:**
```bash
sudo xcode-select -s /Applications/Xcode_16.0.app/Contents/Developer
```

### Test Failures

**Problem:** Tests fail on simulator

**Solution:** Ensure correct simulator is selected:
```bash
xcrun simctl list devices
xcrun simctl boot "iPhone 15 Pro"
```

### Import Errors

**Problem:** "No such module 'SwiftDesignOS'"

**Solution:**
1. Clean build folder: `rm -rf .build`
2. Rebuild: `swift build`
3. Ensure package is added to target dependencies

## Next Steps

- Read [Components Documentation](./components.md) for component usage
- Read [Examples](./examples.md) for implementation examples
- Check [README.md](../README.md) for full project documentation

## Getting Help

- **GitHub Issues:** Report bugs and request features
- **GitHub Discussions:** Ask questions and share ideas
- **Documentation:** Check inline code documentation

Happy building! 🚀