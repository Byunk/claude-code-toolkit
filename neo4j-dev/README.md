# Neo4j Development Plugin

Comprehensive toolkit for Neo4j graph database development, covering graph data modeling and Cypher query development with MCP server integration.

## Features

- **Graph Data Modeling**: Design and validate graph schemas with best practices
- **Cypher Query Development**: Write and optimize Cypher queries
- **Schema Analysis**: Review existing databases for optimization opportunities
- **MCP Integration**: Works with `mcp-neo4j-cypher` and `mcp-neo4j-data-modeling` servers

## Prerequisites

### MCP Server Setup

Configure the Neo4j MCP servers in your Claude Code settings:

```json
{
  "mcpServers": {
    "neo4j-cypher": {
      "command": "uvx",
      "args": ["mcp-neo4j-cypher"],
      "env": {
        "NEO4J_URI": "bolt://localhost:7687",
        "NEO4J_USERNAME": "neo4j",
        "NEO4J_PASSWORD": "<your-password>"
      }
    },
    "neo4j-data-modeling": {
      "command": "uvx",
      "args": ["mcp-neo4j-data-modeling"]
    }
  }
}
```

## Available Agents

| Agent | Description |
|-------|-------------|
| `graph-modeler` | Designs graph data models based on domain requirements |
| `cypher-developer` | Writes and optimizes Cypher queries |
| `schema-analyst` | Analyzes existing schema for optimization opportunities |

## Skills

### `neo4j-dev`

The primary skill that triggers on Neo4j-related tasks. Contains:
- MCP tool reference
- Agent invocation guidance
- Quick reference patterns

**References** (lazy-loaded):
- `modeling-patterns.md` - Graph modeling patterns and anti-patterns
- `cypher-best-practices.md` - Cypher syntax and conventions
- `index-strategies.md` - Index types and strategies
- `query-optimization.md` - Query analysis and optimization

## Usage Examples

### Design a Graph Model

Ask Claude to design a graph model for your domain:

```
Design a graph model for an e-commerce system with users, products, orders, and reviews.
```

### Write Cypher Queries

Ask Claude to write or optimize queries:

```
Write a Cypher query to find all products purchased by users who also reviewed them with 5 stars.
```

### Review Schema

Ask Claude to analyze your existing database:

```
Review my Neo4j schema and identify optimization opportunities.
```

## MCP Tools Reference

### mcp-neo4j-cypher

| Tool | Description |
|------|-------------|
| `get_neo4j_schema` | Retrieve database schema (labels, types, properties, indexes) |
| `read_neo4j_cypher` | Execute read queries |
| `write_neo4j_cypher` | Execute write queries |

### mcp-neo4j-data-modeling

| Tool | Description |
|------|-------------|
| `validate_node` | Validate node definitions |
| `validate_relationship` | Validate relationship definitions |
| `validate_data_model` | Validate complete data model |
| `get_mermaid_config_str` | Generate Mermaid diagram |
| `load_from_arrows_json` | Import from Arrows.app |
| `export_to_arrows_json` | Export to Arrows.app |
