#!/bin/bash
# ============================================================
# GitHub Sample Data Seed Script
# ============================================================
# Creates labels, issues, and milestones in your GitHub repo
# for testing the GitHub MCP Server.
#
# Usage:
#   export GITHUB_TOKEN=ghp_your_token_here
#   export GITHUB_OWNER=your-username
#   export GITHUB_REPO=mulesoft-integration-platform
#   chmod +x seed-github-data.sh
#   ./seed-github-data.sh
# ============================================================

set -e

API="https://api.github.com"
AUTH="Authorization: Bearer ${GITHUB_TOKEN}"
ACCEPT="Accept: application/vnd.github.v3+json"

echo "================================================"
echo "  GitHub Sample Data Seeder"
echo "  Repo: ${GITHUB_OWNER}/${GITHUB_REPO}"
echo "================================================"
echo ""

# ---- Create Labels ----
echo "📌 Creating labels..."

declare -A LABELS
LABELS[bug]="d73a4a"
LABELS[enhancement]="a2eeef"
LABELS[documentation]="0075ca"
LABELS[mcp-server]="5319e7"
LABELS[cloudhub]="006b75"
LABELS[salesforce]="00a1e0"
LABELS[netsuite]="1e3a5f"
LABELS[dataweave]="ff9800"
LABELS[ci-cd]="2ea44f"
LABELS[slack-integration]="4a154b"
LABELS[jira-sync]="0052cc"
LABELS[performance]="fbca04"
LABELS[security]="e11d48"
LABELS[priority-high]="b60205"
LABELS[priority-medium]="fbca04"
LABELS[priority-low]="0e8a16"
LABELS[good-first-issue]="7057ff"

for label in "${!LABELS[@]}"; do
    echo "  Creating label: $label"
    curl -s -X POST "${API}/repos/${GITHUB_OWNER}/${GITHUB_REPO}/labels" \
        -H "${AUTH}" -H "${ACCEPT}" -H "Content-Type: application/json" \
        -d "{\"name\":\"${label}\",\"color\":\"${LABELS[$label]}\"}" > /dev/null 2>&1 || true
done
echo "  ✅ Labels created"
echo ""

# ---- Create Milestone ----
echo "🎯 Creating milestones..."

curl -s -X POST "${API}/repos/${GITHUB_OWNER}/${GITHUB_REPO}/milestones" \
    -H "${AUTH}" -H "${ACCEPT}" -H "Content-Type: application/json" \
    -d '{
        "title": "v2.0 - MCP Agent Platform",
        "description": "Full MCP agent platform with JIRA, GitHub, and Slack integration",
        "due_on": "2026-03-31T00:00:00Z"
    }' > /dev/null 2>&1 || true

curl -s -X POST "${API}/repos/${GITHUB_OWNER}/${GITHUB_REPO}/milestones" \
    -H "${AUTH}" -H "${ACCEPT}" -H "Content-Type: application/json" \
    -d '{
        "title": "v1.5 - Bug Fixes & Stability",
        "description": "Address known bugs and improve reliability",
        "due_on": "2026-02-28T00:00:00Z"
    }' > /dev/null 2>&1 || true

echo "  ✅ Milestones created"
echo ""

# ---- Create Issues ----
echo "🐛 Creating issues..."

# Issue 1 - Bug
curl -s -X POST "${API}/repos/${GITHUB_OWNER}/${GITHUB_REPO}/issues" \
    -H "${AUTH}" -H "${ACCEPT}" -H "Content-Type: application/json" \
    -d '{
        "title": "[BUG] DataWeave null pointer in customer-api.xml when address is missing",
        "body": "## Description\nThe `create-customer-flow` in `customer-api.xml` throws a null pointer when a customer is created without an address object.\n\n## Steps to Reproduce\n1. POST to `/api/customers` with no `address` field\n2. Observe 500 error\n\n## Expected\nCustomer created with null/empty address\n\n## Actual\n`NullPointerException` in DataWeave transformation at line 45\n\n## Related\n- JIRA: INTG-4\n- File: `src/main/mule/customer-api.xml`\n\n## Suggested Fix\nAdd null safety: `payload.address.street default \"\"` or use conditional field mapping.",
        "labels": ["bug", "dataweave", "priority-high"],
        "milestone": 2
    }' > /dev/null 2>&1
