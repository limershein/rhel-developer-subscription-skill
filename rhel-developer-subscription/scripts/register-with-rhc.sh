#!/bin/bash
#
# register-with-rhc.sh
# Modern registration using rhc (Red Hat Connector) with subscription-manager fallback
#
# Usage:
#   sudo ./register-with-rhc.sh <RED_HAT_USERNAME>
#

set -euo pipefail

RED_HAT_USERNAME="${1:-}"

if [[ -z "${RED_HAT_USERNAME}" ]]; then
    echo "Usage: sudo $0 <RED_HAT_USERNAME>"
    echo ""
    echo "Example: sudo $0 myuser@example.com"
    echo ""
    echo "This script uses rhc (Red Hat Connector) if available,"
    echo "falling back to subscription-manager for older systems."
    echo ""
    echo "⚠️  IMPORTANT: Email must be verified first!"
    echo "See EMAIL-VERIFICATION.md for details."
    exit 1
fi

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root (use sudo)"
   exit 1
fi

echo "=== RHEL Developer Subscription Registration (rhc + fallback) ==="
echo ""

# Check RHEL version
if [[ ! -f /etc/redhat-release ]]; then
    echo "ERROR: This doesn't appear to be a RHEL system"
    exit 1
fi

RHEL_VERSION=$(grep -oP 'release \K[0-9]+' /etc/redhat-release || echo "unknown")
RHEL_MINOR=$(grep -oP 'release [0-9]+\.\K[0-9]+' /etc/redhat-release || echo "0")

echo "Detected: $(cat /etc/redhat-release)"
echo ""

# Determine which tool to use
USE_RHC=false

if command -v rhc &>/dev/null; then
    echo "✓ rhc (Red Hat Connector) is installed"
    USE_RHC=true
elif [[ "${RHEL_VERSION}" -eq 9 ]] || [[ "${RHEL_VERSION}" -eq 10 ]]; then
    echo "ℹ rhc is recommended for RHEL ${RHEL_VERSION} but not installed"
    echo "  Will use subscription-manager, then install rhc after registration"
elif [[ "${RHEL_VERSION}" -eq 8 ]] && [[ "${RHEL_MINOR}" -ge 4 ]]; then
    echo "ℹ rhc is available for RHEL ${RHEL_VERSION}.${RHEL_MINOR}"
    echo "  Will use subscription-manager, then install rhc after registration"
else
    echo "ℹ Using subscription-manager (rhc not supported on RHEL ${RHEL_VERSION}.${RHEL_MINOR})"
fi

echo ""

# Check if already registered
if subscription-manager status &>/dev/null 2>&1; then
    CURRENT_STATUS=$(subscription-manager status | grep "Overall Status:" | awk '{print $3}')
    if [[ "${CURRENT_STATUS}" == "Current" ]]; then
        echo "⚠️  System is already registered and subscribed."
        echo ""
        subscription-manager list --consumed
        echo ""
        read -p "Continue anyway to demonstrate rhc? (y/N): " -r
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Exiting. No changes made."
            exit 0
        fi
        # Don't unregister, just show rhc status if available
        if command -v rhc &>/dev/null; then
            echo ""
            echo "Current rhc status:"
            rhc status || true
        fi
        exit 0
    fi
fi

# Register using appropriate tool
if [[ "${USE_RHC}" == "true" ]]; then
    echo "Using rhc connect..."
    echo "Username: ${RED_HAT_USERNAME}"
    echo ""

    if ! rhc connect --username "${RED_HAT_USERNAME}"; then
        echo ""
        echo "ERROR: rhc connect failed"
        echo ""
        echo "Falling back to subscription-manager..."
        USE_RHC=false
    else
        echo ""
        echo "✅ Registration successful using rhc"
        echo ""

        # Show status
        echo "System status:"
        rhc status
        echo ""

        # Repositories are automatically enabled by rhc
        echo "✅ Repositories enabled automatically by rhc"
    fi
fi

if [[ "${USE_RHC}" == "false" ]]; then
    echo "Using subscription-manager..."
    echo "Username: ${RED_HAT_USERNAME}"
    echo "(You will be prompted for your password)"
    echo ""

    if ! subscription-manager register --username "${RED_HAT_USERNAME}"; then
        echo "ERROR: Registration failed"
        echo ""
        echo "⚠️  Did you verify your email address?"
        echo "See EMAIL-VERIFICATION.md for help"
        exit 1
    fi

    echo ""
    echo "✅ Registration successful"
    echo ""

    # Auto-attach subscription
    echo "Attaching subscription..."
    if ! subscription-manager attach --auto; then
        echo "⚠️  Auto-attach failed"
        echo ""
        echo "⚠️  This usually means email is not verified"
        echo "See EMAIL-VERIFICATION.md for help"
        exit 1
    fi

    echo ""
    echo "✅ Subscription attached"
    echo ""

    # Enable repositories
    echo "Enabling repositories..."
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
                --enable rhel-10-for-x86_64-baseos-rpms \
                --enable rhel-10-for-x86_64-appstream-rpms
            ;;
    esac

    echo "✅ Repositories enabled"
    echo ""

    # Try to install rhc now that we're registered
    if [[ "${RHEL_VERSION}" -ge 9 ]] || [[ "${RHEL_VERSION}" -eq 8 && "${RHEL_MINOR}" -ge 4 ]]; then
        echo "Installing rhc for future use..."
        if dnf install -y rhc &>/dev/null; then
            echo "✅ rhc installed successfully"
            echo ""
            echo "ℹ For future registrations, you can use:"
            echo "  sudo rhc connect --username ${RED_HAT_USERNAME}"
        else
            echo "⚠️  Could not install rhc (non-fatal)"
        fi
        echo ""
    fi
fi

# Verify
echo "Verifying registration..."
subscription-manager status
echo ""

echo "Enabled repositories:"
dnf repolist | grep -E "rhel-|repo id"
echo ""

# Test repository access
echo "Testing repository access..."
if dnf check-update &>/dev/null || [[ $? -eq 100 ]]; then
    echo "✅ Repository access confirmed"
else
    echo "⚠️  Repository access test inconclusive"
fi

echo ""
echo "=== Registration Complete ==="
echo ""

if [[ "${USE_RHC}" == "true" ]] || command -v rhc &>/dev/null; then
    echo "📋 Using rhc (Modern Tool):"
    echo "  Check status:     sudo rhc status"
    echo "  Disconnect:       sudo rhc disconnect"
    echo "  View insights:    https://console.redhat.com/insights"
    echo ""
fi

echo "📋 Using subscription-manager (Traditional Tool):"
echo "  Check status:     sudo subscription-manager status"
echo "  List subscriptions: sudo subscription-manager list --consumed"
echo "  Unregister:       sudo subscription-manager unregister"
echo ""

echo "Next steps:"
echo "  1. Update your system:"
echo "     sudo dnf update -y"
echo ""
echo "  2. Install development tools:"
echo "     sudo dnf groupinstall 'Development Tools' -y"
echo ""
echo "  3. Access Red Hat Insights (if using rhc):"
echo "     https://console.redhat.com/insights"
echo ""
