---
description: Guided feature development with codebase understanding and architecture focus
argument-hint: Describe the feature in detail
---

# Feature Development

You are orchestrating feature development using an architecture-first approach. Focus on high-level coordination and let specialized agents handle implementation details.

## Initial Request

$ARGUMENTS

## Workflow

Use TodoWrite to track progress through these phases:

### 1. Context Gathering

Analyze the codebase to understand current architecture and patterns:
- Identify framework, tech stack, and project structure
- Map existing components, APIs, and database patterns
- Review code conventions and architectural decisions
- Document findings with file:line references

This helps you ask informed clarifying questions in the next phase.

### 2. Requirement Clarification

Based on gathered context, use **AskUserQuestion** to clarify ALL requirements before proceeding:
- What exactly should this feature do? What problem does it solve?
- UI/UX requirements: layout, user flow, interactions, design system
- Data requirements: what data, validation rules, relationships
- API requirements: endpoints, authentication, request/response formats
- Performance, security, or integration constraints
- Any specific technical preferences or requirements

**Get complete, unambiguous requirements before moving to architecture design.**

### 3. Architecture Design

Launch the **system-architect** agent with complete requirements:
- Provide the feature requirements gathered from user
- Include relevant context from your analysis
- Architect will design high-level system architecture
- Architect reports back with architecture blueprint (no user interaction)

The architecture blueprint will include API contracts, frontend structure, data models, and system boundaries.

### 4. Design Approval

Present the architecture blueprint to the user:
- Show the proposed architecture clearly
- Explain key architectural decisions and trade-offs
- Use **AskUserQuestion** to ask: "Does this design look good? Any changes needed?"
- **Get explicit approval before proceeding to implementation**

If changes are needed, refine the architecture and get approval again.

### 5. Implementation

Based on the approved architecture, determine affected domains and create implementation tasks.

**Task Planning:**
- Break down complex features into small, focused tasks
- Group tasks by domain (backend, frontend, devops)
- Use TodoWrite to track all implementation tasks

**Sequential Execution:**
For each task, launch the appropriate agent with:
- Architecture blueprint
- Complete requirements from phase 2
- Specific task description
- Context from previously completed tasks (if applicable)

**Domain Agents:**
- **backend-developer** - API endpoints, business logic, services, data models, migrations
- **frontend-developer** - UI components, pages, routing, state management
- **devops-engineer** - Deployment, infrastructure, containerization, CI/CD

**For complex domains** (e.g., multi-page frontend with many components):
- Launch the same agent **sequentially** multiple times
- Each invocation handles one focused task
- Pass results from previous tasks as context to next task

**Agent Autonomy:**
- Agents work autonomously without user interaction
- Agents analyze, design, implement, test, and report back to you
- You coordinate at high level and aggregate results

### 6. Summary

Once all implementation tasks complete, provide final summary:
- What was built (features, endpoints, components, infrastructure)
- Key architectural and implementation decisions
- Files created/modified with file:line references
- Testing results
- Next steps or recommendations

## Key Principles

- **Architecture-first** - Understand the system design before implementation
- **Complete requirements** - Clarify everything upfront to avoid agent confusion
- **Main agent orchestrates** - ALL user communication happens at command level
- **Agent autonomy** - Agents execute tasks without asking user questions
- **Sequential task delegation** - Break complex features into focused tasks
- **Minimal orchestration** - Coordinate at high level, don't prescribe implementation details

**CRITICAL**: You handle ALL user interaction. Agents receive complete requirements and execute autonomously. Never delegate user questions to agents.
