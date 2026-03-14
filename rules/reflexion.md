> Ported from [neko-gundan](https://github.com/aliksir/neko-gundan). CLI-agnostic version.

# Reflexion Module

> **Module**: `reflexion` | **Default**: ON | **Scale**: All

Structured reflection on failure to prevent repeating the same mistakes.

## Worker Agent: Reflexion (Required on Failure)

When a task fails or needs redo, add this reflection section to the report:

```
Reflection (Reflexion):
  - What happened: [Factual description]
  - Why it happened: [Root cause analysis]
  - Next time: [Specific improvement action]
```

### Rules
- "I'll be more careful" is prohibited. Write **specific actions**
  - NG: "I'll be careful next time"
  - OK: "Next time I'll grep import paths before running tests"
- If root cause is unknown, honestly write "Cause unknown, consulting manager agent"

## Integration Points

| Agent | Phase | Action |
|-------|-------|--------|
| worker agent | Post-work (on failure) | Add Reflexion section to failure/redo report |
