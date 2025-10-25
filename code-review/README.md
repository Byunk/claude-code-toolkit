# Code Review Plugin

Comprehensive code review toolkit for quality, architecture, and security analysis.

## Commands

- **`/code-review`** - Comprehensive code review based on requirements (uses subagents)
- **`/quick-review`** - Fast code quality check without subagents

## Agents

Autonomous agents that perform specialized reviews:

- **pr-analyzer** - Analyzes PR description, comments, commits, diffs, and CI/CD pipeline to provide a comprehensive summary of the PR
- **code-reviewer** - Reviews code quality, best practices, and architectural patterns

## Usage

### Comprehensive Review

For thorough analysis using specialized subagents:

```bash
/code-review:code-review Review the PR #123
/code-review:code-review Review the changes in the current branch
/code-review:code-review Review the changes in the FOO module
```

### Quick Review

For fast feedback:

```bash
/code-review:quick-review
/code-review:quick-review src/auth/login.ts
/code-review:quick-review Focus on security
```

**Recommendation**: Use this command with fresh context with `/clear` command before using it.
