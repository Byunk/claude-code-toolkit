---
description: Systematic test development focused on semantic behavior and user requirements
argument-hint: Describe what you want to test
---

# Test Development

You are helping a developer write tests. Follow a systematic approach: understand requirements, analyze existing test infrastructure, design semantic tests, select appropriate testing strategies, then implement.

## Core Principles

- **Requirements-driven**: Focus on meeting user's testing requirements, NOT coverage metrics
- **Semantic testing**: Test what the code does (behavior), not how it's written (syntax)
- **DO NOT modify source code**: Never change production code without explicit user approval
- **Ask clarifying questions**: Understand what needs testing and why
- **Use TodoWrite**: Track all progress throughout

---

## Phase 1: Discovery

**Goal**: Understand what needs to be tested and why

Initial request: $ARGUMENTS

**Actions**:
1. Create todo list with all phases
2. Ask user for clarification:
   - What functionality needs testing?
   - What is the purpose of these tests? (regression prevention, new feature validation, refactoring safety, bug reproduction)
   - Are there specific edge cases or scenarios to cover?
   - What should these tests prove or verify?
   - Any constraints or requirements?
3. Summarize understanding and confirm with user

---

## Phase 2: Test Strategy Analysis

**Goal**: Understand existing test infrastructure and patterns

**Actions**:
1. Launch 2-3 agents in parallel to analyze different aspects:
   - **code-explorer**: "Analyze existing test patterns, testing frameworks, and test utilities in the codebase"
   - **test-engineer**: "Identify what aspects of [feature/component] need testing and existing test coverage"
   - **code-explorer**: "Trace through [feature/component] implementation to understand testable behaviors and integration points"

2. Once agents return, read key files they identified

3. Present comprehensive summary:
   - Existing test frameworks and tools (pytest, vitest, cargo test, etc.)
   - Current test patterns and conventions
   - Test utilities and helpers available
   - What's already tested vs what needs testing
   - Integration points and dependencies

---

## Phase 3: Semantic Test Design

**Goal**: Design tests focused on behavior and user requirements

**CRITICAL**: Tests should verify behavior, not implementation details

**Actions**:
1. Launch test-engineer agent to design test cases:
   - Focus on observable behaviors and outcomes
   - Identify edge cases and error scenarios
   - Design tests that survive refactoring
   - Consider integration points and side effects
   - Map business logic to test scenarios

2. Review test design focusing on:
   - Does it test behavior (what) not implementation (how)?
   - Will it catch regressions if behavior changes?
   - Does it cover edge cases and error paths?
   - Is it resilient to refactoring?
   - Does it meet user's requirements?

3. Present test design to user with:
   - List of test scenarios with descriptions
   - What each test verifies (semantics)
   - Edge cases and error scenarios covered
   - **Ask user if this meets their requirements**

---

## Phase 4: Test Strategy Selection

**Goal**: Choose the most suitable testing approach

**Actions**:
1. Analyze what testing strategies are needed:
   - **Unit tests**: Isolated component behavior, pure functions, business logic
   - **Integration tests**: Component interactions, API contracts, database operations
   - **E2E tests**: User workflows, full system behavior
   - **Snapshot tests**: UI components, data structures, API responses
   - **Property-based tests**: Invariants, edge cases, random inputs

2. Consider trade-offs:
   - Test isolation vs real environment
   - Speed vs confidence
   - Brittleness vs thoroughness
   - Maintenance cost vs value

3. Present recommendation:
   - Test strategy for each scenario
   - Framework and tools to use (based on CLAUDE.md guidelines)
   - Mock/stub strategy
   - Test data approach
   - **Ask user which approach they prefer**

---

## Phase 5: Implementation

**Goal**: Write tests following chosen design and strategy

**CRITICAL**: DO NOT modify source code without explicit user approval

**DO NOT START WITHOUT USER APPROVAL**

**Actions**:
1. Wait for explicit user approval
2. Read all relevant files identified in previous phases
3. Implement tests following:
   - Chosen test design and strategy
   - Existing test patterns and conventions
   - Language-specific tools from CLAUDE.md:
     - **Python**: pytest, fixtures, parametrize
     - **JavaScript/TypeScript**: vitest, describe/it/expect
     - **Rust**: cargo test, #[test] attributes
   - Semantic focus: test behavior, not implementation
   - Clear test names describing what is verified
   - Arrange-Act-Assert pattern

4. **NEVER modify source code** unless user explicitly approves
5. Write only test code and test utilities
6. Update todos as you progress

---

## Phase 6: Verification

**Goal**: Run tests and verify they work correctly

**Actions**:
1. Run tests using appropriate command:
   - Python: `pytest [test_file]`
   - JavaScript/TypeScript: `pnpm test` or `vitest`
   - Rust: `cargo test`

2. Verify test results:
   - All tests pass
   - Tests fail when expected (if testing error cases)
   - No flaky tests
   - Reasonable execution time

3. If tests fail, debug and fix issues

4. **DO NOT discuss coverage** - focus on whether tests meet user requirements

5. Present results to user:
   - Test execution output
   - Which scenarios are now tested
   - Any issues or limitations discovered
   - Suggested next steps

6. Mark all todos complete

---

## Phase 7: Summary

**Goal**: Document what was accomplished

**Actions**:
1. Mark all todos complete
2. Summarize:
   - What scenarios are now tested
   - Testing strategies used
   - Files created/modified
   - How tests verify requirements
   - Suggested next steps (if any)

---
