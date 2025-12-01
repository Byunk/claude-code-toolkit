# Design Principles

## Background

### Subagents for separation of context

One of the key benefits of subagents is the **separation of context windows**. Each subagent starts with an isolated context window. This prevents the performance degradation caused by [**context rot**](https://research.trychroma.com/context-rot).

However, there is a downside to using subagents. Each subagent starts with an isolated context window, so it needs to collect context again from scratch. This results in redundant token usage. Therefore, we should use subagents only when the benefits of context separation outweigh the costs of redundant token usage.

### Skills for passing context

Skills are a powerful way to pass context to agents. It is not just a set of prompts, but a efficient structure to inject additional context in flexible way.

![Skill Architecture](https://www.anthropic.com/_next/image?url=https%3A%2F%2Fwww-cdn.anthropic.com%2Fimages%2F4zrzovbb%2Fwebsite%2Fa3bca2763d7892982a59c28aa4df7993aaae55ae-2292x673.jpg&w=3840&q=75)

As above, there are 3 levels in skills. Level 1 is a metadata located in SKILL.md's frontmatter. It is always loaded into agents so that agent can know what skill it is and when to call it. Level 2 is a SKILL.md file itself. It contains the skill's core capability and index of bundle files. Level 3 is a bundle files. It contains the skill's implementation including scripts, resources, and other files.

Therefore, the context within skills will be lazily loaded only when they are needed. And this is the key benefit of skills over other context management methods.

## Design Principles

### Principle 1: Context agnostic agents

The first principle came from seperation of concerns: **each agent should be context agnostic**.

The agent has to be designed for the specific workflow, not a context. For example, let assume we create a "React Developer" agent and let it use specific React library and patterns. You will soon find it difficult to use this agent in general. This because it violates the principle of separation of concerns.

Here are the common requirements for an agent:

- Clear definition of when to trigger the agent
- When to stop the agent
- Desired output
- Common steps to follow

### Principle 2: Skills as a dedicated way to pass contexts to agents

Skills are the most efficient way to pass contexts. Because SKILL.md is always loaded into agent's context window when it is called, it should only contain the most core capability of the skill. Additionally, the index of bundle files has to be provided in SKILL.md so that the agent can load the bundle files when they are needed.

Please refer to [this article](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices#mcp-tool-references) for the best practices of writing skills.

### Principle 3: Give agents a free hand

We should take advantage of the rapidly developing SOTA models. Don't limit its reasoning by providing excessive details. Keep instructions concise and let agents infer details and approach as needed.
