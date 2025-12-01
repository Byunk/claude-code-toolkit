# Cypher Best Practices

## Query Structure

### Use Parameters

Parameters enable query plan caching and prevent injection:

```cypher
// Good - query plan cached
MATCH (n:Person {name: $name}) RETURN n

// Bad - new plan for each value
MATCH (n:Person {name: 'Alice'}) RETURN n
```

### Early Filtering

Reduce the working set as early as possible:

```cypher
// Good - filter early
MATCH (n:Person)
WHERE n.age > 30
WITH n
MATCH (n)-[:KNOWS]->(friend)
RETURN friend

// Bad - late filtering (processes all relationships first)
MATCH (n:Person)-[:KNOWS]->(friend)
WHERE n.age > 30
RETURN friend
```

### Use Labels on All Nodes

Labels help the query planner:

```cypher
// Good - explicit labels
MATCH (p:Person)-[:WORKS_AT]->(c:Company)
RETURN p, c

// Bad - unlabeled nodes scan everything
MATCH (p)-[:WORKS_AT]->(c)
RETURN p, c
```

### Explicit Relationship Direction

When direction matters, specify it:

```cypher
// Good - explicit direction
MATCH (a:Person)-[:FOLLOWS]->(b:Person)

// Use undirected only when needed
MATCH (a:Person)-[:FRIENDS_WITH]-(b:Person)
```

## Variable-Length Patterns

### Always Set Upper Bound

```cypher
// Good - bounded
MATCH path = (n)-[:KNOWS*1..5]-(m)
RETURN path LIMIT 100

// Dangerous - unbounded can explode
MATCH path = (n)-[:KNOWS*]-(m)  // Never do this!
```

### Add Starting Point Filter

```cypher
// Good - start from indexed property
MATCH (start:Person {id: $id})-[:KNOWS*1..3]->(end)
RETURN end

// Bad - no anchor point
MATCH (n)-[:KNOWS*1..3]->(m)
RETURN n, m  // Scans everything
```

## Read Queries

### MATCH Patterns

```cypher
// Start with most selective pattern
MATCH (p:Person {email: $email})  // Indexed lookup first
MATCH (p)-[:PURCHASED]->(product)
RETURN product
```

### OPTIONAL MATCH

Use only when null results are acceptable:

```cypher
// Returns person even without orders
MATCH (p:Person {id: $id})
OPTIONAL MATCH (p)-[:PLACED]->(o:Order)
RETURN p, collect(o) as orders
```

### Aggregations

```cypher
// Use DISTINCT early if needed
MATCH (n:Person)-[:KNOWS]->(friend)
WITH DISTINCT friend
RETURN count(friend)

// Efficient counting
MATCH (p:Person {id: $id})-[:PURCHASED]->(product)
RETURN count(product)  // Don't collect then size()
```

### EXISTS for Existence Checks

```cypher
// Good - EXISTS short-circuits
MATCH (p:Person)
WHERE EXISTS { (p)-[:PURCHASED]->(:Product) }
RETURN p

// Less efficient
MATCH (p:Person)
WHERE size((p)-[:PURCHASED]->()) > 0
RETURN p
```

## Write Queries

### MERGE vs CREATE

```cypher
// MERGE for idempotency (find or create)
MERGE (n:Person {id: $id})
ON CREATE SET n.created = timestamp()
ON MATCH SET n.updated = timestamp()
RETURN n

// CREATE when guaranteed unique
CREATE (e:Event {id: randomUUID(), type: $type, timestamp: datetime()})
```

### Batch Operations with UNWIND

```cypher
// Good - batch insert
UNWIND $persons as person
MERGE (n:Person {id: person.id})
SET n.name = person.name, n.email = person.email

// Bad - multiple statements
CREATE (n1:Person {id: 1, name: 'Alice'})
CREATE (n2:Person {id: 2, name: 'Bob'})
// ... hundreds more
```

### Atomic Updates

```cypher
// Increment safely
MATCH (p:Product {id: $id})
SET p.viewCount = coalesce(p.viewCount, 0) + 1
RETURN p.viewCount
```

### Delete Patterns

```cypher
// Delete node and relationships
MATCH (n:Person {id: $id})
DETACH DELETE n

// Delete specific relationships
MATCH (a:Person {id: $aId})-[r:FOLLOWS]->(b:Person {id: $bId})
DELETE r

// Batch delete (avoid memory issues)
CALL {
  MATCH (n:TempNode)
  WITH n LIMIT 10000
  DETACH DELETE n
} IN TRANSACTIONS OF 10000 ROWS
```

## WITH Clause

### Pipeline Data Transformation

```cypher
// Chain operations
MATCH (p:Person)-[:PURCHASED]->(product)
WITH p, count(product) as purchaseCount
WHERE purchaseCount > 5
MATCH (p)-[:LIVES_IN]->(city)
RETURN p.name, purchaseCount, city.name
```

### Limit Early

```cypher
// Limit before expensive operations
MATCH (p:Person)
WHERE p.active = true
WITH p
ORDER BY p.createdAt DESC
LIMIT 100
MATCH (p)-[:PURCHASED]->(product)
RETURN p, collect(product)
```

## CASE Expressions

```cypher
// Conditional logic
MATCH (p:Person)
RETURN p.name,
  CASE
    WHEN p.age < 18 THEN 'Minor'
    WHEN p.age < 65 THEN 'Adult'
    ELSE 'Senior'
  END as ageGroup

// Conditional filtering
MATCH (p:Person)
WHERE CASE
  WHEN $filterActive IS NOT NULL THEN p.active = $filterActive
  ELSE true
END
RETURN p
```

## List Operations

```cypher
// List comprehension
MATCH (p:Person)-[:KNOWS]->(friend)
RETURN p.name, [f IN collect(friend) WHERE f.age > 30 | f.name] as olderFriends

// REDUCE for aggregation
MATCH (p:Person)-[:PURCHASED]->(product)
WITH p, collect(product.price) as prices
RETURN p.name, reduce(total = 0, price IN prices | total + price) as totalSpent

// ANY/ALL/NONE predicates
MATCH (p:Person)
WHERE ANY(skill IN p.skills WHERE skill STARTS WITH 'Python')
RETURN p
```

## Subqueries

### CALL Subquery

```cypher
// Isolate complex logic
MATCH (p:Person)
CALL {
  WITH p
  MATCH (p)-[:PURCHASED]->(product)-[:IN_CATEGORY]->(c:Category)
  RETURN c.name as topCategory
  ORDER BY count(*) DESC
  LIMIT 1
}
RETURN p.name, topCategory
```

### EXISTS Subquery

```cypher
// Complex existence check
MATCH (p:Person)
WHERE EXISTS {
  MATCH (p)-[:PURCHASED]->(product)
  WHERE product.price > 1000
}
RETURN p
```

## Performance Tips

- Avoid `OPTIONAL MATCH` when not needed
- Use `RETURN DISTINCT` instead of post-processing
- Prefer `count()` over `collect()` + `size()`
- Use `EXISTS` for existence checks
- Profile queries with `PROFILE` to identify bottlenecks
- Create indexes for frequently queried properties
