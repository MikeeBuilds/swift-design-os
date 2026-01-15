## Summary

<!-- What does this change do and why? Keep it tight (1-2 sentences). -->

## Type of Change

- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update (changes to README, code comments, or docs)
- [ ] Code refactoring (no functional changes, just code cleanup)
- [ ] Performance improvement
- [ ] Testing improvements

## Linked Item

- Closes: #<number> (must be an open Issue)
- Relates to: #<number>
- Addresses: #<number>

## Platform Support

This PR has been tested on:

- [ ] iOS 17.0+ (specify version tested: _____)
- [ ] macOS 14.0+ (specify version tested: _____)
- [ ] watchOS 10.0+ (specify version tested: _____)
- [ ] tvOS 17.0+ (specify version tested: _____)

**Testing Environment:**
- Xcode Version: _____
- Swift Version: _____
- Simulators/Devices tested: _____
- Physical devices tested: _____

## Swift Package Manager Compatibility

- [ ] Package.swift validates successfully (`swift package dump-package`)
- [ ] Package builds on all platforms (`swift build`)
- [ ] Package resolves dependencies correctly
- [ ] Example projects (if any) build successfully
- [ ] SPM integration tested in fresh Xcode project

## Code Quality

- [ ] Code follows Swift DesignOS style guidelines
- [ ] SwiftFormat applied to all changed files
- [ ] SwiftLint passes with no new warnings
- [ ] No forced unwraps (!) unless absolutely necessary
- [ ] Proper error handling implemented
- [ ] Code is properly documented with comments
- [ ] API changes are documented
- [ ] Public APIs have documentation comments (`///`)

## Testing

- [ ] Unit tests added for new functionality
- [ ] UI tests added if applicable
- [ ] All existing tests pass
- [ ] Tests cover edge cases
- [ ] Tests added to appropriate test suite
- [ ] Test coverage improved (if applicable)

**Test Summary:**
- New tests added: _____
- Existing tests modified: _____
- Test coverage change: _____

## SwiftUI Best Practices

- [ ] Views use proper SwiftUI patterns
- [ ] State management appropriate (@State, @Binding, @ObservedObject, @StateObject)
- [ ] View modifiers applied correctly
- [ ] Components are props-based (data passed via properties)
- [ ] No direct data imports in components
- [ ] Supports light and dark mode
- [ ] Responsive design with size classes
- [ ] Uses SF Symbols for icons
- [ ] Proper use of SwiftUI animations
- [ ] No force unwraps in view body

## Platform-Specific Considerations

### iOS
- [ ] Tested on iPhone (specify models: _____)
- [ ] Tested on iPad if applicable (specify models: _____)
- [ ] Handles dynamic type correctly
- [ ] Supports landscape orientation if applicable
- [ ] Handles safe area correctly

### macOS
- [ ] Tested on Mac (specify models: _____)
- [ ] Menu bar / toolbar integration if applicable
- [ ] Keyboard shortcuts work correctly
- [ ] Mouse interactions work correctly
- [ ] Window resizing handled properly

### watchOS
- [ ] Tested on Apple Watch (specify models: _____)
- [ ] Complications if applicable tested
- [ ] Digital Crown interactions if applicable
- [ ] Battery usage optimized

### tvOS
- [ ] Tested on Apple TV (specify models: _____)
- [ ] Focus engine works correctly
- [ ] Remote interactions work
- [ ] Screen layout appropriate for TV

## Breaking Changes

<!-- If this PR includes breaking changes, describe them here -->

**Breaking Changes:**
- List of APIs that changed: _____
- List of APIs that were removed: _____
- Migration guide: _____

**Affected Users:**
- Who will be affected by this change? _____
- How should users migrate? _____

## Documentation

- [ ] README updated if needed
- [ ] API documentation updated (DocC comments)
- [ ] CHANGELOG.md updated with version
- [ ] Usage examples added/updated
- [ ] Platform-specific documentation updated

## Checklist

- [ ] Linked to related Issue
- [ ] Commit messages follow guidelines
- [ ] Code follows Swift DesignOS style guidelines
- [ ] SwiftFormat applied to all changes
- [ ] SwiftLint passes with no new warnings
- [ ] Tests added for new functionality
- [ ] All existing tests pass
- [ ] Documentation updated (if applicable)
- [ ] Platform compatibility tested
- [ ] SwiftUI best practices followed
- [ ] No forced unwraps unless necessary
- [ ] Proper error handling implemented

## Review Checklist

For reviewers to verify:

**Code Review:**
- [ ] Code is readable and maintainable
- [ ] Logic is correct
- [ ] No performance issues
- [ ] No security concerns
- [ ] Follows project conventions

**Testing Review:**
- [ ] Tests are comprehensive
- [ ] Tests pass locally
- [ ] No test flakiness

**Platform Review:**
- [ ] Works on supported platforms
- [ ] No regressions on any platform
- [ ] Platform-specific code is appropriate

**Documentation Review:**
- [ ] Documentation is clear
- [ ] Examples are accurate
- [ ] No outdated information

## Documented Steps to Test

Provide clear steps for reviewers to test this change:

1. _______
2. _______
3. _______

**Expected Behavior:**
_______

**Actual Behavior:**
_______

## Screenshots / Videos

If this change includes UI modifications, include screenshots or screen recordings:

[Before]
[Image or video]

[After]
[Image or video]

## Performance Impact

- [ ] No performance impact
- [ ] Performance improved (describe: _____)
- [ ] Performance degraded (describe: _____)
- [ ] Requires performance benchmarking

## Additional Notes

Anything else reviewers should know:

- Dependencies updated: _____
- Known limitations: _____
- Future work planned: _____
- Related issues/PRs: _____

## Automated Checks

<!-- These will be filled automatically by CI/CD -->

- [ ] CI Build: Passing ✅ / Failing ❌
- [ ] CI Tests: Passing ✅ / Failing ❌
- [ ] SwiftLint: Passing ✅ / Failing ❌
- [ ] SwiftFormat: Passing ✅ / Failing ❌
- [ ] Code Coverage: _____%

---

## Notes for Reviewers

<!-- Anything to call out, specific areas to focus on, potential concerns, etc. -->

**Focus Areas:**
1. _____
2. _____
3. _____

**Potential Concerns:**
1. _____
2. _____
3. _____

---

Thank you for contributing to Swift DesignOS! 🚀
