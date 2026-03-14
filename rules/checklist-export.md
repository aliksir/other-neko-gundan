> Ported from [neko-gundan](https://github.com/aliksir/neko-gundan). CLI-agnostic version.

# Checklist Export Module

> **Module**: `checklist_export` | **Default**: ON | **Scale**: All

Exports task checklists to external files for progress tracking, human review, and record keeping.

## Why

- Checklists embedded in conversation context are lost when context is compacted
- Creating checklists only at completion means progress is invisible during execution
- Separate checklist files are searchable, diffable, and auditable

## Configuration

Set the output directory in your project config:

```
checklist_output_dir: /path/to/checklist/
```

If not configured, defaults to `{project_root}/_checklist/`.

## Checklist Lifecycle

### When to Create

**At the start of planning** — the checklist is the first deliverable of any task.

1. Lead agent (small tasks) or manager agent (multi-agent) creates the checklist file
2. The "Checklist created" item becomes the first PASS item
3. The checklist is updated as work progresses
4. At completion gate, all items must be PASS or N/A

### File Naming

```
{checklist_output_dir}/YYYYMMDD_{project_name}.md
```

Same-day duplicates: append `_2.md`, `_3.md`, etc.

## Checklist Template

See `templates/checklist.md` for the full template.

The checklist has 3 sections: Start, Task-specific, and Completion.

### Section Descriptions

| Section | Who defines | When defined | Purpose |
|---------|------------|-------------|---------|
| **Start** | Template (fixed) | At checklist creation | Ensures planning artifacts exist before work begins |
| **Task-Specific** | Lead/manager agent (planning) | During planning phase | Tracks task progress and prevents gaps |
| **Completion** | Template (fixed) | At checklist creation | Ensures all deliverables and records are finalized |

### Updating the Checklist

- Update the timestamp at phase transitions (planning complete, implementation complete, gate complete)
- Mark items `[x]` as they are completed during work (not just at the end)
- Add items to Task-Specific if new requirements emerge during execution
- Items that become irrelevant: mark as `[N/A] {reason}`

## Completion Gate Integration

At the completion gate, verify:
1. All checklist items are `[x]` (PASS) or `[N/A]` with justification
2. No items remain `[ ]` (unchecked)
3. The checklist file exists in the configured output directory

### Rules
- Every checked item should have evidence where applicable
- FAIL items must include what went wrong
- Link the checklist file from the result report

## Integration Points

| Agent | Phase | Action |
|-------|-------|--------|
| lead agent / manager agent | Planning start | Create checklist file with Start + Task-Specific + Completion sections |
| manager agent | During work | Update checklist items as work progresses |
| manager agent | Completion gate | Verify all items PASS or N/A, link from result report |
