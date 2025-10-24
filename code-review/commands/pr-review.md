---
description: Comprehensive review of entire PR or feature branch
argument-hint: PR number or branch name (optional)
---

# Pull Request Review

You are orchestrating a comprehensive pull request review. Focus on high-level coordination and let the code-reviewer agent handle the detailed analysis.

## Initial Request

$ARGUMENTS

## Workflow

Use TodoWrite to track the workflow.

### 1. Determine PR Scope

Identify what to review:

**If PR number provided** (e.g., "123" or "#123"):
- Use `gh pr view <number>` to get PR details
- Use `gh pr diff <number>` to see all changes
- Extract branch name and affected files

**If branch name provided**:
- Use `git diff <base-branch>...<branch>` to see all changes
- Use `git log <base-branch>...<branch>` to see commit history

**If no arguments provided**:
- Use `git status` to check current branch
- Review current branch against main/master
- Use `git diff <base-branch>...HEAD` for changes

### 2. Gather PR Context

Collect PR-specific information:
- PR description or commit messages describing the goal
- Linked issues or acceptance criteria if available
- Affected areas (frontend, backend, database, configs, etc.)

This context helps the reviewer understand what the feature should accomplish.

### 3. Clarify Requirements (If Needed)

If unclear about the feature or review expectations, ask:
- What is the purpose of this PR?
- Are there specific requirements to validate against?
- Any particular areas of concern?

### 4. Launch Code Reviewer

Launch the **code-reviewer** agent with complete context and feature-level focus:

**Provide**:
- PR goal and requirements (from Step 2)
- All changed files and diffs
- Commit messages
- Linked issues or acceptance criteria

**Focus areas** (the agent will determine how to validate these):
- Feature completeness: Does it deliver what was promised?
- Cross-cutting coherence: Do frontend/backend/database changes align?
- Production readiness: Tests, documentation, configurations
- Code quality and architecture

The agent will autonomously validate the feature and provide a formal review.

### 5. Summary Report

Present the agent's findings with formal merge recommendation:

**Feature Assessment**:
- Overall merge decision (Approve / Request Changes / Block)
- Rationale for the decision
- Critical issues or gaps
- Recommendations before merge

## Key Principles

- **Feature-level validation** - Focus on whether the PR delivers a complete, deployable feature
- **Minimal orchestration** - Gather context and specify focus areas, delegate analysis to the subagent
- **Agent autonomy** - Trust code-reviewer to determine how to validate completeness and quality
- **Formal assessment** - Provide clear merge recommendation (Approve/Request Changes/Block)
- **Cross-cutting focus** - Emphasize how all changes work together, not just individual files

## Notes

- For reviewing specific files only, use `/code-review` instead
- For security-focused reviews, use `/security-review` instead
- Requires git repository with commit history
- Can work with GitHub CLI (`gh`) if available
