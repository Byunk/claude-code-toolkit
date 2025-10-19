# Fullstack Development Plugin

Architecture-first workflows and specialized autonomous agents for fullstack development.

## Commands

Agentic workflows that orchestrate development tasks:

- **`/feature-dev`** - Architecture-first feature development using system design to guide implementation

## Agents

Specialized autonomous agents that handle end-to-end workflows:

- **system-architect** - Designs high-level system architecture (API contracts, data models, frontend structure, system boundaries)
- **backend-developer** - Implements backend features (API endpoints, business logic, data models, migrations, tests)
- **frontend-developer** - Implements frontend features (UI components, pages, routing, state management, tests)
- **devops-engineer** - Handles infrastructure and deployment (containers, orchestration, CI/CD, IaC)

## Usage

Commands orchestrate workflows by launching agents in an architecture-first approach:

```bash
/feature-dev Add user authentication with OAuth
```

Each agent autonomously handles analysis, clarification, design, approval, implementation, and testing for their domain.
