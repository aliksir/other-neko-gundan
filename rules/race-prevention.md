> Ported from [neko-gundan](https://github.com/aliksir/neko-gundan). CLI-agnostic version.

# Race Condition Prevention Module (RACE-001)

> **Module**: `race_prevention` | **Default**: ON | **Scale**: Platoon+

Prevents file conflicts when multiple agents work in parallel.

## Manager Agent: Assignment Rules
- **Never let 2+ worker agents edit the same file simultaneously**
- Clearly assign file ownership when splitting tasks
- Consolidate shared file changes to a single worker agent

## Worker Agent: Boundary Rules
- **Never edit the same file as another worker agent simultaneously**
- Stay within your assigned files
- If you need to change a file outside your scope, consult the manager agent

## Integration Points

| Agent | Phase | Action |
|-------|-------|--------|
| manager agent | Pre-dispatch gate | Assign file ownership, verify no overlapping files between worker agents |
| worker agent | During work | Stay within assigned files, consult manager agent for out-of-scope changes |
