---
description: Comprehensive code review based on requirements
argument-hint: Review requirements and scope
---

# Code Review

You are orchestrating a focused code review based on requirements and scope. Keep coordination high-level and let the agents handle the detailed analysis.

## Initial Request

$ARGUMENTS

## Workflow

Use TodoWrite to track the workflow.

### 1. Determine Review Scope

Identify what needs to be reviewed:

- If the specific file paths are provided, review the specified files
- If the specific changes are provided, review the specified changes
- If the specific PR is provided, review the specified PR
- If no arguments provided, review the recent changes by using git status and git diff

### 2. Clarify Requirements

Clarify the review scope and criteria by asking the user with the **AskUserQuestion** tool before launching any agents.

- What specific aspects to focus on? (code quality, architecture patterns, feature completeness, etc.)
- Any particular concerns or requirements?

### 3. (Optional) Launch PR Analyzer

**Only if the specific PR is provided:**

Launch the **pr-analyzer** agent to analyze the PR with clear review requirements and scope. It will provide a comprehensive summary of the PR and the checklist of the high-level requirements.

### 4. Launch Code Reviewer

Launch the **code-reviewer** agent to perform the review:
- Provide the review requirements and scope
- Let the agent autonomously analyze and provide feedback

The agent will provide a comprehensive code review to meet the review requirements and scope.

### 5. Present Summary

Once the agent completes, present the summary report with the following output format:

**Format**:
```markdown
## Summary
[Brief overview of review findings]

## Critical Issues
[Issues that must be addressed]
- [Issue description] at file.ext:line
  - Impact: [Why this matters]
  - Recommendation: [How to fix]

## Major Concerns
[Issues that should be addressed]
- [Issue description] at file.ext:line
  - Concern: [What could go wrong]
  - Suggestion: [Alternative approach]

## Minor Improvements
[Optional improvements for code quality]
- [Suggestion] at file.ext:line
  - Benefit: [Why this would help]

## Recommended Actions
[Overall suggestions for next steps]
```

## Key Principles

- **Focused scope** - Define clear review requirements and scope
- **Agent autonomy** - Trust agents to handle detailed analysis
- **Minimal orchestration** - Coordinate at high level, don't duplicate agent work
- **Clear scope** - Ensure reviewer knows exactly what to review
