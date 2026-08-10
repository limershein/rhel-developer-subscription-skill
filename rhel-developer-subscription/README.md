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
- 🏢 **Company/work** (team dev, CI/CD, business projects) → **Business (PAID)**

### Detailed Comparison

| Feature | Individual | Business |
|---------|-----------|----------|
| **Cost** | ✅ FREE | 💰 Paid (contact sales) |
| **Who For** | Individual developers | Companies, teams |
| **Systems** | Up to 16 | Unlimited |
| **Support** | Community (self-help) | Commercial with SLA |
| **Use Case** | Personal dev, learning | Team dev, CI/CD |
| **Automation** | Manual (email verification required) | Activation keys (fully automated) |
| **Production Use** | ❌ No | ❌ No (dev/test only) |
| **Commercial Projects** | Personal only | ✅ Business use allowed |

### Red Hat Developer for Individuals (FREE)

Perfect for:
- ✅ Personal learning and skill development
- ✅ Home lab environments
- ✅ Individual developer workstations
- ✅ Testing and demos
- ✅ Open source contributions
- ✅ Student/academic use

**Sign up:** https://developers.redhat.com/register

### RHEL Developer Suite for Business (PAID)

Perfect for:
- ✅ Company development teams
- ✅ CI/CD pipelines
- ✅ Automated deployments
- ✅ Fleet management (10+ systems)
- ✅ Environments requiring commercial support
- ✅ Development for commercial products

**Purchase:** https://www.redhat.com/en/store/red-hat-enterprise-linux-developer-suite

**Note:** Both subscriptions are for development/testing only, NOT for production workloads. Production requires separate RHEL subscriptions.

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
