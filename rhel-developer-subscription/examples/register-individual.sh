#!/bin/bash
#
# register-individual.sh
# Register RHEL system with Red Hat Developer for Individuals subscription
#
# Usage:
#   sudo ./register-individual.sh <RED_HAT_USERNAME>
#

set -euo pipefail

RED_HAT_USERNAME="${1:-}"

if [[ -z "${RED_HAT_USERNAME}" ]]; then
    echo "Usage: sudo $0 <RED_HAT_USERNAME>"
    echo ""
    echo "Example: sudo $0 myuser@example.com"
    echo ""
    echo "Don't have a Red Hat Developer account yet?"
    echo "Register at: https://developers.redhat.com/register"
    echo ""
    echo "⚠️  IMPORTANT: Account Creation Steps:"
    echo "  1. Fill out registration form"
    echo "  2. Check your email for verification link"
    echo "  3. Click the link to verify your email"
    echo "  4. Log in to developers.redhat.com"
    echo "  5. Wait 5-10 minutes for subscription to activate"
    echo "  6. Then run this script"
    echo ""
    exit 1
fi

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root (use sudo)"
   exit 1
fi

echo "=== RHEL Developer for Individuals Registration ==="
echo ""

# Check RHEL version
if [[ ! -f /etc/redhat-release ]]; then
    echo "ERROR: This doesn't appear to be a RHEL system"
    exit 1
fi

RHEL_VERSION=$(grep -oP 'release \K[0-9]+' /etc/redhat-release || echo "unknown")
echo "Detected RHEL version: ${RHEL_VERSION}"
echo ""

# Check if already registered
if subscription-manager status &>/dev/null; then
    CURRENT_STATUS=$(subscription-manager status | grep "Overall Status:" | awk '{print $3}')
    if [[ "${CURRENT_STATUS}" == "Current" ]]; then
        echo "⚠️  System is already registered and subscribed."
        echo ""
        echo "Current subscription:"
        subscription-manager list --consumed
        echo ""
        read -p "Do you want to unregister and re-register? (y/N): " -r
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "Unregistering..."
            subscription-manager unregister
        else
            echo "Exiting. No changes made."
            exit 0
        fi
    fi
fi

# Register
echo "Registering with Red Hat..."
echo "Username: ${RED_HAT_USERNAME}"
echo "(You will be prompted for your password)"
echo ""

if ! subscription-manager register --username "${RED_HAT_USERNAME}"; then
    echo "ERROR: Registration failed"
    echo ""
    echo "Common issues:"
    echo "  - Incorrect username/password"
    echo "  - Network connectivity"
    echo "  - Account not activated at developers.redhat.com"
    echo ""
    echo "⚠️  Did you verify your email address?"
    echo "  Registration requires email verification!"
    echo ""
    echo "  Steps to verify:"
    echo "  1. Check your email inbox (and spam folder)"
    echo "  2. Look for email from 'Red Hat Developer'"
    echo "  3. Click the verification link"
    echo "  4. Log in to developers.redhat.com"
    echo "  5. Wait 5-10 minutes"
    echo "  6. Retry this script"
    echo ""
    exit 1
fi

echo ""
echo "✅ Registration successful"
echo ""

# Auto-attach subscription
echo "Attaching Developer for Individuals subscription..."
if ! subscription-manager attach --auto; then
    echo "⚠️  Auto-attach failed. Trying to find subscription manually..."

    # List available subscriptions
    POOL_ID=$(subscription-manager list --available --matches="*Developer*" | grep "Pool ID:" | head -1 | awk '{print $3}')

    if [[ -n "${POOL_ID}" ]]; then
        echo "Found Developer subscription pool: ${POOL_ID}"
        subscription-manager attach --pool="${POOL_ID}"
    else
        echo "ERROR: No Developer subscription found"
        echo ""
        echo "⚠️  This usually means your email is not verified yet!"
        echo ""
        echo "Required steps:"
        echo "  1. Check your email for verification link"
        echo "  2. Click the link to verify your email address"
        echo "  3. Log in to https://developers.redhat.com/login"
        echo "  4. Visit https://developers.redhat.com/products/rhel/download"
        echo "  5. Wait 5-10 minutes for subscription to activate"
        echo "  6. Retry: subscription-manager attach --auto"
        echo ""
        echo "If you already verified your email:"
        echo "  - Wait a few more minutes (subscription propagation)"
        echo "  - Check https://access.redhat.com/management for active subscriptions"
        echo "  - Contact Red Hat Support if problem persists"
        exit 1
    fi
fi

echo ""
echo "✅ Subscription attached"
echo ""

# Enable repositories based on RHEL version
echo "Enabling RHEL repositories..."

case "${RHEL_VERSION}" in
    8)
        subscription-manager repos \
            --enable rhel-8-for-x86_64-baseos-rpms \
            --enable rhel-8-for-x86_64-appstream-rpms
        ;;
    9)
        subscription-manager repos \
            --enable rhel-9-for-x86_64-baseos-rpms \
            --enable rhel-9-for-x86_64-appstream-rpms
        ;;
    10)
        subscription-manager repos \
            --enable rhel-10-for-x86_64-baseos-beta-rpms \
            --enable rhel-10-for-x86_64-appstream-beta-rpms
        ;;
    *)
        echo "⚠️  Unknown RHEL version: ${RHEL_VERSION}"
        echo "You may need to enable repositories manually."
        echo ""
        echo "List available repos with:"
        echo "  subscription-manager repos --list"
        ;;
esac

echo ""
echo "✅ Repositories enabled"
echo ""

# Verify
echo "Verifying subscription status..."
subscription-manager status
echo ""

echo "Enabled repositories:"
dnf repolist
echo ""

# Test repository access
echo "Testing repository access..."
if dnf check-update &>/dev/null || [[ $? -eq 100 ]]; then
    echo "✅ Repository access confirmed"
else
    echo "⚠️  Repository access test inconclusive (may require retry)"
fi

echo ""
echo "=== Registration Complete ==="
echo ""
echo "Next steps:"
echo "  1. Update your system:"
echo "     sudo dnf update -y"
echo ""
echo "  2. Install development tools:"
echo "     sudo dnf groupinstall 'Development Tools' -y"
echo ""
echo "  3. Access Red Hat documentation:"
echo "     https://access.redhat.com/documentation"
echo ""
echo "  4. Join the developer community:"
echo "     https://developers.redhat.com"
echo ""
echo "To view subscription details:"
echo "  subscription-manager list --consumed"
echo ""
