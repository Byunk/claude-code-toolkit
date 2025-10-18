---
description: Systematic debugging workflow for deployment, CI/CD, runtime, and test failures
argument-hint: Describe the problem/error you're encountering
---

# Debugging Workflow

You are helping a developer debug an issue. Follow a systematic approach: understand the problem, identify root cause, design solution, implement and verify.

## Core Principles

- **Evidence-based diagnosis**: Base conclusions on logs, metrics, and configuration evidence
- **Use specialized agents**: Leverage devops-engineer for infrastructure, code-explorer for application code
- **Confidence levels**: Rate root cause confidence (0-100%); validate if <80%
- **Use TodoWrite**: Track debugging progress throughout

---

## Phase 1: Problem Understanding

**Goal**: Understand the issue and gather diagnostic data

Initial problem: $ARGUMENTS

**Actions**:
1. Create todo list with all debugging phases
2. Ask user for critical context:
   - Error messages, stack traces, or symptoms
   - Problem category (deployment, CI/CD, runtime, test failure)
   - When it started and what changed recently
   - Affected scope (services, environments, users)
   - Reproduction steps
3. Gather diagnostic data based on category:
   - **Deployment/Infrastructure**: Container logs, resource metrics, configs, recent changes
   - **CI/CD**: Pipeline logs, config files, environment variables, recent changes
   - **Runtime**: Application logs with timestamps, system metrics, recent deployments
   - **Test Failures**: Test output, test configs, recent code changes
4. Present summary to user and confirm completeness

---

## Phase 2: Root Cause Analysis

**Goal**: Identify the root cause using specialized agents

**Actions**:
1. Launch agents based on problem type (see guide below):
   - **Deployment/Infrastructure/CI-CD**: devops-engineer to analyze logs, configs, metrics
   - **Runtime Errors**: devops-engineer for infrastructure + code-explorer for application code
   - **Test Failures**: code-explorer to analyze failing tests and trace code paths

2. Review agent findings and synthesize insights
3. Present root cause analysis with:
   - Primary root cause with confidence level (0-100%)
   - Supporting evidence
   - Alternative theories if confidence <80%
4. If confidence <80%, validate hypotheses with additional investigation
5. **Present validated root cause to user and confirm before proceeding**

---

## Phase 3: Solution Design

**Goal**: Design concrete fixes with clear trade-offs

**Actions**:
1. Design solution approaches:
   - **Immediate Fix**: Quick remediation to restore service
   - **Proper Fix**: Comprehensive solution addressing root cause
   - **Long-term Prevention**: Changes to prevent recurrence

2. For each solution, document:
   - Exact changes needed (files, configurations, commands)
   - Potential risks and rollback plan
   - Verification approach

3. Present solutions with recommendation and trade-offs
4. **Ask user which approach they prefer**

---

## Phase 4: Implementation & Verification

**Goal**: Apply fix and verify it works

**DO NOT START WITHOUT USER APPROVAL**

**Actions**:
1. Wait for explicit user approval
2. Implement chosen solution:
   - File modifications with file:line references
   - Configuration changes
   - Commands with expected output
   - Update todos as you progress

3. Verify the fix:
   - Check original error is resolved
   - Monitor logs for new errors
   - Verify metrics returned to normal
   - Test affected functionality

4. Provide rollback instructions if issues arise
5. Mark all todos complete
6. Summarize:
   - Root cause identified
   - Fix applied with file references
   - Verification results
   - Prevention recommendations

---
