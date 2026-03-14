> Ported from [neko-gundan](https://github.com/aliksir/neko-gundan). CLI-agnostic version.

# Intent State Vector Module (ISV)

> **Module**: `isv` | **Default**: OFF | **Scale**: Squad+

Records task intent, state, and results as a multi-dimensional vector. Makes the reasoning behind actions observable, enabling comparison and improvement of success/failure patterns.

## ISV Schema

```yaml
isv:
  # --- Intent dimensions (defined at task start) ---
  urgency: 0.5       # 0.0: no deadline, 0.5: normal, 1.0: immediate
  risk: 0.5          # 0.0: safe change, 0.5: normal, 1.0: destructive change
  complexity: 0.5    # 0.0: 1 file boilerplate, 0.5: few files, 1.0: large design change
  novelty: 0.5       # 0.0: reusing existing pattern, 0.5: partially new, 1.0: entirely new design
  purpose_alignment: 0.9  # 0.0: unrelated, 0.5: indirect, 1.0: core purpose

  # --- State dimensions (updated during execution) ---
  confidence: 0.8    # Judge result aggregate. 0.0: all low, 1.0: all high
  progress: 0.0      # 0.0: not started, 0.5: in progress, 1.0: complete
  retry_count: 0     # Retry count for same approach

  # --- Result dimensions (recorded at completion) ---
  outcome: 1.0       # 0.0: complete failure, 0.5: partial success, 1.0: full success
  review_cycles: 1   # Number of review cycles (1 = ideal)
  intervention_count: 0  # Number of human interventions
```

## Anchor Points (Scoring Guide)

To reduce subjective scoring variance across agents, each dimension has concrete anchors.

| Dimension | 0.0 | 0.3 | 0.5 | 0.7 | 1.0 |
|-----------|-----|-----|-----|-----|-----|
| urgency | No deadline, improvement | This week | Today | Within hours | Immediate, outage |
| risk | Typo fix, comments | Config value change | Feature addition | DB/API change | Destructive, production |
| complexity | 1 file, <10 lines | 1-2 files | 3-5 files | 6-10 files | 10+ files, design change |
| novelty | Copy-paste fix | Existing pattern applied | Partially new | Mostly new | Entirely new, no precedent |
| purpose_alignment | Unrelated to Purpose | Indirectly related | Improves main feature | Adds main feature | Core of Purpose |
| confidence | All low, unverified | Some low | All medium | Mostly high | All high, tool-verified |
| outcome | Complete failure, rollback | Major rework | Partially achieved | Minor fixes to complete | First-try success |

## Lite Version (Squad)

For squad-level tasks (1-2 file changes), only record 3 dimensions:

```yaml
isv_lite:
  risk: 0.3
  confidence: 0.8
  outcome: 1.0
```

## Manager Agent: ISV in Task Instructions

Add ISV start values to task instructions:
```
ISV (start):
  urgency: [0.0-1.0]  risk: [0.0-1.0]  complexity: [0.0-1.0]
  novelty: [0.0-1.0]  purpose_alignment: [0.0-1.0]
```

## Manager Agent: ISV in Reports

Add ISV result values to completion reports:
```
ISV (result):
  confidence: [0.0-1.0]  outcome: [0.0-1.0]
  review_cycles: [count]  intervention_count: [count]
```

## ISV Log Accumulation

Completed ISVs are appended to the ISV log file. Accumulated data enables pattern extraction for future improvement.

## Completion Gate

When this module is active, add gate item: "ISV recorded — Record result dimensions, append to ISV log"

## Integration Points

| Agent | Phase | Action |
|-------|-------|--------|
| manager agent | Task instruction (pre-dispatch) | Add ISV start values (urgency, risk, complexity, novelty, purpose_alignment) |
| manager agent | Completion gate (post-work) | Record ISV result values (confidence, outcome, review_cycles, intervention_count), append to ISV log |
