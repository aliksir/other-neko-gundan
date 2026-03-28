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
| Manager | Completion gate | Quality check on new entries (duplicates, actionable, tags) |
| Commander | Start gate | Search accumulated lessons and apply relevant knowledge |
