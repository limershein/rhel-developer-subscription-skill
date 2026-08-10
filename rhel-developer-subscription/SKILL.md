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

**Overview:** No-cost subscription for individual developers and personal use

| Feature | Details |
|---------|---------|
| **Cost** | ✅ FREE (no-cost subscription) |
| **Systems** | Up to 16 entitlements |
| **Support** | Self-support (knowledge base, community forums, Ask Red Hat AI) |
| **Paid Support** | Not available for Individual subscriptions |
| **SLA** | None |
| **Use Case** | Personal development, learning, testing, demos, small-scale production |
| **Intended For** | Individual developers, students, hobbyists, personal projects |
| **Production Use** | ✅ Allowed for personal/small-scale use |
| **Email Required** | Any email address (personal email OK) |
| **What's Included** | RHEL + access to other Red Hat portfolio products |
| **Architectures** | x86_64 and ARM focused |
| **Registration** | Red Hat Developer account with email verification |
| **Main Page** | https://developers.redhat.com/register |
| **Signup URL** | https://sso.redhat.com/auth/realms/redhat-external/protocol/openid-connect/registrations (scope: developers, ask_red_hat) |

**When to use:**
- ✅ Personal learning and skill development
- ✅ Individual developer workstation
- ✅ Home lab environments
- ✅ Testing and experimentation
- ✅ Demo systems for presentations
- ✅ Contributing to open source projects
- ✅ Student/academic use
- ✅ Individual freelancer development work
- ✅ Personal/small-scale production workloads
- ✅ Side projects and hobbies

**When NOT to use:**
- ❌ Company/business development work (use Business Developers instead)
- ❌ Corporate email required scenarios
- ❌ Need more than 16 systems

### RHEL for Business Developers

**Overview:** No-cost subscription for business/corporate developers (launched July 2025)

| Feature | Details |
|---------|---------|
| **Cost** | ✅ FREE (no-cost subscription) |
| **Systems** | Up to 25 entitlements per registered user |
| **Support** | Self-support (knowledge base, community forums, Ask Red Hat AI) |
| **Paid Support** | Red Hat Developer for Teams support available for purchase |
| **SLA** | None with free self-support; Yes with paid Developer for Teams support |
| **Use Case** | Business development and testing within enterprises |
| **Intended For** | Corporate developers, business unit developers, enterprise teams |
| **Production Use** | ❌ Development/testing ONLY (NOT for production) |
| **Email Required** | Business/corporate email address required |
| **What's Included** | RHEL software only (no Satellite, no other Red Hat products) |
| **Architectures** | All RHEL architectures (physical, virtual, cloud) |
| **Registration** | Red Hat Developer account with business email |
| **Main Page** | https://developers.redhat.com/products/rhel/business |
| **Signup URL** | https://sso.redhat.com/auth/realms/redhat-external/protocol/openid-connect/auth?client_id=rhd-web&redirect_uri=https%3A//developers.redhat.com/rhelbd-confirmation/... |

