# GitHub Repository Setup Guide

This document provides complete instructions for setting up Swift DesignOS as a private or sponsored GitHub repository.

## Repository Overview

**Name:** swift-design-os
**Description:** The missing design process between your product idea and your Swift/SwiftUI codebase
**Language:** Swift
**License:** MIT

## Step 1: Create Repository

### Option A: Private Repository (Development)

1. Go to GitHub → New repository
2. Name: `swift-design-os`
3. Description: The missing design process between your product idea and your Swift/SwiftUI codebase
4. Visibility: Private
5. Initialize with: README.md, LICENSE
6. Click "Create repository"

### Option B: Sponsored Repository (Funding)

1. Create repository as above
2. Add GitHub Sponsors badge to README.md
3. Configure FUNDING.yml with sponsor information
4. Set up GitHub Sponsors integration (see Step 7)

## Step 2: Push Existing Code

If you already have the repository initialized locally:

```bash
# Navigate to existing directory
cd swift-design-os

# Add remote repository
git remote add origin https://github.com/YOUR_ORG/swift-design-os.git

# Push all branches
git push -u origin main

# Push all branches
git push --all origin

# Push all tags
git push --tags origin
```

## Step 3: Configure Repository Settings

### General Settings

Go to repository → Settings

**Repository Visibility:**
- Choose `Private` for development
- Change to `Public` when ready for release

**Repository Features:**
- ✅ Issues
- ✅ Discussions
- ✅ Projects
- ✅ Wikis
- ✅ Actions
- ✅ Packages

**Merge Button:**
- Allow merge commits: ❌ No
- Allow squash merging: ✅ Yes
- Allow rebase merging: ❌ No

**Update Branch Default:**
- Default branch: `main`

**Update Branches for Pull Requests:**
- Require branches to be up to date before merging: ✅ Yes
- Require status checks to pass: ✅ Yes

### Topics

Navigate to Settings → Topics

Add these topics:
```
swift
swiftui
swift-package-manager
design-system
developer-tools
product-planning
ui-components
cross-platform
ios
macos
watchos
tvos
```

## Step 4: Branch Protection Rules

### Protect Main Branch

Go to Settings → Branches → Add rule

**Branch name pattern:** `main`

**Apply rule to:**
- ✅ Include administrators

**Require status checks:**
- ✅ Require status checks to pass before merging
- ✅ Require branches to be up to date before merging

**Required status checks:**
- Build (from ci.yml)
- Test - macOS (from ci.yml)
- Test - iOS (from ci.yml)
- SwiftLint (from ci.yml)
- SwiftFormat (from ci.yml)

**Require branches to be up to date:**
- ✅ Yes

**Require pull request reviews:**
- ✅ Require at least one approval
- Dismiss stale PR approvals: ✅ Yes
- Require review from code owners: ❌ No

**Restrict who can push:**
- ✅ Yes (only administrators)

### Protect Develop Branch (Optional)

Create similar rules for `develop` branch if using GitFlow workflow.

## Step 5: Enable GitHub Features

### Issues

Go to Settings → General → Features

- ✅ Enable issues
- Set issue templates:
  - Bug Report (bug_report.md)
  - Feature Request (feature_request.md)

### Discussions

Go to Settings → General → Features

- ✅ Enable discussions
- Create categories:
  - 🐛 **Bugs** — Bug reports
  - 💡 **Ideas** — Feature proposals
  - ❓ **Q&A** — Community support

### Actions

Go to Settings → Actions → General

- ✅ Enable actions
- Allow GitHub Actions to create and approve pull requests: ✅ Yes
- Allow GitHub Actions to run reusable workflows: ✅ Yes

### Packages

Go to Settings → Actions → Packages

- ✅ Enable Swift packages

## Step 6: Configure GitHub Actions

### Required Workflows

Your repository should include these workflows in `.github/workflows/`:

1. **ci.yml** — Build and test on push/PR
2. **release.yml** — Create releases on tags
3. **stale.yml** — Close inactive issues (existing)
4. **pr-decline.yml** — PR management (existing)

### Permissions

Actions are pre-configured with minimal required permissions:

- `contents: read` — For checking out code
- `contents: write` — For releases
- `pull-requests: write` — For PR management
- `issues: write` — For stale issues

## Step 7: Sponsorship Setup (Optional)

### Configure FUNDING.yml

Edit `.github/FUNDING.yml`:

```yaml
github: YOUR_GITHUB_USERNAME
patreon: YOUR_PATREON_USERNAME
open_collective: YOUR_OPEN_COLLECTIVE_NAME
ko_fi: YOUR_KO_FI_USERNAME
tidelift: YOUR_TIDELIFT_PLATFORM
custom: ['https://your-custom-donation-link.com']
```

