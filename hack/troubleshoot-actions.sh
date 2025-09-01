#!/bin/bash

# GitHub Actions Troubleshooting Script for Kargo
# This script helps diagnose common issues with GitHub Actions

set -e

echo "🔍 GitHub Actions Troubleshooting Script for Kargo"
echo "=================================================="

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Error: Not in a git repository"
    exit 1
fi

# Check if we're in the Kargo repository
if ! git remote get-url origin | grep -q "kargo"; then
    echo "⚠️  Warning: This doesn't appear to be the Kargo repository"
fi

echo ""
echo "📋 Basic Information"
echo "==================="

# Current branch
current_branch=$(git branch --show-current)
echo "Current branch: $current_branch"

# Remote origin
remote_origin=$(git remote get-url origin)
echo "Remote origin: $remote_origin"

# Check if workflows directory exists
if [ -d ".github/workflows" ]; then
    echo "✅ Workflows directory exists"
    workflow_count=$(find .github/workflows -name "*.yaml" -o -name "*.yml" | wc -l)
    echo "   Found $workflow_count workflow files"
else
    echo "❌ No .github/workflows directory found"
fi

echo ""
echo "🏗️  Build Environment Check"
echo "=========================="

# Check for required tools
tools=("make" "docker" "git")
for tool in "${tools[@]}"; do
    if command -v "$tool" &> /dev/null; then
        echo "✅ $tool is installed"
    else
        echo "❌ $tool is not installed"
    fi
done

# Check Docker daemon
if command -v docker &> /dev/null; then
    if docker info &> /dev/null; then
        echo "✅ Docker daemon is running"
    else
        echo "❌ Docker daemon is not running"
    fi
fi

echo ""
echo "🧪 Local Testing"
echo "==============="

# Check if we can run basic make commands
if [ -f "Makefile" ]; then
    echo "✅ Makefile exists"
    
    # Try to run a simple lint check
    echo "🔄 Testing local linting capability..."
    if timeout 30 make hack-lint-go 2>/dev/null; then
        echo "✅ Local Go linting works"
    else
        echo "⚠️  Local Go linting failed or timed out"
        echo "   This might be due to missing tools or network issues"
    fi
else
    echo "❌ No Makefile found"
fi

echo ""
echo "🌐 Network Connectivity"
echo "======================="

# Check connectivity to common external services
urls=("https://github.com" "https://get.helm.sh" "https://golang.org")
for url in "${urls[@]}"; do
    if curl -s --head "$url" | head -n 1 | grep -q "200 OK"; then
        echo "✅ Can reach $url"
    else
        echo "❌ Cannot reach $url"
    fi
done

echo ""
echo "📊 GitHub Actions Status"
echo "========================"

if command -v gh &> /dev/null; then
    echo "✅ GitHub CLI is installed"
    
    # Check if authenticated
    if gh auth status &> /dev/null; then
        echo "✅ GitHub CLI is authenticated"
        
        # Get recent workflow runs
        echo "🔄 Checking recent workflow runs..."
        if gh run list --limit 5 2>/dev/null; then
            echo ""
        else
            echo "⚠️  Could not fetch workflow runs (may not have access)"
        fi
    else
        echo "❌ GitHub CLI is not authenticated"
        echo "   Run 'gh auth login' to authenticate"
    fi
else
    echo "❌ GitHub CLI is not installed"
    echo "   Install from: https://cli.github.com/"
fi

echo ""
echo "🚀 Recommendations"
echo "=================="

echo "To make GitHub Actions run:"
echo ""
echo "1. 📝 Create a Pull Request:"
echo "   git checkout -b my-feature"
echo "   git commit -m 'My changes'"
echo "   git push origin my-feature"
echo "   gh pr create"
echo ""
echo "2. 🔄 Run checks locally first:"
echo "   make hack-test-unit    # Run tests"
echo "   make hack-lint         # Run linters"
echo "   make hack-codegen      # Update generated code"
echo ""
echo "3. 🌐 Manual trigger (if you have write access):"
echo "   gh workflow run ci.yaml"
echo ""
echo "4. 📋 Check workflow status:"
echo "   gh run list"
echo "   gh run view <run-id> --log"

echo ""
echo "✨ For more help, see: docs/docs/60-contributor-guide/25-github-actions.md"