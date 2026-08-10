# RHEL Developer Subscription Skill

Get your RHEL system registered and ready to code. Fast.

## Quick Start

Just ask:
```
"I need a developer subscription for RHEL"
"Register this system with Red Hat Developer"
"Set up RHEL for business development"
```

What happens next:
1. Figures out which subscription you need (Individual or Business)
2. Walks you through account setup
3. Handles email verification (it's required, takes ~10 minutes)
4. Registers your system
5. Enables the repos you need
6. Confirms everything works

### ⚠️ Heads up: Email verification required

For Individual Developer subscriptions:
1. Sign up at https://developers.redhat.com/register
2. Check your email for the verification link
3. Click it
4. Log in to https://developers.redhat.com
5. Wait 5-10 minutes for your subscription to activate
6. Then come back and register your system

Your subscription won't work until you verify your email. It's quick, but you can't skip it.

## Which subscription do you need?

**Simple question:** Personal or work?

- 👤 **Personal** (learning, home lab, side projects) → Individual (free)
- 🏢 **Work** (company dev, testing) → Business Developers (free)

Both are free. Choose based on who you're working for, not features.

### Detailed Comparison

| Feature | Individual | Business Developers |
|---------|-----------|---------------------|
| **Cost** | ✅ FREE | ✅ FREE |
| **Launch** | Long-standing | July 2025 |
| **Who For** | Individual developers | Corporate developers |
| **Systems** | Up to 16 | Up to 25 per user |
| **Email** | Any email (personal OK) | Business email required |
| **Self-Support** | Knowledge base, forums, Ask Red Hat AI | Knowledge base, forums, Ask Red Hat AI |
| **Paid Support** | Not available | Red Hat Developer for Teams (optional) |
| **Production** | ✅ Allowed (personal/small-scale) | ❌ Dev/test ONLY |
| **What's Included** | RHEL + Red Hat portfolio | RHEL only (no Satellite) |
| **Architectures** | x86_64 and ARM focused | All RHEL architectures |
| **Use Case** | Personal dev, learning, small prod | Business dev/testing |

### Red Hat Developer for Individuals (free)

Choose this if you're:
- Learning RHEL
- Running a home lab
- Working on personal projects
- Contributing to open source
- A student or freelancer
- Deploying small personal workloads (production's OK for personal use)

**Sign up:** https://developers.redhat.com/register  
**Email:** Use any email (Gmail, whatever)

### RHEL for Business Developers (free - launched July 2025)

Choose this if you're:
- Developing for your company
- Part of a dev team at work
- Testing apps before production
- Need more than 16 systems
- Working across different RHEL architectures

**Sign up:** https://developers.redhat.com/products/rhel/business  
**Email:** Must use your work email  
**Note:** Dev and test only - use full RHEL subscriptions for production

**The catch:** Business Developers is dev/test only. Individual allows production, but only for personal projects. Choose based on who's paying you.

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
