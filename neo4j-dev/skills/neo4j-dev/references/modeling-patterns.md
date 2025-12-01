# Graph Data Modeling Patterns

## Core Principles

### Nodes vs Properties

**Use nodes when:**
- The entity needs independent relationships
- You need to query or traverse through it
- It has its own identity and lifecycle

**Use properties when:**
- The data is an attribute of the node
- No relationships needed from this data
- Simple scalar values

```cypher
// Property: address as simple attribute
(p:Person {name: "Alice", city: "Boston"})

// Node: address needs relationships (e.g., multiple people at same address)
(p:Person)-[:LIVES_AT]->(a:Address {city: "Boston", street: "Main St"})
```

### Relationship Naming

- Use verbs: KNOWS, OWNS, WORKS_AT, PURCHASED
- Direction matters: (user)-[:FOLLOWS]->(celebrity)
- Add properties for metadata: since, weight, role

```cypher
(alice:Person)-[:WORKS_AT {since: 2020, role: "Engineer"}]->(company:Company)
```

### Labels

- Use for type hierarchies: Person:Employee, Person:Customer
- Keep labels concise and meaningful
- Avoid too many labels per node (2-3 is typical)

## Common Patterns

### Intermediate Nodes

For many-to-many relationships with properties:

```cypher
// Instead of property-heavy relationship
(Person)-[:HAS_ROLE]->(Role)-[:AT_COMPANY]->(Company)
// Role has: title, startDate, endDate, salary

// Example
CREATE (alice:Person {name: "Alice"})
CREATE (role:Role {title: "Engineer", startDate: date("2020-01-01"), salary: 100000})
CREATE (company:Company {name: "TechCorp"})
CREATE (alice)-[:HAS_ROLE]->(role)-[:AT_COMPANY]->(company)
```

### Versioning Pattern

Track historical changes:

```cypher
(Entity)-[:CURRENT_VERSION]->(v3:Version {version: 3})
(v3)-[:PREVIOUS]->(v2:Version)-[:PREVIOUS]->(v1:Version)

// Query current version
MATCH (e:Entity)-[:CURRENT_VERSION]->(v)
RETURN e, v

// Query history
MATCH (e:Entity)-[:CURRENT_VERSION]->(current)
MATCH path = (current)-[:PREVIOUS*]->(oldest)
RETURN e, nodes(path)
```

### Categorization

**Option 1: Labels** (static, fast)
```cypher
(p:Person:Employee)
(p:Person:Customer)
```

**Option 2: Category nodes** (dynamic, flexible)
```cypher
(p:Person)-[:IN_CATEGORY]->(c:Category {name: "Premium"})
```

### Time-Based Relationships

```cypher
// Event sourcing
(user:User)-[:PERFORMED]->(action:Action {timestamp: datetime(), type: "LOGIN"})

// Time windows
(user:User)-[:ACTIVE_DURING]->(period:TimePeriod {start: date("2024-01-01"), end: date("2024-12-31")})
```

### Linked List Pattern

For ordered sequences:

```cypher
(first:Item)-[:NEXT]->(second:Item)-[:NEXT]->(third:Item)

// With head pointer
(list:List)-[:HEAD]->(first:Item)
```

## Anti-Patterns to Avoid

### Supernode Problem

Nodes with millions of relationships cause performance issues.

**Problem:**
```cypher
// Popular user with 10M followers
(celebrity:User)<-[:FOLLOWS]-(follower:User)  // 10 million relationships
```

**Solution: Fan-out through intermediate nodes**
```cypher
// Shard followers into buckets
(celebrity:User)-[:HAS_FOLLOWER_BUCKET]->(bucket:FollowerBucket {id: 1})
(bucket)<-[:IN_BUCKET]-(follower:User)
```

### Property That Should Be Node

**Problem:**
```cypher
// Repeated string properties
(p1:Person {department: "Engineering"})
(p2:Person {department: "Engineering"})
(p3:Person {department: "Engineering"})
```

**Solution: Extract to node**
```cypher
(dept:Department {name: "Engineering"})
(p1:Person)-[:WORKS_IN]->(dept)
(p2:Person)-[:WORKS_IN]->(dept)
```

### Dense Relationship Types

**Problem:**
```cypher
// Generic relationships lose meaning
(a)-[:RELATED_TO]->(b)
(a)-[:CONNECTED]->(c)
```

**Solution: Specific types**
```cypher
(user)-[:PURCHASED]->(product)
(user)-[:REVIEWED]->(product)
(user)-[:WISHLISTED]->(product)
```

### Missing Indexes

Always create indexes for properties used in WHERE clauses:

```cypher
// Create index
CREATE INDEX person_email FOR (p:Person) ON (p.email)

// Now this is fast
MATCH (p:Person {email: $email}) RETURN p
```

### Modeling Relational in Graph

**Problem: Junction tables**
```cypher
// Don't do this
(person)-[:HAS_PERSON_PROJECT]->(pp:PersonProject)-[:FOR_PROJECT]->(project)
```

**Solution: Direct relationships**
```cypher
(person)-[:WORKS_ON {role: "Lead", hours: 20}]->(project)
```

## Access Pattern Design

Design your model around how you'll query it:

### Query: Find friends of friends

```cypher
// Model: Direct friendship relationships
(person)-[:FRIENDS_WITH]->(friend)-[:FRIENDS_WITH]->(fof)

// Query
MATCH (p:Person {name: $name})-[:FRIENDS_WITH*2]-(fof)
WHERE NOT (p)-[:FRIENDS_WITH]-(fof) AND p <> fof
RETURN DISTINCT fof
```

### Query: Product recommendations

```cypher
// Model: Purchase and category relationships
(user)-[:PURCHASED]->(product)-[:IN_CATEGORY]->(category)

// Query: Products in same category as purchases
MATCH (u:User {id: $userId})-[:PURCHASED]->(p)-[:IN_CATEGORY]->(c)
MATCH (recommended:Product)-[:IN_CATEGORY]->(c)
WHERE NOT (u)-[:PURCHASED]->(recommended)
RETURN DISTINCT recommended, count(c) as relevance
ORDER BY relevance DESC
```

## Schema Constraints

```cypher
// Uniqueness
CREATE CONSTRAINT user_email FOR (u:User) REQUIRE u.email IS UNIQUE

// Node key (composite uniqueness)
CREATE CONSTRAINT order_key FOR (o:Order)
REQUIRE (o.orderId, o.customerId) IS NODE KEY

// Property existence
CREATE CONSTRAINT person_name FOR (p:Person) REQUIRE p.name IS NOT NULL

// Property type
CREATE CONSTRAINT age_type FOR (p:Person) REQUIRE p.age IS :: INTEGER
```
