#!/bin/bash
#
# validate.sh
# Validates the RHEL Developer Subscription skill structure and files
#
# Usage: ./validate.sh
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${SCRIPT_DIR}"

echo "=== RHEL Developer Subscription Skill Validation ==="
echo ""

ERRORS=0
WARNINGS=0

# Color codes
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

error() {
    echo -e "${RED}✗ ERROR: $1${NC}"
    ((ERRORS++))
}

warning() {
    echo -e "${YELLOW}⚠ WARNING: $1${NC}"
    ((WARNINGS++))
}

success() {
    echo -e "${GREEN}✓ $1${NC}"
}

info() {
    echo "ℹ $1"
}

# Check 1: Required files exist
echo "📋 Checking required files..."
REQUIRED_FILES=(
    "README.md"
    "INTEGRATION.md"
    "SUMMARY.md"
    "LICENSE"
    ".gitignore"
    "rhel-developer-subscription/SKILL.md"
    "rhel-developer-subscription/README.md"
    "rhel-developer-subscription/TESTING.md"
    "rhel-developer-subscription/QUICKREF.md"
    "rhel-developer-subscription/VERSION"
    "rhel-developer-subscription/examples/register-individual.sh"
    "rhel-developer-subscription/examples/register-business.sh"
    "rhel-developer-subscription/examples/verify-subscription.sh"
    "rhel-developer-subscription/examples/ansible-register.yml"
    "rhel-developer-subscription/examples/bootc-developer.containerfile"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [[ -f "${file}" ]]; then
        success "${file}"
    else
        error "Missing file: ${file}"
    fi
done
echo ""

# Check 2: Scripts are executable
echo "📋 Checking script permissions..."
SCRIPTS=(
    "rhel-developer-subscription/examples/register-individual.sh"
    "rhel-developer-subscription/examples/register-business.sh"
    "rhel-developer-subscription/examples/verify-subscription.sh"
)

for script in "${SCRIPTS[@]}"; do
    if [[ -x "${script}" ]]; then
        success "${script} is executable"
    else
        warning "${script} is not executable (chmod +x needed)"
    fi
done
echo ""

# Check 3: SKILL.md has valid frontmatter
echo "📋 Checking SKILL.md frontmatter..."
SKILL_FILE="rhel-developer-subscription/SKILL.md"

if grep -q "^---$" "${SKILL_FILE}"; then
    success "SKILL.md has YAML frontmatter"

    # Check for required frontmatter fields
    if grep -q "^name:" "${SKILL_FILE}"; then
        NAME=$(grep "^name:" "${SKILL_FILE}" | head -1 | cut -d: -f2- | xargs)
        success "name: ${NAME}"
    else
        error "SKILL.md missing 'name' in frontmatter"
    fi

    if grep -q "^description:" "${SKILL_FILE}"; then
        success "description field present"
    else
        error "SKILL.md missing 'description' in frontmatter"
    fi

    if grep -q "^version:" "${SKILL_FILE}"; then
        VERSION=$(grep "^version:" "${SKILL_FILE}" | head -1 | cut -d: -f2- | xargs)
        success "version: ${VERSION}"
    else
        error "SKILL.md missing 'version' in frontmatter"
    fi

    if grep -q "^triggers:" "${SKILL_FILE}"; then
        success "triggers field present"
    else
        warning "SKILL.md missing 'triggers' in frontmatter (optional but recommended)"
    fi
else
    error "SKILL.md missing YAML frontmatter (should start with '---')"
fi
echo ""

# Check 4: Shell scripts syntax
echo "📋 Checking shell script syntax..."
for script in "${SCRIPTS[@]}"; do
    if bash -n "${script}" 2>/dev/null; then
        success "${script} syntax OK"
    else
        error "${script} has syntax errors"
    fi
done
echo ""

# Check 5: Ansible playbook syntax
echo "📋 Checking Ansible playbook..."
PLAYBOOK="rhel-developer-subscription/examples/ansible-register.yml"

if command -v ansible-playbook &>/dev/null; then
    if ansible-playbook --syntax-check "${PLAYBOOK}" &>/dev/null; then
        success "${PLAYBOOK} syntax OK"
    else
        error "${PLAYBOOK} has syntax errors"
    fi
else
    warning "ansible-playbook not installed, skipping playbook validation"
fi
echo ""

# Check 6: Containerfile syntax
echo "📋 Checking Containerfile..."
CONTAINERFILE="rhel-developer-subscription/examples/bootc-developer.containerfile"

if grep -q "^FROM " "${CONTAINERFILE}"; then
    success "${CONTAINERFILE} has FROM instruction"
else
    error "${CONTAINERFILE} missing FROM instruction"
fi

if grep -q "registry.redhat.io" "${CONTAINERFILE}"; then
    success "${CONTAINERFILE} uses Red Hat registry"
else
    warning "${CONTAINERFILE} doesn't use Red Hat registry (may be intentional)"
fi
echo ""

# Check 7: Documentation completeness
echo "📋 Checking documentation..."

# README should mention both subscription types
if grep -qi "developer for individuals" README.md && grep -qi "developer suite for business" README.md; then
    success "README.md mentions both subscription types"
else
    warning "README.md should mention both Individual and Business subscriptions"
fi

# TESTING.md should have test cases
TEST_COUNT=$(grep -c "^### Test [0-9]" rhel-developer-subscription/TESTING.md || echo "0")
if [[ ${TEST_COUNT} -ge 5 ]]; then
    success "TESTING.md has ${TEST_COUNT} test cases"
else
    warning "TESTING.md has only ${TEST_COUNT} test cases (expected 5+)"
fi

# QUICKREF should have common commands
if grep -q "subscription-manager" rhel-developer-subscription/QUICKREF.md; then
    success "QUICKREF.md has subscription-manager commands"
else
    warning "QUICKREF.md should include subscription-manager commands"
fi
echo ""

# Check 8: Security - no credentials in files
echo "📋 Checking for credentials..."
if grep -r "password\s*=\s*['\"]" --include="*.sh" --include="*.yml" . ; then
    error "Found hardcoded passwords in scripts"
else
    success "No hardcoded passwords found"
fi

if grep -r "activationkey\s*=\s*['\"][^$]" --include="*.sh" --include="*.yml" . ; then
    error "Found hardcoded activation keys in scripts"
else
    success "No hardcoded activation keys found"
fi
echo ""

# Check 9: RHEL compliance
echo "📋 Checking RHEL compliance..."

# Should use dnf, not apt
if grep -r "apt\s" --include="*.sh" --include="*.yml" --include="*.md" rhel-developer-subscription/ ; then
    error "Found 'apt' commands (should use 'dnf' for RHEL)"
else
    success "No apt commands found (dnf compliance)"
fi

# Should use podman, not docker
if grep -r "\bdocker\b" --include="*.sh" --include="*.yml" rhel-developer-subscription/examples/ ; then
    warning "Found 'docker' references (prefer 'podman' for RHEL)"
else
    success "No docker commands in examples (podman compliance)"
fi

# Should use subscription-manager
if grep -q "subscription-manager" rhel-developer-subscription/SKILL.md; then
    success "Uses subscription-manager (RHEL standard)"
else
    error "SKILL.md doesn't mention subscription-manager"
fi
echo ""

# Check 10: Line count statistics
echo "📋 File statistics..."
SKILL_LINES=$(wc -l < rhel-developer-subscription/SKILL.md)
TESTING_LINES=$(wc -l < rhel-developer-subscription/TESTING.md)

info "SKILL.md: ${SKILL_LINES} lines"
info "TESTING.md: ${TESTING_LINES} lines"

if [[ ${SKILL_LINES} -gt 100 ]]; then
    success "SKILL.md is comprehensive (${SKILL_LINES} lines)"
else
    warning "SKILL.md seems short (${SKILL_LINES} lines)"
fi
echo ""

# Summary
echo "=== Validation Summary ==="
echo ""

if [[ ${ERRORS} -eq 0 && ${WARNINGS} -eq 0 ]]; then
    echo -e "${GREEN}✓ All checks passed! Skill is ready.${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Test scripts on a RHEL system"
    echo "  2. Review INTEGRATION.md for TAILWIND integration"
    echo "  3. Run test suite from TESTING.md"
    exit 0
elif [[ ${ERRORS} -eq 0 ]]; then
    echo -e "${YELLOW}⚠ Validation passed with ${WARNINGS} warning(s)${NC}"
    echo ""
    echo "Review warnings above. Skill is likely usable but may need adjustments."
    exit 0
else
    echo -e "${RED}✗ Validation failed with ${ERRORS} error(s) and ${WARNINGS} warning(s)${NC}"
    echo ""
    echo "Fix errors above before using this skill."
    exit 1
fi
