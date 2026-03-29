> Ported from [neko-gundan](https://github.com/aliksir/neko-gundan). CLI-agnostic version.

# Raw Log Module

> **Module**: `raw_log` | **Default**: OFF | **Scale**: Squad+

Full audit trail of every agent action — what was read, changed, executed, and decided. For engineers who want to see **exactly** what the agent did, not just the summary.

"What did you check before saying done?"

## Why

Completion gates prove **what was checked**. Raw logs prove **what was done**. When you need to explain every line change to a stakeholder, the report isn't enough — you need the full diff, every command output, and the reasoning behind each decision.

## Output

One file per mission, generated **after work is complete** (not during execution).

```
logs/raw-{mission-name}-{YYYYMMDD}.md
```

## Output Format

Record every tool call at the same granularity as a context viewer.
**No summaries. No omissions. All entries recorded.**

```markdown
# Raw Log: {Mission Name}
**Date**: YYYY-MM-DD HH:MM
**Scale**: {squad/platoon/battalion}
**Team**: {agent list}

## Actions

- Read: C:/work/project/src/main.js (250行)
- Read: C:/work/project/package.json (32行)
- Glob: src/**/*.jsx → 8 files
- Grep: "useState" in src/ → 12 matches in 5 files
- Edit: C:/work/project/src/main.js L15-20 — import追加
- Edit: C:/work/project/src/main.js L45-80 — handleSubmit関数書き換え
- Write: C:/work/project/src/utils/helper.js (新規, 35行)
- Bash: cd C:/work/project && npm install (exit:0)
- Bash: cd C:/work/project && npm run build (exit:0)
- Bash: cd C:/work/project && npm test (exit:1, FAIL: 2/15)
- Decision: テスト失敗はimportパスの変更漏れ → helper.jsのexportを修正
- Edit: C:/work/project/src/utils/helper.js L12 — export名修正
- Bash: cd C:/work/project && npm test (exit:0, PASS: 15/15)
- SendMessage: → worker-agent-1 "テスト修正完了、再レビュー依頼"
- Agent: worker-agent-1 (worktree, background) "エッジケーステスト追加"
- Skill: /simplify → 変更ファイル3件レビュー
```

### 記録ルール

| ルール | 内容 |
|--------|------|
| **全件記録** | Read/Write/Edit/Bash/Grep/Glob/Agent/Skill/MCP等、**全てのツールコールを1件ずつ記録**。省略・まとめ・要約禁止 |
| **1行1アクション** | `- Read: {path} ({行数})` のようにツール名+対象+結果を1行で。リストマーカー `- ` 付き |
| **結果を含める** | Bash→exit code、Grep→match数、テスト→pass/fail数 |
| **失敗も記録** | エラー・リトライ・失敗した試行も全て記録（むしろ重要） |
| **Decisionは理由付き** | 判断・選択をした箇所は `- Decision:` で理由を1行記録 |
| **Readも全件** | ファイル読み込みは全て記録。「10ファイル読んだ」ではなく各ファイルを1行ずつ |

### ツール別フォーマット

| Action | Format |
|--------|--------|
| **Read** | `- Read: {path} ({N}行)` / `- Read: {path} L{start}-{end}` |
| **Edit** | `- Edit: {path} L{line} — {何を変えたか}` |
| **Write** | `- Write: {path} (新規, {N}行)` / `- Write: {path} (上書き, {N}行)` |
| **Bash** | `- Bash: {command} (exit:{code})` 失敗時は `(exit:{code}, {エラー要約})` |
| **Grep** | `- Grep: "{pattern}" in {path} → {N} matches in {M} files` |
| **Glob** | `- Glob: {pattern} → {N} files` |
| **Decision** | `- Decision: {何を判断したか} → {選んだ結果と理由}` |
| **SendMessage** | `- SendMessage: → {recipient} "{要約}"` |
| **Agent** | `- Agent: {name} ({options}) "{task}"` |
| **Skill** | `- Skill: /{name} → {結果要約}` |
| **MCP** | `- MCP: {tool_name}({params要約}) → {結果要約}` |

## Generation Procedure

### Worker Agent: Record During Work

During execution, keep a mental note of actions taken. No file writes during work — just remember what you did. At handoff time, include a **structured action list** in your completion report:

```yaml
actions:
  - tool: Edit
    file: src/checks/inbound.js
    line: 31
    diff: |
      + /\b(?:Invoke-Expression|IEX)\s*[\s(]/i,
      + /\bStart-Process\b/i,
  - tool: Bash
    command: node -e "const {CHECKS}..."
    output: "IN-002 patterns: 16"
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
