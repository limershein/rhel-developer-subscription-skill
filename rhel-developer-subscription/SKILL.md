---
name: rhel-developer-subscription
description: >
  Guides users through obtaining Red Hat Developer for Individuals or RHEL for Business
  Developer subscriptions via a single prompt. Handles account creation, subscription
  activation, system registration, and verification. Supports both no-cost individual
  developer access and RHEL Developer Suite for business teams.
triggers:
  - developer subscription
  - rhel subscription
  - register rhel
  - activate rhel
  - red hat developer
  - developer for individuals
  - rhel for business
version: 1.0.0
---

# RHEL Developer Subscription Skill

## Purpose

Automate the end-to-end flow for obtaining and activating Red Hat Enterprise Linux developer subscriptions:
- **Red Hat Developer for Individuals** (no-cost, for personal development)
- **RHEL Developer Suite for Business** (team subscriptions with support)

From a single user prompt, this skill will:
1. Determine subscription type based on use case
2. Guide account creation or login
3. Activate the subscription
4. Register the RHEL system
5. Verify repository access

## Subscription Types

### Red Hat Developer for Individuals
- **Cost:** Free (no-cost subscription)
- **Use case:** Personal learning, development, demos
- **Entitlement:** 16 systems
- **Support:** Self-supported (community)
- **URL:** https://developers.redhat.com/register

### RHEL Developer Suite for Business
- **Cost:** Paid subscription
- **Use case:** Business development teams
- **Entitlement:** Team-based licensing
- **Support:** Full Red Hat support
- **URL:** https://www.redhat.com/en/store/red-hat-enterprise-linux-developer-suite

## Prerequisites

Before running this skill, verify:
- System is running RHEL (8.x, 9.x, or 10.x)
- Network connectivity to Red Hat services
- Root/sudo access for registration

## Usage

User invokes with natural language:
```
"I need a developer subscription for RHEL"
"Register this RHEL system with a developer account"
"Set up Red Hat Developer for Individuals"
"Get a business developer subscription for my team"
```

## Workflow

### Step 1: Determine Subscription Type

Ask clarifying question if not specified:

**Prompt:**
```
Which subscription do you need?

1. **Red Hat Developer for Individuals** (Free)
   - For personal development, learning, demos
   - 16 systems, self-supported
   
2. **RHEL Developer Suite for Business** (Paid)
   - For business development teams
   - Team licensing with full support

Enter 1 or 2, or describe your use case:
```

### Step 2: Verify System

```bash
# Check RHEL version
cat /etc/redhat-release

# Verify subscription-manager is available
which subscription-manager

# Check current registration status
sudo subscription-manager status
```

**Expected output:**
- RHEL version: 8.x, 9.x, or 10.x
- subscription-manager: installed
- Status: "Overall Status: Unknown" (if not registered)

### Step 3A: Red Hat Developer for Individuals Flow

#### 3A.1: Account Creation/Login

**Guide user:**
```
To activate your no-cost subscription:

1. Visit: https://developers.redhat.com/register
2. Fill out the registration form with:
   - Email address
   - Personal information
   - Password
   - Accept terms and conditions
3. **Important:** Check your email for a verification link
4. Click the verification link in the email to activate your account
5. After email verification, log in to https://developers.redhat.com
6. Your Developer for Individuals subscription activates automatically upon first login

After completing registration and email verification, you'll have:
- Red Hat account credentials (username/password)
- Automatic entitlement to Developer for Individuals (16 systems)

⚠️  **Email Verification Required:**
The subscription will NOT be active until you:
1. Verify your email address by clicking the link sent to you
2. Complete your first login to developers.redhat.com

This process typically takes 2-5 minutes.

Have you completed email verification and logged in? (y/n)
```

#### 3A.2: System Registration

```bash
# Register with Red Hat
sudo subscription-manager register --username <RED_HAT_USERNAME>

# System will prompt for password
# Auto-attach available subscriptions
sudo subscription-manager attach --auto

# Verify subscription
sudo subscription-manager status
```

**Expected output:**
```
Overall Status: Current
System Purpose Status: Current
```

#### 3A.3: Enable Repositories

