> Ported from [neko-gundan](https://github.com/aliksir/neko-gundan). CLI-agnostic version.

# Review Loop Protocol

Quality assurance flow applied at all scales.

## 3 Principles (Core — Always Active)

1. **Implementer != Reviewer**: The agent who wrote it doesn't review it
2. **Reviewer is read-only**: No code modifications. Point out issues only, return to implementer for fixes
3. **Loop limit 3 cycles**: After 3 cycles, a senior arbiter intervenes to decide continue or abort

### Process Weight Exception

The "implementer != reviewer" principle has one defined exception:
- **Light mode** (see `rules/process-weight.md`): Self-check is allowed for simple, low-risk changes
- Light mode includes ESCALATION-001: if complexity exceeds expectations, the process weight is upgraded and independent review becomes mandatory
- This exception does NOT apply to Standard or Strict modes

All other principles (reviewer is read-only, loop limit 3) apply regardless of process weight.

## Scope Bind Rule (Sprint Contract)

Reviewers judge pass/fail ONLY against the plan's "acceptance criteria" (Sprint Contract).

- **Don't fail on criteria not in the contract**: Prevent scope creep ("this could also be improved")
- **Judge only what's in the contract**: Each criterion is PASS/FIX binary. All PASS = approved
- **Issues found outside contract**: Don't fail the review. Report via OBJECTION separately. Fix in next task
- **No acceptance criteria defined**: Use the plan's "success criteria" as substitute. If neither exists, request definition before starting review
- **Verifiability check**: Each criterion must have a stated verification method (command output, file check, browser/CLI result). Criteria without verification methods cannot be PASS/FIX judged — request plan completion before review. Inspired by Hyperagents (arxiv:2603.19461) "Evaluate on computable tasks"
- **Fuzzy words prohibited in criteria**: Words like "good", "appropriate", "sufficient", "clean", "correct", "readable", "efficient", "optimal", "stable", "high-quality", "user-friendly", "problem-free" make criteria unjudgeable. Replace with specific, measurable conditions

## Flow

```
implement -> review(edit:false) -> [issues found] -> fix -> review -> ... (max 3 times)
                                   [no issues]    -> supervise -> COMPLETE
```

## Context Rot Prevention

During fix phases, don't carry over previous session responses. Share information via review report files.

## External Tool Results Integration

Before the reviewer's rubric judgment, input the following external tool results as structured data:
- lint/type check results
- test results (pass/fail/coverage)
- security scan results (gitleaks, semgrep, etc.)

Eliminate "gut feeling LGTM" by requiring tool evidence.

### SAST Pre-injection Effectiveness (2026-03-28, arxiv:2602.16741)

In 8-model × 9,000-trial experiments, injecting SAST results before review recovered 47% of baseline failures, reaching 96.9% detection rate. Commercial models (including Claude) maintain 89-96% detection accuracy against adversarial comment injection, but the remaining 4-11% miss rate means SAST supplementation is mandatory for security-relevant PRs.

- **Required**: For security-impacting PRs, include betterleaks/semgrep/trivy scan results in reviewer input before starting review
- **Two-stage verification**: SAST pre-injection → JiTTests boundary value supplementation is the most effective pipeline

## Blind Review Principle (2026-03-28, arxiv:2603.18740)

LLM reviewers are influenced by PR description/commit message framing ("this is a bug fix", "this is safe"), reducing vulnerability detection by up to 93% (confirmation bias). In autonomous agent mode, attack success rate reaches 88%.

- **Diff-first evaluation**: Reviewers must evaluate code diff before reading PR descriptions/commit messages. Record preliminary evaluation, then cross-reference with description
- **Metadata removal**: For security-related reviews, intentionally hide committer info and PR descriptions ("blind review mode")
- **Autonomous agent caution**: When passing instructions to the reviewer agent, do not include implementer claims ("tests pass") verbatim. Pass only facts (test execution logs)

## Agent-as-a-Judge (Structured Review)

The reviewer agent uses a rubric with 5 aspects: correctness, safety, maintainability, testing, purpose alignment.
Eliminates subjective "looks good" with structured judgment.
When confidence is `low`, escalate to a senior/arbiter agent.

## Self-Verification Methods

| Method | When to use |
|--------|-------------|
| Test execution | After code changes, run the test suite |
| Expected output | Provide "this input -> this output is correct" for self-checking |
| Screenshot verification | For UI changes, use browser tools for visual check |
| Lint/type check | Static verification before review |

## Refactoring Limit

Based on research (arxiv:2602.21833): LLMs make large changes v0→v1, then converge to <1% changes by v3+. They also tend to make unnecessary changes to already-clean code.

- `/simplify` or refactoring requests: **max 2 passes**. A 3rd pass has near-zero ROI
- If changes are minimal or absent, declare "stabilized" and stop
- Define stopping criteria before starting any refactoring ("what specifically are we improving?")

## Test Quality Guide

Based on research (arxiv:2602.07900): AI-generated tests tend to mimic habits over rigor. Print statements outnumber asserts 4-5x. Test quantity has no statistical correlation with problem-solving rate (83% of tasks unaffected by test presence).

- **Assert-first**: Every test must contain formal assertions. Print-only tests are invalid
- **Quality over quantity**: Design few, precise tests targeting boundary values and edge cases
- **Reduction is OK**: Cutting test count is acceptable (impact is ~-2%)
- **Adversarial testing recommended**: Mutation-testing approach — deliberately inject bugs, verify tests catch them

## Structural Hints for Complex Code

Based on research (arxiv:2512.14917): LLM comprehension accuracy drops sharply on certain code structures. When working with these, include structural hints in prompts:

| Difficult Structure | Mitigation |
|-------------------|------------|
| Deep nesting (conditionals/loops) | Summarize nesting structure first |
| Inter-class dependencies | Provide call chain overview |
| Compound data types (custom objects) | Explicitly state type definitions |
| Third-party API calls | Briefly explain API behavior |

## DB Design Review Checklist

For all tasks involving database changes, conduct a DB design review before implementation. Reviewer must be different from designer.

| Aspect | What to check |
|--------|--------------|
| **Normalization** | 3NF or above. If denormalized, performance rationale must be documented |
| **Indexes** | Indexes defined for columns used in WHERE/JOIN/ORDER BY. No over-indexing |
| **Extensibility** | Design anticipates future column additions / table splits. No hardcoded ENUMs or fixed column counts |
| **Naming** | snake_case consistent. No abbreviation abuse. Consistent with existing tables |
| **Data types** | Appropriate type choices (VARCHAR length, INTEGER vs BIGINT, datetime types). NULL allowance justified |
| **Constraints** | PRIMARY KEY, FOREIGN KEY, UNIQUE, NOT NULL, DEFAULT values appropriate |
| **Migration** | No destructive changes to existing data. Rollback procedure defined |

### DB Review Flow

```
DB design doc -> DB review(edit:false) -> [issues] -> fix -> re-review -> ... (max 3 times)
                                          [no issues] -> proceed to API/UI design
```

## Optional Extensions

The following features are available as modules (see `rules/`):
- `rules/jit-tests.md` — Just-in-Time disposable tests from PR diffs
- `rules/spec-driven-review.md` — Verify alignment with project spec
- `rules/tdd-separation.md` — Separate test creation and implementation to different agents

## Integration Points

| Agent | Phase | Action |
|-------|-------|--------|
| worker agent | Implementation | Write code, hand off to reviewer agent |
| reviewer agent | Review (edit:false) | Apply rubric, return REQUEST_CHANGES or APPROVE |
| manager agent | Loop monitoring | Escalate to arbiter after 3 cycles |
| lead agent / arbiter | On 3+ cycle limit | Intervene: gather info, issue ruling, unblock |
