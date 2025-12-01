# Neo4j Index Strategies

## Index Types

### Range Index (Default)

Best for: Equality, range queries, string prefix

```cypher
// Create
CREATE INDEX person_name FOR (n:Person) ON (n.name)

// Queries that use this
MATCH (n:Person {name: $name})                    // Equality
MATCH (n:Person) WHERE n.name STARTS WITH 'A'    // Prefix
MATCH (n:Person) WHERE n.age > 30                // Range
MATCH (n:Person) WHERE n.age >= 18 AND n.age < 65  // Range
```

### Composite Index

Best for: Queries filtering on multiple properties

```cypher
// Create - order matters!
CREATE INDEX person_composite FOR (n:Person) ON (n.lastName, n.firstName)

// Queries that use this (leftmost property first)
MATCH (n:Person {lastName: $last, firstName: $first})  // Both properties
MATCH (n:Person {lastName: $last})                     // Leftmost only - still uses index

// This does NOT use the index efficiently
MATCH (n:Person {firstName: $first})  // Missing leftmost property
```

### Text Index

Best for: Full-text search within strings (CONTAINS, ENDS WITH)

```cypher
// Create
CREATE TEXT INDEX person_bio FOR (n:Person) ON (n.bio)

// Queries that use this
MATCH (n:Person) WHERE n.bio CONTAINS 'engineer'
MATCH (n:Person) WHERE n.bio ENDS WITH '.com'
```

### Full-Text Index

Best for: Advanced text search with relevance scoring, fuzzy matching

```cypher
// Create on multiple properties
CREATE FULLTEXT INDEX personSearch FOR (n:Person) ON EACH [n.name, n.bio, n.skills]

// Query with scoring
CALL db.index.fulltext.queryNodes('personSearch', 'software engineer')
YIELD node, score
RETURN node, score
ORDER BY score DESC
LIMIT 10

// Fuzzy matching
CALL db.index.fulltext.queryNodes('personSearch', 'enginear~')  // Finds 'engineer'
YIELD node, score
RETURN node
```

### Point Index

Best for: Geographic/spatial queries

```cypher
// Create
CREATE POINT INDEX location_idx FOR (n:Location) ON (n.coordinates)

// Store point data
CREATE (l:Location {name: 'Office', coordinates: point({latitude: 40.7128, longitude: -74.0060})})

// Distance queries
MATCH (l:Location)
WHERE point.distance(l.coordinates, point({latitude: $lat, longitude: $lon})) < 1000
RETURN l
```

### Relationship Index

Index properties on relationships:

```cypher
// Create
CREATE INDEX purchased_date FOR ()-[r:PURCHASED]-() ON (r.date)

// Query
MATCH (u:User)-[r:PURCHASED]->(p:Product)
WHERE r.date > date('2024-01-01')
RETURN u, p
```

## Index Selection Guide

| Query Pattern | Index Type | Example |
|--------------|------------|---------|
| Exact match `=` | Range | `WHERE n.id = $id` |
| Range `>`, `<`, `>=`, `<=` | Range | `WHERE n.age > 30` |
| `STARTS WITH` | Range | `WHERE n.name STARTS WITH 'A'` |
| Multiple properties | Composite | `WHERE n.last = $l AND n.first = $f` |
| `CONTAINS` | Text | `WHERE n.bio CONTAINS 'python'` |
| `ENDS WITH` | Text | `WHERE n.email ENDS WITH '@gmail.com'` |
| Fuzzy/relevance search | Full-Text | Lucene query syntax |
| Geographic distance | Point | `point.distance()` |

## Constraints (Implicit Indexes)

Constraints automatically create indexes:

```cypher
// Unique constraint - creates Range index
CREATE CONSTRAINT person_id FOR (n:Person) REQUIRE n.id IS UNIQUE

// Node key - creates Composite index
CREATE CONSTRAINT order_key FOR (n:Order)
REQUIRE (n.orderId, n.customerId) IS NODE KEY

// Relationship uniqueness
CREATE CONSTRAINT unique_friendship
FOR ()-[r:FRIENDS_WITH]-() REQUIRE r.id IS UNIQUE
```

## Index Maintenance

### Show Indexes

```cypher
// All indexes
SHOW INDEXES

// Specific type
SHOW INDEXES WHERE type = 'RANGE'

// Index status
SHOW INDEXES YIELD name, state, populationPercent
```

### Drop Indexes

```cypher
// By name
DROP INDEX person_name

// Drop constraint (also removes index)
DROP CONSTRAINT person_id
```

### Check Index Usage

```cypher
// EXPLAIN shows plan without executing
EXPLAIN MATCH (n:Person {name: $name}) RETURN n

// Look for:
// - NodeIndexSeek (good - using index)
// - NodeByLabelScan (bad - full scan)

// PROFILE shows actual execution
PROFILE MATCH (n:Person {name: $name}) RETURN n
```

## Index Design Principles

### 1. Index Frequently Queried Properties

```cypher
// If you often query by email
MATCH (u:User {email: $email}) RETURN u

// Create index
CREATE INDEX user_email FOR (u:User) ON (u.email)
```

### 2. Consider Query Patterns

```cypher
// If you always query lastName AND firstName together
CREATE INDEX person_name_composite FOR (p:Person) ON (p.lastName, p.firstName)

// Better than two separate indexes for this pattern
```

### 3. Balance Write vs Read

- More indexes = slower writes
- Only index what you query
- Remove unused indexes

### 4. Use Constraints When Possible

```cypher
// If ID must be unique, use constraint (gets index for free)
CREATE CONSTRAINT user_id FOR (u:User) REQUIRE u.id IS UNIQUE

// Better than just an index when uniqueness matters
```

## Index Hints

Force index usage when planner doesn't choose it:

```cypher
// Force specific index
MATCH (n:Person)
USING INDEX n:Person(email)
WHERE n.email = $email OR n.name = $name
RETURN n

// Force label scan (rare)
MATCH (n:Person)
USING SCAN n:Person
WHERE n.age > 30
RETURN n
```

## Common Index Mistakes

### Missing Index on Foreign Keys

```cypher
// If you join on userId property
MATCH (o:Order {userId: $userId})

// Create index
CREATE INDEX order_user FOR (o:Order) ON (o.userId)
```

### Wrong Composite Index Order

```cypher
// Query pattern
WHERE n.type = 'active' AND n.score > 100

// Good - selective property first
CREATE INDEX FOR (n:Node) ON (n.type, n.score)

// Consider cardinality - put more selective property first
```

### Over-Indexing

```cypher
// Don't index everything
// Only index properties used in WHERE clauses
// Each index adds write overhead
```

## Index Performance Monitoring

```cypher
// Check index populations
SHOW INDEXES YIELD name, state, populationPercent
WHERE state <> 'ONLINE'

// Query statistics
PROFILE MATCH (n:Person {email: $email}) RETURN n
// Look at:
// - DB Hits (lower is better)
// - Rows (data volume)
// - Time (if available)
```