```bash
# List available repositories
sudo subscription-manager repos --list | grep rhel-

# Enable base repositories (example for RHEL 9)
sudo subscription-manager repos \
  --enable rhel-9-for-x86_64-baseos-rpms \
  --enable rhel-9-for-x86_64-appstream-rpms

# For RHEL 8
sudo subscription-manager repos \
  --enable rhel-8-for-x86_64-baseos-rpms \
  --enable rhel-8-for-x86_64-appstream-rpms

# For RHEL 10 Beta
sudo subscription-manager repos \
  --enable rhel-10-for-x86_64-baseos-beta-rpms \
  --enable rhel-10-for-x86_64-appstream-beta-rpms
```

#### 3A.4: Verification

```bash
# Verify repository access
sudo dnf repolist

# Test package installation
sudo dnf check-update

# Show subscription details
sudo subscription-manager list --consumed
```

**Success criteria:**
- `dnf repolist` shows enabled RHEL repositories
- No subscription errors
- Can access RHEL packages

### Step 3B: RHEL Developer Suite for Business Flow

#### 3B.1: Purchase Guidance

**Guide user:**
```
To obtain RHEL Developer Suite for Business:

1. Visit: https://www.redhat.com/en/store/red-hat-enterprise-linux-developer-suite
2. Contact Red Hat Sales or purchase online
3. You'll receive:
   - Subscription credentials
   - Activation keys (optional)
   - Organization ID

Options for registration:
A. Username/password
B. Activation key + Organization ID (preferred for automation)

Which method do you have? (A/B)
```

#### 3B.2: Registration (Username/Password)

```bash
# Register with organization
sudo subscription-manager register \
  --username <RED_HAT_USERNAME> \
  --org <ORG_ID>

# Attach subscription by pool ID (if known)
sudo subscription-manager attach --pool=<POOL_ID>

# Or auto-attach
sudo subscription-manager attach --auto
```

#### 3B.3: Registration (Activation Key)

```bash
# Register with activation key
sudo subscription-manager register \
  --org <ORG_ID> \
  --activationkey <ACTIVATION_KEY>

# Subscription auto-attaches with activation key
# Verify status
sudo subscription-manager status
```

#### 3B.4: Enable Repositories & Verify

Same as Step 3A.3 and 3A.4 above.

### Step 4: Post-Registration Setup

```bash
# Update system with latest packages
sudo dnf update -y

# Install development tools (optional)
sudo dnf groupinstall "Development Tools" -y

# Install RHEL System Roles (optional, for automation)
sudo dnf install rhel-system-roles -y
```

### Step 5: Summary & Next Steps

**Report to user:**
```
✅ RHEL Developer Subscription Active

Subscription Type: [Red Hat Developer for Individuals | RHEL Developer Suite]
System Status: Registered and subscribed
Enabled Repositories: [list]

Next Steps:
- Run `sudo dnf update` regularly to get updates
- Access Red Hat documentation: https://access.redhat.com/documentation
- Join Red Hat Developer community: https://developers.redhat.com

To view subscription details anytime:
  sudo subscription-manager status
  sudo subscription-manager list --consumed

To unregister (if needed):
  sudo subscription-manager unregister
```

## Troubleshooting

### Common Issues

#### "Unable to register, already registered"
```bash
# Check current status
sudo subscription-manager status

# If needed, unregister first
sudo subscription-manager unregister

# Then re-register
sudo subscription-manager register --username <USERNAME>
```

#### "No subscriptions available"

**Most common cause:** Email address not verified yet.

```bash
# List available subscriptions
sudo subscription-manager list --available

# If empty, check:
# 1. Have you verified your email address?
# 2. Have you logged in to developers.redhat.com at least once?
# 3. Wait 5-10 minutes after email verification

# After email verification is complete:
# Manually attach by pool ID
sudo subscription-manager attach --pool=<POOL_ID>

# Or force auto-attach
sudo subscription-manager attach --auto
```

**If still no subscriptions after email verification:**
1. Log in to https://developers.redhat.com/login
2. Visit https://developers.redhat.com/products/rhel/download
3. This should trigger subscription activation
4. Wait 5 minutes, then retry registration

