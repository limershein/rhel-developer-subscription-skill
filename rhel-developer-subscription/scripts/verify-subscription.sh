#!/bin/bash
#
# verify-subscription.sh
# Verify RHEL subscription is active and repositories are accessible
#
# Usage:
#   sudo ./verify-subscription.sh
#

set -euo pipefail

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root (use sudo)"
   exit 1
fi

echo "=== RHEL Subscription Verification ==="
echo ""

# Check RHEL version
if [[ ! -f /etc/redhat-release ]]; then
    echo "❌ ERROR: This doesn't appear to be a RHEL system"
    exit 1
fi

RHEL_RELEASE=$(cat /etc/redhat-release)
echo "System: ${RHEL_RELEASE}"
echo ""

# Check registration status
echo "📋 Registration Status:"
echo "----------------------"

if ! subscription-manager identity &>/dev/null; then
    echo "❌ System is NOT registered with Red Hat"
    echo ""
    echo "To register:"
    echo "  - Individual Developer: Use register-individual.sh"
    echo "  - Business Developer: Use register-business.sh"
    exit 1
fi

subscription-manager identity
echo ""

# Check subscription status
echo "📋 Subscription Status:"
echo "----------------------"

OVERALL_STATUS=$(subscription-manager status 2>/dev/null | grep "Overall Status:" | awk '{print $3}')

subscription-manager status
echo ""

if [[ "${OVERALL_STATUS}" != "Current" ]]; then
    echo "❌ Subscription status is NOT current"
    echo ""
    echo "Available subscriptions:"
    subscription-manager list --available
    echo ""
    echo "Try attaching a subscription:"
    echo "  subscription-manager attach --auto"
    exit 1
fi

echo "✅ Subscription is current"
echo ""

# Show consumed subscriptions
echo "📋 Consumed Subscriptions:"
echo "-------------------------"
subscription-manager list --consumed
echo ""

# Check enabled repositories
echo "📋 Enabled Repositories:"
echo "-----------------------"

REPO_COUNT=$(dnf repolist 2>/dev/null | grep -c "rhel-" || echo "0")

if [[ ${REPO_COUNT} -eq 0 ]]; then
    echo "⚠️  No RHEL repositories enabled"
    echo ""
    echo "Available RHEL repositories:"
    subscription-manager repos --list | grep -A 5 "Repo ID:.*rhel-" | head -30
    echo ""
    echo "To enable repositories, see examples in SKILL.md"
    exit 1
fi

dnf repolist
echo ""
echo "✅ ${REPO_COUNT} RHEL repositories enabled"
echo ""

# Test repository access
echo "📋 Repository Access Test:"
echo "-------------------------"

echo "Checking for available updates..."
if dnf check-update &>/dev/null; then
    echo "✅ System is fully updated"
elif [[ $? -eq 100 ]]; then
    UPDATE_COUNT=$(dnf check-update 2>/dev/null | grep -c "^[a-zA-Z]" || echo "unknown")
    echo "✅ Repository access confirmed (${UPDATE_COUNT} updates available)"
else
    echo "⚠️  Repository access test failed"
    echo ""
    echo "Try refreshing subscription data:"
    echo "  subscription-manager refresh"
    exit 1
fi

echo ""

# Test package installation (dry run)
echo "📋 Package Availability Test:"
echo "-----------------------------"

TEST_PACKAGES=("gcc" "make" "git" "python3")
AVAILABLE=0

for pkg in "${TEST_PACKAGES[@]}"; do
    if dnf info "${pkg}" &>/dev/null; then
        echo "✅ ${pkg} is available"
        ((AVAILABLE++))
    else
        echo "❌ ${pkg} is NOT available"
    fi
done

echo ""

if [[ ${AVAILABLE} -eq ${#TEST_PACKAGES[@]} ]]; then
    echo "✅ All test packages are available"
else
    echo "⚠️  ${AVAILABLE}/${#TEST_PACKAGES[@]} test packages available"
fi

echo ""

# Summary
echo "=== Verification Summary ==="
echo ""
echo "✅ System is registered"
echo "✅ Subscription is current"
echo "✅ Repositories are enabled"
echo "✅ Repository access confirmed"
echo ""

# Show system purpose
if subscription-manager status | grep -q "System Purpose Status:"; then
    echo "📋 System Purpose:"
    subscription-manager status | grep "System Purpose" -A 3
    echo ""
fi

# Subscription details
echo "📋 Quick Reference:"
echo "------------------"
echo "View status:           subscription-manager status"
echo "List subscriptions:    subscription-manager list --consumed"
echo "List repositories:     dnf repolist"
echo "Enable repository:     subscription-manager repos --enable <repo-id>"
echo "Update system:         dnf update"
echo "Unregister:            subscription-manager unregister"
echo ""

echo "=== Verification Complete ==="
