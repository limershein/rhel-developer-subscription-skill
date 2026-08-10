# GitHub Setup Instructions

## Quick Setup

To publish this skill on GitHub for community review, follow these steps:

### Option 1: Using GitHub CLI (gh)

```bash
# Install gh if not already installed
# Fedora/RHEL: sudo dnf install gh
# Or: https://cli.github.com/

# Authenticate
gh auth login

# Create repository
gh repo create rhel-developer-subscription-skill \
  --public \
  --description "Agent Skills-compliant skill for automating RHEL Developer subscription registration" \
  --source=. \
  --remote=origin \
  --push

# Repository will be created at:
# https://github.com/YOUR_USERNAME/rhel-developer-subscription-skill
```

### Option 2: Using GitHub Web Interface

1. **Create repository on GitHub:**
   - Go to https://github.com/new
   - Repository name: `rhel-developer-subscription-skill`
   - Description: `Agent Skills-compliant skill for automating RHEL Developer subscription registration`
   - Visibility: **Public**
   - Do NOT initialize with README, .gitignore, or license (we have them)
   - Click "Create repository"

2. **Push local code to GitHub:**
   ```bash
   # Add GitHub remote (replace YOUR_USERNAME)
   git remote add origin https://github.com/YOUR_USERNAME/rhel-developer-subscription-skill.git

   # Or with SSH:
   git remote add origin git@github.com:YOUR_USERNAME/rhel-developer-subscription-skill.git

   # Push code
   git push -u origin main
   ```

### Option 3: Red Hat Organization (if you have access)

If publishing under a Red Hat organization:

```bash
# Replace ORG_NAME with actual Red Hat org
git remote add origin git@github.com:ORG_NAME/rhel-developer-subscription-skill.git
git push -u origin main
```

## Repository Settings

After creating the repository:

### Topics/Tags (for discoverability)

Add these topics to your repository (Settings → About → Topics):

- `rhel`
- `red-hat`
- `subscription-management`
- `agent-skills`
- `developer-subscription`
- `rhc`
- `subscription-manager`
- `ansible`
- `bootc`
- `ai-agents`
- `claude-code`

### Repository Description

```
Agent Skills-compliant skill for automating Red Hat Developer subscription registration on RHEL systems. Supports Individual (free) and Business subscriptions with rhc/subscription-manager, email verification workflow, Ansible automation, and bootc integration.
```

### About Section

- ✅ Add description
- ✅ Add website: `https://developers.redhat.com`
- ✅ Add topics (see above)
- ✅ Include license: MIT

## Sharing for Review

Once published, share this link with colleagues:

```
https://github.com/YOUR_USERNAME/rhel-developer-subscription-skill
```

### For Internal Red Hat Review

Consider also:

1. **Create GitLab mirror** (if Red Hat uses GitLab internally):
   ```bash
   git remote add gitlab git@gitlab.com:YOUR_ORG/rhel-developer-subscription-skill.git
   git push gitlab main
   ```

2. **Create discussion issue** on GitHub for feedback:
   - Go to Issues → New Issue
   - Title: "Feedback and Review - RHEL Developer Subscription Skill v1.0.0"
   - Body: Link to key docs, ask for specific feedback
   - Label: `feedback`, `review-requested`

3. **Share in Red Hat channels:**
   - Slack/Mattermost
   - Email to relevant teams
   - Internal forums

## Quick Review Links

Share these direct links for different audiences:

**For Product Managers:**
- README: `https://github.com/YOUR_USERNAME/rhel-developer-subscription-skill/blob/main/README.md`
- Summary: `https://github.com/YOUR_USERNAME/rhel-developer-subscription-skill/blob/main/SUMMARY.md`

**For Developers:**
- Skill Spec: `https://github.com/YOUR_USERNAME/rhel-developer-subscription-skill/blob/main/rhel-developer-subscription/SKILL.md`
- Examples: `https://github.com/YOUR_USERNAME/rhel-developer-subscription-skill/tree/main/rhel-developer-subscription/examples`