#### "Email not verified" or "Account not activated"
```bash
# This means you haven't clicked the email verification link yet

# Steps to resolve:
# 1. Check your email inbox (and spam folder)
# 2. Look for email from "Red Hat Developer" or "noreply@redhat.com"
# 3. Click the verification link
# 4. Log in to developers.redhat.com
# 5. Wait 5-10 minutes for subscription to activate
# 6. Retry registration

# If you can't find the email:
# - Visit https://developers.redhat.com/login
# - Look for "Resend verification email" option
# - Or create a support case at access.redhat.com
```

#### "Repository not found" errors
```bash
# Refresh subscription data
sudo subscription-manager refresh

# List all available repositories
sudo subscription-manager repos --list

# Enable correct repositories for your RHEL version
# (See Step 3A.3 above)
```

#### Network/Proxy Issues
```bash
# Configure proxy (if needed)
sudo subscription-manager config --server.proxy_hostname=<PROXY> \
  --server.proxy_port=<PORT>

# Test connectivity
curl -I https://subscription.rhsm.redhat.com/subscription/

# Check subscription-manager logs
sudo tail -f /var/log/rhsm/rhsm.log
```

## Security Considerations

- **Never store credentials in scripts or files**
- **Use activation keys for automation** (business subscriptions)
- **Rotate activation keys regularly** per Red Hat recommendations
- **Limit activation key scope** to specific repositories/organizations
- **Use RBAC** in Red Hat Customer Portal for team access control

## Advanced: Automation with Activation Keys

For business teams managing multiple systems:

### Create Activation Key (Red Hat Customer Portal)

1. Log in to https://access.redhat.com
2. Navigate to Subscriptions → Activation Keys
3. Create new key with:
   - Name/Description
   - Organization
   - Subscriptions attached
   - Repository overrides

### Register Multiple Systems

```bash
#!/bin/bash
# register-rhel.sh

ORG_ID="1234567"
ACTIVATION_KEY="rhel-dev-team-key"

sudo subscription-manager register \
  --org="${ORG_ID}" \
  --activationkey="${ACTIVATION_KEY}"

# Verify
sudo subscription-manager status

# Enable standard repos
RHEL_VERSION=$(grep -oP 'release \K[0-9]+' /etc/redhat-release)
sudo subscription-manager repos \
  --enable "rhel-${RHEL_VERSION}-for-x86_64-baseos-rpms" \
  --enable "rhel-${RHEL_VERSION}-for-x86_64-appstream-rpms"

sudo dnf update -y
```

## Integration with Image Mode / bootc

For RHEL image mode (bootc) deployments:

```dockerfile
# Example Containerfile for bootc image
FROM registry.redhat.io/rhel10/rhel-bootc:latest

# Embed activation key (use secrets management in production)
ARG ORG_ID
ARG ACTIVATION_KEY

RUN subscription-manager register \
      --org=${ORG_ID} \
      --activationkey=${ACTIVATION_KEY} && \
    subscription-manager repos \
      --enable rhel-10-for-x86_64-baseos-beta-rpms \
      --enable rhel-10-for-x86_64-appstream-beta-rpms && \
    dnf install -y \
      podman \
      buildah \
      ansible-core && \
    dnf clean all && \
    subscription-manager unregister
```

**Note:** For bootc images, consider embedding repository configurations instead of registration credentials.

## Resources

- **Developer Portal:** https://developers.redhat.com
- **Subscription Management Guide:** https://access.redhat.com/documentation/en-us/red_hat_subscription_management
- **RHEL Documentation:** https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux
- **Customer Portal:** https://access.redhat.com
- **Support:** https://access.redhat.com/support

## Agent Implementation Notes

When implementing this skill:

1. **Detect context automatically:**
   - Check RHEL version (`/etc/redhat-release`)
   - Check registration status (`subscription-manager status`)
   - Determine if business or individual use case from prompt

2. **Interactive prompts:**
   - Ask for subscription type if ambiguous
   - Confirm before running sudo commands
   - Provide context for each step

3. **Error handling:**
   - Catch subscription-manager errors
   - Guide through proxy configuration if network fails
   - Suggest manual steps if automation blocked

4. **Security:**
   - Never log credentials
   - Warn about activation key security
   - Recommend secrets management for automation

5. **Verification:**
   - Always verify registration status
   - Check repository access
   - Test package installation

6. **Platform-specific:**
   - Adjust repository names by RHEL version (8/9/10)
   - Handle UBI vs RHEL base image scenarios
   - Account for bootc/image mode environments

