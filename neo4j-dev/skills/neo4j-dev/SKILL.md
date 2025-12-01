---
description: Neo4j graph database development including data modeling and Cypher query optimization
---

# Neo4j Development Skill

Comprehensive toolkit for Neo4j graph database development, integrating with MCP servers for schema management, query execution, and data modeling.

## When to Use

- Designing graph data models for Neo4j
- Writing or optimizing Cypher queries
- Reviewing existing Neo4j schema
- Working with graph database patterns
- Analyzing query performance

## MCP Servers

### mcp-neo4j-cypher

Query execution and schema retrieval.

| Tool | Description | Parameters |
|------|-------------|------------|
| `get_neo4j_schema` | Retrieve database schema | `sample_param` (optional) |
| `read_neo4j_cypher` | Execute read queries | `query`, `params` (optional) |
| `write_neo4j_cypher` | Execute write queries | `query`, `params` (optional) |

### mcp-neo4j-data-modeling

Graph data model design and validation.

| Tool | Description |
|------|-------------|
| `validate_node` | Validate node definitions |
| `validate_relationship` | Validate relationship definitions |
| `validate_data_model` | Validate complete data model |
| `get_mermaid_config_str` | Generate Mermaid diagram |
| `load_from_arrows_json` | Import from Arrows.app |
| `export_to_arrows_json` | Export to Arrows.app |

## Available Agents

| Agent | Use When |
|-------|----------|
| `graph-modeler` | Designing new graph data models from domain requirements |
| `cypher-developer` | Writing, optimizing, or debugging Cypher queries |
| `schema-analyst` | Reviewing existing schema for issues and optimization opportunities |

## Reference Index

Load these references as needed for detailed knowledge:

| Reference | Description | Load When |
|-----------|-------------|-----------|
| `references/modeling-patterns.md` | Graph modeling patterns and anti-patterns | Designing data models |
| `references/cypher-best-practices.md` | Cypher syntax patterns and conventions | Writing queries |
| `references/index-strategies.md` | Index types and selection strategies | Creating indexes |
| `references/query-optimization.md` | EXPLAIN/PROFILE and optimization techniques | Optimizing slow queries |

## Quick Reference

### Cypher Patterns

```cypher
// Use parameters for query caching
MATCH (n:Person {name: $name}) RETURN n

// Early filtering reduces working set
MATCH (n:Person)
WHERE n.age > 30
WITH n
MATCH (n)-[:KNOWS]->(friend)
RETURN friend

// Always bound variable-length patterns
MATCH path = (n)-[:KNOWS*1..5]-(m)
RETURN path LIMIT 100
```

### Modeling Principles

- **Nodes**: Nouns (Person, Product, Order)
- **Relationships**: Verbs (KNOWS, PURCHASED, REVIEWED)
- **Properties**: Attributes that don't need traversal
- **Intermediate nodes**: For complex many-to-many with properties

### Index Types

| Type | Use Case |
|------|----------|
| Range | Equality, range, prefix queries |
| Composite | Multi-property filters |
| Text | CONTAINS, ENDS WITH |
| Full-Text | Fuzzy search with scoring |
