# Swift DesignOS

> **The missing design process between your product idea and your Swift/SwiftUI codebase.**

This repository contains Swift DesignOS, a comprehensive product planning and design tool for Apple platforms.

---

## Quick Links

- 📖 [Full Documentation](../README.md)
- 🚀 [Getting Started](../README.md#getting-started)
- 📚 [Usage Guide](docs/USAGE.md)
- 🚢 [Publishing Guide](docs/PUBLISHING.md)
- 🤝 [Contributing](CONTRIBUTING.md)
- 📄 [License](../LICENSE)

---

## What is Swift DesignOS?

Swift DesignOS is a planning tool that bridges the gap between product ideas and SwiftUI code. It provides:

- **Structured Product Planning** — Define vision, roadmap, and data model
- **Design System Builder** — Choose colors, typography, and UI patterns
- **Section-by-Section Design** — Design each feature area with SwiftUI views
- **Export Package Generation** — Create complete implementation handoff packages
- **Multi-Platform Support** — iOS, macOS, watchOS, and tvOS

---

## Installation

### Swift Package Manager

Add Swift DesignOS to any Apple project:

```bash
# File → Add Package Dependencies in Xcode
# Paste: https://github.com/YOUR_ORG/swift-design-os.git
```

Requirements:
- iOS 17.0+, macOS 14.0+, watchOS 10.0+, tvOS 17.0+
- Swift 6.0+
- Xcode 15+

### Mac App (Planning Tool)

Run the full planning interface locally:

```bash
git clone https://github.com/YOUR_ORG/swift-design-os.git
cd swift-design-os
open App/swift-design-os-app/swift-design-os-app.xcodeproj
```

---

## Platform Support

| Platform | Minimum Version |
|----------|----------------|
| iOS | 17.0+ |
| macOS | 14.0+ |
| watchOS | 10.0+ |
| tvOS | 17.0+ |

---

## Documentation

- [Getting Started](../README.md#getting-started) — Installation and quick start
- [Usage Guide](docs/USAGE.md) — Library usage and API reference
- [Publishing Guide](docs/PUBLISHING.md) — Publish to Swift Package Index
- [Components](docs/components.md) — Available SwiftUI components
- [Examples](docs/examples.md) — Example workflows and implementations
- [GitHub Setup](docs/github-setup.md) — Repository configuration

---

## Key Features

### 🎯 Product Planning

- **Product Vision** — Define your app's identity and purpose
- **Roadmap** — Break down into 3-5 development sections
- **Data Model** — Specify core entities and relationships
- **Design Tokens** — Choose colors, typography, and patterns
- **Application Shell** — Design persistent navigation structure

### 🎨 Design System

- **SwiftUI Native** — Built with Apple's declarative UI framework
- **SF Symbols** — Access to 5,000+ Apple-designed icons
- **System Colors** — Platform-native color palette
- **Typography** — SF Pro and system font integration
- **Light & Dark Mode** — Automatic theme support

### 🚦 Sequential Workflow

10-step guided process:
1. Product Vision
2. Product Roadmap
3. Data Model
4. Design Tokens
5. Application Shell
6. Shape Section (for each section)
7. Sample Data (for each section)
8. Design Screen (for each section)
9. Screenshot Design (optional)
10. Export Product

### 📦 Export Package

Complete handoff package including:
- Production-ready SwiftUI components
- Swift data structures
- Sample data for testing
- Implementation prompts for AI agents
- Test specifications

---

## Example: TaskFlow App

Built in 2 hours using Swift DesignOS:

**Sections:**
- Daily Feed — Shows today's tasks
- Task List — Full task management
- Projects — Organize by project
- Settings — Preferences

**Data Model:**
- Task, Project, User entities

**Design System:**
- Primary: `.blue`
- Secondary: `.indigo`
- Typography: `.title` + `.body`

See [Examples](docs/examples.md) for more details.

---

## Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

---

## License

MIT License — see [LICENSE](../LICENSE) for details.

---

## Based on DesignOS

Swift DesignOS is the Apple-platform implementation of [DesignOS](https://github.com/buildermethods/design-os) by Brian Casel.

---

## Support

- 📖 [Documentation](../README.md)
- 🐛 [Report Bugs](ISSUE_TEMPLATE.md)
- 💡 [Request Features](FEATURE_TEMPLATE.md)
- 💬 [Discussions](https://github.com/YOUR_ORG/swift-design-os/discussions)

---

## Quick Start

### As a Library

```swift
import SwiftDesignOS

// Load product data
let product = try loadProductData(from: "product/product-overview.md")

// Load section data
let section = try loadSectionData(from: "product/sections/dashboard/spec.md")

// Use components
Button("Get Started") {
    // Action
}
```

### As a Planning Tool

1. Run `/product-vision` to define your app
2. Run `/product-roadmap` to break into sections
3. Run `/data-model` to specify entities
4. Run `/design-tokens` to choose visual design
5. Run `/export-product` to generate implementation package

---

**Happy building with Swift DesignOS! 🚀**