echo "  Created: [BUG] DataWeave null pointer"

# Issue 2 - Bug
curl -s -X POST "${API}/repos/${GITHUB_OWNER}/${GITHUB_REPO}/issues" \
    -H "${AUTH}" -H "${ACCEPT}" -H "Content-Type: application/json" \
    -d '{
        "title": "[BUG] Inventory cache TTL causing stale data (4 hour delay)",
        "body": "## Description\nThe inventory sync Object Store cache has a 4-hour TTL, causing customers to see stale inventory levels.\n\n## Impact\nCustomers placing orders based on outdated stock data. Multiple complaints received.\n\n## Root Cause\nIn `inventory-sync.xml`, the Object Store is configured with:\n```xml\n<os:object-store name=\"Inventory_Cache\" entryTtl=\"4\" entryTtlUnit=\"HOURS\"/>\n```\n\n## Fix\nReduce TTL to 30 minutes:\n```xml\n<os:object-store name=\"Inventory_Cache\" entryTtl=\"30\" entryTtlUnit=\"MINUTES\"/>\n```\n\n## Related\n- JIRA: INTG-7\n- File: `src/main/mule/inventory-sync.xml`",
        "labels": ["bug", "netsuite", "performance", "priority-high"],
        "milestone": 2
    }' > /dev/null 2>&1
echo "  Created: [BUG] Inventory cache TTL"

# Issue 3 - Enhancement
curl -s -X POST "${API}/repos/${GITHUB_OWNER}/${GITHUB_REPO}/issues" \
    -H "${AUTH}" -H "${ACCEPT}" -H "Content-Type: application/json" \
    -d '{
        "title": "[FEATURE] Add GitHub webhook listener for auto JIRA updates",
        "body": "## Problem\nWhen PRs are merged or issues are closed in GitHub, there is no automatic update to the corresponding JIRA tickets.\n\n## Proposed Solution\nCreate a Mule flow that:\n1. Listens for GitHub webhook events (push, PR merge, issue close)\n2. Parses the event payload for JIRA ticket references (e.g., INTG-123)\n3. Automatically adds a comment or transitions the JIRA ticket\n\n## Systems Involved\n- GitHub (webhooks)\n- JIRA Cloud (REST API)\n- MuleSoft (CloudHub 2.0)\n\n## Acceptance Criteria\n- [ ] Webhook listener deployed and receiving events\n- [ ] JIRA tickets auto-commented on PR merge\n- [ ] JIRA tickets auto-transitioned to Done on branch merge to main\n- [ ] Error handling and retry logic\n\n## Related\n- JIRA: INTG-3",
        "labels": ["enhancement", "jira-sync", "mcp-server"],
        "milestone": 1
    }' > /dev/null 2>&1
echo "  Created: [FEATURE] GitHub webhook listener"

# Issue 4 - Enhancement
curl -s -X POST "${API}/repos/${GITHUB_OWNER}/${GITHUB_REPO}/issues" \
    -H "${AUTH}" -H "${ACCEPT}" -H "Content-Type: application/json" \
    -d '{
        "title": "[FEATURE] Implement rate limiting on all MCP endpoints",
        "body": "## Problem\nMCP server endpoints have no rate limiting, making them vulnerable to abuse and potentially overloading downstream systems (Salesforce, NetSuite, JIRA).\n\n## Proposed Solution\nAdd API Manager rate limiting policies:\n- 100 requests/minute per client for read operations\n- 20 requests/minute per client for write operations\n- Return 429 with Retry-After header when exceeded\n\n## Implementation Options\n1. Apply rate limiting policy via API Manager\n2. Implement custom rate limiting using Object Store counters\n3. Use CloudHub 2.0 built-in DDoS protection + custom policy\n\n## Related\n- JIRA: INTG-6",
        "labels": ["enhancement", "security", "mcp-server", "priority-medium"],
        "milestone": 1
    }' > /dev/null 2>&1
