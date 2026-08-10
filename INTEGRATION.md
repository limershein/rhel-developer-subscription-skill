# Integration Guide - Adding RHEL Developer Subscription Skill to TAILWIND

This guide explains how to integrate the `rhel-developer-subscription` skill into the TAILWIND monorepo.

## File Structure

The skill follows the standard TAILWIND skills layout:

```
tailwind/
└── skills/
    └── rhel-developer-subscription/
        ├── SKILL.md                    # Main skill specification
        ├── README.md                   # Overview and quick start
        ├── TESTING.md                  # Comprehensive testing guide
        ├── QUICKREF.md                 # Quick reference card
        └── examples/
            ├── register-individual.sh   # Individual registration script
            ├── register-business.sh     # Business registration script
            ├── verify-subscription.sh   # Verification script
            ├── ansible-register.yml     # Ansible playbook
            └── bootc-developer.containerfile  # bootc image example
```

## Installation Steps

### 1. Copy to TAILWIND Monorepo

```bash
# Clone TAILWIND (if not already)
git clone git@gitlab.com:tailwind/tailwind.git ~/Projects/tailwind
cd ~/Projects/tailwind

# Copy the skill
cp -r /path/to/rhel-developer-subscription skills/

# Verify structure
tree skills/rhel-developer-subscription
```

### 2. Make Scripts Executable

```bash
chmod +x skills/rhel-developer-subscription/examples/*.sh
```

### 3. Update Skills Index (if applicable)

If TAILWIND maintains a skills registry or index, add an entry:

```yaml
# skills/index.yaml or registry/index.yaml
- id: rhel-developer-subscription
  name: RHEL Developer Subscription
  description: >
    Automates obtaining and activating Red Hat Developer subscriptions
    (Individual or Business) through AI assistants.
  version: 1.0.0
  category: infrastructure
  tags:
    - rhel
    - subscription
    - registration
    - developer
    - subscription-manager
  triggers:
    - developer subscription
    - register rhel
    - red hat developer
    - rhel for business
  maintainer: Domain 0
  path: skills/rhel-developer-subscription/SKILL.md
```

### 4. Update Documentation

Add reference to main skills documentation:

```markdown
<!-- docs/domain0/skills.md or docs/product-management/skills-catalog.md -->

## Infrastructure Skills

### rhel-developer-subscription

Automates RHEL developer subscription registration.

- **Use Case:** Register RHEL systems with Developer for Individuals or Business subscriptions
- **Triggers:** "developer subscription", "register rhel", "red hat developer"
- **Capabilities:**
  - Detects RHEL version
  - Guides account creation
  - Runs subscription-manager registration
  - Enables appropriate repositories
  - Verifies access
  - Provides troubleshooting
- **Documentation:** [skills/rhel-developer-subscription/](../skills/rhel-developer-subscription/)
```

### 5. Add to Agent Skill Loading

Update agents that should have access to this skill:

```markdown
<!-- agents/domain0-agent.md or similar -->

Available skills:
- ...existing skills...
- rhel-developer-subscription: RHEL subscription registration workflow
```

### 6. Commit to Repository

```bash
cd ~/Projects/tailwind

git checkout -b add-rhel-developer-subscription-skill

git add skills/rhel-developer-subscription/

git commit -m "Add RHEL developer subscription skill

Adds comprehensive skill for automating Red Hat Developer subscription
registration on RHEL systems. Supports both Individual (free) and
Business (paid) subscriptions.

Features:
- Interactive registration workflows
- Automated scripts for common scenarios
- Ansible playbook for fleet management
- bootc image integration example
- Comprehensive testing guide
- Error handling and troubleshooting

Closes: #XXX (if applicable)
"

git push origin add-rhel-developer-subscription-skill
```

### 7. Create Merge/Pull Request

Create MR/PR with:
- **Title:** Add RHEL Developer Subscription Skill
- **Description:** 
  ```
  ## Summary
  Adds skill for automating RHEL developer subscription registration.
  
  ## Changes
  - New skill: `rhel-developer-subscription`
  - Registration scripts (individual, business, verification)
  - Ansible playbook for automation
  - bootc Containerfile example
  - Comprehensive testing guide
  
  ## Testing
  Tested on:
  - RHEL 8.10
  - RHEL 9.5
  - RHEL 10 Beta
  
  Both Individual and Business subscription flows verified.
  
  ## Documentation
  - SKILL.md: Full specification and workflows
  - README.md: Quick start guide
  - TESTING.md: Test cases and procedures
  - QUICKREF.md: Command reference
  ```

## Agent Configuration

### For Claude Code

Ensure skill is discoverable by adding metadata:

```yaml
# .claude/settings.json (if project-specific settings needed)
{
  "skills": {
    "rhel-developer-subscription": {
      "enabled": true,
      "autoload": true,
      "triggers": [
        "developer subscription",
        "register rhel",
        "red hat developer",
        "rhel for business",
        "activate rhel"
      ]
    }
  }
}
```

### For Other AI Assistants

The skill can be loaded by any agent that supports the Agent Skills specification:

