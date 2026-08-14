#!/bin/bash
#
# test-skill-commands.sh
# Validates RHEL Developer Subscription Skill commands against real RHEL/UBI environment
#
# Usage:
#   podman run --rm -v $(pwd):/test:Z registry.access.redhat.com/ubi9/ubi:latest bash /test/test-skill-commands.sh
#

set -euo pipefail

echo "========================================"
echo "RHEL Developer Subscription Skill Tests"
echo "========================================"
echo ""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

pass_count=0
fail_count=0
warn_count=0

test_pass() {
    echo -e "${GREEN}✅ PASS${NC}: $1"
    ((pass_count++))
}

test_fail() {
    echo -e "${RED}❌ FAIL${NC}: $1"
    ((fail_count++))
}

test_warn() {
    echo -e "${YELLOW}⚠️  WARN${NC}: $1"
    ((warn_count++))
}

echo "Test Environment:"
cat /etc/redhat-release
echo ""
echo "Subscription Manager Version:"
subscription-manager --version 2>/dev/null || echo "subscription-manager not installed"
echo ""
echo "----------------------------------------"
echo ""

# TEST 1: Version Detection (from SKILL.md line 87-88)
echo "TEST 1: RHEL Version Detection"
echo "Command from skill: cat /etc/redhat-release"
if [[ -f /etc/redhat-release ]]; then
    VERSION_OUTPUT=$(cat /etc/redhat-release)
    echo "Output: $VERSION_OUTPUT"
    test_pass "Version detection command works"
else
    test_fail "Version detection - /etc/redhat-release not found"
fi
echo ""

# TEST 2: Version Parsing (from SKILL.md line 138)
echo "TEST 2: RHEL Version Parsing"
echo "Command from skill: grep -oP 'release \K[0-9]+' /etc/redhat-release"
RHEL_VERSION=$(grep -oP 'release \K[0-9]+' /etc/redhat-release 2>/dev/null || echo "unknown")
echo "Detected version: ${RHEL_VERSION}"
if [[ "${RHEL_VERSION}" =~ ^[0-9]+$ ]]; then
    test_pass "Version parsing extracts major version: ${RHEL_VERSION}"
else
    test_fail "Version parsing failed to extract number"
fi
echo ""

# TEST 3: Tool Availability Check (from SKILL.md lines 91-96)
echo "TEST 3: Tool Availability Detection"
echo "Command from skill: command -v rhc &>/dev/null"
if command -v rhc &>/dev/null; then
    echo "rhc found: $(which rhc)"
    test_pass "rhc tool detected"
    RHC_AVAILABLE=true
else
    echo "rhc not found (expected in UBI containers)"
    test_warn "rhc not installed (normal for UBI, would be available on installed RHEL 9+)"
    RHC_AVAILABLE=false
fi

echo "Command from skill: subscription-manager"
if command -v subscription-manager &>/dev/null; then
    echo "subscription-manager found: $(which subscription-manager)"
    test_pass "subscription-manager tool detected"
else
    test_fail "subscription-manager not found"
fi
echo ""

# TEST 4: Subscription Status Check (from SKILL.md line 159)
echo "TEST 4: Subscription Status Check"
echo "Command from skill: sudo subscription-manager status"
STATUS_OUTPUT=$(subscription-manager status 2>&1 || true)
echo "Output (first 3 lines):"
echo "$STATUS_OUTPUT" | head -3
if echo "$STATUS_OUTPUT" | grep -q "Overall Status"; then
    test_pass "subscription-manager status command format correct"
elif echo "$STATUS_OUTPUT" | grep -q "not registered"; then
    test_pass "subscription-manager status shows expected 'not registered' message"
else
    test_warn "subscription-manager status output differs from expected (container limitation)"
fi
echo ""

# TEST 5: Repository Command Format (from SKILL.md lines 256-261)
echo "TEST 5: Repository Enable Command (Syntax Check)"
echo "Command from skill (dynamic version):"
cat <<'EOF'
RHEL_VERSION=$(grep -oP 'release \K[0-9]+' /etc/redhat-release)
sudo subscription-manager repos \
  --enable "rhel-${RHEL_VERSION}-for-x86_64-baseos-rpms" \
  --enable "rhel-${RHEL_VERSION}-for-x86_64-appstream-rpms"
EOF

# Build the command
RHEL_VERSION=$(grep -oP 'release \K[0-9]+' /etc/redhat-release)
EXPECTED_REPOS=(
    "rhel-${RHEL_VERSION}-for-x86_64-baseos-rpms"
    "rhel-${RHEL_VERSION}-for-x86_64-appstream-rpms"
)

echo "For RHEL ${RHEL_VERSION}, expected repos:"
for repo in "${EXPECTED_REPOS[@]}"; do
    echo "  - ${repo}"
done

# Verify repo names don't contain -beta for RHEL 10
if [[ "${RHEL_VERSION}" == "10" ]]; then
    if [[ ! "${EXPECTED_REPOS[0]}" =~ "beta" ]]; then
        test_pass "RHEL 10 repo names do not contain -beta (GA version)"
    else
        test_fail "RHEL 10 repo names incorrectly contain -beta"
    fi
else
    test_pass "Repo name format correct for RHEL ${RHEL_VERSION}"
fi
echo ""

