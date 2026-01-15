# Contributing to Swift DesignOS

Thanks for considering a contribution! Swift DesignOS is free and open source, and we welcome contributions from the community.

---

## Where Things Go

- **Bug Reports:** Use the Bug Report template for confirmed issues with reproduction steps
  👉 **Check the docs first:** See [README.md](../README.md)

- **Feature Requests:** Use the Feature Request template for new features or enhancements

- **Discussions (Q&A):** Ask and answer community questions

---

## Development Workflow

### Prerequisites

- **Xcode 16.0+** for Swift 6.0 support
- **SwiftLint** for code quality
- **SwiftFormat** for code formatting

### Setting Up

```bash
# Clone repository
git clone https://github.com/YOUR_ORG/swift-design-os.git
cd swift-design-os

# Build package
swift build

# Run tests
swift test
```

### Coding Standards

- **Swift Style:** Follow Swift API Design Guidelines
- **Formatting:** Run `swiftformat Sources Tests` before committing
- **Linting:** Run `swiftlint` to check code quality
- **Documentation:** Public APIs should have documentation comments

### Platform Support

Swift DesignOS supports all Apple platforms:
- **iOS 17.0+**
- **macOS 14.0+**
- **watchOS 10.0+**
- **tvOS 17.0+**

When making changes, ensure they work on all target platforms.

---

## Pull Requests

To avoid wasted effort and to protect maintainer time:

### Bug Fix PRs

- Include `[bug fix]` in your PR title
- Clearly describe steps to reproduce the bug
- Document how to test the fix
- Add tests for the fix

### Feature PRs

> 💡 **Ideas welcome!** We recommend starting with a Feature Request Issue to gather feedback and community support before submitting a PR.
> New features must consider:
> - Long-term roadmap and maintainability
> - Backward compatibility
> - Platform support implications
> - Documentation requirements

A declined PR doesn't mean "never"—it means "not now."

### Documentation PRs

Typos, clarifications, and doc improvements are always welcomed!

---

## Testing

### Running Tests

```bash
# Run all tests
swift test

# Run tests with coverage
swift test --enable-code-coverage

# Run specific test
swift test --filter TestClassName.testMethodName
```

### Test Coverage

- Aim for >80% code coverage on new features
- Write unit tests for all public APIs
- Add integration tests for complex workflows

---

## Submitting a PR

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature-name`
3. Make your changes
4. Run formatting: `swiftformat Sources Tests`
5. Run linting: `swiftlint`
6. Run tests: `swift test`
7. Commit your changes: `git commit -m "Your commit message"`
8. Push to your fork: `git push origin feature/your-feature-name`
9. Open a Pull Request

### PR Checklist

- [ ] Linked to related Issue
- [ ] Code follows Swift DesignOS style guidelines
- [ ] SwiftFormat applied to all changes
- [ ] SwiftLint passes with no new warnings
- [ ] Tests added for new functionality
- [ ] All existing tests pass
- [ ] Documentation updated (if applicable)
- [ ] Platform compatibility tested

---

## Proposing New Features

1. Open a Feature Request Issue with:
   - Problem statement and motivation
   - Proposed solution and alternatives
   - User experience impact
   - Implementation considerations
   - Backward compatibility implications

2. Wait for maintainer feedback

3. If approved, submit a PR following the guidelines above

---

## Code of Conduct

By participating, you agree to our [Code of Conduct](./CODE_OF_CONDUCT.md). Be respectful and constructive.

---

## Getting Help

- **GitHub Issues:** For bugs and feature requests
- **GitHub Discussions:** For questions and community support
- **Documentation:** Check README.md and source code comments

Thank you for contributing to Swift DesignOS! 🚀