echo "  Created: [FEATURE] Rate limiting"

# Issue 5 - CI/CD
curl -s -X POST "${API}/repos/${GITHUB_OWNER}/${GITHUB_REPO}/issues" \
    -H "${AUTH}" -H "${ACCEPT}" -H "Content-Type: application/json" \
    -d '{
        "title": "[FEATURE] Set up CI/CD pipeline for automated MCP server deployments",
        "body": "## Goal\nAutomate build, test, and deployment of all MCP server applications using GitHub Actions.\n\n## Pipeline Stages\n1. **Build**: `mvn clean package` on every PR\n2. **Test**: Run MUnit tests\n3. **Deploy to Sandbox**: Auto-deploy on merge to `develop`\n4. **Deploy to Production**: Auto-deploy on merge to `main` (with approval gate)\n5. **Notify**: Slack notification on success/failure\n\n## Status\n- [x] Basic workflow file created (`.github/workflows/ci-cd.yml`)\n- [ ] Add MUnit test step\n- [ ] Configure Anypoint Platform credentials as GitHub Secrets\n- [ ] Add approval gate for production\n- [ ] Test end-to-end\n\n## Related\n- JIRA: INTG-5",
        "labels": ["enhancement", "ci-cd", "good-first-issue"],
        "milestone": 1
    }' > /dev/null 2>&1
echo "  Created: [FEATURE] CI/CD pipeline"

# Issue 6 - Slack integration
curl -s -X POST "${API}/repos/${GITHUB_OWNER}/${GITHUB_REPO}/issues" \
    -H "${AUTH}" -H "${ACCEPT}" -H "Content-Type: application/json" \
    -d '{
        "title": "[FEATURE] Slack notification flow for deployment failures",
        "body": "## Problem\nWhen CloudHub 2.0 deployments fail, the team has no immediate notification.\n\n## Proposed Solution\nCreate a Mule flow that monitors deployment events and posts to `#engineering-alerts` Slack channel.\n\n## Details\n- Monitor CloudHub deployment status changes\n- Filter for FAILED status\n- Post formatted Slack message with:\n  - App name\n  - Environment\n  - Error message\n  - Link to CloudHub logs\n  - Timestamp\n\n## Related\n- JIRA: INTG-8",
        "labels": ["enhancement", "slack-integration", "cloudhub", "priority-low"],
        "milestone": 1
    }' > /dev/null 2>&1
echo "  Created: [FEATURE] Slack deployment notifications"

# Issue 7 - Documentation
curl -s -X POST "${API}/repos/${GITHUB_OWNER}/${GITHUB_REPO}/issues" \
    -H "${AUTH}" -H "${ACCEPT}" -H "Content-Type: application/json" \
    -d '{
        "title": "[DOCS] Document all MCP server tool contracts and schemas",
        "body": "## Need\nComprehensive documentation for all MCP server tools including:\n- Tool name and description\n- Input parameter JSON schemas\n- Example request/response payloads\n- Error codes and handling\n- Rate limits and constraints\n\n## Servers to Document\n- [ ] MCP Multi (4 tools)\n- [ ] JIRA MCP Server (7 tools)\n- [ ] GitHub MCP Server (8 tools)\n- [ ] Cases Priority MCP (1 tool)\n\n## Deliverable\nUpdate `docs/API.md` with complete MCP tool documentation.\n\n## Related\n- JIRA: INTG-9",
        "labels": ["documentation", "mcp-server", "good-first-issue"],
        "milestone": 1
    }' > /dev/null 2>&1
echo "  Created: [DOCS] MCP tool documentation"

