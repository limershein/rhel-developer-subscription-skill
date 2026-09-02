# Quick Reference - RHEL Developer Subscriptions

Two subscription types: **Red Hat Developer for Individuals** ("Individual") and **RHEL for Business Developers** ("Business Developers"). Both free.

## Subscription Types

### Quick Decision Guide

**Are you doing this for personal projects or for work/your company?**

- 👤 **Personal** → Individual (FREE) - https://developers.redhat.com/register
- 🏢 **Work/Company** → Business Developers (FREE) - https://developers.redhat.com/products/rhel/business

**Both are FREE!** The difference is personal vs business use.

### Detailed Comparison

| Feature | Individual | Business Developers |
|---------|-----------|---------------------|
| **Cost** | ✅ FREE | ✅ FREE |
| **Launch** | Long-standing | July 2025 |
| **Who** | You personally | Corporate developers |
| **Delivery** | Self-service | Self-service |
| **Systems** | Up to 16 | Up to 25 per user |
| **Email** | Any (personal OK) | Business email required |
| **Self-Support** | Knowledge base, forums, Ask Red Hat AI | Knowledge base, forums, Ask Red Hat AI |
| **Optional Support Add-on** | Not available | Developer support (dev/test only) |
| **Production** | ✅ Personal/small | ❌ Dev/test ONLY |
| **Included** | RHEL + portfolio | RHEL only |
| **Sign Up** | developers.redhat.com/register | developers.redhat.com/products/rhel/business |

**When in doubt:** Personal projects with any email → Individual. Company work with business email → Business Developers (sign up yourself, no seller needed).

**Note:** For centralized/managed team deployment instead of self-service, **Red Hat Developer for Teams** (FREE, delivered by Red Hat sellers) is a separate option — see below.

## One-Liners

### Check Status
```bash
# See if registered
sudo subscription-manager status

# Show subscriptions
sudo subscription-manager list --consumed

# List repos
dnf repolist
```

### Register (Individual)

⚠️ **Before registering:** Verify your email address!
1. Sign up at https://developers.redhat.com/register
2. Check email for verification link
3. Click link to verify
4. Log in to https://developers.redhat.com
5. Wait 5-10 minutes
6. Then register:

```bash
# Interactive
sudo subscription-manager register --username myuser@example.com
sudo subscription-manager attach --auto

# Scripted
sudo ./register-individual.sh myuser@example.com
```

### Register (Business)

**RHEL for Business Developers:** create your own key in console.redhat.com (self-service).
**Red Hat Developer for Teams:** get the key and org ID from your IT department (centrally managed).

```bash
# With activation key (best for automation)
sudo subscription-manager register --org 1234567 --activationkey my-key

# With username
sudo subscription-manager register --username user@example.com --org 1234567
sudo subscription-manager attach --auto

# Scripted
sudo ./register-business.sh --org 1234567 --key my-key
```

### Enable Repositories

```bash
# RHEL 8
sudo subscription-manager repos \
  --enable rhel-8-for-x86_64-baseos-rpms \
  --enable rhel-8-for-x86_64-appstream-rpms

# RHEL 9
sudo subscription-manager repos \
  --enable rhel-9-for-x86_64-baseos-rpms \
  --enable rhel-9-for-x86_64-appstream-rpms

# RHEL 10
sudo subscription-manager repos \
  --enable rhel-10-for-x86_64-baseos-rpms \
  --enable rhel-10-for-x86_64-appstream-rpms
```

### Unregister
```bash
sudo subscription-manager unregister
```

## Common Commands

```bash
# System identity
subscription-manager identity

# Available subscriptions
subscription-manager list --available

# Attach specific subscription
subscription-manager attach --pool=POOL_ID

# List all repos
subscription-manager repos --list

# Enabled repos
subscription-manager repos --list-enabled

# Refresh subscription data
subscription-manager refresh

# Update all packages
sudo dnf update -y

# Install dev tools
sudo dnf groupinstall "Development Tools" -y
```

## Troubleshooting

### "Already registered"
```bash
sudo subscription-manager unregister
# Then re-register
```

