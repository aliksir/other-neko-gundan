> Ported from [neko-gundan](https://github.com/aliksir/neko-gundan). CLI-agnostic version.

# Process Weight Module (ESCALATION-001)

> **Module**: `process_weight` | **Default**: ON | **Scale**: All

Dynamic process weight selection. Start light, escalate when needed.

## Three Process Weights

| | Light | Standard | Strict |
|---|---|---|---|
| **Trigger** | Keyword (see below) | Default | Keyword or pre-release |
| **Completion gate** | Quick gate (test + diff only) | Full gate | Full gate + ensemble judge |
| **Review** | Self-check allowed | Implementer != Reviewer | Required + ensemble |
| **Whiteboard** | None | Multi-agent+ | Required |
| **Plans/Reports** | 1-line summary | Standard | Detailed |
| **ISV** | Skip | Optional | Required |

## Activation Keywords

Users trigger process weight with natural language:

**Light mode:** "quick fix", "light mode", "just a small change"

**Strict mode:** "careful", "strict mode", "pre-release", "production"

**Standard:** Default when no keyword is given.

## Light Mode — Quick Gate

Replaces the full completion gate with a minimal check (see `rules/completion-gates.md`):

| Gate # | Check | How to verify |
|--------|-------|---------------|
| #1 | Tests pass (all success criteria met) | Run test suite |
| #2 | No unintended diff | `git diff` shows only target files |
| #5 | Committed (no uncommitted new files) | `git status` is clean |

That's it. No plans/, no reports/, no ISV, no whiteboard.

### Reviewer in Light Mode

In Light mode, the **independent reviewer agent is not involved**. The implementer (worker agent or manager agent) performs self-check instead.

### Self-check Definition

"Self-check allowed" in Light mode means the **implementer** performs:

Allowed:
- Run tests to verify functionality
- Run lint/type checks for static quality
- `git diff` to verify no unintended changes
- Basic logic check

Not allowed (requires Standard/Strict mode):
- Critical review from alternative perspectives
- Security deep-dive
- Maintainability/architecture evaluation

## Escalation Protocol (ESCALATION-001)

**Any agent** can request a process weight upgrade. This is an **obligation, not a suggestion**.

### Escalation Triggers

Escalate from Light to Standard if **any one** matches:

| Trigger | Why |
|---------|-----|
| 3+ files need changes | Scope exceeds "quick fix" |
| DB or API changes involved | Structural risk |
| Security-relevant changes | Safety risk |
| Existing tests break | Unexpected blast radius |
| Agent judges "this isn't light" | Professional judgment |

### Escalation Format

```
ESCALATION-001: Process weight upgrade request
Current: Light
Proposed: Standard (or Strict)
Reason: [Specific trigger — e.g., "This touches 4 files including DB migration"]
```

### Rules

- Escalation is **never punished**. False positives are acceptable; missed risks are not
- The escalated agent **continues working** — don't restart from scratch
- Downgrading (Standard → Light) requires explicit human approval

## Strict Mode — When to Use

Strict mode adds maximum verification on top of standard:
- Pre-release changes
- Production database changes
- Security-sensitive features

Strict mode activates: ensemble judge, mandatory ISV, full evidence gates, arbiter on standby.

## Integration Points

| Agent | Phase | Action |
|-------|-------|--------|
| lead agent | Task assignment | Set initial process weight based on activation keywords |
| manager agent | Pre-dispatch | Pass process weight to worker agents in task instructions |
| worker agent | During work | Monitor escalation triggers, file ESCALATION-001 if needed |
| reviewer agent | Review start | Check process weight to determine review depth |
| lead agent | On ESCALATION-001 | Decide ACCEPT/REJECT/MODIFY for weight upgrade requests |
