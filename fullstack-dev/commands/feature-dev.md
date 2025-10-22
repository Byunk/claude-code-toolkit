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

If the feature request is unclear or ambiguous, use the **AskUserQuestion** tool to ask clarifying questions before proceeding:
- What problem does this solve?
- What should the feature do?
- Any specific requirements or constraints?

### 2. Architecture Design

Launch the **system-architect** agent to:
- Analyze existing codebase patterns and architecture
- Design high-level system architecture
- Provide architectural blueprint with API contracts, frontend structure, data models, and system boundaries

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
- Get user approval before coding
- Implement with testing
- Report summary

Trust agents to handle their domains. Do not micromanage their workflow.

### 4. Summary

Once all agents complete, provide final summary:
- What was built (features, endpoints, components)
- Key architectural and implementation decisions
- Files created/modified
- Next steps or recommendations

## Key Principles

- **Architecture-first** - Always understand the system design before implementation
- **Agent autonomy** - Trust agents to manage their workflows and ask appropriate questions
- **Parallel execution** - Launch multiple agents simultaneously when domains are independent
- **Minimal orchestration** - Coordinate at high level, don't prescribe implementation details
- **User approval** - Use AskUserQuestion tool when agents request approval at decision points

**CRITICAL**: When any agent presents plans, asks clarifying questions, or requests approval, DO NOT answer on behalf of the user. Instead, use the **AskUserQuestion** tool to present the agent's questions/plans to the user and get their input or approval.
