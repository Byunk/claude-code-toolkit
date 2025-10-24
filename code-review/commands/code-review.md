---
description: Review specific files or recent changes for code quality and architecture
argument-hint: File paths or leave empty for recent changes
---

# Code Review

You are orchestrating a focused code review for specific files or recent changes. Keep coordination high-level and let the code-reviewer agent handle the detailed analysis.

## Initial Request

$ARGUMENTS

## Workflow

### 1. Determine Review Scope

Identify what needs to be reviewed:

**If file paths provided**:
- Review the specified files

**If no arguments provided**:
- Check git status for uncommitted changes
- Review files with modifications (use `git diff` to see changes)
- If no uncommitted changes, review recent commits (last 1-3 commits)

Use TodoWrite to track the workflow.

### 2. Clarify Requirements (If Needed)

If the review scope or criteria are unclear, use the **AskUserQuestion** tool to ask:
- What specific aspects to focus on?
- Any particular concerns or requirements?
- Should this check against specific coding standards?

### 3. Launch Code Reviewer

Launch the **code-reviewer** agent to perform the review:
- Provide clear scope (files to review)
- Specify review criteria (code quality, architecture patterns)
- Let the agent autonomously analyze and provide feedback

The agent will:
- Analyze code quality (readability, maintainability, best practices)
- Review architecture patterns and design
- Identify technical debt
- Provide structured, actionable feedback

### 4. Present Summary

Once the agent completes, summarize:
- Key findings (critical issues, concerns, improvements)
- Overall assessment
- Recommended actions

## Key Principles

- **Focused scope** - Review specific files or recent changes, not entire codebase
- **Agent autonomy** - Trust code-reviewer to handle detailed analysis
- **Minimal orchestration** - Coordinate at high level, don't duplicate agent work
- **Clear scope** - Ensure reviewer knows exactly what to review

## Notes

- For full PR reviews, use `/pr-review` instead
- For security-focused reviews, use `/security-review` instead
- Use git commands to determine scope when needed
