---
name: erd-skill
description: Comprehensive database design and ERD (Entity-Relationship Diagram) toolkit using DBML format. This skill should be used when creating database schemas from requirements, analyzing existing DBML files for improvements, designing database architecture, or providing guidance on database modeling, normalization, indexing, and relationships.
---

# ERD Design Skill

## Overview

This skill enables comprehensive database design and ERD creation using DBML (Database Markup Language) as the primary format. Use this skill for creating database schemas from natural language requirements, analyzing and improving existing DBML files, providing database design guidance, and ensuring best practices in data modeling.

## When to Use This Skill

Trigger this skill when users request:
- "Create an ERD for [system description]"
- "Design a database schema for [application]"
- "Analyze this DBML file and suggest improvements"
- "Help me design a database for [use case]"
- "Review my database schema"
- Working with `.dbml` files
- Database normalization, indexing, or relationship guidance

## Core Capabilities

### 1. Creating ERDs from Requirements

When creating a new database schema from requirements:

**Step 1: Understand Requirements**
- Identify entities (main data objects like users, products, orders)
- Determine attributes for each entity
- Identify relationships between entities
- Clarify business rules and constraints

**Step 2: Apply Design Principles**
- Use singular nouns for entity names in schema definitions
- Use plural nouns for table names (e.g., `Table users`)
- Apply appropriate normalization (usually 3NF)
- Define primary keys (auto-increment integers or UUIDs)
- Establish foreign key relationships
- Add appropriate indexes for query performance

**Step 3: Reference Templates**
For common patterns, reference or adapt from `templates/`:
- `basic.dbml` - Simple user-following system
- `advanced.dbml` - Complex e-commerce schema with products, orders, and users

**Step 4: Add Documentation**
- Include table notes explaining purpose
- Document column notes for complex fields
- Use TableGroups to organize related tables
- Document constraints and business rules

**Example Request:** "Create an ERD for a task management system"

**Approach:**
1. Identify core entities: users, projects, tasks, comments
2. Define relationships: users → projects (many-to-many), projects → tasks (one-to-many), tasks → comments (one-to-many)
3. Add timestamps, soft deletes, audit fields as needed
4. Create DBML schema with proper indexes and constraints
5. Organize with TableGroups

### 2. Analyzing Existing DBML Schemas

When analyzing an existing DBML file:

**Read and Parse**
- Load the DBML file to understand current structure
- Identify tables, relationships, indexes, and constraints

**Check Best Practices**
Reference `best-practices.md` to verify:
- Naming conventions (consistent snake_case, appropriate naming)
- Normalization level (typically 3NF, check for anomalies)
- Index strategy (foreign keys indexed, composite indexes optimized)
- Data types (appropriate for each field)
- Constraints (NOT NULL, unique, check constraints)
- Missing timestamps (created_at, updated_at)
- Relationship integrity (proper foreign keys, cascade rules)

**Identify Issues**
Common problems to look for:
- Missing indexes on foreign keys
- Missing unique constraints
- Inconsistent naming conventions
- Over-normalization or under-normalization
- Missing audit fields (created_at, updated_at)
- Unclear or missing documentation
- Circular dependencies
- Missing or incorrect relationship cardinality

**Provide Recommendations**
- Prioritize suggestions (critical, important, nice-to-have)
- Explain reasoning for each recommendation
- Provide concrete DBML code for improvements

### 3. Database Design Guidance

When providing database design advice:

**Normalization Decisions**
- Explain normalization levels (1NF, 2NF, 3NF) when relevant
- Guide when to denormalize for performance
- Balance normalization with query performance

**Indexing Strategy**
- Identify columns frequently used in WHERE, JOIN, ORDER BY clauses
- Recommend composite indexes for common query patterns
- Consider index trade-offs (read vs write performance)

**Relationship Patterns**
- One-to-Many: Foreign key in "many" table
- Many-to-Many: Junction table with composite primary key
- One-to-One: Unique foreign key or table merging
- Polymorphic: Include type discriminator column

**Common Patterns**
Reference patterns from `best-practices.md`:
- Timestamps (created_at, updated_at)
- Soft deletes (deleted_at)
- Audit trails (history tables)
- Versioning (version columns)
- Polymorphic associations

### 4. DBML Syntax Reference

When users need DBML syntax help, reference `DBML.md` which contains:
- Complete DBML syntax documentation
- Table, column, and relationship definitions
- Index and constraint syntax
- Enum definitions
- Note and documentation syntax
- TableGroup organization

Load this reference when:
- Users ask about specific DBML syntax
- Creating complex schemas with advanced features
- Questions about DBML capabilities

### 5. Interactive Design Process

For complex database design tasks:

**Collaborative Approach:**
1. Start with high-level entity identification
2. Iterate on relationships and cardinality
3. Refine attributes and data types
4. Add constraints and indexes
5. Review and optimize
6. Document thoroughly

**Ask Clarifying Questions:**
- "Should users be able to belong to multiple organizations?"
- "Do you need to track historical changes to orders?"
- "What queries will be most common?"
- "Are there any unique business constraints?"

## Output Format

When creating or modifying DBML schemas:

**File Structure:**
```dbml
// Clear header comment explaining the schema

Table tablename {
  id integer [primary key, increment]
  // columns with appropriate types and constraints
  created_at timestamp [not null, default: `now()`]

  indexes {
    // indexes for query optimization
  }

  Note: 'Clear description of table purpose'
}

// Additional tables with relationships

TableGroup groupname {
  // logically related tables
}
```

**Best Practices in Output:**
- Include comments for complex logic
- Use consistent formatting
- Group related tables with TableGroups
- Add notes for non-obvious design decisions
- Document constraints and business rules

## Resources

- **`DBML.md`** - Complete DBML syntax documentation. Load when users need specific syntax help or when creating complex schemas.
- **`best-practices.md`** - Database design best practices including normalization, indexing, naming conventions, and common patterns. Reference when analyzing schemas or providing design guidance.

### templates/
Ready-to-use DBML templates for common scenarios:
- **`basic.dbml`** - Simple user-following system
- **`advanced.dbml`** - Complex e-commerce schema with products, orders, and users

Use these templates as starting points or reference examples when creating similar systems.
