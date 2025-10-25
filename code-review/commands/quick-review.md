---
description: Quick code quality check focusing on critical and major issues
argument-hint: File paths or leave empty for recent changes
---

# Quick Review

You are performing a fast, focused code review in the main conversation. Identify critical and major issues only - skip minor improvements and style suggestions.

## Initial Request

$ARGUMENTS

## Workflow

Use TodoWrite to track the workflow.

### 1. Determine Review Scope

Identify what needs to be reviewed:

- If the specific file paths are provided, review the specified files
- If the specific changes are provided, review the specified changes
- If no arguments provided, review the recent changes by using git status and git diff

### 2. Clarify Requirements

Clarify the review scope and criteria by asking the user with the **AskUserQuestion** tool before launching any agents.

- What specific aspects to focus on? (code quality, architecture patterns, feature completeness, etc.)
- Any particular concerns or requirements?

### 3. Context Gathering

Gather only essential context directly without launching any agents:

- Identify programming language(s) and framework(s)
- Understand the project architecture and patterns
- Review existing code conventions and style guides
- Test coverage and its impact

### 4. Focused Analysis

Review for **critical and major issues only**:

**Critical Issues** (must fix):
- Security flaws (injection, XSS, auth, secrets)
- Logic errors causing failure, data loss, or corruption
- Memory/resource leaks
- Concurrency bugs (race, deadlock)
- Breaking changes to public APIs
- Major violations of clean code or architecture that prevent maintainability

**Major Concerns** (should fix):
- Poor error handling that hides bugs
- Significant performance problems
- Architectural/code quality issues harming modularity or clarity
- Missing input validation on key paths
- Improper resource management

### 5. Present Findings

Provide concise, actionable feedback using this format:

```markdown
## Summary
[1-2 sentence overview of findings]

## Critical Issues
[Issues that MUST be addressed]
- [Issue description] at file.ext:line
  - Impact: [Concrete risk]
  - Recommendation: [Specific fix]

## Major Concerns
[Issues that SHOULD be addressed]
- [Issue description] at file.ext:line
  - Concern: [What could go wrong]
  - Suggestion: [Alternative approach]

## Recommended Actions
[Priority-ordered next steps]
```

**If no critical/major issues found**, state clearly that the code looks clean.

## Important Guidelines

- **Speed over completeness** - This is a quick scan, not exhaustive
- **High signal, low noise** - Only report issues that truly matter
- **Be specific** - Always include file:line references
- **No minor items** - Skip style, formatting, optional improvements
- **Limit findings** - Max 3-5 issues per category
- **Be constructive** - Explain why each issue matters and how to fix it
