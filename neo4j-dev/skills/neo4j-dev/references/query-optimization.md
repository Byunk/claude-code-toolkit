# Cypher Query Optimization

## Query Analysis

### EXPLAIN vs PROFILE

```cypher
// EXPLAIN - shows plan without executing
EXPLAIN MATCH (n:Person)-[:KNOWS]->(friend) RETURN friend

// PROFILE - executes and shows actual metrics
PROFILE MATCH (n:Person)-[:KNOWS]->(friend) RETURN friend
```

### Key Metrics in PROFILE

| Metric | Description | What to Look For |
|--------|-------------|------------------|
| Rows | Data flowing through operator | High early = inefficient |
| DB Hits | Database operations | Lower is better |
| Time | Execution time per operator | Identify bottlenecks |
| Memory | Memory usage | Watch for spikes |

### Understanding Query Plans

**Good operators:**
- `NodeIndexSeek` - Using index for lookup
- `DirectedRelationshipIndexSeek` - Using relationship index
- `NodeUniqueIndexSeek` - Using unique constraint

**Warning signs:**
- `NodeByLabelScan` - Full label scan (missing index?)
- `AllNodesScan` - Scanning all nodes (missing label?)
- `CartesianProduct` - Cross join (usually bad)
- `Eager` - Blocking operation (breaks streaming)

## Common Optimization Techniques

### 1. Add Missing Indexes

```cypher
// Before - full label scan
PROFILE MATCH (n:Person {email: $email}) RETURN n
// Shows: NodeByLabelScan

// After
CREATE INDEX person_email FOR (n:Person) ON (n.email)

// Now shows: NodeIndexSeek
```

### 2. Avoid Cartesian Products

```cypher
// Bad - Cartesian product (n × m combinations)
MATCH (a:Person), (b:Product)
WHERE a.id = $personId
RETURN a, b

// Good - connected patterns
MATCH (a:Person {id: $personId})-[:PURCHASED]->(b:Product)
RETURN a, b

// If you need unconnected data, use subqueries
MATCH (a:Person {id: $personId})
CALL {
  MATCH (b:Product) WHERE b.featured = true RETURN b LIMIT 10
}
RETURN a, b
```

### 3. Early Aggregation

```cypher
// Bad - aggregate late (processes all rows)
MATCH (p:Person)-[:FRIENDS]->(f)-[:POSTED]->(post)
WHERE p.id = $id
RETURN p, count(post)

// Good - aggregate early when possible
MATCH (p:Person {id: $id})-[:FRIENDS]->(f)
WITH p, f
MATCH (f)-[:POSTED]->(post)
WITH p, count(post) as postCount
RETURN p, postCount
```

### 4. Limit Variable-Length Results

```cypher
// Always bound and limit
MATCH path = (start:Person {id: $id})-[:KNOWS*1..3]-(end)
RETURN path
LIMIT 100

// Even better - filter within pattern
MATCH path = (start:Person {id: $id})-[:KNOWS*1..3]-(end:Person)
WHERE end.active = true
RETURN path
LIMIT 100
```

### 5. Use Index Hints When Needed

```cypher
// Force specific index when planner chooses wrong one
MATCH (n:Person)
USING INDEX n:Person(email)
WHERE n.email = $email OR n.name = $name
RETURN n
```

### 6. Reorder MATCH Clauses

Put most selective patterns first:

```cypher
// Bad - starts with broad pattern
MATCH (c:Category)<-[:IN_CATEGORY]-(p:Product)
MATCH (u:User {id: $id})-[:PURCHASED]->(p)
RETURN p

// Good - starts with selective indexed lookup
MATCH (u:User {id: $id})-[:PURCHASED]->(p:Product)
MATCH (p)-[:IN_CATEGORY]->(c:Category)
RETURN p, c
```

## Performance Patterns

### Pagination

```cypher
// Skip/Limit for pagination
MATCH (n:Person)
RETURN n
ORDER BY n.name
SKIP $offset LIMIT $pageSize

// Keyset pagination (more efficient for large offsets)
MATCH (n:Person)
WHERE n.name > $lastSeenName
RETURN n
ORDER BY n.name
LIMIT $pageSize
```

### Existence Checks

