# Claude Code Toolkit

A comprehensive plugin toolkit for Claude Code, with a clear separation of concerns.

Anthropic has released powerful features for Claude Code: commands, agents, hooks, and skills. However, finding effective examples of their use remains challenging. One of the common mistakes is defining responsibilities with ambiguous boundaries, which confuses Claude Code and leads to misbehavior.

This project helps you to use these features effectively by providing a set of plugins and core design principles.

## Plugins

- [Fullstack Development](./fullstack-dev) - Core workflows for full-stack development
- [Code Review](./code-review) - Comprehensive code review and PR analysis
- [ERD Skill](./erd-skill) - Database design and ERD creation using DBML format

## Installation

Launch Claude Code and run the following command:

```bash
/plugin marketplace add byunk/claude-code-toolkit
```

## Usage Guide

Use the following slash commands as needed.

**Feature Development**:

Recommended to use this command for complex feature development.

```bash
/fullstack-dev:feature-dev <Describe the feature in detail>
```

**Comprehensive Code Review**:

```bash
/code-review:code-review Review the PR #123
/code-review:code-review Review the changes in the current branch
/code-review:code-review Review the changes in the FOO module
```

**Quick Code Review**:

Note: This command does not invoke any subagents. Recommend you to use this command with fresh context with `/clear` command before using it.

```bash
/code-review:quick-review Review the changes in the BAR module
```

## Design Principles

### Claude Code as a Dedicated Orchestrator

LLMs experience attention degradation over long contexts, known as the [**Context Rot problem**](https://research.trychroma.com/context-rot). As more context accumulates, Claude Code tends to forget initial context which typically includes the most important requirements and high-level plans—and instead focuses on implementation details.

To address this, keep the primary context window minimal and focused on high-level orchestration. Delegate low-level details, such as context gathering, sub-planning, and execution, to subagents. While subagents might occasionally gather redundant information by using more tokens, this approach ensures the main agent remains focused on high-level planning without distraction.

### Task Delegation to Subagents

[Subagents](https://docs.claude.com/en/docs/claude-code/sub-agents) maintain contexts isolated from the main conversation. This keeps the main context clean and focused on orchestration.

For effective isolation, define each subagent with a single, clear, and complete responsibility so it can run tasks independently within a single context window.

One of the best practices is to create a subagent only when there are clear benefits to separating context.

### Domain Knowledge to Skills

[Skills](https://docs.claude.com/en/docs/claude-code/skills) package domain knowledge (instructions, scripts, resources) for specific tools and file types.

However, it might mess up the context window with low-level details. Therefore, skills has to be called carefully with proper context window management. One of the best practices is to call skills by subagents which keep isolated contexts about low-level details.

### Allow Claude Code the freedom

Claude is a highly capable model. There’s no reason to constrain its reasoning with overly prescriptive instructions. Keep guidance concise and let it infer details and approach as needed.

## Additional curated plugins

- [claude-code-plugins](https://github.com/anthropics/claude-code) - A core plugins for development such as PR review, feature development, etc.
- [anthropic-agent-skills](https://github.com/anthropics/skills) - A collection of core skills for Claude Code agents.

## Contributing

Contributions are welcome! Whether you have ideas for plugin designs, feedback on existing agents, or suggestions for new workflows, please open an issue or submit a pull request.

Use `scripts/dev-install.sh` to locally install the plugins for development.

```bash
./scripts/dev-install.sh
```