### GitHub Sponsors

1. Go to repository → Sponsors
2. Set up sponsorship tiers
3. Add sponsor information to README.md

### Add Sponsor Badge to README.md

```markdown
<a href="https://github.com/sponsors/YOUR_USERNAME">
  <img src="https://img.shields.io/github/sponsors/YOUR_USERNAME?style=social" alt="Sponsors">
</a>
```

## Step 8: Configure Security

### Security Policy

Edit `.github/SECURITY.yml` with contact email.

### Dependabot

Go to Settings → Security → Dependabot alerts → Enable

Enable alerts for:
- ✅ Security vulnerabilities in dependencies
- ✅ Automated dependency updates

### Code Scanning

Go to Settings → Security → Code scanning

- ✅ Enable code scanning
- ✅ Enable secret scanning

## Step 9: Configure Teams (For Organizations)

### Repository Teams

Go to Settings → Collaborators & teams → Teams

Create teams:
- **Maintainers** — Full access
- **Contributors** — Write access
- **Reviewers** — Triage issues/PRs

### Team Permissions

- **Maintainers:** Admin
- **Contributors:** Write
- **Reviewers:** Triage, Read

## Step 10: Configure Milestones

Go to Issues → Milestones

Create milestones for:
- **v1.0.0** — Initial release
- **v1.1.0** — First feature release
- **v2.0.0** — Major version

## Step 11: Configure Labels

Go to Issues → Labels

Create these labels:

**Priority:**
- `priority: critical` (red)
- `priority: high` (orange)
- `priority: medium` (yellow)
- `priority: low` (blue)

**Type:**
- `type: bug` (red)
- `type: feature` (green)
- `type: enhancement` (purple)
- `type: documentation` (blue)

**Status:**
- `status: in progress` (yellow)
- `status: needs review` (orange)
- `status: ready for merge` (green)

**Platform:**
- `platform: ios` (blue)
- `platform: macos` (purple)
- `platform: watchos` (orange)
- `platform: tvos` (pink)

## Step 12: Make Repository Public (When Ready)

1. Go to Settings → General
2. Scroll to "Danger Zone"
3. Click "Change repository visibility"
4. Select "Make public"
5. Confirm with repository name

## Step 13: Publish to Swift Package Index

### Manual Submission

1. Go to [Swift Package Index](https://swiftpackageindex.com)
2. Fork the repository: [swift-package-index-server](https://github.com/swift-package-index/swift-package-index-server)
3. Edit `packages.yml` and add:

```yaml
- name: SwiftDesignOS
  url: https://github.com/YOUR_ORG/swift-design-os.git
  ignorePackages:
    - swift-design-os-app
```

4. Submit PR

### Automatic Indexing

After first release (v1.0.0), Swift Package Index will automatically discover and index the package.

## Step 14: Configure Integrations

### CI/CD Services

Consider integrating:
- **CodeCov** — Code coverage tracking
- **Danger** — Automated PR reviews
- **SonarCloud** — Code quality analysis

### Communication

- **Slack** — Notify team of PR/issues
- **Discord** — Community chat
- **Discourse** — Discussion forums

## Verification Checklist

Before going public:

- [ ] Repository pushed to GitHub
- [ ] Branch protection rules configured
- [ ] CI/CD workflows working
- [ ] All tests passing
- [ ] Documentation updated
- [ ] FUNDING.yml configured (if sponsored)
- [ ] SECURITY.yml updated
- [ ] README.md complete
- [ ] CONTRIBUTING.md updated
- [ ] CHANGELOG.md created
- [ ] License file present
- [ ] Topics added
- [ ] Milestones created
- [ ] Labels configured
- [ ] First release tag created

## Post-Setup Actions

1. **Announce repository:**
   - Tweet about it
   - Post on Reddit/r/swift
   - Share in Swift community Discords

2. **Initial release:**
   - Create v1.0.0 tag
   - Generate changelog
   - Publish GitHub release

3. **Submit to directories:**
   - Swift Package Index
   - CocoaPods (if applicable)

4. **Monitor and respond:**
   - Watch for issues
   - Respond to discussions
   - Review and merge PRs

## Next Steps

- Follow [RELEASING.md](../RELEASING.md) for versioning
- Follow [CONTRIBUTING.md](./CONTRIBUTING.md) for contribution guidelines
- Read [Setup Guide](./setup.md) for local development

## Support

For questions about GitHub repository setup, open a GitHub Discussion.