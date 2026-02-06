# API Documentation

## Customer API

Base URL: `https://{app-name}.{region}.cloudhub.io/api`

### Endpoints

#### List Customers
```
GET /api/customers?limit=50&offset=0
```
Returns active customers with pagination.

**Response:**
```json
{
    "count": 2,
    "customers": [
        {
            "id": "CUST-001",
            "firstName": "Jane",
            "lastName": "Smith",
            "email": "jane.smith@acme.com",
            "company": "Acme Corp",
            "status": "active"
        }
    ]
}
```

#### Get Customer by ID
```
GET /api/customers/{customerId}
```

#### Create Customer
```
POST /api/customers
Content-Type: application/json

{
    "firstName": "John",
    "lastName": "Doe",
    "email": "john@example.com",
    "company": "Example Inc",
    "address": {
        "street": "123 Main St",
        "city": "Atlanta",
        "state": "GA",
        "zipCode": "30301",
        "country": "US"
    }
}
```

> **Known Issue**: Address field is required but no validation exists yet.
> Null addresses cause a DataWeave transformation error. See INTG-4.

---

## Inventory API

#### Check Inventory
```
GET /api/inventory/{materialNo}
```

**Response:**
```json
{
    "materialNo": "MAT-10001",
    "sku": "WIDGET-A",
    "name": "Premium Widget A",
    "quantityOnHand": 1250,
    "quantityAvailable": 980,
    "source": "cache",
    "lastUpdated": "2026-02-05T10:30:00Z"
}
```

> **Known Issue**: Cache TTL is 4 hours, causing stale inventory data.
> Fix in progress - see INTG-7.

---

## MCP Server Endpoints

All MCP servers expose tools via Streamable HTTP transport at `/mcp`.

| Server | URL | Tools |
|--------|-----|-------|
| MCP Multi | `/mcp` | findCustomersByName, get_inventory, get_invoice_details, search_docs |
| JIRA MCP | `/mcp` | jira_search_issues, jira_get_issue, jira_create_issue, + 4 more |
| GitHub MCP | `/mcp` | github_search_repos, github_list_issues, github_create_issue, + 5 more |
| Cases Priority | `/mcp` | get-priority-cases |

---

## Error Codes

| HTTP Status | Meaning |
|-------------|---------|
| 200 | Success |
| 201 | Created |
| 400 | Bad Request - Invalid parameters |
| 401 | Unauthorized - Check credentials |
| 404 | Not Found |
| 429 | Rate Limited - Back off and retry |
| 500 | Server Error - Check CloudHub logs |
| 503 | Service Unavailable - App may be starting |
