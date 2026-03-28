> Ported from [neko-gundan](https://github.com/aliksir/neko-gundan). CLI-agnostic version.

# Reflexion Module

> **Module**: `reflexion` | **Default**: ON | **Scale**: All

Structured reflection on failure to prevent repeating the same mistakes.

## Worker Agent: Reflexion (Required on Failure)

When a task fails or needs redo, add this reflection section to the report:

```
Reflection (Reflexion):
  Section A — Principled Reflection (What to avoid):
    - Pattern: [What pattern/situation led to failure]
    - Avoid: [Specific action to NOT do next time]
    - Why: [Root cause — why this approach failed]
  Section B — Procedural Reflection (How to succeed):
    - Success path: [Specific steps that would have worked]
    - Verification: [How to confirm the correct approach]
```

### Rules
- "I'll be more careful" is prohibited. Write **specific actions**
  - NG: "I'll be careful next time"
  - OK: "Next time I'll grep import paths before running tests"
- If root cause is unknown, honestly write "Cause unknown, consulting manager agent"
- Both sections are required. Omitting either is prohibited
- Section A captures "what to avoid" (principled reflection), Section B captures "how to succeed" (procedural reflection)
- Research basis: arxiv:2601.11974 (MARS) — separating principled and procedural reflection improves reasoning with less computational overhead

## Integration Points

| Agent | Phase | Action |
|-------|-------|--------|
| worker agent | Post-work (on failure) | Add Reflexion section (both Section A and Section B) to failure/redo report |