**For QA/Testers:**
- Testing Guide: `https://github.com/YOUR_USERNAME/rhel-developer-subscription-skill/blob/main/rhel-developer-subscription/TESTING.md`

**For DevOps:**
- Ansible Playbook: `https://github.com/YOUR_USERNAME/rhel-developer-subscription-skill/blob/main/rhel-developer-subscription/examples/ansible-register.yml`
- bootc Example: `https://github.com/YOUR_USERNAME/rhel-developer-subscription-skill/blob/main/rhel-developer-subscription/examples/bootc-developer.containerfile`

**For Email Verification Questions:**
- Email Verification Guide: `https://github.com/YOUR_USERNAME/rhel-developer-subscription-skill/blob/main/EMAIL-VERIFICATION.md`
- Quick Reference: `https://github.com/YOUR_USERNAME/rhel-developer-subscription-skill/blob/main/EMAIL-VERIFICATION-QUICKREF.txt`

## Badge (Optional)

Add to top of README.md:

```markdown
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![RHEL](https://img.shields.io/badge/RHEL-8%20%7C%209%20%7C%2010-red)](https://www.redhat.com/en/technologies/linux-platforms/enterprise-linux)
[![Agent Skills](https://img.shields.io/badge/Agent%20Skills-1.0-blue)](https://agentskills.io)
```

## Example Announcement

**Subject:** New: RHEL Developer Subscription Skill for AI Agents

Hi team,

I've published a new Agent Skills-compliant skill for automating RHEL Developer subscription registration:

🔗 **GitHub:** https://github.com/YOUR_USERNAME/rhel-developer-subscription-skill

**What it does:**
Enables AI assistants (Claude, etc.) to guide users through the complete workflow of obtaining and activating Red Hat Developer subscriptions from a single natural language prompt.

**Key features:**
- ✅ Individual (free) and Business (paid) subscriptions
- ✅ RHEL 8.x, 9.x, and 10.x support
- ✅ Modern `rhc` tool with `subscription-manager` fallback
- ✅ Email verification workflow (fully documented)
- ✅ Ansible playbook for fleet management
- ✅ bootc integration example
- ✅ Comprehensive testing guide

**Try it:**
```
"I need a developer subscription for RHEL"
```

The AI agent loads the skill and walks you through account creation, email verification, system registration, and verification.

**Feedback welcome!**
Please review and comment on the GitHub repository or file issues.

**Quick links:**
- Overview: [README.md](link)
- Complete spec: [SKILL.md](link)
- Testing: [TESTING.md](link)
- Email verification: [EMAIL-VERIFICATION.md](link)

Thanks,
[Your name]

## Verify Upload

After pushing, verify everything is there:

```bash
# View on GitHub
gh repo view --web

# Or visit manually:
# https://github.com/YOUR_USERNAME/rhel-developer-subscription-skill
```

Check:
- ✅ All 21 files present
- ✅ README renders correctly
- ✅ Scripts show as executable
- ✅ License file visible
- ✅ Topics/tags added

## Next Steps After Publishing

1. **Monitor for feedback**
   - Watch GitHub issues
   - Check pull requests
   - Respond to comments

2. **Create releases**
   ```bash
   # Tag v1.0.0
   git tag -a v1.0.0 -m "Release v1.0.0: Initial production release"
   git push origin v1.0.0

   # Create GitHub release
   gh release create v1.0.0 \
     --title "v1.0.0: Initial Release" \
     --notes-file CHANGELOG.md
   ```

3. **Submit to Agent Skills registry** (if applicable)
   - Visit https://agentskills.io
   - Follow submission process

4. **Cross-post to relevant communities**
   - Red Hat Developer blog
   - Reddit: r/redhat, r/linux
   - Hacker News (if appropriate)
   - LinkedIn

5. **Integrate into TAILWIND**
   - Follow INTEGRATION.md
   - Create MR to TAILWIND monorepo
