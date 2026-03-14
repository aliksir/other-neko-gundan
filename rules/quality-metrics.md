> Ported from [neko-gundan](https://github.com/aliksir/neko-gundan). CLI-agnostic version.

# Quality Metrics Module

> **Module**: `quality_metrics` | **Default**: OFF | **Scale**: All

Accumulates quality metrics per task and outputs a cumulative markdown report with trend analysis.

## Why

AI-generated code volume is growing faster than human review capacity. Without statistical visibility into quality trends, gates become theater — they exist but no one checks if they're working.

This module makes quality trends visible by accumulating per-task metrics into a single file per project, with inline explanations so the file is self-contained.

## Configuration

Set the output directory in your project config:

```
metrics_output_dir: /path/to/metrics/
```

If not configured, defaults to `{project_root}/_metrics/`.

## Output File

One cumulative file per project (not per task):

```
{metrics_output_dir}/{project_name}_metrics.md
```

Each task completion **appends** a row to Recent Tasks and **recalculates** the Summary.

## Metrics Procedure

### Timing
- After checklist export (if enabled), before writing the result report
- Part of the completion gate flow

### Data Sources

| Source | Metrics extracted |
|--------|------------------|
| Completion gate checklist | PASS / FAIL / SKIP counts, skip rate |
| ISV result dimensions | confidence, outcome, review_cycles, intervention_count |
| git diff / git log | Files changed count, hotspot detection |

### File Format

```markdown
# Quality Metrics: {project_name}
Updated: YYYY-MM-DD

## Summary (last 10 tasks)
| Metric | Value | Trend | What it means |
|--------|-------|-------|---------------|
| Gate pass rate | 87% | → | Completion gate PASS ratio. Low = quality gaps |
| Skip rate | 23% | ↑ ⚠️ | N/A skip ratio. High = gates becoming theater |
| Avg review cycles | 1.3 | ↓ | Review rounds per task. All 1 = reviews may be too lenient |
| Human interventions | 0.4/task | → | Human correction count. Sustained 0 = full autonomy or no oversight |
| Avg confidence | 0.82 | → | Judge confidence level. Low = passing with uncertainty |

## Alerts
- ⚠️ {metric} {description of concern}

## Recent Tasks
| Date | Task | Files | Cycles | Outcome | Confidence | Gate | Flags |
|------|------|-------|--------|---------|------------|------|-------|
| MM-DD | {summary} | {n} | {n} | {0-1} | {0-1} | {P/F/S} | {alerts} |

## Hotspots (last 30 days)
Files changed repeatedly may indicate unstable design.
| File | Changes | Last changed |
|------|---------|--------------|
| {path} | {n} | MM-DD |
```

### Trend Indicators
- `↑` increasing (last 3 vs previous 3)
- `↓` decreasing
- `→` stable
- `⚠️` appended when trend is concerning (skip rate up, confidence down, etc.)

### Reference Thresholds

| Metric | Healthy | Watch | Action needed |
|--------|---------|-------|---------------|
| Gate pass rate | 70-95% | 50-70% or >95% | < 50% |
| Skip rate | < 20% | 20-35% | > 35% |
| Avg review cycles | 1.2-2.0 | 1.0 (sustained) or > 2.5 | > 3.0 or sustained 1.0 for 5+ tasks |
| Human interventions | 0.2-1.0/task | 0 for 10+ tasks | Sustained 0 (no oversight?) |
| Confidence | > 0.7 | 0.6-0.7 | < 0.6 |

**Why sustained 1.0 review cycles are suspicious:** Some pushback is healthy. If every task passes review on the first try for an extended period, reviews may not be substantive.

**Why 100% gate pass rate is suspicious:** If nothing ever fails, gates may be too lenient or teams may be unconsciously avoiding challenging tasks.

### Alert Triggers

| Condition | Alert |
|-----------|-------|
| Skip rate > 30% | "Gate items are being skipped frequently — check if N/A is justified" |
| Avg review cycles = 1.0 for 5+ tasks | "All tasks pass first review — verify reviews are substantive" |
| Human interventions = 0 for 10+ tasks | "No human corrections detected — confirm oversight is active" |
| Confidence < 0.6 for any task | "Low-confidence task passed — review evidence quality" |
| Same file changed 5+ times in 30 days | "Hotspot detected — consider if design needs stabilizing" |

### Rules
- Keep the last 30 task rows in Recent Tasks (older rows archived or trimmed)
- Recalculate Summary from the last 10 tasks each time
- Hotspots are calculated from git log of the last 30 days
- If ISV module is not enabled, omit confidence/outcome columns and related metrics
- The file must be self-contained — all metric meanings are inline, no external references needed

## Integration Points

| Agent | Phase | Action |
|-------|-------|--------|
| manager agent / lead agent | Completion gate (after checklist export) | Append task metrics row to metrics file, recalculate summary |
| manager agent / lead agent | Completion gate | Check alert triggers; flag concerning trends |
| manager agent / lead agent | Periodic review | Review hotspots (files changed 5+ times in 30 days) for design instability |
