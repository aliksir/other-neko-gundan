> Ported from [neko-gundan](https://github.com/aliksir/neko-gundan). CLI-agnostic version.

# Review Output Module

> **Module**: `review_output` | **Default**: ON | **Scale**: Squad+

Persists review results (simplify, reviewer agent) to files for traceability.

## Why

Reviews find real issues (C-1: 460-line dead code, C-2: timeout leak). Without file output, these findings exist only in conversation context and agent temp files that get cleaned up. Persisting reviews enables:
- Post-mortem analysis of what reviewers caught
- Pattern detection across reviews (recurring issue types)
- Evidence for completion gates

## Output

```
reviews/YYYYMMDD_{task}_{reviewer}.md
```

Examples:
- `reviews/20260329_my-feature_simplify.md`
- `reviews/20260329_my-feature_reviewer.md`

## Output Format

```markdown
# Review: {task} — {reviewer}

**Date**: YYYY-MM-DD HH:MM
**Reviewer**: simplify / reviewer agent
**Target**: {project} ({N} files reviewed)
**Verdict**: APPROVE / REQUEST_CHANGES

## Findings

| # | Severity | File:Line | Issue |
|---|----------|-----------|-------|
| 1 | critical | src/app.ts:338 | ... |

## Files Reviewed

- src/app.ts (1213 lines)
- src/config.ts (60 lines)
- ...

## Confidence

high / medium / low
```

## Who Writes the File

| Reviewer | Writer | Timing |
|----------|--------|--------|
| simplify (code-reviewer agent) | lead agent / manager agent | After agent completes, extract result and write to file |
| reviewer agent | lead agent / manager agent | After agent completes, extract result and write to file |

The review agents themselves run in read-only mode. The parent agent (lead or manager) receives the result and writes it to file.

## Integration Points

| Agent | Phase | Action |
|-------|-------|--------|
| lead agent / manager agent | After simplify completes | Write simplify result to `reviews/YYYYMMDD_{task}_simplify.md` |
| lead agent / manager agent | After reviewer agent completes | Write reviewer result to `reviews/YYYYMMDD_{task}_reviewer.md` |
| manager agent | Completion gate | Verify review files exist (when reviews were conducted) |

## Completion Gate

When reviews were conducted during the task, add gate item: "Review output files exist in `reviews/`"
