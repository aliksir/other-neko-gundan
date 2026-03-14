# Result Report: {project_name} — {task_summary}

**Date**: {date} {time}
**Author**: {agent_name}
**Plan**: `plans/{plan_file}`
**Checklist**: `checklist/{checklist_file}`

---

## Status

{COMPLETE / PARTIAL / FAILED}

## Summary

{2-3 sentences summarizing what was accomplished.}

## What Was Done

- {action taken}
- {action taken}
- {action taken}

## Files Changed

| File | Change type | Notes |
|------|------------|-------|
| {path} | {new / modified / deleted} | {notes} |

## Verification

{How the result was verified. Include test output, command output, or other evidence.}

```
{test output or command output}
```

## Reproduction Steps

Steps for a third party to verify the result:

```bash
{command 1}
{command 2}
```

## Completion Gate

| # | Item | Status | Evidence |
|---|------|--------|----------|
| 1 | Success criteria met | {PASS/FAIL/N/A} | {evidence} |
| 2 | No unintended changes | {PASS/FAIL/N/A} | {evidence} |
| 3 | Tests pass | {PASS/FAIL/N/A} | {evidence} |
| 4 | No new lint errors | {PASS/FAIL/N/A} | {evidence} |
| 5 | No uncommitted files | {PASS/FAIL/N/A} | {evidence} |
| 6 | Existing features not broken | {PASS/FAIL/N/A} | {evidence} |
| 7 | No accidental deletions | {PASS/FAIL/N/A} | {evidence} |

**Gate result**: {N} items checked (PASS: {X}, N/A: {Y})

## ISV (if enabled)

```yaml
isv:
  confidence: {0.0-1.0}
  outcome: {0.0-1.0}
  review_cycles: {n}
  intervention_count: {n}
```

## Reflexion (if task had failures)

```
- What happened: {factual description}
- Why it happened: {root cause}
- Next time: {specific action}
```

## Notes

{Any observations, caveats, or follow-up items not captured above.}
