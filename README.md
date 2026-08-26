# RHEL Developer Subscription Skill

**Get your RHEL development environment set up without the subscription hassle.**

This skill teaches AI assistants how to walk you through Red Hat developer subscription registration - from account creation to `dnf install`. Works for individual developers, whether for personal projects or company work.

## What it does

Automates everything between "I need RHEL" and "dnf install works":

- **Red Hat Developer for Individuals** (free, 16 systems, for personal use)
- **RHEL for Business Developers** (free, 25 systems, for work)

One prompt. Five minutes. Your AI assistant handles:
1. Checking your RHEL version
2. Figuring out which subscription you need
3. Walking you through account setup
4. Running `subscription-manager register`
5. Enabling the right repos
6. Confirming everything works

## Quick start

### Talk to your AI assistant

```
"I need a developer subscription for RHEL"
"Register this system with Red Hat Developer"
"Set up RHEL for business development"
```

That's it. The AI loads this skill and walks you through the rest.

### Skip the AI, run the scripts

```bash
cd rhel-developer-subscription/examples

# Personal dev machine
sudo ./register-individual.sh user@example.com

# Work machine (with activation key)
sudo ./register-business.sh --org 1234567 --key my-activation-key

# Check it worked
sudo ./verify-subscription.sh
```

### Need team-wide deployment?

**RHEL for Business Developers is self-service** — sign up directly with a business email, no seller needed. You can self-register up to 16 (Individual) or 25 (Business Developers) systems, and create your own activation keys in console.redhat.com.

For centralized/managed team deployment instead, contact Red Hat Sales about:
- **Red Hat Developer for Teams** (FREE, delivered by Red Hat sellers)
- Centralized activation keys
- Organization-level controls
- Optional Developer support add-on: https://access.redhat.com/support/offerings/developer

## Features

✅ **Automated Registration** - Complete workflow from account to active subscription  
✅ **Dual Subscription Types** - Individual (free) and Business Developers (free)  
✅ **Version Detection** - Automatic RHEL 8/9/10 support with correct repositories  
✅ **Error Handling** - Graceful failures with actionable guidance  
✅ **Verification** - Built-in health checks for subscription status  
✅ **Modern Tools** - Supports both rhc and subscription-manager  
✅ **bootc Integration** - Example Containerfile for image mode RHEL  
✅ **Comprehensive Testing** - Full test suite with 10+ scenarios  
✅ **Security-First** - Best practices for credential handling  

## Repository Structure

```
rhel-developer-subscription/
├── SKILL.md              # Complete skill specification (AI agent)
├── README.md             # Overview and quick start
├── TESTING.md            # Comprehensive test guide
├── QUICKREF.md           # Command quick reference
├── VERSION               # Semantic version
└── examples/
    ├── register-individual.sh     # Individual subscription script
    ├── register-business.sh       # Business subscription script
    ├── verify-subscription.sh     # Verification script
    ├── ansible-register.yml       # Ansible playbook
    └── bootc-developer.containerfile  # bootc image example

INTEGRATION.md            # Guide for adding to TAILWIND monorepo
```

## Documentation

| Document | Purpose | Audience |
|----------|---------|----------|
| [SKILL.md](rhel-developer-subscription/SKILL.md) | Complete skill specification with workflows | AI agents, developers |
| [README.md](rhel-developer-subscription/README.md) | Quick start and overview | All users |
| [TESTING.md](rhel-developer-subscription/TESTING.md) | Test cases and procedures | Testers, QA |
| [QUICKREF.md](rhel-developer-subscription/QUICKREF.md) | Command reference card | System administrators |
| [INTEGRATION.md](INTEGRATION.md) | Integration with TAILWIND | Maintainers |

## Requirements