### "No subscriptions available"

⚠️ **Most common cause:** Email not verified

```bash
# First, verify you completed email verification:
# 1. Check your email for verification link
# 2. Click the link
# 3. Log in to developers.redhat.com
# 4. Visit https://developers.redhat.com/products/rhel/download
# 5. Wait 5-10 minutes

# Then check available subscriptions
subscription-manager list --available

# Manual attach
subscription-manager attach --pool=POOL_ID

# Or force auto
subscription-manager attach --auto
```

### Network/Proxy
```bash
# Configure proxy
sudo subscription-manager config \
  --server.proxy_hostname=proxy.example.com \
  --server.proxy_port=3128

# Test connectivity
curl -I https://subscription.rhsm.redhat.com/subscription/
```

### Repository errors
```bash
# Refresh
sudo subscription-manager refresh

# Clean DNF cache
sudo dnf clean all
sudo dnf makecache
```

### Check logs
```bash
sudo tail -f /var/log/rhsm/rhsm.log
```

## URLs

- **Sign Up (Individual, FREE):** https://developers.redhat.com/register
- **Sign Up (Business Developers, FREE):** https://developers.redhat.com/products/rhel/business
- **Customer Portal:** https://access.redhat.com
- **Documentation:** https://access.redhat.com/documentation/en-us/red_hat_subscription_management
- **RHEL Docs:** https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux

## AI Agent Triggers

Load this skill when user says:
- "developer subscription"
- "register rhel"
- "red hat developer"
- "rhel for business"
- "activate rhel"
- "subscription-manager"

## Script Usage

```bash
# Individual registration
sudo ./register-individual.sh myuser@example.com

# Business with activation key
sudo ./register-business.sh --org 1234567 --key my-activation-key

# Business with username
sudo ./register-business.sh --username user@example.com --org 1234567

# Verify subscription
sudo ./verify-subscription.sh

# Ansible (single host)
ansible-playbook ansible-register.yml \
  -i localhost, \
  -e rhsm_username=user@example.com \
  -e rhsm_password=pass

# Ansible (activation key)
ansible-playbook ansible-register.yml \
  -i inventory.ini \
  -e rhsm_org_id=1234567 \
  -e rhsm_activation_key=my-key
```

## bootc Integration

```bash
# Build image with dev tools
podman build -f bootc-developer.containerfile \
  --build-arg ORG_ID=1234567 \
  --build-arg ACTIVATION_KEY=my-key \
  -t rhel-developer-bootc:latest .

# Deploy to disk
sudo podman run --rm --privileged \
  -v /var/lib/containers:/var/lib/containers \
  rhel-developer-bootc:latest \
  bootc install to-disk /dev/vda
```

## Security Reminders

- ❌ **Never** commit credentials to git
- ✅ **Use** activation keys for automation
- ✅ **Rotate** activation keys regularly
- ✅ **Limit** activation key scope
- ❌ **Don't** log passwords
- ✅ **Use** secrets management in CI/CD

## Support Resources (Included FREE)

Both Individual (FREE) and Business Developers (FREE) include:

### Self-Support (No Cost)
```bash
# Knowledge Base
https://access.redhat.com/documentation

# Ask Red Hat AI
https://access.redhat.com
# (Look for "Ask Red Hat" in support section)

# Community Forums
https://community.redhat.com

# Developer Resources
https://developers.redhat.com
```

### Optional Developer Support Add-on (Dev/Test Only)

Both **RHEL for Business Developers (FREE, self-service)** and **Red Hat Developer for Teams (FREE, delivered by Red Hat sellers)** offer an optional **Developer support add-on** for dev/test environments:

**Includes:**
- Technical support from Red Hat engineers
- SLA-backed response times
- Direct support case management
- Priority bug fixes

**NOT available for:**
- ❌ Individual Developer subscriptions

**Details:** https://access.redhat.com/support/offerings/developer

**When you need it:**
- Business-critical dev/test environments
- Need guaranteed response times
- Complex issues requiring expert help
- Compliance requires vendor support

**Note:** This is developer support for dev/test — not production support.