## Modern Alternative: Using rhc (Red Hat Connector)

### What is rhc?

`rhc` (Red Hat Connector) is the **modern, recommended tool** for RHEL systems (8.4+, 9+, 10+). It provides:
- Simplified registration workflow
- Automatic Insights client connection
- Better user experience
- Combined functionality of multiple tools

**Recommendation:** Use `rhc` on RHEL 8.4+, RHEL 9+, and RHEL 10+. Fall back to `subscription-manager` for older RHEL 8 versions.

### Installing rhc

```bash
# On RHEL 8.4+
sudo dnf install rhc

# On RHEL 9+ (may be pre-installed)
sudo dnf install rhc -y
```

### Registration with rhc (Individual Developer)

#### Option 1: Interactive (Recommended)

```bash
# Single command registration
sudo rhc connect

# This will:
# 1. Prompt for Red Hat account username/password
# 2. Register the system
# 3. Attach subscription automatically
# 4. Enable Insights client
# 5. Configure system purpose
```

**Prompts you'll see:**
```
Red Hat username: your-email@example.com
Password: [enter password]

System registered successfully.
Connected to Red Hat Insights.
```

#### Option 2: Non-interactive

```bash
# With credentials
sudo rhc connect \
  --username your-email@example.com \
  --password 'your-password'

# Better: use environment variable
export RHC_PASSWORD='your-password'
sudo rhc connect --username your-email@example.com
```

### Registration with rhc (Business with Activation Key)

```bash
# Using activation key
sudo rhc connect \
  --organization YOUR_ORG_ID \
  --activation-key YOUR_ACTIVATION_KEY
```

### Checking Status with rhc

```bash
# View connection status
sudo rhc status

# Expected output:
# System registration: Registered
# Insights client:     Connected
# System purpose:      Set
```

### Disconnecting (Unregistering) with rhc

```bash
# Disconnect and unregister
sudo rhc disconnect
```

### Comparison: rhc vs subscription-manager

| Feature | rhc | subscription-manager |
|---------|-----|----------------------|
| **Registration** | `rhc connect` | `subscription-manager register` + `attach` |
| **Insights** | Automatic | Manual setup |
| **User Experience** | Simplified, interactive | More verbose |
| **RHEL Support** | 8.4+, 9+, 10+ | All RHEL versions |
| **Recommendation** | ✅ Preferred for modern RHEL | Use for older RHEL 8.x |

### Updated Workflow: rhc-first with subscription-manager fallback

#### Step 1: Check if rhc is available

```bash
# Check RHEL version
RHEL_VERSION=$(grep -oP 'release \K[0-9]+' /etc/redhat-release)

# Check if rhc is installed
if command -v rhc &>/dev/null; then
    echo "Using rhc (recommended)"
    USE_RHC=true
elif [[ "${RHEL_VERSION}" -ge 9 ]] || [[ "${RHEL_VERSION}" -eq 8 ]]; then
    echo "Installing rhc..."
    # Note: requires repository access, which we don't have yet
    # Fall back to subscription-manager
    USE_RHC=false
else
    echo "Using subscription-manager"
    USE_RHC=false
fi
```

#### Step 2: Register with rhc (if available)

**Individual Developer:**
```bash
if [[ "${USE_RHC}" == "true" ]]; then
    sudo rhc connect --username your-email@example.com
else
    sudo subscription-manager register --username your-email@example.com
    sudo subscription-manager attach --auto
fi
```

**Business with Activation Key:**
```bash
if [[ "${USE_RHC}" == "true" ]]; then
    sudo rhc connect \
        --organization YOUR_ORG_ID \
        --activation-key YOUR_KEY
else
    sudo subscription-manager register \
        --org YOUR_ORG_ID \
        --activationkey YOUR_KEY
fi
```

#### Step 3: Verify

```bash
if [[ "${USE_RHC}" == "true" ]]; then
    sudo rhc status
else
    sudo subscription-manager status
fi
```

### rhc Additional Features

#### System Purpose with rhc

```bash
# Set system purpose during registration
sudo rhc connect \
    --username your-email@example.com \
    --role "Red Hat Enterprise Linux Server" \
    --usage "Development/Test"
```