# Issue 8 - Bug
curl -s -X POST "${API}/repos/${GITHUB_OWNER}/${GITHUB_REPO}/issues" \
    -H "${AUTH}" -H "${ACCEPT}" -H "Content-Type: application/json" \
    -d '{
        "title": "[BUG] API Gateway timeout on CloudHub 2.0 with large payloads",
        "body": "## Description\nThe API gateway times out after 30 seconds when processing payloads > 5MB through the CloudHub 2.0 proxy.\n\n## Impact\nAffects customer onboarding flow when processing large document uploads.\n\n## Environment\n- CloudHub 2.0, US-East-2\n- Mule Runtime 4.9.6\n- Replica: 0.1 vCores\n\n## Possible Fixes\n1. Increase timeout configuration\n2. Implement streaming for large payloads\n3. Upgrade replica size\n4. Implement chunked upload pattern\n\n## Related\n- JIRA: INTG-1",
        "labels": ["bug", "cloudhub", "performance", "priority-high"],
        "milestone": 2
    }' > /dev/null 2>&1
echo "  Created: [BUG] API Gateway timeout"

# Issue 9 - Enhancement
curl -s -X POST "${API}/repos/${GITHUB_OWNER}/${GITHUB_REPO}/issues" \
    -H "${AUTH}" -H "${ACCEPT}" -H "Content-Type: application/json" \
    -d '{
        "title": "[FEATURE] Bidirectional Salesforce case sync with JIRA",
        "body": "## Problem\nSupport teams in Salesforce cannot see engineering progress in JIRA, and engineers cannot see customer context from cases.\n\n## Proposed Solution\nBidirectional sync:\n- Salesforce Case created → Auto-create JIRA issue\n- JIRA status change → Update Salesforce Case status\n- Comments synced both ways\n- Priority mapping between systems\n\n## Mapping\n| Salesforce | JIRA |\n|-----------|------|\n| Case.Subject | Issue.Summary |\n| Case.Description | Issue.Description |\n| Case.Priority=High | Issue.Priority=High |\n| Case.Status=Escalated | Issue.Status=In Progress |\n\n## Related\n- JIRA: INTG-2",
        "labels": ["enhancement", "salesforce", "jira-sync", "priority-high"],
        "milestone": 1
    }' > /dev/null 2>&1
echo "  Created: [FEATURE] Salesforce-JIRA sync"

# Issue 10 - Upgrade
curl -s -X POST "${API}/repos/${GITHUB_OWNER}/${GITHUB_REPO}/issues" \
    -H "${AUTH}" -H "${ACCEPT}" -H "Content-Type: application/json" \
    -d '{
        "title": "[UPGRADE] Mule Runtime 4.10.x across all CloudHub apps",
        "body": "## Goal\nUpgrade all CloudHub 2.0 applications from Mule 4.9.x to 4.10.x.\n\n## Benefits\n- Improved performance\n- New connector features\n- Security patches\n- MCP Connector 1.3+ compatibility\n\n## Applications to Upgrade\n- [ ] mcp-multi (currently 4.10.2 ✅)\n- [ ] mcp-cases-priority (currently 4.10.2 ✅)\n- [ ] customer-onboarding-agent (currently 4.10.2 ✅)\n- [ ] cust-2025-api (currently 4.9.12 ⚠️)\n- [ ] lightedgecust (currently 4.9.12 ⚠️)\n- [ ] american-ws-mule (currently 4.8.5 ⚠️⚠️)\n\n## Testing Plan\n1. Upgrade in Sandbox first\n2. Run regression tests\n3. Monitor for 48 hours\n4. Promote to Production\n\n## Related\n- JIRA: INTG-10",
        "labels": ["enhancement", "cloudhub", "priority-medium"],
        "milestone": 1
    }' > /dev/null 2>&1
echo "  Created: [UPGRADE] Mule Runtime 4.10.x"

echo ""
echo "  ✅ All 10 issues created"
echo ""

echo "================================================"
echo "  ✅ Seeding complete!"
echo ""
echo "  Created:"
echo "    - 17 labels"
echo "    - 2 milestones"
echo "    - 10 issues (3 bugs, 6 features, 1 docs)"
echo ""
echo "  Test your GitHub MCP Server with queries like:"
echo "    - 'List open issues in my repo'"
echo "    - 'Show me all bugs with priority-high label'"
echo "    - 'Get details on issue #1'"
echo "    - 'What are the recent commits?'"
echo "    - 'Show me the inventory-sync.xml file'"
echo "================================================"
