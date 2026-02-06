# MuleSoft Integration Platform

Enterprise integration platform built on MuleSoft Anypoint, connecting Salesforce, NetSuite, Slack, JIRA, and GitHub through MCP-enabled AI agents.

## Architecture

```
┌──────────┐   ┌──────────┐   ┌──────────┐
│Salesforce │   │ NetSuite │   │  Slack   │
└─────┬─────┘   └─────┬─────┘   └─────┬────┘
      │               │               │
      ▼               ▼               ▼
┌─────────────────────────────────────────────┐
│        MuleSoft Anypoint Platform           │
│  ┌─────────┐ ┌──────────┐ ┌─────────────┐  │
│  │ MCP     │ │ Customer │ │ Inventory   │  │
│  │ Servers │ │ API      │ │ Service     │  │
│  └─────────┘ └──────────┘ └─────────────┘  │
└─────────────────────────────────────────────┘
```

## Projects

| Application | Status | Environment | Description |
|-------------|--------|-------------|-------------|
| mcp-multi | ✅ Running | Sandbox | Multi-tool MCP server (customer search, invoices, docs) |
| jira-mcp-server | 🔄 In Dev | Sandbox | JIRA Cloud integration MCP tools |
| github-mcp-server | 🔄 In Dev | Sandbox | GitHub integration MCP tools |
| mcp-cases-priority | ✅ Running | Sandbox | Salesforce case management |
| customer-onboarding-agent | ✅ Running | Sandbox | Agent Broker for onboarding |

## Getting Started

### Prerequisites
- MuleSoft Anypoint Studio 7.x+
- Java 17
- Maven 3.9+
- Anypoint Platform account with Sandbox environment

### Local Development
```bash
git clone https://github.com/YOUR_ORG/mulesoft-integration-platform.git
cd mulesoft-integration-platform
mvn clean package
mvn mule:run
```

### Deployment
```bash
mvn clean deploy -DmuleDeploy -Denvironment=Sandbox
```

## Team

- **Frank Salas** - Solutions Engineer, MuleSoft
- Integration Architecture & MCP Server Development

## License

Internal use only - MuleSoft / Salesforce