#### Enable Insights Automatically

`rhc` automatically enables and connects Red Hat Insights for:
- Proactive issue detection
- Security advisories
- Performance recommendations
- Automated remediation suggestions

View Insights: https://console.redhat.com/insights

#### rhc Configuration

```bash
# View current configuration
rhc config

# Set proxy
sudo rhc config set proxy.server proxy.example.com
sudo rhc config set proxy.port 3128
```

### Example: Updated Registration Script with rhc

```bash
#!/bin/bash
# register-with-rhc.sh
# Modern registration using rhc

set -euo pipefail

USERNAME="${1:-}"

if [[ -z "${USERNAME}" ]]; then
    echo "Usage: sudo $0 <RED_HAT_USERNAME>"
    exit 1
fi

# Check RHEL version
RHEL_VERSION=$(grep -oP 'release \K[0-9]+' /etc/redhat-release)

echo "RHEL ${RHEL_VERSION} detected"

# Use rhc if available or installable
if command -v rhc &>/dev/null; then
    echo "Using rhc (Red Hat Connector)"
    sudo rhc connect --username "${USERNAME}"
elif [[ "${RHEL_VERSION}" -ge 9 ]]; then
    echo "rhc not installed but recommended for RHEL ${RHEL_VERSION}"
    echo "Would you like to install rhc first? (y/n)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        # This will fail on unregistered system
        echo "Note: Cannot install rhc before registration"
        echo "Falling back to subscription-manager"
    fi
    echo "Using subscription-manager"
    sudo subscription-manager register --username "${USERNAME}"
    sudo subscription-manager attach --auto
else
    echo "Using subscription-manager"
    sudo subscription-manager register --username "${USERNAME}"
    sudo subscription-manager attach --auto
fi

# Enable repositories (same for both methods)
sudo subscription-manager repos \
    --enable "rhel-${RHEL_VERSION}-for-x86_64-baseos-rpms" \
    --enable "rhel-${RHEL_VERSION}-for-x86_64-appstream-rpms"

echo "Registration complete!"
```

### Troubleshooting rhc

#### "rhc: command not found"

```bash
# Install rhc
sudo dnf install rhc -y

# If system not registered yet:
# Use subscription-manager first, then install rhc
```

#### rhc connection fails

```bash
# Check logs
sudo journalctl -u rhcd -n 50

# Verify network connectivity
curl -I https://console.redhat.com

# Fall back to subscription-manager
sudo subscription-manager register --username your-email@example.com
```

#### Insights not connecting

```bash
# Check Insights status
sudo insights-client --status

# Re-register Insights
sudo insights-client --register
```

### When to Use rhc vs subscription-manager

**Use rhc when:**
- ✅ Running RHEL 9+ or RHEL 10+
- ✅ Running RHEL 8.4 or later
- ✅ Want simplified registration
- ✅ Want automatic Insights connection
- ✅ Prefer interactive workflow

**Use subscription-manager when:**
- ✅ Running RHEL 8.0 - 8.3
- ✅ rhc not available
- ✅ Need fine-grained control
- ✅ Scripting non-interactive workflows
- ✅ Existing automation uses subscription-manager

### Best Practice: Hybrid Approach

For maximum compatibility:

```bash
# Try rhc first, fall back to subscription-manager
if command -v rhc &>/dev/null && [[ "${RHEL_VERSION}" -ge 9 ]]; then
    sudo rhc connect --username "${USERNAME}"
else
    sudo subscription-manager register --username "${USERNAME}"
    sudo subscription-manager attach --auto
    
    # Optionally install rhc after registration
    if [[ "${RHEL_VERSION}" -ge 9 ]]; then
        sudo dnf install -y rhc
    fi
fi
```

## Summary: Tool Selection Matrix

| RHEL Version | Recommended Tool | Alternative | Notes |
|--------------|------------------|-------------|-------|
| **RHEL 10.x** | `rhc` | `subscription-manager` | rhc provides best experience |
| **RHEL 9.x** | `rhc` | `subscription-manager` | rhc often pre-installed |
| **RHEL 8.4+** | `rhc` | `subscription-manager` | Install rhc after registration |
| **RHEL 8.0-8.3** | `subscription-manager` | - | rhc not fully supported |

