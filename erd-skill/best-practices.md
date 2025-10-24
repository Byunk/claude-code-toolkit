# Database Design Best Practices

## Normalization

### First Normal Form (1NF)
- Each column contains atomic (indivisible) values
- Each column contains values of a single type
- Each column has a unique name
- The order of rows doesn't matter

### Second Normal Form (2NF)
- Meets all requirements of 1NF
- No partial dependencies (all non-key attributes fully depend on the primary key)
- Relevant for composite primary keys

### Third Normal Form (3NF)
- Meets all requirements of 2NF
- No transitive dependencies (non-key attributes don't depend on other non-key attributes)
- Most common target normalization level

### Denormalization
Consider denormalization for:
- Read-heavy workloads where query performance is critical
- Aggregated data that's expensive to compute
- Historical snapshots that shouldn't change

## Naming Conventions

### Tables
- Use plural nouns (e.g., `users`, `posts`, `orders`)
- Use snake_case for multi-word names (e.g., `user_profiles`, `order_items`)
- Keep names descriptive but concise

### Columns
- Use singular nouns (e.g., `id`, `name`, `email`)
- Use snake_case for multi-word names (e.g., `created_at`, `user_id`)
- Boolean columns should use prefixes like `is_`, `has_`, `can_` (e.g., `is_active`, `has_verified_email`)

### Foreign Keys
- Use format: `{referenced_table_singular}_id` (e.g., `user_id`, `post_id`)
- Be consistent across the entire schema

### Indexes
- Name format: `idx_{table}_{columns}` or `{table}_{columns}_idx`
- Include purpose when relevant: `idx_users_email_unique`, `idx_posts_author_created`

## Primary Keys

### Auto-incrementing Integers
```dbml
Table users {
  id integer [primary key, increment]
}
```
**Pros:** Simple, compact, sequential, human-readable
**Cons:** Exposes record count, potential security concern, not globally unique

### UUIDs
```dbml
Table users {
  id uuid [primary key]
}
```
**Pros:** Globally unique, can be generated client-side, harder to enumerate
**Cons:** Larger storage, less human-readable, non-sequential (worse for indexing)

### Composite Keys
```dbml
Table user_roles {
  user_id integer
  role_id integer

  indexes {
    (user_id, role_id) [primary key]
  }
}
```
**Use when:** Natural composite identifier exists and makes sense

## Indexing Strategies

### Single-column Indexes
Create indexes on columns frequently used in:
- WHERE clauses
- JOIN conditions
- ORDER BY clauses
- Foreign keys

### Composite Indexes
- Order matters: most selective column first
- Consider query patterns when designing
- Can satisfy multiple query types

```dbml
Table posts {
  id integer [primary key]
  author_id integer
  status varchar
  created_at timestamp

  indexes {
    (author_id, created_at) [name: 'idx_posts_author_created']
    status [name: 'idx_posts_status']
  }
}
```

### Unique Indexes
Use for:
- Ensuring data uniqueness (e.g., email, username)
- Natural keys
- Business constraints

```dbml
Table users {
  id integer [primary key]
  email varchar [unique]
  username varchar [unique]
}
```

## Relationships

### One-to-Many
Most common relationship type. Use foreign key in the "many" table.

```dbml
Table users {
  id integer [primary key]
}

Table posts {
  id integer [primary key]
  author_id integer [ref: > users.id]
}
```

### Many-to-Many
Requires junction/join table.

```dbml
Table users {
  id integer [primary key]
}

Table roles {
  id integer [primary key]
}

Table user_roles {
  user_id integer [ref: > users.id]
  role_id integer [ref: > roles.id]

  indexes {
    (user_id, role_id) [primary key]
  }
}
```

### One-to-One
Less common. Can be modeled with unique foreign key or by merging tables.

```dbml
Table users {
  id integer [primary key]
}

Table user_profiles {
  id integer [primary key]
  user_id integer [ref: - users.id, unique]
}
```

## Constraints and Validation

### NOT NULL
Use for required fields:
```dbml
Table users {
  id integer [primary key]
  email varchar [not null]
  username varchar [not null]
}
```

### Default Values
Provide sensible defaults:
```dbml
Table posts {
  id integer [primary key]
  status varchar [default: 'draft']
  created_at timestamp [default: `now()`]
}
```

### Check Constraints
Enforce business rules at the database level:
```dbml
Table products {
  id integer [primary key]
  price decimal [note: 'CHECK (price >= 0)']
  stock integer [note: 'CHECK (stock >= 0)']
}
```

## Common Patterns

### Timestamps
If tracking creation and update times has business value:
```dbml
Table posts {
  id integer [primary key]
  // ... other fields
  created_at timestamp [not null, default: `now()`]
  updated_at timestamp [not null, default: `now()`]
}
```

### Soft Deletes
For preserving deleted records:
```dbml
Table users {
  id integer [primary key]
  // ... other fields
  deleted_at timestamp [null]
}
```

### Polymorphic Associations
When a table can belong to multiple parent types:
```dbml
Table comments {
  id integer [primary key]
  commentable_type varchar // 'Post' or 'Product'
  commentable_id integer   // ID of Post or Product
  content text
}
```

### Audit Trail
Track changes to important data:
```dbml
Table order_history {
  id integer [primary key]
  order_id integer [ref: > orders.id]
  changed_by integer [ref: > users.id]
  old_status varchar
  new_status varchar
  changed_at timestamp [default: `now()`]
}
```

### Versioning
For maintaining version history:
```dbml
Table documents {
  id integer [primary key]
  version integer [not null, default: 1]
  // ... other fields

  indexes {
    (id, version) [unique]
  }
}
```

## Performance Considerations

### Avoid Over-indexing
- Each index adds write overhead
- Maintain only indexes that are actually used
- Monitor query performance and adjust

### Use Appropriate Data Types
- VARCHAR vs TEXT: Use VARCHAR with appropriate length
- INT vs BIGINT: Choose based on expected range
- DECIMAL for money: Avoid floating point for currency
- TIMESTAMP vs DATE: Use appropriate precision

## Schema Organization

### Use Table Groups
Organize related tables:
```dbml
TableGroup user_management {
  users
  user_profiles
  user_roles
}

TableGroup content {
  posts
  comments
  tags
}
```

### Use Schemas/Namespaces
For large applications:
```dbml
Table auth.users {
  id integer [primary key]
}

Table cms.posts {
  id integer [primary key]
  author_id integer [ref: > auth.users.id]
}
```
