# GitHub Sample Repository - Quick Start

## Step 1: Create the GitHub Repository

```bash
# Create a new repo on GitHub (via CLI or github.com)
gh repo create mulesoft-integration-platform --public --description "MuleSoft Integration Platform - MCP Agent Demo"

# Or create manually at https://github.com/new
#   Name: mulesoft-integration-platform
#   Visibility: Public (or Private)
```

## Step 2: Push the Sample Files

```bash
# Extract the sample repo archive
tar -xzf github-sample-repo.tar.gz
cd github-sample-repo

# Initialize and push
git init
git add .
git commit -m "Initial commit: MuleSoft integration platform with customer API, inventory sync, and CI/CD"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/mulesoft-integration-platform.git
git push -u origin main
```

## Step 3: Create a Feature Branch (for PR testing)

```bash
# Create a branch with a "fix" for testing PR tools
git checkout -b fix/inventory-cache-ttl

# Edit inventory-sync.xml - change TTL from 4 hours to 30 minutes
sed -i 's/entryTtl="4" entryTtlUnit="HOURS"/entryTtl="30" entryTtlUnit="MINUTES"/' src/main/mule/inventory-sync.xml

git add .
git commit -m "fix: reduce inventory cache TTL from 4 hours to 30 minutes

Addresses stale data issue reported in INTG-7.
Customers were seeing inventory levels up to 4 hours old.

Reduces Object Store TTL to 30 minutes for fresher data
while still providing cache benefits."

git push -u origin fix/inventory-cache-ttl

# Create a PR
gh pr create \
  --title "Fix: Reduce inventory cache TTL to 30 minutes (INTG-7)" \
  --body "## Summary
Reduces the inventory Object Store cache TTL from 4 hours to 30 minutes.

## Problem
Customers reported seeing stale inventory data. The 4-hour cache TTL meant stock levels could be significantly outdated.

## Changes
- \`inventory-sync.xml\`: Changed \`entryTtl\` from 4 HOURS to 30 MINUTES

## Testing
- [x] Verified cache expiry in local environment
- [x] Confirmed NetSuite API handles increased call volume
- [ ] Deploy to Sandbox for integration testing

## Related
- GitHub Issue: #2
- JIRA: INTG-7" \
  --label "bug,netsuite,performance"
```

## Step 4: Seed Issues, Labels, and Milestones

```bash
# Set your credentials
export GITHUB_TOKEN=ghp_your_token_here
export GITHUB_OWNER=your-username
export GITHUB_REPO=mulesoft-integration-platform

# Run the seed script
chmod +x seed-github-data.sh
./seed-github-data.sh
```

This creates:
- **17 custom labels** (bug, enhancement, mcp-server, cloudhub, salesforce, etc.)
- **2 milestones** (v2.0 MCP Agent Platform, v1.5 Bug Fixes)
- **10 issues** that cross-reference JIRA tickets:
  - 3 bugs (DataWeave null pointer, inventory cache, API timeout)
  - 6 feature requests (webhook listener, rate limiting, CI/CD, Slack alerts, SF-JIRA sync, runtime upgrade)
  - 1 documentation task

## Step 5: Test with GitHub MCP Server

Once your GitHub MCP Server is deployed, try these from Slack:

```
"List all open bugs in mulesoft-integration-platform"
→ github_list_issues with labels=bug

"Get details on issue #2 - the inventory cache bug"
→ github_get_issue for issue #2

"Show me open pull requests"
→ github_list_pull_requests

"What were the recent commits to main?"
→ github_list_commits

"Show me the inventory-sync.xml file"
→ github_get_file_contents for src/main/mule/inventory-sync.xml

"Create a bug for the login timeout issue"
→ github_create_issue with labels=[bug]
```

## Cross-System Demo Queries (JIRA + GitHub)

```
"Find all high-priority JIRA bugs and check if there are matching GitHub PRs"
→ jira_search_issues + github_list_pull_requests

"The inventory cache issue INTG-7 - show me the JIRA ticket and the GitHub fix"
→ jira_get_issue (INTG-7) + github_get_issue (#2) + github_list_pull_requests

"Create a JIRA bug for the API timeout and link the GitHub issue"
→ jira_create_issue + jira_add_comment with GitHub URL
```

## Repo Contents

```
mulesoft-integration-platform/
├── README.md                           # Project overview
├── CHANGELOG.md                        # Version history
├── .gitignore                          # Git ignore rules
├── .github/
│   ├── workflows/
│   │   └── ci-cd.yml                   # GitHub Actions pipeline
│   └── ISSUE_TEMPLATE/
│       ├── bug_report.md               # Bug template
│       └── feature_request.md          # Feature template
├── docs/
│   └── API.md                          # API documentation
├── src/main/
│   ├── mule/
│   │   ├── customer-api.xml            # Customer CRUD flows
│   │   ├── inventory-sync.xml          # NetSuite inventory sync (has known bug)
│   │   └── global-config.xml           # Global connectors
│   └── resources/
│       └── config-dev.properties       # Dev environment config
└── seed-github-data.sh                 # Script to populate issues/labels
```
