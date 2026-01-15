# Publishing Swift DesignOS

This guide explains how to publish Swift DesignOS to make it discoverable and installable by other developers.

---

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Swift Package Index (SPI)](#swift-package-index-spi)
3. [Swift Package Registry](#swift-package-registry)
4. [Versioning Strategy](#versioning-strategy)
5. [Verification Steps](#verification-steps)
6. [Troubleshooting](#troubleshooting)
7. [Best Practices](#best-practices)

---

## Prerequisites

Before publishing, ensure you have:

- [ ] Public git repository (GitHub, GitLab, etc.)
- [ ] Valid `Package.swift` in root directory
- [ ] LICENSE file in repository root
- [ ] `swift package dump-package` outputs valid JSON
- [ ] Swift 5.0+ toolchain installed
- [ ] Xcode 15+ (for macOS development)
- [ ] Swift 6.0+ for latest features

### Validate Package Structure

```bash
# Navigate to package root
cd swift-design-os

# Validate Package.swift outputs valid JSON
swift package dump-package

# Expected output: JSON with name, products, targets, etc.

# Build and test locally
swift build
swift test

# Verify package builds successfully
```

---

## Swift Package Index (SPI)

The Swift Package Index is the recommended approach for open-source Swift packages.

### Overview

**Benefits:**
- Free, public search engine for Swift packages
- No authentication required
- Packages remain hosted on your git repository
- Users discover packages via GitHub URLs or external searches
- Automatic documentation generation with DocC
- Platform compatibility information displayed

### Step-by-Step Publishing

#### Step 1: Create Semantic Version Tag

```bash
# Tag your release (must follow SemVer 2.0: MAJOR.MINOR.PATCH)
git tag 0.1.0

# Push tag to remote
git push origin 0.1.0

# Verify tag exists
git tag -l
git ls-remote --tags origin
```

**Important:**
- Tag format: `1.0.0`, `0.1.5` (no "v" prefix)
- Tags must follow semantic versioning
- Each tag triggers a new version in the index
- Update Package.swift version when tagging

#### Step 2: Verify Tag on Remote

```bash
# Check remote tags
git ls-remote --tags origin

# Should show output like:
# abc123 refs/tags/0.1.0
# def456 refs/tags/0.2.0
```

#### Step 3: Submit to Swift Package Index

1. Visit [swiftpackageindex.com/add-a-package](https://swiftpackageindex.com/add-a-package)
2. Enter your repository URL: `https://github.com/YOUR_ORG/swift-design-os.git`
3. Click "Add Package"
4. SPI will validate your package automatically

**No account or authentication required** - it's completely open and free.

#### Step 4: Wait for Validation

SPI automatically validates:
- Repository accessibility (public repo required)
- `Package.swift` validity
- Semantic version tags
- Platform compatibility
- License detection
- Build status

**Validation typically completes within 5-10 minutes.**

#### Step 5: Verify Publication

1. Visit [swiftpackageindex.com/packages/swiftdesignos](https://swiftpackageindex.com/packages/swiftdesignos)
2. Verify package appears in search results
3. Check that all versions are indexed
4. Verify license, platforms, and documentation display correctly

### Optional: Configure `.spi.yml`

Create `.spi.yml` in your package root for advanced configuration:

```yaml
version: 1
builder:
  configs:
    - documentation_targets:
        - SwiftDesignOS  # First item is the "landing" target
      custom_documentation_parameters: [
        --emit-docc-path,
        --display-name,
        "Swift DesignOS"
      ]
```

**Purpose of .spi.yml:**
- Configure DocC documentation generation
- Specify custom schemes for builds
- Control platform compatibility checking
- Set up automatic documentation deployment

**Validate your `.spi.yml` at:** [swiftpackageindex.com/validate-spi-manifest](https://swiftpackageindex.com/validate-spi-manifest)

---

## Swift Package Registry

**Note:** This is an optional advanced approach for private/commercial packages. Skip this section if using SPI only.

### Overview

The Swift Package Registry allows publishing packages as archives to a registry service.

**Use Cases:**
- Private or commercial packages
- Need for token-based authentication
- Direct HTTP downloads (no git clone required)
- Corporate package management

**Registry Services:**
- JFrog Artifactory
- AWS CodeArtifact
- Cloudsmith
- GitHub Packages

### Prerequisites

- Swift 5.9+ installed
- Xcode 15+ (on macOS)
- Registry service account
- Registry access token with publish permissions

### Step-by-Step Publishing

#### Step 1: Set Up Registry Service

**Example using JFrog Artifactory:**

```bash
# Set registry URL (project-specific)
swift package-registry set "https://myorganization.jfrog.io/artifactory/api/swift/swift"

# Or globally
swift package-registry set "https://myorganization.jfrog.io/artifactory/api/swift/swift" --global
```

This creates `.swiftpm/configuration/registries.json`:
```json
{
  "authentication": {},
  "registries": {
    "[default]": {
      "supportsAvailability": false,
      "url": "https://myorganization.jfrog.io/artifactory/api/swift/swift"
    }
  },
  "version": 1
}
```

#### Step 2: Authenticate with Registry

```bash
# Login to registry
swift package-registry login "https://myorganization.jfrog.io/artifactory/api/swift/swift" \
  --token "<your-registry-token>"
```

#### Step 3: Create Package Metadata

Create `package-metadata.json` in your package root:

```json
{
  "author": {
    "name": "Your Name",
    "email": "your.email@example.com",
    "url": "https://github.com/yourusername",
    "organization": {
      "name": "Your Company",
      "url": "https://yourcompany.com"
    }
  },
  "description": "A comprehensive product planning and design tool for Apple platforms",
  "licenseURL": "https://github.com/username/repo/blob/main/LICENSE",
  "readmeURL": "https://github.com/username/repo/blob/main/README.md",
  "repositoryURLs": [
    "https://github.com/username/repo.git",
    "git@github.com:username/repo.git"
  ]
}
```

#### Step 4: Publish to Registry

```bash
# Basic publish
swift package-registry publish swiftdesignos 1.0.0 \
  --metadata-path package-metadata.json

# With custom registry
swift package-registry publish swiftdesignos 1.0.0 \
  --url https://myorganization.jfrog.io/artifactory/api/swift/swift \
  --metadata-path package-metadata.json

# Dry run (prepare but don't publish)
swift package-registry publish swiftdesignos 1.0.0 \
  --metadata-path package-metadata.json \
  --dry-run
```

**Command Options:**
- `<package-id>`: Package identifier in `<scope>.<name>` format (e.g., `yourcompany.swiftdesignos`)
- `<version>`: Semantic version (e.g., `1.0.0`)
- `--url`: Registry URL
- `--metadata-path`: Path to metadata JSON
- `--dry-run`: Prepare without publishing

#### Step 5: Verify Publication

Check your registry UI to verify the package is available.

---

## Versioning Strategy

Follow semantic versioning (SemVer 2.0): `MAJOR.MINOR.PATCH`

### Version Format

- **MAJOR**: Incompatible API changes
- **MINOR**: Backwards-compatible functionality additions
- **PATCH**: Backwards-compatible bug fixes

Examples:
- `1.0.0` — Initial stable release
- `1.1.0` — New features, backwards compatible
- `1.1.1` — Bug fix
- `2.0.0` — Breaking changes

### Versioning Rules

1. **Always use semantic version tags**: `1.0.0`, not `v1.0.0`
2. **Update Package.swift version**: Keep version in sync with tags
3. **Create git tag for each release**: Tag the commit being released
4. **Push tags to remote**: Tags must be on remote for SPI to detect
5. **Document breaking changes**: In CHANGELOG.md and release notes

### Pre-Release Versions

Use pre-release identifiers for alpha/beta releases:

- `1.0.0-alpha.1`
- `1.0.0-beta.1`
- `1.0.0-rc.1`

### Git Tag Workflow

```bash
# Make release commit
git commit -m "Release v1.0.0"

# Create tag
git tag -a 1.0.0 -m "Release v1.0.0"

# Push both commit and tag
git push origin main
git push origin 1.0.0
```

### Update Package.swift

```swift
let package = Package(
    name: "SwiftDesignOS",
    // ...
)
```

Note: Swift Package Manager doesn't use version in Package.swift, but it's good practice to document version in comments.

---

## Verification Steps

### For Swift Package Index

#### 1. Check Package Page

Visit: `https://swiftpackageindex.com/packages/swiftdesignos`

Verify:
- [ ] Package name and description correct
- [ ] All version tags appear
- [ ] License detected correctly
- [ ] Platform compatibility shown (iOS 17+, macOS 14+, watchOS 10+, tvOS 17+)
- [ ] Documentation link works

#### 2. Test Installation in Xcode

```bash
# Create a new test project
# In Xcode: File → New → Project → iOS App

# Add package
# File → Add Package Dependencies...
# Paste: https://github.com/YOUR_ORG/swift-design-os.git

# Select version rule
# "Up to Next Major Version" → 1.0.0

# Add to target
# Select your app target → Add Package

# Test import
# In your Swift file:
import SwiftDesignOS
```

#### 3. Verify Package Downloads

- Check GitHub release page for download counts
- Monitor SPI analytics (if available)
- Search on Swift Package Index to verify discovery

#### 4. Search Discovery

1. Visit [swiftpackageindex.com](https://swiftpackageindex.com)
2. Search for "SwiftDesignOS"
3. Verify package appears in results
4. Check search ranking

### For Package Registry

#### 1. Check Registry UI

- Navigate to your registry dashboard
- Verify package appears with correct version
- Check metadata displays correctly

#### 2. Test Resolution

```bash
# Force resolution from registry
swift package --replace-scm-with-registry resolve

# Build package
swift build
```

#### 3. Verify Download

- Check registry logs for download activity
- Verify package archive is accessible
- Test download URL directly

---

## Troubleshooting

### Swift Package Index Issues

#### Problem: Package not validated

```bash
# Check if Package.swift is valid
swift package dump-package

# Verify package builds
swift build

# Verify tag exists
git tag -l

# Check if repo is public
curl -I https://github.com/YOUR_ORG/swift-design-os.git
```

**Solution:**
- Ensure you're using the latest Swift toolchain
- Verify `Package.swift` has valid syntax
- Check all dependencies are accessible
- Ensure tags follow SemVer: `1.0.0`, not `v1.0.0`
- Verify repository is public

#### Problem: Package not appearing in search results

**Solution:**
- Verify repository is public
- Ensure semantic version tags exist
- Wait 24-48 hours for SPI to re-index
- Contact SPI team via GitHub if issue persists

#### Problem: Missing license in SPI display

**Solution:**
Add a `LICENSE` file to repository root. Common licenses:
- MIT
- Apache-2.0
- BSD-3-Clause

#### Problem: Platform compatibility not detected

**Solution:**
Check `Package.swift` platform requirements:

```swift
let package = Package(
    name: "SwiftDesignOS",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .watchOS(.v10),
        .tvOS(.v17)
    ],
    // ...
)
```

### Package Registry Issues

#### Problem: Authentication failed

```bash
# Reset configuration
rm -rf ~/.swiftpm/configuration/registries.json

# Re-login
swift package-registry login "https://your-registry.url" --token "<token>"
```

#### Problem: Publish fails with "package not found"

**Solution:**
- Ensure package identifier is registered with registry
- Check scope and name match registry configuration
- Verify you have publish permissions

#### Problem: Unsigned package warnings

```bash
# Configure to allow unsigned packages
# Edit ~/.swiftpm/configuration/registries.json
"onUnsigned": "silentAllow"

# Or sign your package
swift package-registry publish swiftdesignos 1.0.0 \
  --signing-identity "Identity" \
  --metadata-path package-metadata.json
```

#### Problem: Registry timeout

**Solution:**
```bash
# Increase timeout
swift package-registry publish swiftdesignos 1.0.0 \
  --timeout 300 \
  --metadata-path package-metadata.json
```

### General Debugging Commands

```bash
# Clear SwiftPM cache
swift package purge-cache

# Reset build products
swift package reset

# Check registry configuration
cat ~/.swiftpm/configuration/registries.json

# Get detailed output
swift package-registry publish ... --verbose

# Dump package JSON for debugging
swift package dump-package > package.json
cat package.json
```

---

## Best Practices

### 1. Version Management

- Follow semantic versioning (MAJOR.MINOR.PATCH)
- Create a git tag for each release
- Update CHANGELOG.md with release notes
- Document breaking changes in release notes
- Use pre-release tags for beta versions

### 2. Documentation

- Comprehensive README with installation instructions
- API documentation comments in code
- Example usage in README or `/Examples` directory
- CHANGELOG.md for version history
- DocC documentation for all public APIs

### 3. Testing

- Write tests for public API
- Test on all supported platforms
- Test installation in fresh Xcode project
- Verify examples build and run
- Check code coverage

### 4. Metadata

- Clear package description in Package.swift
- Relevant keywords for discoverability
- Author and license information
- Repository URL with `.git` extension
- README with usage examples

### 5. Release Process

- Automated CI/CD for releases
- GitHub releases with notes
- DocC documentation generation
- Platform compatibility testing
- Publish to Swift Package Index
- Update CHANGELOG

### 6. Community

- Respond to issues promptly
- Review and merge PRs
- Engage in discussions
- Provide migration guides for breaking changes
- Maintain backward compatibility when possible

---

## Alternative Installation Methods

If SPI or registry approaches don't work for your use case, users can still install Swift DesignOS directly:

### Method 1: Direct GitHub URL (Most Common)

In Xcode:
1. **File → Add Package Dependencies...**
2. Paste GitHub URL: `https://github.com/YOUR_ORG/swift-design-os.git`
3. Xcode fetches repository and parses `Package.swift`
4. Select version rule (e.g., "Up to Next Major Version")
5. Choose target(s) to add package to
6. Click "Add Package"

### Method 2: Manual Clone

```bash
# Clone repository
git clone https://github.com/YOUR_ORG/swift-design-os.git
cd swift-design-os

# Add as local package in Xcode
# File → Add Package Dependencies → Add Local Package...
# Select swift-design-os directory
```

### Method 3: Git Submodule

```bash
# Add as submodule
git submodule add https://github.com/YOUR_ORG/swift-design-os.git Dependencies/swift-design-os

# Add to Package.swift in your project
.package(path: "Dependencies/swift-design-os")
```

---

## Additional Resources

- [Swift Package Index](https://swiftpackageindex.com/) - Package discovery and search
- [SPI Add Package](https://swiftpackageindex.com/add-a-package) - Submit your package
- [SPI FAQ](https://swiftpackageindex.com/faq) - Common questions
- [Swift Evolution SE-0391](https://github.com/apple/swift-evolution/blob/main/proposals/0391-package-registry-publish.md) - Package Registry spec
- [Swift Package Manager Docs](https://docs.swift.org/swiftpm/documentation/packagemanagerdocs/)
- [WWDC21: Discover and curate Swift Packages](https://developer.apple.com/videos/play/wwdc2021/10197/) - Package collections in Xcode
- [Semantic Versioning 2.0](https://semver.org/) - Versioning specification

---

## Quick Reference

### Publish to Swift Package Index

```bash
# Tag release
git tag 1.0.0
git push origin 1.0.0

# Submit to SPI
# Visit: https://swiftpackageindex.com/add-a-package
# Enter: https://github.com/YOUR_ORG/swift-design-os.git
```

### Publish to Package Registry

```bash
# Login
swift package-registry login "https://registry.url" --token "<token>"

# Publish
swift package-registry publish swiftdesignos 1.0.0 \
  --metadata-path package-metadata.json
```

### Verify Package

```bash
# Dump package JSON
swift package dump-package

# Build locally
swift build

# Test in Xcode
# File → Add Package Dependencies...
# Enter: https://github.com/YOUR_ORG/swift-design-os.git
```

---

**Need Help?**
- Open an [issue](../.github/ISSUE_TEMPLATE.md)
- Join [Discussions](https://github.com/YOUR_ORG/swift-design-os/discussions)
- Check [SPI Documentation](https://swiftpackageindex.com)