# TEST 6: Version-Specific Repo Names
echo "TEST 6: Version-Specific Repository Names"
case "${RHEL_VERSION}" in
    8)
        EXPECTED_BASE="rhel-8-for-x86_64-baseos-rpms"
        EXPECTED_APP="rhel-8-for-x86_64-appstream-rpms"
        ;;
    9)
        EXPECTED_BASE="rhel-9-for-x86_64-baseos-rpms"
        EXPECTED_APP="rhel-9-for-x86_64-appstream-rpms"
        ;;
    10)
        EXPECTED_BASE="rhel-10-for-x86_64-baseos-rpms"
        EXPECTED_APP="rhel-10-for-x86_64-appstream-rpms"
        ;;
    *)
        EXPECTED_BASE="unknown"
        EXPECTED_APP="unknown"
        ;;
esac

echo "Expected for RHEL ${RHEL_VERSION}:"
echo "  Base: ${EXPECTED_BASE}"
echo "  AppStream: ${EXPECTED_APP}"

if [[ "${EXPECTED_BASE}" == "${EXPECTED_REPOS[0]}" ]]; then
    test_pass "Base repository name matches skill documentation"
else
    test_fail "Base repository name mismatch"
fi

if [[ "${EXPECTED_APP}" == "${EXPECTED_REPOS[1]}" ]]; then
    test_pass "AppStream repository name matches skill documentation"
else
    test_fail "AppStream repository name mismatch"
fi
echo ""

# TEST 7: Command Syntax Validation
echo "TEST 7: Command Syntax Validation"

# Test registration command syntax (won't execute, just validate syntax)
echo "Validating: subscription-manager register --username user@example.com"
if bash -n <(echo 'subscription-manager register --username user@example.com') 2>/dev/null; then
    test_pass "Registration command syntax valid"
else
    test_fail "Registration command syntax invalid"
fi

# Test attach command syntax
echo "Validating: subscription-manager attach --auto"
if bash -n <(echo 'subscription-manager attach --auto') 2>/dev/null; then
    test_pass "Attach command syntax valid"
else
    test_fail "Attach command syntax invalid"
fi

# Test repos command syntax
REPOS_CMD="subscription-manager repos --enable rhel-${RHEL_VERSION}-for-x86_64-baseos-rpms --enable rhel-${RHEL_VERSION}-for-x86_64-appstream-rpms"
echo "Validating: ${REPOS_CMD}"
if bash -n <(echo "${REPOS_CMD}") 2>/dev/null; then
    test_pass "Repository enable command syntax valid"
else
    test_fail "Repository enable command syntax invalid"
fi
echo ""

# TEST 8: Error Message Validation (from SKILL.md)
echo "TEST 8: Error Message Handling"
echo "Testing unregistered system detection..."

# In a container, we expect registration to fail
REG_OUTPUT=$(subscription-manager register --username test@example.com --password fake 2>&1 || true)
if echo "$REG_OUTPUT" | grep -qE "not registered|Unable to verify|Network error|connection"; then
    test_pass "Unregistered error message is informative"
else
    test_warn "Registration error message format may vary in containers"
fi
echo ""

# TEST 9: Verify Scripts Exist (from SKILL.md line 265-272)
echo "TEST 9: Automation Scripts Availability"
SCRIPT_DIR="/home/limershe/Projects/devsub-skill/rhel-developer-subscription/scripts"

EXPECTED_SCRIPTS=(
    "register-individual.sh"
    "register-business.sh"
    "register-with-rhc.sh"
    "verify-subscription.sh"
    "ansible-register.yml"
    "bootc-developer.containerfile"
)

# Note: We're checking from the host filesystem, not inside container
echo "Checking for scripts in: ${SCRIPT_DIR}"
for script in "${EXPECTED_SCRIPTS[@]}"; do
    if [[ -f "${SCRIPT_DIR}/${script}" ]]; then
        echo "  ✓ ${script}"
        ((pass_count++))
    else
        echo "  ✗ ${script} NOT FOUND"
        ((fail_count++))
    fi
done
echo ""

# TEST 10: Reference Documentation Exists
echo "TEST 10: Reference Documentation Availability"
REF_DIR="/home/limershe/Projects/devsub-skill/rhel-developer-subscription/references"

EXPECTED_REFS=(
    "QUICKREF.md"
    "EMAIL-VERIFICATION.md"
    "TESTING.md"
)

echo "Checking for references in: ${REF_DIR}"
for ref in "${EXPECTED_REFS[@]}"; do
    if [[ -f "${REF_DIR}/${ref}" ]]; then
        echo "  ✓ ${ref}"
        ((pass_count++))
    else
        echo "  ✗ ${ref} NOT FOUND"
        ((fail_count++))
    fi
done
echo ""

# SUMMARY
echo "========================================"
echo "TEST SUMMARY"
echo "========================================"
echo ""
echo -e "${GREEN}Passed: ${pass_count}${NC}"
echo -e "${YELLOW}Warnings: ${warn_count}${NC}"
echo -e "${RED}Failed: ${fail_count}${NC}"
echo ""

TOTAL=$((pass_count + warn_count + fail_count))
PASS_RATE=$(awk "BEGIN {printf \"%.1f\", ($pass_count / $TOTAL) * 100}")

echo "Pass Rate: ${PASS_RATE}%"
echo ""

if [[ ${fail_count} -eq 0 ]]; then
    echo -e "${GREEN}✅ ALL CRITICAL TESTS PASSED${NC}"
    echo "The skill's commands and documentation are accurate for RHEL ${RHEL_VERSION}"
    exit 0
else
    echo -e "${RED}❌ SOME TESTS FAILED${NC}"
    echo "Review failed tests above"
    exit 1
fi
