#!/bin/bash
#
# register-business.sh
# Register RHEL system with RHEL Developer Suite for Business subscription
# using activation key (preferred) or username/password
#
# Usage:
#   # With activation key (recommended)
#   sudo ./register-business.sh --org 1234567 --key rhel-dev-team
#
#   # With username/password
#   sudo ./register-business.sh --username myuser@example.com --org 1234567
#

set -euo pipefail

ORG_ID=""
ACTIVATION_KEY=""
USERNAME=""
POOL_ID=""

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --org)
            ORG_ID="$2"
            shift 2
            ;;
        --key|--activationkey)
            ACTIVATION_KEY="$2"
            shift 2
            ;;
        --username)
            USERNAME="$2"
            shift 2
            ;;
        --pool)
            POOL_ID="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage:"
            echo "  $0 --org ORG_ID --key ACTIVATION_KEY"
            echo "  $0 --username USERNAME --org ORG_ID [--pool POOL_ID]"
            echo ""
            echo "Options:"
            echo "  --org          Organization ID (required)"
            echo "  --key          Activation key name (recommended)"
            echo "  --username     Red Hat username (alternative to activation key)"
            echo "  --pool         Specific subscription pool ID (optional)"
            echo ""
            echo "Examples:"
            echo "  sudo $0 --org 1234567 --key rhel-dev-team"
            echo "  sudo $0 --username user@example.com --org 1234567"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root (use sudo)"
   exit 1
fi

if [[ -z "${ORG_ID}" ]]; then
    echo "ERROR: Organization ID is required (--org)"
    echo "Use --help for usage information"
    exit 1
fi

if [[ -z "${ACTIVATION_KEY}" && -z "${USERNAME}" ]]; then
    echo "ERROR: Either --key or --username is required"
    echo "Use --help for usage information"
    exit 1
fi

echo "=== RHEL Developer Suite for Business Registration ==="
echo ""

# Check RHEL version
if [[ ! -f /etc/redhat-release ]]; then
    echo "ERROR: This doesn't appear to be a RHEL system"
    exit 1
fi

RHEL_VERSION=$(grep -oP 'release \K[0-9]+' /etc/redhat-release || echo "unknown")
echo "Detected RHEL version: ${RHEL_VERSION}"
echo "Organization ID: ${ORG_ID}"
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

if [[ -n "${ACTIVATION_KEY}" ]]; then
    echo "Using activation key: ${ACTIVATION_KEY}"
    echo ""

    if ! subscription-manager register \
        --org="${ORG_ID}" \
        --activationkey="${ACTIVATION_KEY}"; then
        echo "ERROR: Registration with activation key failed"
        echo ""
        echo "Common issues:"
        echo "  - Incorrect organization ID"
        echo "  - Invalid or expired activation key"
        echo "  - Network connectivity"
        echo "  - Activation key usage limit reached"
        exit 1
    fi

    # Activation keys auto-attach subscriptions
    echo ""
    echo "✅ Registration successful (subscription auto-attached)"

elif [[ -n "${USERNAME}" ]]; then
    echo "Using username: ${USERNAME}"
    echo "(You will be prompted for your password)"
    echo ""

    if ! subscription-manager register \
        --username="${USERNAME}" \
        --org="${ORG_ID}"; then
        echo "ERROR: Registration failed"
        echo ""
        echo "Common issues:"
        echo "  - Incorrect username/password"
        echo "  - Incorrect organization ID"
        echo "  - Network connectivity"
        exit 1
    fi

    echo ""
    echo "✅ Registration successful"
    echo ""

    # Attach subscription
    echo "Attaching subscription..."

    if [[ -n "${POOL_ID}" ]]; then
        echo "Using specified pool ID: ${POOL_ID}"
        subscription-manager attach --pool="${POOL_ID}"
    else
        echo "Auto-attaching subscription..."
        if ! subscription-manager attach --auto; then
            echo "⚠️  Auto-attach failed. Listing available subscriptions..."
            echo ""
            subscription-manager list --available
            echo ""
            echo "Please manually attach a subscription using:"
            echo "  subscription-manager attach --pool=<POOL_ID>"
            exit 1
        fi
    fi

    echo ""
    echo "✅ Subscription attached"
fi

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

echo "Consumed subscription:"
subscription-manager list --consumed
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
echo "  3. Install RHEL System Roles (for automation):"
echo "     sudo dnf install rhel-system-roles -y"
echo ""
echo "  4. Access Red Hat Customer Portal:"
echo "     https://access.redhat.com"
echo ""
echo "  5. Access RHEL documentation:"
echo "     https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux"
echo ""
echo "To view subscription details:"
echo "  subscription-manager list --consumed"
echo ""
echo "To unregister (if needed):"
echo "  sudo subscription-manager unregister"
echo ""
