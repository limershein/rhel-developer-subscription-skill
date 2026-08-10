# RHEL Developer Subscription Skill

Automates the process of obtaining and activating Red Hat Enterprise Linux developer subscriptions through AI assistants.

## Quick Start

**User prompts:**
```
"I need a developer subscription for RHEL"
"Register this system with Red Hat Developer"
"Set up RHEL for business development"
```

**Agent loads this skill and:**
1. Determines subscription type (Individual vs Business)
2. Guides through account creation or login
3. **Ensures email verification is complete** ⚠️
4. Registers the RHEL system
5. Enables repositories
6. Verifies access

### ⚠️ Important: Email Verification Required

For **Individual Developer** subscriptions, you MUST:
1. Sign up at https://developers.redhat.com/register
2. **Check your email** for a verification link
3. **Click the link** to verify your email address
4. **Log in** to https://developers.redhat.com
5. **Wait 5-10 minutes** for subscription to activate
6. Then proceed with system registration

The subscription will NOT work until email verification is complete!

## Subscription Types

### Which Subscription Do You Need?

**Quick Decision:**
- 👤 **Personal use** (learning, home lab, personal projects) → **Individual (FREE)**
- 🏢 **Company/work** (team dev, testing, business projects) → **Business Developers (FREE)**

**Both subscriptions are FREE** - the difference is personal vs business use!

### Detailed Comparison

| Feature | Individual | Business Developers |
|---------|-----------|---------------------|
| **Cost** | ✅ FREE | ✅ FREE |
| **Launch** | Long-standing | July 2025 |
| **Who For** | Individual developers | Corporate developers |
| **Systems** | Up to 16 | Up to 25 per user |
| **Email** | Any email (personal OK) | Business email required |
| **Support** | Self-service | Self-service (paid option available) |
| **Production** | ✅ Allowed (personal/small-scale) | ❌ Dev/test ONLY |
| **What's Included** | RHEL + Red Hat portfolio | RHEL only (no Satellite) |
| **Architectures** | x86_64 and ARM focused | All RHEL architectures |
| **Use Case** | Personal dev, learning, small prod | Business dev/testing |

### Red Hat Developer for Individuals (FREE)

Perfect for:
- ✅ Personal learning and skill development
- ✅ Home lab environments  
- ✅ Individual developer workstations
- ✅ Personal/small-scale production workloads
- ✅ Testing and demos
- ✅ Open source contributions
- ✅ Student/academic use
- ✅ Freelancer development work

**Sign up:** https://developers.redhat.com/register  
**Email:** Any email address (personal OK)

### RHEL for Business Developers (FREE - launched July 2025)

Perfect for:
- ✅ Company/corporate development work
- ✅ Business development teams
- ✅ Testing applications before production deployment
- ✅ Enterprise development environments
- ✅ Building apps for business purposes
- ✅ Need 17-25 systems (more than Individual's 16)
- ✅ All RHEL architectures required

**Sign up:** https://developers.redhat.com/products/rhel/business  
**Email:** Business/corporate email required  
**Note:** Dev/test ONLY - not for production workloads

**Important:** Individual allows production use for personal projects. Business Developers is dev/test only but gives you 25 systems and all RHEL architectures.

## Requirements

- RHEL 8.x, 9.x, or 10.x
- Root/sudo access
- Network access to Red Hat services
- `subscription-manager` installed (default on RHEL)

## What It Does

1. **Detects** current RHEL version and registration status
2. **Asks** for subscription type if not clear from context
3. **Guides** through Red Hat account creation or login
4. **Registers** system with `subscription-manager`
5. **Enables** appropriate repositories for your RHEL version
6. **Verifies** subscription is active and repos accessible
7. **Reports** summary and next steps

## Files

- `SKILL.md` — Full skill specification with workflows and troubleshooting
- `README.md` — This overview
- `examples/` — Example automation scripts

## Integration

### For Agent Developers

Load this skill when user prompt matches:
- "developer subscription"
- "register rhel"
- "red hat developer"
- "rhel for business"
- "activate rhel subscription"

### For TAILWIND Monorepo

Add to `skills/rhel-developer-subscription/SKILL.md` and register in index.

## Examples

### Basic Individual Subscription
```
User: "I need to register my RHEL system for development"

Agent: 
1. Detects RHEL 9.4 
2. Asks: Individual or Business subscription?
3. User: "Individual"
4. Guides to developers.redhat.com/register
5. Runs: sudo subscription-manager register
6. Enables rhel-9-for-x86_64-baseos-rpms & appstream
7. Verifies with: sudo dnf repolist
8. Reports success
```

### Business Subscription with Activation Key
```
User: "Register this server with our business developer subscription.
       Org ID: 1234567, Activation Key: dev-team-rhel9"

Agent:
1. Detects RHEL 9.5
2. Recognizes business subscription context
3. Runs: sudo subscription-manager register \
          --org 1234567 \
          --activationkey dev-team-rhel9
4. Enables repositories
5. Verifies subscription
6. Reports success
```

## Testing

```bash
# Check RHEL version
cat /etc/redhat-release

# Current subscription status
sudo subscription-manager status

# Available repositories
sudo subscription-manager repos --list

# Enabled repositories
sudo dnf repolist
```

## License

Per TAILWIND monorepo license.

## Maintainer

See MAINTAINERS.md in repository root.
