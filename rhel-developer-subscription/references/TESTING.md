# Testing Guide - RHEL Developer Subscription Skill

This guide helps you test the RHEL developer subscription skill in various scenarios.

## Prerequisites

- RHEL 8.x, 9.x, or 10.x system (VM or bare metal)
- Root/sudo access
- Network connectivity to Red Hat services
- Red Hat account (create at https://developers.redhat.com/register if needed)

## Test Environments

### Option 1: Local RHEL VM

```bash
# Using libvirt/KVM with RHEL 9
curl -LO https://developers.redhat.com/content-gateway/file/rhel-9.5-x86_64-boot.iso

virt-install \
  --name rhel9-dev-test \
  --memory 4096 \
  --vcpus 2 \
  --disk size=20 \
  --cdrom rhel-9.5-x86_64-boot.iso \
  --os-variant rhel9.0 \
  --network default
```

### Option 2: Podman/Docker Container (Limited)

```bash
# Note: subscription-manager has limited functionality in containers
# Better for testing workflows, not full registration

podman run -it --name rhel-test \
  registry.access.redhat.com/ubi9/ubi:latest \
  /bin/bash

# Inside container
dnf install -y subscription-manager
```

### Option 3: Cloud Instance

```bash
# AWS EC2 - RHEL 9 (BYOS - bring your own subscription)
# Launch a RHEL instance without pre-registered subscription

# Azure - RHEL 9 BYOS
# GCP - RHEL 9 BYOS
```

## Test Cases

### Test 1: Individual Developer Registration (Fresh System)

**Scenario:** Register a new RHEL system with Developer for Individuals subscription.

**Prerequisites:**
- Have a Red Hat Developer account
- **Email must be verified** (check inbox for verification link)
- Have logged in to https://developers.redhat.com at least once
- Wait 5-10 minutes after email verification before testing

**Steps:**
```bash
# 0. Verify account prerequisites
# - Visit https://developers.redhat.com/login
# - Ensure you can log in successfully
# - Visit https://developers.redhat.com/products/rhel/download
#   (This triggers subscription activation)
# - Wait 5-10 minutes

# 1. Verify system is not registered
sudo subscription-manager status
# Expected: "Overall Status: Unknown" or error

# 2. Run registration script
cd rhel-developer-subscription/examples
sudo ./register-individual.sh myuser@example.com
# Enter password when prompted

# 3. Verify registration
sudo subscription-manager status
# Expected: "Overall Status: Current"

# 4. Check repositories
dnf repolist
# Expected: See rhel-*-baseos-rpms and rhel-*-appstream-rpms

# 5. Test package installation
sudo dnf install -y gcc
# Expected: Package installs successfully
```

**Success Criteria:**
- ✅ Email verified before testing
- ✅ System registered
- ✅ Subscription attached
- ✅ Repositories enabled
- ✅ Can install packages

**If Test Fails:**
- Check email verification status
- Ensure you've logged in to developers.redhat.com
- Wait 5-10 minutes after email verification
- See "Test 7" for credential error handling

### Test 2: Business Developer Registration (Activation Key)

**Scenario:** Register with business subscription using activation key.

**Prerequisites:**
- Have valid Organization ID
- Have valid Activation Key (create at access.redhat.com)

**Steps:**
```bash
# 1. Verify not registered
sudo subscription-manager status

# 2. Run business registration
cd rhel-developer-subscription/examples
sudo ./register-business.sh \
  --org 1234567 \
  --key my-activation-key

# 3. Verify subscription
sudo subscription-manager list --consumed

# 4. Check auto-attached repositories
dnf repolist
```

**Success Criteria:**
- ✅ Registered without password prompt
- ✅ Subscription auto-attached
- ✅ Repositories enabled
- ✅ Can install packages

### Test 3: Re-registration (Already Registered System)

**Scenario:** Attempt to register an already-registered system.

**Steps:**
```bash
# System already registered from Test 1 or 2

# Run registration again
sudo ./register-individual.sh myuser@example.com

# Expected: Script detects existing registration
# Prompts: "System is already registered. Unregister and re-register? (y/N)"

# Enter 'N' for no
# Expected: Script exits without changes

# Enter 'Y' for yes
# Expected: Unregisters and re-registers successfully
```

**Success Criteria:**
- ✅ Detects existing registration
- ✅ Prompts before unregistering
- ✅ Can re-register if confirmed

### Test 4: Verification Script

**Scenario:** Verify subscription health on registered system.

**Steps:**
```bash
# After completing Test 1 or 2
sudo ./verify-subscription.sh

# Expected output sections:
# - System information
# - Registration status ✅
# - Subscription status ✅
# - Enabled repositories ✅
# - Repository access test ✅
# - Package availability test ✅
```

**Success Criteria:**
- ✅ All checks pass
- ✅ Shows subscription details
- ✅ Confirms repository access

### Test 5: Ansible Automation

**Scenario:** Register multiple systems using Ansible.

**Prerequisites:**
- Ansible installed
- Inventory file with test systems
- `community.general` collection (`ansible-galaxy collection install community.general`)

**Steps:**
```bash
# Create inventory
cat > inventory.ini <<EOF
[rhel_dev]
rhel-test-1 ansible_host=192.168.1.10
rhel-test-2 ansible_host=192.168.1.11
EOF

# Test with Individual subscription
ansible-playbook ansible-register.yml \
  -i inventory.ini \
  -e rhsm_username=myuser@example.com \
  -e rhsm_password=mypassword \
  -e rhsm_install_dev_tools=true

# Or with activation key
ansible-playbook ansible-register.yml \
  -i inventory.ini \
  -e rhsm_org_id=1234567 \
  -e rhsm_activation_key=my-key \
  -e rhsm_update_packages=true
```

**Success Criteria:**
- ✅ All systems registered
- ✅ Playbook idempotent (can run multiple times)
- ✅ Development tools installed (if requested)

### Test 6: bootc Image Build

**Scenario:** Build a bootc image with developer tools.

**Prerequisites:**
- Podman installed
- RHEL 10 Beta access (or RHEL 9 bootc tech preview)
- Organization ID and Activation Key

**Steps:**
```bash
# Build image
cd rhel-developer-subscription/examples

podman build -f bootc-developer.containerfile \
  --build-arg ORG_ID=1234567 \
  --build-arg ACTIVATION_KEY=my-key \
  -t localhost/rhel-developer-bootc:latest \
  .

# Verify image
podman images | grep rhel-developer-bootc

# Inspect installed packages
podman run --rm localhost/rhel-developer-bootc:latest \
  rpm -qa | grep -E "gcc|git|podman"

# Expected: See gcc, git, podman packages
```

**Success Criteria:**
- ✅ Image builds successfully
- ✅ Developer tools present
- ✅ No subscription credentials left in image

### Test 7: Error Handling - Invalid Credentials

**Scenario:** Test error handling with wrong credentials and unverified email.

**Test 7A: Wrong Password**
```bash
# Run with correct username but wrong password
sudo ./register-individual.sh myuser@example.com
# Enter wrong password

# Expected:
# - Registration fails gracefully
# - Error message explains credential issue
# - Suggests checking account at developers.redhat.com
```

**Test 7B: Unverified Email**
```bash
# Create a NEW account at developers.redhat.com
# DO NOT click the email verification link
# Immediately try to register

sudo ./register-individual.sh new-unverified@example.com
# Enter correct password

# Expected:
# - Registration may succeed OR fail
# - Subscription attach will fail with "No subscriptions available"
# - Script provides guidance about email verification
# - Suggests checking email and verification link
```

**Test 7C: Email Verified But Subscription Not Activated**
```bash
# Create account, verify email
# BUT don't log in to developers.redhat.com yet
# Immediately try to register

sudo ./register-individual.sh verified-but-not-activated@example.com

# Expected:
# - Registration may succeed
# - Subscription attach fails
# - Script suggests logging in to developers.redhat.com
# - Suggests visiting /products/rhel/download page
# - Recommends waiting 5-10 minutes
```

**Success Criteria:**
- ✅ Clear error messages for each scenario
- ✅ No partial registration state
- ✅ Actionable guidance provided
- ✅ Email verification mentioned prominently
- ✅ Wait time recommendations included

### Test 8: Error Handling - Network Issues

**Scenario:** Test behavior with network problems.

**Steps:**
```bash
# Block Red Hat subscription service (temporary)
sudo iptables -A OUTPUT -d subscription.rhsm.redhat.com -j DROP

# Attempt registration
sudo ./register-individual.sh myuser@example.com

# Expected:
# - Connection timeout or network error
# - Script suggests checking network/proxy

# Restore network
sudo iptables -D OUTPUT -d subscription.rhsm.redhat.com -j DROP
```

**Success Criteria:**
- ✅ Detects network issue
- ✅ Suggests troubleshooting steps
- ✅ Doesn't leave system in broken state

### Test 9: RHEL Version Compatibility

**Scenario:** Test across different RHEL versions.

**Test Matrix:**
| RHEL Version | Base Repo | AppStream Repo |
|--------------|-----------|----------------|
| 8.10         | rhel-8-for-x86_64-baseos-rpms | rhel-8-for-x86_64-appstream-rpms |
| 9.5          | rhel-9-for-x86_64-baseos-rpms | rhel-9-for-x86_64-appstream-rpms |
| 10.0         | rhel-10-for-x86_64-baseos-rpms | rhel-10-for-x86_64-appstream-rpms |

**Steps:**
```bash
# For each RHEL version:

# 1. Check version detection
cat /etc/redhat-release
grep -oP 'release \K[0-9]+' /etc/redhat-release

# 2. Run registration
sudo ./register-individual.sh myuser@example.com

# 3. Verify correct repos enabled
dnf repolist | grep rhel-

# 4. Confirm repo names match version
```

**Success Criteria:**
- ✅ Correct version detected
- ✅ Appropriate repos enabled for each version
- ✅ Package installation works

### Test 10: AI Agent Integration Test

**Scenario:** Test the skill with an AI agent (Claude, etc.).

**User Prompt:**
```
"I need to set up a RHEL developer subscription on this system for personal development work"
```

**Expected Agent Workflow:**
1. Agent loads `rhel-developer-subscription` skill
2. Detects RHEL version (runs `cat /etc/redhat-release`)
3. Checks registration status (runs `subscription-manager status`)
4. Asks: "Individual or Business subscription?"
5. User: "Individual"
6. Guides to https://developers.redhat.com/register
7. Waits for confirmation user has account
8. Runs: `sudo subscription-manager register`
9. Runs: `sudo subscription-manager attach --auto`
10. Enables repositories based on RHEL version
11. Verifies with `dnf repolist`
12. Reports success + next steps

**Success Criteria:**
- ✅ Agent follows skill workflow
- ✅ Asks clarifying questions
- ✅ Runs correct commands for RHEL version
- ✅ Verifies success
- ✅ Provides helpful summary

## Cleanup After Testing

```bash
# Unregister system
sudo subscription-manager unregister

# Remove any test files
sudo dnf clean all

# Verify unregistered
sudo subscription-manager status
# Expected: Error about not being registered

# Re-register for production use if needed
```

## Troubleshooting Test Failures

### Registration Fails
```bash
# Check logs
sudo tail -f /var/log/rhsm/rhsm.log

# Verify network
curl -I https://subscription.rhsm.redhat.com/subscription/

# Check DNS
nslookup subscription.rhsm.redhat.com

# Test auth
subscription-manager register --username=user@example.com
```

### Repositories Not Available
```bash
# Refresh subscription data
sudo subscription-manager refresh

# List all available repos
sudo subscription-manager repos --list | less

# Check enabled repos
sudo subscription-manager repos --list-enabled

# Manually enable
sudo subscription-manager repos --enable <repo-id>
```

### Package Installation Fails
```bash
# Clear DNF cache
sudo dnf clean all

# Regenerate cache
sudo dnf makecache

# Check repository metadata
sudo dnf repolist -v

# Test specific package
sudo dnf info gcc
```

## Test Report Template

```markdown
## Test Execution Report

**Date:** YYYY-MM-DD
**Tester:** Name
**Environment:** RHEL X.Y on [VM/Cloud/Bare Metal]

### Test Results

| Test # | Test Name | Status | Notes |
|--------|-----------|--------|-------|
| 1 | Individual Registration | ✅ PASS | Registered successfully |
| 2 | Business Registration | ⚠️ SKIP | No activation key available |
| 3 | Re-registration | ✅ PASS | Detected existing reg |
| 4 | Verification Script | ✅ PASS | All checks passed |
| 5 | Ansible Automation | ✅ PASS | 2 systems registered |
| 6 | bootc Image | ❌ FAIL | Build error, investigating |
| 7 | Invalid Credentials | ✅ PASS | Clear error message |
| 8 | Network Issues | ✅ PASS | Detected timeout |
| 9 | Version Compatibility | ✅ PASS | RHEL 9.5 tested |
| 10 | AI Agent Integration | ✅ PASS | Agent followed workflow |

### Issues Found

1. **Issue #1:** bootc build failed with...
   - **Impact:** Medium
   - **Workaround:** Manual registration in running system
   - **Fix:** Update Containerfile line 42

### Recommendations

- All core functionality works on RHEL 9.5
- Scripts handle errors gracefully
- Ready for production use with Individual subscriptions
- Need activation key access to fully test Business flow
```

## Continuous Testing

Set up automated testing:

```bash
# Create test automation script
cat > test-runner.sh <<'EOF'
#!/bin/bash
# Runs all automated tests and generates report

LOG_FILE="test-results-$(date +%Y%m%d-%H%M%S).log"

echo "=== RHEL Developer Subscription Skill Test Suite ===" | tee -a "${LOG_FILE}"
echo "Started: $(date)" | tee -a "${LOG_FILE}"
echo "" | tee -a "${LOG_FILE}"

# Test 1: Verification (if already registered)
if subscription-manager status &>/dev/null; then
    echo "Test 1: Running verification script..." | tee -a "${LOG_FILE}"
    if sudo ./verify-subscription.sh &>>"${LOG_FILE}"; then
        echo "✅ PASS" | tee -a "${LOG_FILE}"
    else
        echo "❌ FAIL" | tee -a "${LOG_FILE}"
    fi
fi

# More tests...

echo "" | tee -a "${LOG_FILE}"
echo "Completed: $(date)" | tee -a "${LOG_FILE}"
echo "Full log: ${LOG_FILE}"
EOF

chmod +x test-runner.sh
```

## Next Steps After Testing

1. **Document** any issues found
2. **Update** scripts based on test feedback
3. **Integrate** with TAILWIND monorepo
4. **Train** AI agents on test scenarios
5. **Monitor** production usage
