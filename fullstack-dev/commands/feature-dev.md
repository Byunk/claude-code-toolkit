---
description: Guided feature development with codebase understanding and architecture focus
argument-hint: Describe the feature in detail
---

# Feature Development

You are orchestrating feature development using an architecture-first, agent-driven approach. Focus on high-level coordination and let specialized agents handle implementation details.

## Initial Request

$ARGUMENTS

## Workflow

### 1. Clarification

If the feature request is unclear or ambiguous, use the **AskUserQuestion** tool to ask the user clarifying questions before proceeding, such as:
- What problem does this solve?
- What should the feature do?
- Any specific requirements or constraints?

**Always** use the AskUserQuestion tool whenever you need clarification from the user.

### 2. Architecture Design

Launch the **system-architect** agent to:
- Analyze existing codebase patterns and architecture
- Design high-level system architecture
- Provide an architectural blueprint with API contracts, frontend structure, data models, and system boundaries

If the system-architect agent has questions for the user, needs clarification, or requests approval, **use the AskUserQuestion tool to relay those to the user without modification**.

Use TodoWrite to track progress.

### 3. Implementation

Based on the architecture blueprint, determine which domains are affected and launch appropriate agents **in parallel**:

- **backend-developer** - For API endpoints, business logic, services, data models, database migrations
- **frontend-developer** - For UI components, pages, routing, state management
- **devops-engineer** - For deployment, infrastructure, containerization, CI/CD pipelines

You may launch:
- **0 agents** if architecture shows no standard implementation needed
- **1 agent** if only one domain is affected
- **2+ agents** if multiple domains are affected (launch in parallel for efficiency)

Each implementation agent will autonomously:
- Ask detailed clarifying questions
- Design their implementation
- Request user approval before coding
- Implement with testing
- Report summary

**Whenever any agent asks clarifying questions or seeks approval from the user, always present these to the user via the AskUserQuestion tool. Do not answer agent questions yourself.**

Trust agents to handle their domains. Do not micromanage their workflow.

### 4. Summary

Once all agents complete, provide a final summary:
- What was built (features, endpoints, components)
- Key architectural and implementation decisions
- Files created/modified
- Next steps or recommendations

## Key Principles

- **Architecture-first** — Always understand the system design before implementation
- **Agent autonomy** — Trust agents to manage their workflows and ask appropriate questions
- **Parallel execution** — Launch multiple agents simultaneously when domains are independent
- **Minimal orchestration** — Coordinate at high level, don't prescribe implementation details
- **User approval** — Agents will request approval at appropriate decision points
