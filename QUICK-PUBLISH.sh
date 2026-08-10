#!/bin/bash
#
# Quick publish script - creates GitHub repo and pushes
#

set -e

echo "=== RHEL Developer Subscription Skill - GitHub Publish ==="
echo ""

# Check if gh CLI is installed
if ! command -v gh &>/dev/null; then
    echo "❌ GitHub CLI (gh) not found"
    echo ""
    echo "Install with:"
    echo "  sudo dnf install gh"
    echo "  or visit: https://cli.github.com/"
    echo ""
    exit 1
fi

# Check if authenticated
if ! gh auth status &>/dev/null; then
    echo "⚠️  Not authenticated with GitHub"
    echo ""
    echo "Run: gh auth login"
    exit 1
fi

# Confirm
echo "This will:"
echo "  1. Create a PUBLIC GitHub repository"
echo "  2. Push all code to GitHub"
echo "  3. Set up topics/tags"
echo ""
read -p "Continue? (y/N): " -r
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 0
fi

REPO_NAME="rhel-developer-subscription-skill"

echo ""
echo "Creating GitHub repository: ${REPO_NAME}"

# Create repository
gh repo create "${REPO_NAME}" \
    --public \
    --description "Agent Skills-compliant skill for automating RHEL Developer subscription registration on RHEL systems" \
    --source=. \
    --remote=origin \
    --push

echo ""
echo "✅ Repository created and code pushed!"
echo ""

# Get repository URL
REPO_URL=$(gh repo view --json url -q .url)

echo "📋 Repository URL:"
echo "   ${REPO_URL}"
echo ""

# Add topics (best effort)
echo "Adding topics..."
gh repo edit --add-topic rhel,red-hat,subscription-management,agent-skills,developer-subscription,rhc,subscription-manager,ansible,bootc,ai-agents,claude-code || true

echo ""
echo "=== Publishing Complete ==="
echo ""
echo "Next steps:"
echo "  1. Visit: ${REPO_URL}"
echo "  2. Review repository settings"
echo "  3. Share link with colleagues"
echo "  4. See GITHUB-SETUP.md for more options"
echo ""
