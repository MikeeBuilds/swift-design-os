# Contributing to Swift DesignOS

Contributions are welcome! This is an open-source project and we appreciate all help.

## How to Contribute

### Reporting Bugs

1. Open an issue on GitHub
2. Use the bug report template
3. Include:
   - Clear title and description
   - Steps to reproduce
   - Expected vs actual behavior
   - Platform information (iOS, macOS, watchOS, tvOS)
   - Xcode and Swift version
   - Any relevant error messages or logs

### Suggesting Enhancements

1. Check existing issues first to avoid duplicates
2. Use the feature request template
3. Describe the problem you're trying to solve
4. Explain your proposed solution clearly
5. Discuss alternatives you've considered
6. Include examples or use cases

### Submitting Pull Requests

1. Fork this repository
2. Create a feature branch from `main`
3. Make your changes with clear commit messages
4. Add tests for new features
5. Ensure all tests pass
6. Submit a pull request with a clear description

## Development Workflow

### Setting Up

```bash
# Clone repository
git clone https://github.com/YOUR_USERNAME/swift-design-os.git
cd swift-design-os

# Add Swift DesignOS to your project
# For SPM package
swift package add local:../swift-design-os

# For local package dependency
# Add to Package.swift or use Xcode package manager
```

### Testing

Test your changes on all supported platforms:
- iOS Simulator
- Mac
- Watch Simulator (if applicable)
- Apple TV (if applicable)

```bash
# Run tests
swift test

# Build for specific platform
xcodebuild -scheme swift-design-os -destination 'platform=iOS Simulator,name=iPhone 15'
```

## Code Style

- Follow Swift naming conventions
- Use SwiftUI best practices
- Add documentation for public APIs
- Write clear, concise commit messages

## Documentation

If you're adding new features or changing existing ones, please update:
- README.md
- Relevant command files in `.claude/commands/design-os/`
- Inline code documentation

## Questions?

Feel free to open an issue for questions or discussion.