**When to use:**
- ✅ Company/business development work
- ✅ Corporate development teams
- ✅ Business unit developers within enterprises
- ✅ Testing applications on RHEL before production
- ✅ Need 17-25 systems (more than Individual's 16)
- ✅ Enterprise development environments
- ✅ Building applications for business purposes
- ✅ All RHEL architectures needed
- ✅ Corporate email address available

**When NOT to use:**
- ❌ Personal projects (use Individual instead - same cost, allows production)
- ❌ Production workloads (this is dev/test ONLY - use full RHEL subscriptions)
- ❌ Need fewer than 16 systems for personal use
- ❌ Want access to other Red Hat products beyond RHEL
- ❌ Don't have business email address

### Key Differences Summary

| Aspect | Individual | Business Developers |
|--------|-----------|---------------------|
| **Cost** | ✅ FREE | ✅ FREE |
| **Who** | Individual person | Corporate developers |
| **Systems** | 16 entitlements | 25 entitlements |
| **Email** | Any email (personal OK) | Business/corporate email required |
| **Self-Support** | Knowledge base, forums, Ask Red Hat AI | Knowledge base, forums, Ask Red Hat AI |
| **Paid Support** | Not available | Red Hat Developer for Teams (optional purchase) |
| **Production** | ✅ Allowed (personal/small-scale) | ❌ Dev/test ONLY |
| **What's Included** | RHEL + Red Hat portfolio | RHEL only (no Satellite) |
| **Architectures** | x86_64 and ARM focused | All RHEL architectures |
| **Use Case** | Personal dev/learning/small prod | Business dev/testing only |
| **Signup URL** | Different (personal registration) | Different (business registration) |

### Decision Flow

Ask the user these questions to determine the right subscription:

1. **Is this for personal use or work/company use?**
   - Personal projects/learning → **Individual**
   - Company/employer work → **Business Developers**

2. **What email will you use?**
   - Personal email (gmail, etc.) → **Individual**
   - Corporate/business email → **Business Developers**

3. **How many systems do you need?**
   - 1-16 systems → **Individual** (unless it's for work)
   - 17-25 systems → **Business Developers**
   - More than 25 → Contact Red Hat Sales

4. **Do you need production use?**
   - Yes, for personal/small production → **Individual** (allowed)
   - No, dev/test only for business → **Business Developers**
   - Yes, for business production → Neither (need full RHEL subscriptions)

5. **What do you need access to?**
   - RHEL + other Red Hat products → **Individual**
   - RHEL only (all architectures) → **Business Developers**

**Simple rule of thumb:**
- **Personal projects/learning** → Individual (16 systems, production OK, any email)
- **Company/employer work** → Business Developers (25 systems, dev/test only, business email required)

**Both are FREE** - the difference is personal vs business use, not cost!

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

If the user's prompt doesn't clearly indicate individual vs business use, ask clarifying questions:

**Prompt:**
```
To help you get the right RHEL Developer subscription, I need to ask:

❓ Is this for personal use or for your company/employer?

1. **Personal** - Individual learning, home lab, personal projects
   → Red Hat Developer for Individuals (FREE)
   
2. **Company/Work** - Business development, team projects, work systems
   → RHEL Developer Suite for Business (PAID)

Or tell me about your use case and I'll recommend the right one.
```

**Additional clarifying questions if needed:**

```
Let me help determine which subscription fits your needs:

• Are you setting this up for yourself or for a team?
• Will this be used for personal projects or company work?
• Do you need more than 16 systems?
• Do you need commercial support with SLA?
• Is this for CI/CD automation?

Based on your answers:
- Personal use, ≤16 systems, no support needed → Individual (FREE)
- Company use, team/automation, or need support → Business (PAID)
```

**Automated detection from user prompt:**

Look for these keywords in the user's request:

**Indicators for Individual:**
- "my personal", "learning", "studying", "home lab"
- "trying out", "experimenting", "testing"
- "for myself", "personal project"
- "hobby", "side project"

**Indicators for Business:**
- "our company", "our team", "work", "employer"
- "CI/CD", "pipeline", "automation", "fleet"
- "production", "commercial", "enterprise"
- "multiple developers", "team members"
- "need support", "SLA required"

**Example responses:**

User: "I'm learning RHEL for personal development"
→ Agent: "You need Red Hat Developer for Individuals (free)"

User: "Our dev team needs to set up RHEL for our CI/CD pipeline"
→ Agent: "You need RHEL Developer Suite for Business (paid, with activation keys)"

User: "I want to register this system"
→ Agent: "Is this for personal use or company/team use?" (ask clarifying question)

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


## Support Options

Both subscription types include comprehensive self-support resources at no additional cost. Business Developers can optionally purchase paid support.

### Self-Support (Included with Both Subscriptions)

**Available to:**
- ✅ Red Hat Developer for Individuals
- ✅ RHEL for Business Developers

**Included resources:**

1. **Red Hat Knowledge Base**
   - Access to Red Hat's comprehensive knowledge base
   - Technical articles, solutions, and best practices
   - Product documentation
   - https://access.redhat.com/documentation

2. **Red Hat Community Forums**
   - Community-driven support
   - Ask questions and get answers from Red Hat users
   - Share knowledge and best practices
   - https://community.redhat.com

3. **Ask Red Hat AI**
   - AI-powered support assistant
   - Instant answers to common questions
   - Searches knowledge base and documentation
   - Available through Red Hat Customer Portal

4. **Red Hat Developer Resources**
   - Developer guides and tutorials
   - Code samples and examples
   - Learning paths and certifications
   - https://developers.redhat.com

### Red Hat Developer for Teams Support (Paid - Business Developers Only)

**Available to:**
- ❌ NOT available for Red Hat Developer for Individuals
- ✅ Available for RHEL for Business Developers (optional purchase)

**What it includes:**
- **Professional technical support** from Red Hat engineers
- **SLA-backed response times** for support cases
- **Direct access** to Red Hat support engineers
- **Case management** through Red Hat Customer Portal
- **Knowledge base** access (also included in free self-support)
- **Bug fixes and patches** with priority handling

**How to purchase:**
- Contact Red Hat Sales
- Available as add-on to RHEL for Business Developers subscription
- Pricing varies by support level and team size

**When you need it:**
- Production-critical development environments
- Compliance requirements mandate vendor support
- Complex technical issues requiring expert assistance
- Need guaranteed response times (SLA)
- Large development teams requiring dedicated support

### Support Comparison

| Support Type | Individual | Business Developers | Business Developers + Teams Support |
|--------------|-----------|---------------------|-------------------------------------|
| **Cost** | FREE (included) | FREE (included) | Paid (optional add-on) |
| **Knowledge Base** | ✅ Yes | ✅ Yes | ✅ Yes |
| **Community Forums** | ✅ Yes | ✅ Yes | ✅ Yes |
| **Ask Red Hat AI** | ✅ Yes | ✅ Yes | ✅ Yes |
| **Developer Resources** | ✅ Yes | ✅ Yes | ✅ Yes |
| **Technical Support Cases** | ❌ No | ❌ No | ✅ Yes |
| **SLA Response Times** | ❌ No | ❌ No | ✅ Yes |
| **Red Hat Engineers** | ❌ No | ❌ No | ✅ Yes |
| **Priority Bug Fixes** | ❌ No | ❌ No | ✅ Yes |

### Accessing Self-Support Resources

**Knowledge Base:**
```bash
# Visit Red Hat Customer Portal
https://access.redhat.com

# Log in with your Red Hat Developer account
# Navigate to: Documentation → Product Documentation
```

**Ask Red Hat AI:**
```bash
# Available in Red Hat Customer Portal
https://access.redhat.com

# Look for "Ask Red Hat" in the support section
# Type your question in natural language
# Get AI-powered answers from knowledge base
```

**Community Forums:**
```bash
# Visit Red Hat Community
https://community.redhat.com

# Browse discussions or post questions
# No Red Hat account required to read
# Red Hat account required to post
```

**Developer Resources:**
```bash
# Visit Red Hat Developer
https://developers.redhat.com

# Access tutorials, guides, and learning paths
# Download software and tools
# Join developer programs
```

### Getting Help

**For both Individual and Business Developers (self-support):**

1. **Search the Knowledge Base first**
   - Most common issues already documented
   - Search at https://access.redhat.com

2. **Try Ask Red Hat AI**
   - Fast AI-powered answers
   - Searches knowledge base automatically

3. **Ask the Community**
   - Post on https://community.redhat.com
   - Other users and Red Hat engineers participate

4. **Check Developer Documentation**
   - Visit https://developers.redhat.com
   - Comprehensive guides and tutorials

**For Business Developers with Teams Support (paid):**

1. **Open a Support Case**
   - Log in to https://access.redhat.com
   - Click "Open a Support Case"
   - Provide details about your issue
   - Red Hat engineer will respond per SLA

2. **Track Case Progress**
   - View case status in Customer Portal
   - Receive email notifications
   - Add attachments and updates

3. **Escalate if Needed**
   - Request escalation through case management
   - Contact account team if urgent

### Support Limitations

**What self-support does NOT include:**
- ❌ Guaranteed response times
- ❌ Direct access to Red Hat engineers
- ❌ Ability to open support cases
- ❌ Priority bug fixes
- ❌ Custom patches or workarounds
- ❌ Architecture or design consultation
- ❌ Production environment support

**What Developer for Teams support does NOT include:**
- ❌ Support for production workloads (dev/test subscriptions only)
- ❌ 24x7 support (unless purchased at higher tier)
- ❌ On-site support
- ❌ Custom development work

**For production support:**
- Purchase full RHEL subscriptions
- Includes Red Hat Production Support
- Multiple support tiers available (Standard, Premium, etc.)

### Best Practices

**Maximize self-support effectiveness:**

1. **Search before asking**
   - Check knowledge base first
   - Use Ask Red Hat AI
   - Search community forums

2. **Be specific**
   - Include error messages
   - Provide RHEL version and architecture
   - Describe what you've already tried

3. **Use community wisely**
   - Follow community guidelines
   - Search before posting
   - Accept helpful answers

4. **Stay updated**
   - Follow Red Hat blogs
   - Subscribe to security advisories
   - Join developer mailing lists

**When to consider paid support:**

- Development environment is business-critical
- Need guaranteed response times
- Complex issues beyond self-support scope
- Compliance requires vendor support
- Large team needs dedicated support channel

