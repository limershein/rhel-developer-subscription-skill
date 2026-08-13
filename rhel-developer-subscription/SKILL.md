---
name: rhel-developer-subscription
description: Register RHEL systems with Red Hat Developer subscriptions (Individual or Business Developers). Handles account creation, email verification, system registration with subscription-manager or rhc, repository enablement, and troubleshooting. Use when setting up RHEL development environments.
license: MIT
compatibility: Requires RHEL 8.4+ system with subscription-manager or rhc installed
metadata:
  version: "2.0"
  author: Red Hat
---

# RHEL Developer Subscription Registration

Get developers from "I need RHEL" to "dnf install works."

## What this does

Walks users through registering RHEL systems with Red Hat Developer subscriptions:
- **Red Hat Developer for Individuals** (free, 16 systems, personal use)
- **RHEL for Business Developers** (free, 25 systems, work use)

Handles the complete flow: account setup → email verification → system registration → repo enablement → verification.

## Before you start: Do they have RHEL installed?

**Critical**: You need a Red Hat Developer account BEFORE you can download RHEL.

### If they don't have RHEL yet

**Complete workflow: Account → Download → Install → Register**

**Step 1: Create Red Hat Developer account** (required to download RHEL)
1. Visit https://developers.redhat.com/register
2. Fill out registration form
3. Check email for verification link
4. Click the verification link
5. Log in to https://developers.redhat.com
6. Wait 5-10 minutes for account activation

**Step 2: Download RHEL**
1. Visit https://developers.redhat.com/products/rhel/download
2. Log in with your Red Hat Developer account
3. Choose your RHEL version:
   - RHEL 10 (latest, GA release)
   - RHEL 9 (stable, widely deployed)
   - RHEL 8 (for compatibility with older systems)
4. Select download type:
   - **Boot ISO** (small, requires internet during install)
   - **Binary DVD** (full, ~10GB, no internet needed)
5. Download the ISO file

**Step 3: Install RHEL**
- For physical hardware: Burn ISO to USB drive (use Fedora Media Writer, Rufus, or dd)
- For virtual machines: Use ISO with VirtualBox, VMware, KVM/libvirt, or cloud provider
- Follow Red Hat installation guide: https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/performing_a_standard_rhel_9_installation

**Step 4: After RHEL is installed, return here to register it**

Use this skill to register your newly installed RHEL system (continue to "Registration workflow" below).

---

### If they already have RHEL installed

Proceed directly to the "Registration workflow" section below.

## Quick decision: Which subscription?

Ask: **"Is this for personal use or work?"**

- 👤 **Personal** (learning, home lab, side projects) → Individual
  - Any email address
  - 16 systems
  - Production allowed for personal projects
  
- 🏢 **Work** (company dev, testing) → Business Developers
  - Business email required
  - 25 systems
  - Dev/test ONLY (no production)

Both are free. Choose based on who's paying.

## Registration workflow

### Step 1: Check system and choose tool

```bash
# Check RHEL version
cat /etc/redhat-release

# Check which tool to use
if command -v rhc &>/dev/null && [[ $(grep -oP 'release \K[0-9]+' /etc/redhat-release) -ge 9 ]]; then
  echo "Use rhc (modern, recommended for RHEL 9+)"
else
  echo "Use subscription-manager (works on all RHEL versions)"
fi
```

**Modern approach (RHEL 8.4+, 9+, 10+):** Use `rhc` (Red Hat Connector)
**Traditional approach (all versions):** Use `subscription-manager`

### Step 2: Account setup (if needed)

**For Individual:**
1. Visit https://developers.redhat.com/register
2. Fill form, submit
3. **Check email for verification link** (required!)
4. Click link, log in
5. Wait 5-10 minutes for subscription to activate

**For Business Developers:**
1. Visit https://developers.redhat.com/products/rhel/business
2. Use work email
3. Same email verification process

**Can't skip email verification.** Grab coffee while you wait.

### Step 3: Register system

**Option A: Using rhc (RHEL 9+, recommended)**

```bash
# One command does it all
sudo rhc connect --username your-email@example.com
# Enter password when prompted
# Done - subscription attached, repos enabled, Insights connected
```

