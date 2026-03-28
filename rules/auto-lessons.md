> Ported from [neko-gundan](https://github.com/aliksir/neko-gundan). CLI-agnostic version.

# Auto-Lessons Module

> **Module**: `auto_lessons` | **Default**: ON | **Scale**: All

Autonomous knowledge accumulation from both success and failure, inspired by Hyperagents' Archive pattern (arxiv:2603.19461, Meta AI).

Unlike Reflexion (failure-only), Auto-Lessons captures knowledge from **both success and failure**.

## Classification (aligned with Contextual Commits)

| Type | What to record | When |
|------|---------------|------|
| **learned** | API traps, undocumented behavior, non-obvious specs | Discovered a fact not in docs |
| **constraint** | Hard limits (API rate limits, browser compat, etc.) | Found a wall blocking approaches |
| **rejected** | Approaches tried and abandoned (**reason required**) | Chose not to use an approach |

## Write Target

- **Path**: `memory/lessons/{topic}.md` (e.g., `api.md`, `browser.md`, `testing.md`)
- Existing file: append. No existing file: create new

## Format

```
- [project-name] [tag] Knowledge content — Specific action guideline (YYYY-MM-DD)
```

## Trajectory Analysis (ERL, 2026-03-28追加, arxiv:2603.24639)

Auto-Lessons captures knowledge not only when discoveries occur during work, but also through **mandatory post-task trajectory analysis**. After every task completion (not just failures), analyze the task trajectory to extract transferable heuristics.

### When to analyze
- **Current (step 9.5)**: Record as discoveries happen during work — unchanged
- **New (completion report)**: Before submitting completion report, review the full task trajectory and extract any additional lessons not captured during work

### Analysis questions
1. What approach worked that wasn't obvious beforehand? → `learned`
2. What constraint did I discover that would affect similar tasks? → `constraint`
3. What alternative did I consider and reject? → `rejected` (reason required)

## Write Scoring (AgeMem, 2026-03-28追加, arxiv:2601.01885)

Before writing a lesson, score it on 3 criteria. Write only if 2+ criteria are YES:

| Criterion | Question | YES example | NO example |
|-----------|----------|-------------|------------|
| **Novelty** | Is this different from existing lessons on the same topic? | New API behavior not in docs | Already recorded in lessons/api.md |
| **Generality** | Can this be reused across multiple sessions/projects? | "Windows path separator breaks glob" | "This specific file had a typo" |
| **Actionability** | Does this change a concrete future action? | "Use --preserve-symlinks flag" | "Vite is complex" |

If fewer than 2 criteria pass, do NOT write to lessons/. Report via SendMessage only.

## Quality Criteria (enforced at completion gate)

1. **Actionable**: Must include concrete action. "Be careful" prohibited
2. **No duplicates**: Check existing lessons before writing
3. **Accurate tags**: Project name and topic must match actual project/domain
4. **Dated**: Include date for temporal context

## Scope Boundary

- **Writable**: `memory/lessons/` only
- **NOT writable**: CLAUDE.md, agent definitions, gates, rules, or any config files

## Integration Points

| Agent Role | Phase | Action |
|------------|-------|--------|
| Implementer | During work | Record knowledge to `memory/lessons/{topic}.md` when discoveries occur |
| Implementer | Post-work (completion report) | Perform trajectory analysis: review full task trajectory, extract additional lessons using Write Scoring |
| Manager | Completion gate | Quality check on new entries (duplicates, actionable, tags) |
| Commander | Start gate | Search accumulated lessons and apply relevant knowledge |
