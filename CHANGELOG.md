# Changelog

All notable changes to the MuleSoft Integration Platform.

## [Unreleased]

### Added
- JIRA MCP Server with 7 tools (search, get, create, update, comment, transition, projects)
- GitHub MCP Server with 8 tools (repos, issues, PRs, commits, file contents)
- Slack bot integration with Claude API and MCP servers

### Fixed
- Customer API now handles missing address fields gracefully (INTG-4)

### Changed
- Inventory cache TTL reduced from 4 hours to 30 minutes (INTG-7)

---

## [1.2.0] - 2026-01-24

### Added
- MCP Multi server with customer search, invoice lookup, inventory check, and doc search
- Salesforce case priority MCP tool
- Employee onboarding agent via Agent Broker

### Fixed
- CloudHub 2.0 deployment URL mismatch between environments
- DataWeave null handling in customer lookup

---

## [1.1.0] - 2026-01-17

### Added
- Customer API with CRUD operations
- Inventory sync scheduler (NetSuite → Object Store)
- Global error handler

### Known Issues
- Inventory cache TTL too aggressive (4 hours) - stale data reported
- Customer creation fails when address is null

---

## [1.0.0] - 2025-12-01

### Added
- Initial project setup
- HTTP listener configuration
- Database connector configuration
- CI/CD pipeline via GitHub Actions
- Basic CloudHub 2.0 deployment