**Option B: Using subscription-manager (all RHEL)**

```bash
# Register
sudo subscription-manager register --username your-email@example.com
# Enter password when prompted

# Attach subscription
sudo subscription-manager attach --auto

# Enable repos (RHEL 9 example)
RHEL_VERSION=$(grep -oP 'release \K[0-9]+' /etc/redhat-release)
sudo subscription-manager repos \
  --enable "rhel-${RHEL_VERSION}-for-x86_64-baseos-rpms" \
  --enable "rhel-${RHEL_VERSION}-for-x86_64-appstream-rpms"
```

**For Business with activation key:**

```bash
# subscription-manager
sudo subscription-manager register --org ORG_ID --activationkey KEY_NAME

# Or with rhc
sudo rhc connect --organization ORG_ID --activation-key KEY_NAME
```

### Step 4: Verify

```bash
# Check status
sudo subscription-manager status
# Should show "Overall Status: Current"

# Confirm repos
dnf repolist
# Should show rhel-*-baseos-rpms and rhel-*-appstream-rpms

# Test package access
sudo dnf check-update
```

## Common issues

### "No subscriptions available"

**Most common cause:** Email not verified.

1. Check email inbox (and spam)
2. Click verification link
3. Log in to developers.redhat.com
4. Visit https://developers.redhat.com/products/rhel/download (triggers activation)
5. Wait 5-10 minutes
6. Retry: `sudo subscription-manager attach --auto`

### "Already registered"

```bash
sudo subscription-manager unregister
# Then re-register
```

### Terms & Conditions prompt

If users see unexpected T&C prompts on login:
- This can happen if Red Hat's Developer Terms were temporarily deactivated
- Users will be re-prompted on next login
- Subscription will renew automatically after accepting
- No action needed beyond accepting the terms

### RHEL 10 repositories

RHEL 10 is now GA (General Availability). Use standard repository names without `-beta` suffix:

```bash
# RHEL 10 GA repositories
sudo subscription-manager repos \
  --enable rhel-10-for-x86_64-baseos-rpms \
  --enable rhel-10-for-x86_64-appstream-rpms
```

For auto-detection across all RHEL versions (8, 9, 10):

```bash
RHEL_VERSION=$(grep -oP 'release \K[0-9]+' /etc/redhat-release)
sudo subscription-manager repos \
  --enable "rhel-${RHEL_VERSION}-for-x86_64-baseos-rpms" \
  --enable "rhel-${RHEL_VERSION}-for-x86_64-appstream-rpms"
```

## Automation scripts

Available in `scripts/`:
- `register-individual.sh` - Interactive Individual registration
- `register-business.sh` - Business registration with activation keys
- `register-with-rhc.sh` - Modern rhc-first approach
- `verify-subscription.sh` - Health check script
- `ansible-register.yml` - Ansible playbook (for managing your own systems)
- `bootc-developer.containerfile` - bootc image example

**For centralized team deployment:** Contact Red Hat Sales about Red Hat Developer for Teams (FREE, seller-assisted offering with optional Developer support add-on: https://access.redhat.com/support/offerings/developer).

## Support resources (free with both subscriptions)

- **Knowledge Base**: https://access.redhat.com/documentation
- **Ask Red Hat AI**: AI assistant in Customer Portal
- **Community Forums**: https://community.redhat.com
- **Developer Resources**: https://developers.redhat.com

**Optional Developer support add-on** (for dev/test environments):
- Available for RHEL for Business Developers
- Available for Red Hat Developer for Teams
- Details: https://access.redhat.com/support/offerings/developer
- Note: This is developer support, not production support

## More details

- [Quick Reference](references/QUICKREF.md) - Command cheat sheet
- [Testing Guide](references/TESTING.md) - Test scenarios and validation
- [README](README.md) - Overview and examples

## Key URLs

- Individual signup: https://developers.redhat.com/register
- Business signup: https://developers.redhat.com/products/rhel/business
- RHEL download: https://developers.redhat.com/products/rhel/download
- Customer Portal: https://access.redhat.com
