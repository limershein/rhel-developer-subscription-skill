# Changelog - RHEL Developer Subscription Skill

All notable changes to this skill will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-08-10

### Added
- Initial release of RHEL Developer Subscription skill
- Support for Red Hat Developer for Individuals (free subscription)
- Support for RHEL Developer Suite for Business (paid subscription)
- RHEL version auto-detection (8.x, 9.x, 10.x)
- Interactive registration scripts (individual, business, verification)
- Ansible playbook for fleet management
- bootc Containerfile example for image mode RHEL
- Comprehensive documentation (SKILL.md, README.md, TESTING.md, QUICKREF.md)
- 10 detailed test cases
- Validation script for skill structure
- Security best practices (no hardcoded credentials, activation key support)
- Error handling and troubleshooting guidance
- Email verification workflow documentation
- Integration guide for TAILWIND monorepo

### Features
- Agent Skills specification compliant
- RHEL development standards compliant (dnf, podman, subscription-manager)
- Multiple deployment methods (manual, Ansible, bootc, AI agent)
- Comprehensive error messages with actionable guidance
- Repository auto-enablement based on RHEL version
- Subscription health verification
- Network/proxy troubleshooting

### Documentation
- SKILL.md (490 lines) - Complete skill specification
- TESTING.md (551 lines) - Test cases and procedures
- README.md - Quick start and overview
- QUICKREF.md - Command reference card
- INTEGRATION.md - TAILWIND integration guide
- SUMMARY.md - Development summary and statistics
- EMAIL-VERIFICATION.md - Detailed email verification workflow
- MANIFEST.txt - File inventory
- CHANGELOG.md - This file

### Security
- No hardcoded credentials in any files
- Activation key support for automation
- Secrets management guidance
- Regular key rotation recommendations
- .gitignore for sensitive files
- Ansible no_log for passwords
- Credential cleanup in bootc images

### Scripts
- register-individual.sh (173 lines) - Individual subscription
- register-business.sh (263 lines) - Business subscription
- verify-subscription.sh (169 lines) - Health check
- ansible-register.yml (139 lines) - Fleet automation
- bootc-developer.containerfile - Image mode example
- validate.sh - Skill structure validation

### Compliance
- Agent Skills specification v1.0
- RHEL development standards (CLAUDE.md)
- MIT License
- Security best practices

## [Unreleased]

### Planned Features
- RHEL 11 support (when released)
- Satellite/Katello integration
- Subscription usage reports
- Auto-renewal checking
- Metrics and monitoring integration
- Additional language bindings (Python, Go)
- Web UI for guided registration

### Known Limitations
- Email verification cannot be automated (by design)
- Subscription propagation can take up to 10 minutes
- RHEL 7 not supported (EOL approaching)
- Requires network access to Red Hat services
- Proxy configuration must be manual

### Future Considerations
- Support for disconnected/air-gapped environments
- Integration with Red Hat Insights
- Subscription health monitoring
- Automated renewal reminders
- Multi-region deployment optimization

---

## Version History

- **1.0.0** (2026-08-10) - Initial production release

## Contributors

- Domain 0 / Products AI CoE
- TAILWIND Program
- Red Hat

## References

- [Agent Skills Specification](https://agentskills.io)
- [RHEL Subscription Management](https://access.redhat.com/documentation/en-us/red_hat_subscription_management)
- [Red Hat Developer Program](https://developers.redhat.com)
