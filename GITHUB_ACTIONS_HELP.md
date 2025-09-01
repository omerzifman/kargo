## How to Make GitHub Actions Run

This repository uses GitHub Actions for continuous integration. If you're having trouble getting actions to run, here are the most common solutions:

### Quick Start

1. **Create a Pull Request** (most common trigger):
   ```bash
   git checkout -b my-feature-branch
   # Make your changes
   git add .
   git commit -m "Your changes"
   git push origin my-feature-branch
   # Create PR via GitHub web interface or:
   gh pr create --title "Your Feature" --body "Description"
   ```

2. **Manual trigger** (if you have write access):
   ```bash
   # Via GitHub CLI
   gh workflow run ci.yaml
   
   # Or via GitHub web interface:
   # Go to Actions → CI → Run workflow
   ```

### Automatic Triggers

GitHub Actions run automatically on:
- Pull requests to any branch (except `newdocs`)
- Pushes to `main` branch
- Pushes to `release-*` branches
- Merge group events

### Troubleshooting

If actions aren't running, use our troubleshooting script:

```bash
make hack-troubleshoot-actions
```

This script will check:
- ✅ Repository configuration
- ✅ Local development environment
- ✅ Network connectivity
- ✅ GitHub CLI setup
- ✅ Common issues and solutions

### Common Issues

1. **Actions disabled**: Check repository Settings → Actions → General
2. **Missing permissions**: Ensure proper read/write access to the repository
3. **Branch protection**: Check if branch protection rules are configured correctly
4. **Network issues**: Some CI jobs require internet access for downloading dependencies

### Running Tests Locally

Before pushing, run tests locally to avoid CI failures:

```bash
# Run all tests
make hack-test-unit

# Run all linters
make hack-lint

# Update generated code
make hack-codegen

# Build everything
make hack-build
```

### Getting Help

- 📖 Detailed guide: [docs/docs/60-contributor-guide/25-github-actions.md](docs/docs/60-contributor-guide/25-github-actions.md)
- 🐛 Report issues: [GitHub Issues](https://github.com/omerzifman/kargo/issues)
- 💬 Ask questions: [GitHub Discussions](https://github.com/omerzifman/kargo/discussions)
- 💭 Join community: [Discord](https://akuity.community)