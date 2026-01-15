# Releasing Swift DesignOS

This document describes the versioning and release process for Swift DesignOS.

## Versioning

Swift DesignOS follows [Semantic Versioning](https://semver.org/) (SemVer): `MAJOR.MINOR.PATCH`

- **MAJOR**: Incompatible API changes
- **MINOR**: New functionality, backwards compatible
- **PATCH**: Bug fixes, backwards compatible

Examples:
- `1.0.0` → Initial release
- `1.1.0` → New feature, compatible with 1.0.0
- `1.1.1` → Bug fix, compatible with 1.1.0
- `2.0.0` → Breaking changes, incompatible with 1.x

## Release Process

### 1. Prepare Release

```bash
# Update version in Package.swift
swift package edit-version 1.0.0

# Update CHANGELOG.md
# Add release notes for new version

# Commit changes
git add Package.swift CHANGELOG.md
git commit -m "chore: prepare for v1.0.0 release"
```

### 2. Create Release Branch

```bash
# Create release branch from main
git checkout -b release/v1.0.0
git push origin release/v1.0.0
```

### 3. Create Tag

```bash
# Tag the release commit
git tag -a v1.0.0 -m "Release v1.0.0"

# Push tag to trigger GitHub Actions
git push origin v1.0.0
```

### 4. GitHub Actions Automatically

- Creates GitHub Release with changelog
- Validates package
- Provides Swift Package Index submission instructions

### 5. Publish to Swift Package Index

1. Fork [swift-package-index/swift-package-index-server](https://github.com/swift-package-index/swift-package-index-server)
2. Add your package to `packages.yml`
3. Submit PR with format:

```yaml
- name: SwiftDesignOS
  url: https://github.com/YOUR_ORG/swift-design-os.git
  ignorePackages:
    - swift-design-os-app  # Exclude demo app
```

## Release Checklist

Before releasing a new version:

- [ ] All tests passing on all platforms
- [ ] Code coverage threshold met (>80%)
- [ ] Documentation updated
- [ ] CHANGELOG.md updated with release notes
- [ ] Version number updated in Package.swift
- [ ] Breaking changes documented
- [ ] SwiftFormat applied
- [ ] SwiftLint passing

## Post-Release

After releasing a new version:

1. Update README.md if needed
2. Announce release on GitHub Discussions
3. Tweet or share on social media (optional)
4. Close any related issues in milestone
5. Create new milestone for next release

## Breaking Changes

When introducing breaking changes:

1. Update MAJOR version
2. Document migration guide in CHANGELOG
3. Update documentation with new API usage
4. Deprecate old APIs for at least one minor version
5. Provide clear upgrade instructions

Example changelog entry:

```markdown
## [2.0.0] - 2025-01-15

### Breaking Changes

- Removed `ProductLoader.load()` in favor of `ProductLoader.load(from:)`
  Migration: Replace `ProductLoader.load()` with `ProductLoader.load(from: productPath)`

### Added

- New `ProductLoader.load(from:)` method with explicit path parameter

### Deprecated

- `ProductLoader.load()` will be removed in v2.1.0
```

## Maintenance Releases

For patch releases (bug fixes):

- Release from main branch
- No new features
- Backwards compatible
- Fast release cycle (1-2 days)

## Feature Releases

For minor releases (new features):

- Release from main branch
- Backwards compatible
- Includes planned features from milestone
- Release cycle (2-4 weeks)

## Major Releases

For major releases (breaking changes):

- Create dedicated release branch
- Extensive testing required
- Migration guide required
- Release cycle (1-3 months)

## Hotfixes

For critical production issues:

1. Create hotfix branch from latest tag
2. Apply fix
3. Tag as patch version
4. Merge hotfix back to main

```bash
git checkout -b hotfix/v1.0.1 v1.0.0
# Apply fix
git tag v1.0.1
git push origin hotfix/v1.0.1 v1.0.1
```

## Platform Compatibility

Each release must support:

- iOS 17.0+
- macOS 14.0+
- watchOS 10.0+
- tvOS 17.0+

Test on all platforms before releasing.

## Dependency Updates

When updating dependencies:

1. Test thoroughly on all platforms
2. Update CHANGELOG with dependency changes
3. Note any breaking changes from dependencies
4. Update minimum platform versions if required

## Questions?

For questions about the release process, open a GitHub Discussion.