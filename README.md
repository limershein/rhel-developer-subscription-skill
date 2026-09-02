# RHEL Developer Subscription Skill

**Get your RHEL development environment set up without the subscription hassle.**

This skill teaches AI assistants how to walk you through Red Hat developer subscription registration - from account creation to `dnf install`. Works for individual developers, whether for personal projects or company work.

## Prerequisites

**System requirements:**
- RHEL 8.x, 9.x, or 10.x (VM, cloud, or bare metal)
- Root/sudo access
- Network connectivity to Red Hat services

**Before you start, three questions:**
- **Do you have a Red Hat account?** If not, you'll create one as part of this process — it's free.
- **Do you have RHEL installed already?** If not, this skill also walks you through downloading and installing it first, then registering.
- **Do you need AI tooling?** No — the scripts below work standalone. AI assistance is a convenience, not a requirement.

**Terminology used throughout:** "Individual" = Red Hat Developer for Individuals. "Business Developers" = RHEL for Business Developers. Both are free.

## ⚠️ Before you register: email verification is required

Both subscription types require verifying your email address before they activate — this takes **5-10 minutes and cannot be skipped**. It's the #1 reason registration appears broken ("No subscriptions available" is almost always this). See the [Email Verification Guide](rhel-developer-subscription/references/EMAIL-VERIFICATION.md) for the full walkthrough and troubleshooting.

## Choose your path

- **End user** — just want to register a system? Jump to [Quick start](#quick-start) below.
- **Agent developer** — integrating this skill into an AI assistant? See [SKILL.md](rhel-developer-subscription/SKILL.md) for the full specification, including why its `allowed-tools` frontmatter only permits read-only commands.

## Quick start

### Run it yourself (no AI required)

```bash
cd rhel-developer-subscription/scripts

# Personal dev machine
sudo ./register-individual.sh user@example.com

# Work machine (with activation key)
sudo ./register-business.sh --org 1234567 --key my-activation-key

# Check it worked
sudo ./verify-subscription.sh
```

### Or talk to your AI assistant

```
"I need a developer subscription for RHEL"
"Register this system with Red Hat Developer"
"Set up RHEL for business development"
```

That's it. The AI loads this skill and walks you through the rest.

### Need team-wide deployment?

**RHEL for Business Developers is self-service** — sign up directly with a business email, no seller needed. You can self-register up to 16 (Individual) or 25 (Business Developers) systems, and create your own activation keys in console.redhat.com.

For centralized/managed team deployment instead, contact Red Hat Sales about:
- **Red Hat Developer for Teams** (FREE, delivered by Red Hat sellers)
- Centralized activation keys
- Organization-level controls
- Optional Developer support add-on: https://access.redhat.com/support/offerings/developer

**Already on Developer for Teams?** Get your activation key and Organization ID from your organization's IT department — it's centrally managed, not self-service like Business Developers.

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
├── VERSION               # Semantic version
├── scripts/
│   ├── register-individual.sh     # Individual subscription script
│   ├── register-business.sh       # Business subscription script
│   ├── register-with-rhc.sh       # Modern rhc-first registration
│   ├── verify-subscription.sh     # Verification script
│   ├── ansible-register.yml       # Ansible playbook
│   └── bootc-developer.containerfile  # bootc image example
└── references/
    ├── EMAIL-VERIFICATION.md      # Email verification deep-dive
    ├── QUICKREF.md                # Command quick reference
    └── TESTING.md                 # Comprehensive test guide
```

## Documentation

| Document | Purpose | Audience |
|----------|---------|----------|
| [SKILL.md](rhel-developer-subscription/SKILL.md) | Complete skill specification with workflows | AI agents, developers |
| [README.md](rhel-developer-subscription/README.md) | Quick start and overview | All users |
| [EMAIL-VERIFICATION.md](rhel-developer-subscription/references/EMAIL-VERIFICATION.md) | Email verification walkthrough — the #1 source of confusion | All users |
| [TESTING.md](rhel-developer-subscription/references/TESTING.md) | Test cases and procedures | Testers, QA |
| [QUICKREF.md](rhel-developer-subscription/references/QUICKREF.md) | Command reference card | System administrators |

## Installation

```bash
# Clone this repository
git clone <this-repo-url> rhel-developer-subscription
cd rhel-developer-subscription

# Make scripts executable
chmod +x rhel-developer-subscription/scripts/*.sh

# Use scripts directly
cd rhel-developer-subscription/scripts
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
12. Reports: "✅ RHEL Developer subscription active. Run `sudo dnf groupinstall 'Development Tools'` to get started, or see the Now what? section below."

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
cd rhel-developer-subscription/scripts

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
cd rhel-developer-subscription/scripts

# Test 1: Individual registration
sudo ./register-individual.sh user@example.com

# Test 4: Verification
sudo ./verify-subscription.sh

# See references/TESTING.md for all 10 test cases
```

## Subscription Types Comparison

**Simple question:** Is this for **personal use** or for **your company/employer**?

| Feature | Individual (FREE) | Business Developers (FREE) |
|---------|-------------------|----------------------------|
| **Best for** | Personal use — learning, home lab, side projects | Work use — company dev, testing |
| **Systems** | Up to 16 | Up to 25 per user |
| **Email** | Any (personal OK) | Business email required |
| **Production** | ✅ Personal/small-scale | ❌ Dev/test ONLY |

**Both are FREE!** The difference is personal vs business use, not cost. Full comparison (support options, architectures, sign-up links): [references/QUICKREF.md](rhel-developer-subscription/references/QUICKREF.md).

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

## Now what?

Subscription active, repos enabled — here's how to actually start using RHEL:

**Install a dev toolchain:**
```bash
sudo dnf groupinstall "Development Tools" -y
```

**Connect to Red Hat Insights** (if you didn't use `rhc connect`, which does this automatically):
```bash
# subscription-manager users
sudo insights-client --register
```

**Start a project:** clone your code, `sudo dnf install` whatever runtime/toolchain you need, and browse [developers.redhat.com](https://developers.redhat.com) for language- and framework-specific guides, or [access.redhat.com/documentation](https://access.redhat.com/documentation) for RHEL administration docs.

## Contributing

Contributions welcome:

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

MIT — see [LICENSE](LICENSE).

## Support

- **Skill Issues:** File an issue in this repository
- **RHEL Subscriptions:** https://access.redhat.com/support
- **Developer Program:** https://developers.redhat.com/support

## Resources

- **Developer Portal:** https://developers.redhat.com
- **Customer Portal:** https://access.redhat.com
- **Subscription Management:** https://access.redhat.com/management
- **Documentation:** https://access.redhat.com/documentation/en-us/red_hat_subscription_management
- **RHEL Docs:** https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux

## Acknowledgments

- Built as a personal experiment in Agent-Skills-based developer tooling — not an official Red Hat deliverable
- Follows [Agent Skills](https://agentskills.io) specification
- Designed for Claude Code and compatible AI assistants

---

**Quick Links:**
- [Get Started →](rhel-developer-subscription/README.md)
- [Test Guide →](rhel-developer-subscription/references/TESTING.md)
- [Quick Reference →](rhel-developer-subscription/references/QUICKREF.md)