- RHEL 8.x, 9.x, or 10.x (VM, cloud, or bare metal)
- Root/sudo access
- Network connectivity to Red Hat services
- Red Hat account (free at https://developers.redhat.com/register)

Optional:
- Ansible 2.9+ (for automation)
- Podman 4.0+ (for bootc examples)

## Installation

### For TAILWIND Monorepo

See [INTEGRATION.md](INTEGRATION.md) for complete integration guide.

```bash
# Clone TAILWIND
git clone git@gitlab.com:tailwind/tailwind.git ~/Projects/tailwind

# Copy skill
cp -r rhel-developer-subscription ~/Projects/tailwind/skills/

# Commit
cd ~/Projects/tailwind
git checkout -b add-rhel-developer-subscription
git add skills/rhel-developer-subscription
git commit -m "Add RHEL developer subscription skill"
git push origin add-rhel-developer-subscription
```

### Standalone Usage

```bash
# Clone this repository
git clone <this-repo-url> rhel-developer-subscription
cd rhel-developer-subscription

# Make scripts executable
chmod +x rhel-developer-subscription/examples/*.sh

# Use scripts directly
cd rhel-developer-subscription/examples
sudo ./register-individual.sh user@example.com
```

## Usage Examples

### Example 1: AI Agent Workflow

**User:** "I need to set up RHEL developer subscription on this server"

**Agent:**
1. Loads `rhel-developer-subscription` skill
2. Runs: `cat /etc/redhat-release` → Detects RHEL 9.5
3. Runs: `subscription-manager status` → Not registered
4. Asks: "Individual (free) or Business subscription?"
5. User: "Individual"
6. Guides to https://developers.redhat.com/register
7. Waits for confirmation of account creation
8. Runs: `sudo subscription-manager register --username user@example.com`
9. Runs: `sudo subscription-manager attach --auto`
10. Enables: `rhel-9-for-x86_64-baseos-rpms` + `appstream-rpms`
11. Verifies: `dnf repolist` shows repositories
12. Reports: "✅ RHEL Developer subscription active. Next steps: ..."

### Example 2: Using rhc (Modern Approach)

**Scenario:** Register RHEL 9 system with rhc tool

```bash
# One command registration with rhc
sudo rhc connect --username developer@example.com

# rhc automatically:
# - Registers the system
# - Attaches subscription
# - Enables repositories
# - Connects to Insights

# Verify
sudo rhc status
```

**For team-wide deployment** instead of self-service Business Developers: Contact Red Hat Sales about Red Hat Developer for Teams (FREE, delivered by Red Hat sellers, with optional Developer support add-on).

### Example 3: bootc Developer Image

**Scenario:** Build custom RHEL 10 image with developer tools

```bash
cd rhel-developer-subscription/examples

# Build image
podman build -f bootc-developer.containerfile \
  --build-arg ORG_ID=1234567 \
  --build-arg ACTIVATION_KEY=rhel10-dev-key \
  -t rhel10-developer:latest .

# Deploy to VM disk
sudo podman run --rm --privileged \
  -v /var/lib/containers:/var/lib/containers \
  rhel10-developer:latest \
  bootc install to-disk /dev/vda

# Result: Bootable RHEL 10 system with gcc, git, podman, ansible pre-installed
```

## Testing

Comprehensive test suite covering 10 scenarios:

```bash
cd rhel-developer-subscription/examples

# Test 1: Individual registration
sudo ./register-individual.sh user@example.com

# Test 4: Verification
sudo ./verify-subscription.sh

# See TESTING.md for all 10 test cases
```

## Subscription Types Comparison

### Which Subscription Do You Need?

**Simple question:** Is this for **personal use** or for **your company/employer**?

- 👤 **Personal** (learning, home lab, side projects) → **Individual** (FREE)
- 🏢 **Work** (company dev, testing, business projects) → **Business Developers** (FREE)

**Both are FREE!** The difference is personal vs business use, not cost.

### Detailed Comparison

| Feature | Individual (FREE) | Business Developers (FREE) |
|---------|-------------------|----------------------------|
| **Cost** | ✅ FREE | ✅ FREE |
| **Launch** | Long-standing | July 2025 |
| **Best For** | Individual developers | Corporate developers |
| **Systems** | Up to 16 | Up to 25 per user |
| **Email** | Any (personal OK) | Business email required |
| **Self-Support** | Knowledge base, forums, Ask Red Hat AI | Knowledge base, forums, Ask Red Hat AI |
| **Developer Support Add-on** | Not available | Available (optional, dev/test only) |
| **Production** | ✅ Personal/small-scale | ❌ Dev/test ONLY |
| **What's Included** | RHEL + Red Hat portfolio | RHEL only |
| **Architectures** | x86_64 and ARM | All RHEL architectures |
| **Use Case** | Personal learning, home lab, small prod | Business dev/testing |
| **Registration** | Email verification required | Email verification required |
| **Sign Up** | https://developers.redhat.com/register | https://developers.redhat.com/products/rhel/business |

### When to Use Individual (FREE)

✅ You're learning RHEL  
✅ Personal development workstation  
✅ Home lab environment  
✅ Personal/small-scale production use  
✅ Testing and experimentation  
✅ Student/academic projects  
✅ Open source contributions  
✅ Individual freelancer development  
✅ Any email address (personal OK)  

### When to Use Business Developers (FREE - July 2025)

✅ Company/corporate development work  
✅ Business development teams  
✅ Testing apps before production deployment  
✅ Enterprise development environments  
✅ Need 17-25 systems (more than Individual's 16)  
✅ All RHEL architectures required  
✅ Have business/corporate email  
❌ Dev/test ONLY (not for production)  

**Important:** 
- **Individual** allows production for personal/small-scale use
- **Business Developers** is dev/test only (use full RHEL subs for business production)
- **Both are FREE** - choose based on personal vs business use, not cost!

## Security Best Practices

✅ **Never commit credentials** to version control  
✅ **Use activation keys** for automation (business subscriptions)  
✅ **Rotate keys regularly** (quarterly recommended)  
✅ **Limit key scope** to specific repos/organizations  
✅ **Use secrets management** (Vault, AWS Secrets Manager, etc.)  
✅ **Audit usage** via Red Hat Customer Portal  
✅ **No-log in Ansible** for password tasks  

❌ **Don't** store passwords in scripts  
❌ **Don't** use personal credentials for shared systems  
❌ **Don't** skip subscription verification  

## Troubleshooting

### Common Issues

**"Unable to register, already registered"**
```bash
sudo subscription-manager unregister
sudo subscription-manager register --username user@example.com
```

**"No subscriptions available"**
```bash
# Ensure account activated at developers.redhat.com
subscription-manager list --available
subscription-manager attach --pool=POOL_ID
```

**Network/proxy issues**
```bash
sudo subscription-manager config \
  --server.proxy_hostname=proxy.example.com \
  --server.proxy_port=3128
```

**Repository not found**
```bash
sudo subscription-manager refresh
sudo dnf clean all
```

See [SKILL.md](rhel-developer-subscription/SKILL.md) for complete troubleshooting guide.

## Contributing

This skill is part of the TAILWIND monorepo. Contributions welcome:

1. Fork the repository
2. Create feature branch: `git checkout -b feature/my-improvement`
3. Make changes and test thoroughly
4. Update version in SKILL.md frontmatter
5. Commit: `git commit -am "Description"`
6. Push: `git push origin feature/my-improvement`
7. Create Merge/Pull Request

## Versioning

This skill follows [Semantic Versioning](https://semver.org/):

- **Major:** Breaking workflow changes
- **Minor:** New features, RHEL version support
- **Patch:** Bug fixes, documentation

Current version: **1.0.0** (see [VERSION](rhel-developer-subscription/VERSION))

## License

Per TAILWIND monorepo license.

## Support

- **Skill Issues:** File issue in TAILWIND repository
- **RHEL Subscriptions:** https://access.redhat.com/support
- **Developer Program:** https://developers.redhat.com/support

## Resources

- **Developer Portal:** https://developers.redhat.com
- **Customer Portal:** https://access.redhat.com
- **Subscription Management:** https://access.redhat.com/management
- **Documentation:** https://access.redhat.com/documentation/en-us/red_hat_subscription_management
- **RHEL Docs:** https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux

## Maintainer

See [MAINTAINERS.md](MAINTAINERS.md) (TAILWIND monorepo).

## Acknowledgments

- Built for the TAILWIND program (Red Hat Products AI CoE)
- Follows [Agent Skills](https://agentskills.io) specification
- Designed for Claude Code and compatible AI assistants

---

**Quick Links:**
- [Get Started →](rhel-developer-subscription/README.md)
- [Integration Guide →](INTEGRATION.md)
- [Test Guide →](rhel-developer-subscription/TESTING.md)
- [Quick Reference →](rhel-developer-subscription/QUICKREF.md)
