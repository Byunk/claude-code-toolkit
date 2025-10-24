---
name: erd-skill
description: Comprehensive database design and ERD (Entity-Relationship Diagram) toolkit using DBML format. This skill should be used when creating database schemas from requirements, analyzing existing DBML files for improvements, designing database architecture, or providing guidance on database modeling, normalization, indexing, and relationships.
---

# ERD Design Skill

## Overview

This skill helps you design, analyze, and manage database schemas using DBML (Database Markup Language). DBML is a simple, readable DSL for defining database structures that can be converted to SQL and visualized as ERDs. Use this skill for creating new schemas, analyzing existing designs, and converting between DBML and SQL formats.

## When to Use This Skill

Trigger this skill when users request:
- "Create an ERD for [system description]"
- "Design a database schema for [application]"
- "Analyze this DBML file and suggest improvements"
- "Help me design a database for [use case]"
- "Review my database schema"
- "Convert DBML to SQL" or "Convert SQL to DBML"
- Working with `.dbml` files
- Database normalization, indexing, or relationship guidance

## Resource Guide

### For DBML Syntax Questions

**Read `DBML.md` when:**
- Users ask about specific DBML syntax (tables, columns, relationships)
- You need to understand index or constraint syntax
- Working with enums, notes, or TableGroups
- Learning about TablePartials for reusable field sets
- Questions about DBML capabilities and advanced features

### For Design Best Practices

**Read `best-practices.md` when:**
- Analyzing existing schemas for improvements
- Deciding on normalization levels (1NF, 2NF, 3NF)
- Planning indexing strategies
- Choosing naming conventions
- Understanding relationship patterns (one-to-many, many-to-many, etc.)
- Implementing common patterns (timestamps, soft deletes, audit trails, versioning)
- Making performance vs normalization trade-offs

### For Schema Templates

**Read `templates/` when:**
- Starting a new schema and need a reference pattern
- `templates/basic.dbml` - Simple user-following system example
- `templates/advanced.dbml` - Complex e-commerce schema with products, orders, and users

Use templates as starting points or adapt patterns for similar use cases.

### For CLI Operations

**Read `cli.md` when:**
- Converting DBML to SQL (various database types)
- Converting SQL to DBML
- Generating DBML directly from a live database connection
- Need examples of command-line usage

## Workflows

### Reading and Analyzing Schemas

**For understanding schema structure:**
1. Read the `.dbml` file directly
2. Analyze table relationships, indexes, and constraints
3. Reference `DBML.md` for syntax clarification if needed

**For schema review and improvements:**
1. Read the existing `.dbml` file
2. **MANDATORY - READ ENTIRE FILE**: Read `best-practices.md` completely from start to finish. **NEVER set any range limits when reading this file.**
3. Check against standards:
   - Naming conventions
   - Normalization level (1NF, 2NF, 3NF)
   - Index strategy
   - Missing constraints or timestamps
   - Relationship integrity
4. Prioritize recommendations (critical, important, nice-to-have)
5. Provide concrete DBML improvements

### Creating New Schemas

1. **Understand requirements**: Clarify entities, relationships, and business rules
2. **Choose a template**: Read relevant template from `templates/` for similar patterns
   - `templates/basic.dbml` for simple applications
   - `templates/advanced.dbml` for complex e-commerce-like systems
3. **MANDATORY - READ FILES**: Read both `best-practices.md` and `DBML.md` completely from start to finish for design principles and syntax
4. **Design the schema**:
   - Define tables with appropriate data types
   - Apply naming conventions (plural tables, singular columns, snake_case)
   - Add primary keys and indexes
   - Define relationships between tables
   - Apply normalization guidelines (typically target 3NF)
5. **Add documentation**:
   - Include table and column notes
   - Group related tables with TableGroups
   - Document constraints and business rules
6. **Use TablePartials** for reusable patterns (timestamps, soft deletes, etc.)

### Modifying Existing Schemas

1. Read the existing `.dbml` file
2. Identify the required changes
3. Reference `DBML.md` for syntax when adding new features
4. Reference `best-practices.md` for design decisions
5. Apply changes while maintaining consistency with existing patterns
6. Update documentation (notes, comments)

### CLI Operations (DBML ↔ SQL Conversion)

**Converting DBML to SQL:**
1. **Read `cli.md`** for command syntax and examples
2. Use `dbml2sql` command:
   ```bash
   dbml2sql schema.dbml --mysql -o schema.sql
   ```
3. Specify target database: `--mysql`, `--postgres`, `--mssql`, `--oracle`

**Converting SQL to DBML:**
1. **Read `cli.md`** for command syntax and examples
2. Use `sql2dbml` command:
   ```bash
   sql2dbml dump.sql --postgres -o schema.dbml
   ```
3. Specify source database type

**Generating from live database:**
1. **Read `cli.md`** for connection string examples
2. Use `db2dbml` command with appropriate connection string
3. Support for: PostgreSQL, MySQL, MSSQL, Snowflake, BigQuery

## Code Style Guidelines

**IMPORTANT**: When generating DBML schemas:
- Write concise, readable DBML code
- Use consistent naming conventions (snake_case, plural tables, singular columns)
- Add comments only for complex business logic
- Use table and column notes for documentation instead of excessive comments
- Leverage TablePartials for reusable patterns (timestamps, audit fields)
- Group related tables with TableGroups for better organization
- Keep indexes close to their table definitions

## Dependencies

Required dependencies (install if not available):

- **@dbml/cli**: `npm install -g @dbml/cli` (for DBML ↔ SQL conversion)
  - Includes: `dbml2sql`, `sql2dbml`, `db2dbml` commands