```python
# Example: Loading in custom agent
from agent_skills import SkillLoader

loader = SkillLoader()
subscription_skill = loader.load("rhel-developer-subscription")

# Agent can now reference skill workflows
workflow = subscription_skill.get_workflow("individual_registration")
```

## Testing Integration

After integration, verify the skill loads correctly:

```bash
# Test skill discovery
cd ~/Projects/tailwind

# Search for skill
grep -r "rhel-developer-subscription" skills/

# Verify triggers are registered
grep -r "developer subscription" skills/rhel-developer-subscription/

# Run example script
cd skills/rhel-developer-subscription/examples
./verify-subscription.sh --help
```

## Usage Examples

### Via AI Agent

**User prompt:**
```
"I need to register my RHEL 9 system with a developer subscription"
```

**Agent behavior:**
1. Loads `rhel-developer-subscription` skill
2. Checks RHEL version
3. Asks: Individual or Business subscription?
4. Follows appropriate workflow from SKILL.md
5. Executes registration commands
6. Verifies success
7. Provides next steps

### Direct Script Usage

```bash
# Individual registration
cd ~/Projects/tailwind/skills/rhel-developer-subscription/examples
sudo ./register-individual.sh user@example.com

# Business registration
sudo ./register-business.sh --org 1234567 --key my-activation-key

# Verification
sudo ./verify-subscription.sh
```

### Ansible Automation

```bash
cd ~/Projects/tailwind/skills/rhel-developer-subscription/examples

# Register fleet
ansible-playbook ansible-register.yml \
  -i /path/to/inventory.ini \
  -e rhsm_org_id=1234567 \
  -e rhsm_activation_key=fleet-dev-key \
  -e rhsm_install_dev_tools=true
```

## Maintenance

### Updating the Skill

```bash
cd ~/Projects/tailwind

# Create update branch
git checkout -b update-rhel-subscription-skill

# Make changes
vim skills/rhel-developer-subscription/SKILL.md

# Update version
# In SKILL.md frontmatter:
# version: 1.1.0

# Commit
git commit -am "Update RHEL subscription skill to v1.1.0

- Add RHEL 11 support
- Improve error handling
- Update repository names
"

git push origin update-rhel-subscription-skill
```

### Versioning

Follow semantic versioning in SKILL.md frontmatter:

- **Major (X.0.0):** Breaking changes to workflow or API
- **Minor (1.X.0):** New features, new RHEL version support
- **Patch (1.0.X):** Bug fixes, documentation updates

## Dependencies

This skill requires:

**On RHEL systems:**
- `subscription-manager` (pre-installed on RHEL)
- `dnf` package manager
- Network access to Red Hat services

**For Ansible automation:**
- Ansible 2.9+
- `community.general` collection
  ```bash
  ansible-galaxy collection install community.general
  ```

**For bootc examples:**
- Podman 4.0+
- RHEL 9.4+ or RHEL 10 Beta
- Access to Red Hat registries

## Security Considerations

When integrating into TAILWIND:

1. **Never commit credentials**
   - Add to `.gitignore`:
     ```
     # Subscription credentials
     **/activation-keys.txt
     **/rhsm-credentials.env
     ```

2. **Use secrets management**
   - Store activation keys in HashiCorp Vault, AWS Secrets Manager, etc.
   - Reference in Ansible: `{{ lookup('vault', 'rhsm/activation_key') }}`

3. **Limit activation key scope**
   - Create separate keys for dev/staging/production
   - Set usage limits in Red Hat Customer Portal
   - Regular rotation (quarterly recommended)

4. **Audit usage**
   - Monitor subscription usage at access.redhat.com
   - Track which systems are registered
   - Alert on unexpected registrations

## Troubleshooting Integration

### Skill Not Loading

```bash
# Verify file permissions
ls -la skills/rhel-developer-subscription/

# Check SKILL.md syntax
head -20 skills/rhel-developer-subscription/SKILL.md

# Validate YAML frontmatter
yq eval skills/rhel-developer-subscription/SKILL.md
```

### Scripts Not Executable

```bash
# Fix permissions
find skills/rhel-developer-subscription/examples -name "*.sh" -exec chmod +x {} \;

# Verify
ls -l skills/rhel-developer-subscription/examples/*.sh
```

### Ansible Playbook Issues

```bash
# Test playbook syntax
ansible-playbook --syntax-check ansible-register.yml

# Check collection
ansible-galaxy collection list | grep community.general

# Install if missing
ansible-galaxy collection install community.general
```

## Support

- **Skill Issues:** File issue in TAILWIND repository
- **RHEL Subscription Issues:** Red Hat Support (access.redhat.com/support)
- **Subscription Management:** https://access.redhat.com/management

## Related Documentation

- [RHEL Subscription Management Guide](https://access.redhat.com/documentation/en-us/red_hat_subscription_management)
- [Red Hat Developer Program](https://developers.redhat.com)
- [Agent Skills Specification](https://agentskills.io)
- [TAILWIND Skills Guide](docs/product-management/skills-guide.md)

## Changelog

### v1.0.0 (2026-08-10)
- Initial release
- Support for Individual and Business subscriptions
- Registration scripts for manual and automated workflows
- Ansible playbook for fleet management
- bootc integration example
- Comprehensive testing guide
