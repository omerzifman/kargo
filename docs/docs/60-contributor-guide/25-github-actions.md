---
description: Learn how to enable and troubleshoot GitHub Actions for the Kargo repository
sidebar_label: GitHub Actions
---

# GitHub Actions

This guide explains how to make GitHub Actions run in the Kargo repository and troubleshoot common issues.

## Overview

The Kargo repository uses GitHub Actions for continuous integration (CI) and automated testing. The main workflow is defined in `.github/workflows/ci.yaml` and includes several jobs:

- **test-unit**: Runs Go unit tests
- **lint-and-typecheck-ui**: Lints and type-checks the UI code
- **lint-go**: Lints Go code using golangci-lint
- **lint-charts**: Lints Helm charts
- **lint-proto**: Lints Protocol Buffer definitions
- **check-codegen**: Verifies code generation is up to date
- **build-image**: Builds Docker images
- **build-cli**: Builds the CLI binary

## How to Make Actions Run

### Automatic Triggers

GitHub Actions will automatically run when:

1. **Pull Request Events**: Actions run on pull requests to any branch except `newdocs`
2. **Push Events**: Actions run on pushes to:
   - `main` branch
   - `release-*` branches (e.g., `release-v1.0.0`)
3. **Merge Group Events**: Actions run when commits are added to merge queues

### Manual Triggers

You can manually trigger workflows in several ways:

#### Option 1: Via GitHub Web Interface

1. Navigate to the [Actions tab](https://github.com/omerzifman/kargo/actions) in the repository
2. Select the workflow you want to run (e.g., "CI")
3. Click "Run workflow" button
4. Select the branch and click "Run workflow"

#### Option 2: Via GitHub CLI

If you have the [GitHub CLI](https://cli.github.com/) installed:

```bash
# Trigger the CI workflow on the current branch
gh workflow run ci.yaml

# Trigger on a specific branch
gh workflow run ci.yaml --ref main
```

#### Option 3: Create a Pull Request

The most common way to trigger CI is by creating a pull request:

```bash
# Create a new branch
git checkout -b my-feature-branch

# Make your changes and commit
git add .
git commit -m "My changes"

# Push the branch
git push origin my-feature-branch

# Create a pull request (this will trigger CI)
gh pr create --title "My Feature" --body "Description of changes"
```

## Troubleshooting Common Issues

### Actions Not Running

If GitHub Actions are not running, check the following:

#### 1. Repository Settings

Ensure GitHub Actions are enabled:

1. Go to repository **Settings** → **Actions** → **General**
2. Under "Actions permissions", ensure one of these is selected:
   - "Allow all actions and reusable workflows"
   - "Allow omerzifman, and select non-omerzifman, actions and reusable workflows"

#### 2. Branch Protection Rules

Check if branch protection rules are blocking actions:

1. Go to **Settings** → **Branches**
2. Check protection rules for your target branch
3. Ensure "Require status checks to pass before merging" allows your actions

#### 3. Workflow Permissions

The CI workflow requires these permissions (already configured):

```yaml
permissions:
  contents: read
  checks: write  # For some linting jobs
```

#### 4. Secrets and Variables

Some workflows may require repository secrets:

- `CODECOV_TOKEN`: For uploading test coverage reports

Check **Settings** → **Secrets and variables** → **Actions** to verify required secrets exist.

### Actions Failing

If actions are running but failing, common causes include:

#### 1. Test Failures

Run tests locally to debug:

```bash
# Run unit tests
make test-unit

# Run tests in container (recommended)
make hack-test-unit
```

#### 2. Lint Failures

Run linters locally:

```bash
# Lint all code
make hack-lint

# Lint specific components
make hack-lint-go
make hack-lint-proto
make hack-lint-charts
make lint-ui
```

#### 3. Code Generation Issues

Ensure generated code is up to date:

```bash
# Run code generation
make hack-codegen

# Check if anything changed
git diff
```

#### 4. Dependency Issues

If external dependencies fail to download:

- Check if the repository has network access restrictions
- Verify external URLs are accessible
- Check if any proxy configuration is needed

### Viewing Action Logs

To debug failing actions:

1. Go to the [Actions tab](https://github.com/omerzifman/kargo/actions)
2. Click on the failed workflow run
3. Click on the failing job
4. Expand the failing step to view detailed logs

You can also use GitHub CLI:

```bash
# List recent workflow runs
gh run list

# View logs for a specific run
gh run view <run-id> --log
```

## Running Actions Locally

For faster iteration, you can run many CI checks locally:

### Prerequisites

Install the required tools:

- [Docker](https://docs.docker.com/engine/install/) or compatible runtime
- [Make](https://www.gnu.org/software/make/)

### Available Commands

```bash
# Run all tests
make hack-test-unit

# Run all linters
make hack-lint

# Run code generation
make hack-codegen

# Build images
make hack-build

# Build CLI
make hack-build-cli
```

The `hack-` prefix runs commands in containers, eliminating the need to install specific tool versions locally.

## Workflow Status Badges

To add status badges to documentation or README files:

```markdown
![CI](https://github.com/omerzifman/kargo/actions/workflows/ci.yaml/badge.svg)
```

This badge shows the status of the CI workflow on the main branch.

## Best Practices

1. **Test Locally First**: Always run tests and linters locally before pushing
2. **Small Commits**: Make small, focused commits to make CI failures easier to debug
3. **Check Status**: Monitor the Actions tab after pushing to ensure CI passes
4. **Fix Quickly**: Address CI failures promptly to avoid blocking other contributors

## Getting Help

If you continue to have issues with GitHub Actions:

1. Check the [GitHub Actions documentation](https://docs.github.com/en/actions)
2. Review existing [Issues](https://github.com/omerzifman/kargo/issues) and [Discussions](https://github.com/omerzifman/kargo/discussions)
3. Ask for help in the [Discord community](https://akuity.community)
4. Open a new issue with the `area/ci-process` label