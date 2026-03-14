> Ported from [neko-gundan](https://github.com/aliksir/neko-gundan). CLI-agnostic version.

# Raw Log Module

> **Module**: `raw_log` | **Default**: OFF | **Scale**: Squad+

Full audit trail of every agent action — what was read, changed, executed, and decided. For engineers who want to see **exactly** what the agent did, not just the summary.

## Why

Completion gates prove **what was checked**. Raw logs prove **what was done**. When you need to explain every line change to a stakeholder, the report isn't enough — you need the full diff, every command output, and the reasoning behind each decision.

## Output

One file per mission, generated **after work is complete** (not during execution).

```
logs/raw-{mission-name}-{YYYYMMDD}.md
```

## Output Format

```markdown
# Raw Log: {Mission Name}
**Date**: YYYY-MM-DD HH:MM
**Scale**: {squad/platoon/battalion}
**Team**: {agent list}

## {agent-name}

### [{HH:MM:SS}] Read {file_path}
(Read file — {N} lines)

### [{HH:MM:SS}] Edit {file_path}:{line}
```diff
- old line
+ new line
```

### [{HH:MM:SS}] Bash {command summary}
```
{full output}
```
exit: {code}

### [{HH:MM:SS}] Search {pattern} in {path}
{match count} matches in {file count} files

### [{HH:MM:SS}] Decision
{reasoning for a judgment or choice}
```

### What to Log

| Action | Log content |
|--------|-------------|
| **Read** | File path, line count |
| **Edit** | File path, line number, full diff (unified format) |
| **Write** | File path, full content |
| **Command** | Command, full stdout/stderr, exit code |
| **Search** | Pattern, match count, file count |
| **Decision** | What was decided and why |
| **Handoff** | Recipient, summary of message |

### What NOT to Log

- Internal planning thoughts (these are in the whiteboard)
- Repeated identical reads of the same file (log once)
- Tool calls that returned empty/no-op results (unless relevant to a decision)

## Generation Procedure

### Worker Agent: Record During Work

During execution, keep a structured action list. At handoff time, include it in the completion report:

```yaml
actions:
  - tool: Edit
    file: src/checks/inbound.js
    line: 31
    diff: |
      + new line added
  - tool: Command
    command: npm test
    output: "42 passed, 0 failed"
    exit: 0
```

### Manager Agent: Generate Log File

After all worker agents complete and before the completion gate:

1. Collect action lists from all worker agent completion reports
2. Run `git diff` to capture the authoritative diff (not relying on agent memory)
3. Combine into the log file format
4. Write to `logs/raw-{mission}-{YYYYMMDD}.md`

### Enrichment from Git

The git diff is the **source of truth** for code changes. Agent-reported diffs are cross-checked:

```bash
git diff HEAD~{N}..HEAD -- {files}
```

If the agent's reported diff doesn't match git, use git's version and flag the discrepancy.

## Configuration

Set the output directory in your project config (optional, defaults to `logs/`):

```
raw_log_output_dir: logs/
```

## Completion Gate

When this module is active, add gate item: "Raw log generated — `logs/raw-{mission}-*.md` exists with action details"

## Integration Points

| Agent | Phase | Action |
|-------|-------|--------|
| worker agent | Post-work (completion report) | Include structured action list in handoff |
| manager agent | Pre-completion-gate | Collect action lists, run git diff, generate raw log file |
| manager agent | Completion gate | Verify raw log file exists |
