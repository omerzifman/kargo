# Instructions for Removing 2 Commits from Main Branch

This PR represents the state of the repository **after** removing the following 2 commits from main:

1. **Commit `4c2e6740`**: "Add workflow_dispatch trigger to CI workflow"
2. **Commit `fdd7a582`**: "Merge branch 'akuity:main' into main"

## Current State

- This branch (`copilot/remove-two-commits-main`) is at commit `03581148` - the latest from akuity/main
- The `main` branch currently has the 2 unwanted commits
- The only file difference is the removal of `workflow_dispatch:` from `.github/workflows/ci.yaml`

## How to Apply This Change to Main

Since GitHub doesn't allow force-pushing through the web UI or automated tools, you have two options:

### Option 1: Force Push Locally (Recommended)

```bash
# Fetch the latest changes
git fetch origin

# Checkout the branch with the corrected history
git checkout copilot/remove-two-commits-main

# Force push this branch to main
git push origin copilot/remove-two-commits-main:main --force
```

### Option 2: Reset Main Directly

```bash
# Checkout main
git checkout main

# Reset to the akuity upstream commit
git reset --hard 03581148a9ff251ec7b01a9b27ca5ae2f27c2662

# Force push
git push origin main --force
```

## What Gets Removed

The workflow_dispatch trigger line will be removed from `.github/workflows/ci.yaml`:

```yaml
name: CI

on:
-  workflow_dispatch:
   pull_request:
     branches-ignore:
     - newdocs
```

## Important Notes

- ⚠️ Force pushing will rewrite history on the main branch
- Make sure no one else has work based on the commits being removed
- This is a destructive operation and cannot be undone without the old commit SHAs
