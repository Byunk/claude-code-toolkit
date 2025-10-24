# Claude Code Toolkit

Comprehensive toolkit for coding in Claude Code.

## Plugins

- [Fullstack Development](./fullstack-dev) - Core workflows for full-stack development
- [Code Review](./code-review) - Comprehensive code review and PR analysis

## Installation

Launch Claude Code and run the following command:

```
/plugin marketplace add byunk/claude-code-toolkit
```

## Design Principles

### Claude Code as a Dedicated Orchestrator

An LLM model essentially suffers from the **Context Rot problem**. This means it loses its attention on earlier context as new context is added. As a result, Claude Code can forget initial architectural designs after writing code because it focuses more on the implementation details. 

To address this, main Claude Code agent should include only minimal context and focus solely on orchestrating the subagents. This may cause subagents to use more redundant tokens, but it allows the main agent to remain focused on high-level planning rather than being distracted by details.

### Task Delegation to Subagents

[Subagents](https://docs.claude.com/en/docs/claude-code/sub-agents) keep isolated contexts from the main conversation. This helps keep the main context clean and focused on high-level orchestration.

For this isolation to be effective, subagents should be designed to run tasks independently without additional input. Each subagent should focus on clear and complete responsibilities with necessary information provided upfront. Therefore, define subagents only when there are clear benefits to separating context.

### Allow Claude Code the freedom

Claude Code is already highly capable. So, there's no need to limit its reasoning capabilities by providing excessive details in agent prompts, commands, or workflows. Keep instructions concise and let agents infer details and approach as needed.

## Additional curated plugins

- [claude-code-plugins](https://github.com/anthropics/claude-code) - A core plugins for development such as PR review, feature development, etc.
- [anthropic-agent-skills](https://github.com/anthropics/skills) - A collection of core skills for Claude Code agents.

## Contributing

Contributions are welcome! Whether you have ideas for plugin designs, feedback on existing agents, or suggestions for new workflows, please open an issue or submit a pull request.