```cypher
// Good - EXISTS short-circuits
MATCH (p:Person {id: $id})
WHERE EXISTS { (p)-[:PURCHASED]->(:Product) }
RETURN p

// Bad - counts everything
MATCH (p:Person {id: $id})
WHERE size((p)-[:PURCHASED]->()) > 0
RETURN p
```

### Counting

```cypher
// Good - count directly
MATCH (p:Person)-[:PURCHASED]->(product)
RETURN count(product)

// Bad - collect then size
MATCH (p:Person)-[:PURCHASED]->(product)
RETURN size(collect(product))
```

### Conditional Queries

```cypher
// Dynamic filtering with CASE
MATCH (p:Person)
WHERE CASE
  WHEN $filterActive IS NOT NULL THEN p.active = $filterActive
  ELSE true
END
RETURN p

// Optional pattern matching
MATCH (p:Person {id: $id})
OPTIONAL MATCH (p)-[:PURCHASED]->(product)
WHERE $includeProducts = true
RETURN p, collect(product) as products
```

## Batch Processing

### Large Data Operations

```cypher
// Batch delete to avoid memory issues
CALL {
  MATCH (n:TempNode)
  WITH n LIMIT 10000
  DETACH DELETE n
  RETURN count(*) as deleted
} IN TRANSACTIONS OF 10000 ROWS
RETURN sum(deleted)

// Batch update
CALL {
  MATCH (n:Person)
  WHERE n.status = 'pending'
  WITH n LIMIT 5000
  SET n.status = 'processed', n.processedAt = datetime()
  RETURN count(*) as updated
} IN TRANSACTIONS OF 5000 ROWS
```

### Parallel Execution

```cypher
// UNION for parallel branches
CALL {
  MATCH (p:Person)-[:PURCHASED]->(product)
  RETURN product, 'purchased' as source
  UNION
  MATCH (p:Person)-[:WISHLISTED]->(product)
  RETURN product, 'wishlisted' as source
}
RETURN product, collect(source)
```

## Query Rewriting Techniques

### Flatten Nested Patterns

```cypher
// Before - nested optional matches
MATCH (a:Person)
OPTIONAL MATCH (a)-[:KNOWS]->(b)
OPTIONAL MATCH (b)-[:KNOWS]->(c)
RETURN a, b, c

// After - single variable-length pattern
MATCH (a:Person)
OPTIONAL MATCH path = (a)-[:KNOWS*1..2]->(end)
RETURN a, nodes(path)
```

### Use WITH for Optimization Barriers

```cypher
// Force evaluation order
MATCH (p:Person {id: $id})
WITH p  // Ensures p is found before continuing
MATCH (p)-[:PURCHASED]->(product)
WITH p, product
MATCH (product)-[:IN_CATEGORY]->(c)
RETURN p, product, c
```

### Avoid Property Access in Hot Loops

```cypher
// Bad - accesses property multiple times
MATCH (p:Person)-[:KNOWS*1..5]->(friend)
WHERE friend.status = p.status
RETURN friend

// Good - extract property once
MATCH (p:Person {id: $id})
WITH p.status as targetStatus
MATCH (p)-[:KNOWS*1..5]->(friend)
WHERE friend.status = targetStatus
RETURN friend
```

## Monitoring and Diagnostics

### Query Logging

```cypher
// Enable query logging in neo4j.conf
// db.logs.query.enabled=INFO
// db.logs.query.threshold=1000ms

// Check slow queries in query.log
```

### Memory Management

```cypher
// Check memory usage
CALL dbms.listQueries() YIELD queryId, query, elapsedTimeMillis, allocatedBytes
WHERE elapsedTimeMillis > 1000
RETURN *

// Kill long-running query
CALL dbms.killQuery('query-id')
```

### Query Statistics

```cypher
// After PROFILE, examine:
// 1. Total DB Hits - overall efficiency
// 2. Rows at each step - data volume
// 3. Eager operators - streaming blockers
// 4. Time distribution - where time is spent
```

## Optimization Checklist

1. [ ] Indexes exist for WHERE clause properties
2. [ ] Most selective pattern is first
3. [ ] No Cartesian products (unless intended)
4. [ ] Variable-length patterns are bounded
5. [ ] LIMIT applied early when possible
6. [ ] Using EXISTS for existence checks
7. [ ] Batch operations for large data
8. [ ] No unnecessary OPTIONAL MATCH
9. [ ] Parameters used instead of literals
10. [ ] PROFILE shows expected operators
