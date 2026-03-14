# other-neko-gundan

**CLI-agnostic quality rules from the neko-gundan framework.**

The [neko-gundan](https://github.com/aliksir/neko-gundan) framework is a multi-agent
orchestration system built for Claude Code. Most of its quality protocols, however,
do not depend on any Claude-specific API — they are plain Markdown documents describing
*how to think about code quality*.

This package extracts those portable rules so you can use them with any AI CLI.

---

## Supported CLIs

| CLI | Adapter file | How it works |
|-----|-------------|--------------|
| [Codex CLI](https://github.com/openai/codex) | `AGENTS.md` | Codex reads `AGENTS.md` from the project root automatically |
| [Gemini CLI](https://github.com/google-gemini/gemini-cli) | `GEMINI.md` | Gemini CLI reads `GEMINI.md` from the project root automatically |
| [Aider](https://aider.chat/) | `.aider.conf.yml` + `conventions.md` | Aider loads the conventions file on every session |
| Any other CLI | Manual setup | Copy the rules you need and reference them in your system prompt |

---

## Quick Start

```bash
# Clone this repo (or use it as a git submodule)
git clone https://github.com/aliksir/other-neko-gundan.git

# Run the installer, pointing it at your project
bash other-neko-gundan/scripts/install.sh ./your-project
```

The installer:
1. Detects which supported CLIs are installed (`codex`, `gemini`, `aider`)
2. Copies the matching adapter file to your project root
3. Copies `rules/` and `templates/` to your project
4. Skips existing files (asks before overwriting)

---

## What's Included

### rules/

Core quality protocols — read these before starting any task.

| File | What it defines |
|------|----------------|
| `review-protocol.md` | Implementer != Reviewer rule, 3-cycle review cap, reviewer is read-only |
| `safety-tiers.md` | Destructive operation control (Tier 1: never / Tier 2: confirm first) |
| `completion-gates.md` | Evidence-based done criteria — no gate passes without a verifiable check |
| `reflexion.md` | Structured failure reflection format (what / why / next specific action) |
| `linter-protection.md` | Never silence linter errors by editing config — fix the code instead |
| `process-weight.md` | Light / Standard / Strict modes; escalation protocol when risk grows |
| `checklist-export.md` | How to create and maintain task checklists as external files |
| `quality-metrics.md` | Per-task metrics accumulation and trend analysis |
| `audit-trail.md` | Traceability records for decisions and changes |
| `faceted-prompting.md` | Prompt structure design using Separation of Concerns |
| `isv.md` | Intent State Vector — multi-dimensional task intent and result tracking |
| `jit-tests.md` | Just-in-Time disposable tests generated from git diff |
| `spec-driven-review.md` | Verify changes align with project spec, not just "does it work" |
| `whiteboard.md` | Cross-agent (or cross-session) shared knowledge file |
| `raw-log.md` | Append-only session log for context persistence |
| `fides.md` | Data trust levels (HIGH / MEDIUM / LOW) and promotion procedure |
| `race-prevention.md` | File conflict prevention when multiple agents work in parallel |

### templates/

Ready-to-use templates for common artifacts.

| File | Purpose |
|------|---------|
| `plan.md` | Task planning document (scope, steps, success criteria) |
| `result-report.md` | Completion report with evidence and metrics |
| `checklist.md` | Work + QA checklist |
| `whiteboard.md` | Cross-session shared knowledge |
| `audit-trail/traceability.md` | Requirement-to-implementation traceability |
| `audit-trail/approvals.md` | Approval records |
| `audit-trail/changes.md` | Change log |
| `audit-trail/audit-report.md` | Audit summary report |

### adapters/

CLI-specific configuration files.

```
adapters/
  codex/   AGENTS.md          — copy to project root for Codex CLI
  gemini/  GEMINI.md          — copy to project root for Gemini CLI
  aider/   .aider.conf.yml    — copy to project root for Aider
           conventions.md     — loaded by Aider every session
```

### scripts/

```
scripts/
  install.sh    — auto-detects installed CLIs and copies adapter + rules
```

---

## Manual Setup

If the installer doesn't fit your workflow, copy files manually:

```bash
# 1. Copy rules and templates
cp -r other-neko-gundan/rules/     ./rules/
cp -r other-neko-gundan/templates/ ./templates/

# 2. Copy the adapter for your CLI
cp other-neko-gundan/adapters/codex/AGENTS.md  ./AGENTS.md   # Codex
cp other-neko-gundan/adapters/gemini/GEMINI.md ./GEMINI.md   # Gemini
cp other-neko-gundan/adapters/aider/.aider.conf.yml ./       # Aider
cp other-neko-gundan/adapters/aider/conventions.md  ./
```

For any other CLI, reference the rules in your system prompt:

```
Before any task, read these files:
- rules/review-protocol.md
- rules/completion-gates.md
- rules/safety-tiers.md
```

---

## Relationship to neko-gundan

[neko-gundan](https://github.com/aliksir/neko-gundan) is the full Claude Code framework.
It includes multi-agent orchestration features (`TeamCreate`, `SendMessage`, `TaskGet`, etc.)
that only work inside Claude Code.

**other-neko-gundan** is the portable subset:

| Feature | neko-gundan | other-neko-gundan |
|---------|------------|-------------------|
| Quality rules (review, gates, safety) | Yes | Yes |
| Templates (plan, checklist, report) | Yes | Yes |
| CLI adapters (Codex, Gemini, Aider) | No | Yes |
| Multi-agent orchestration | Yes | No |
| Heartbeat / Polling protocols | Yes | No |
| Capacity escalation | Yes | No |
| Ensemble judge | Yes | No |

If you are using Claude Code, use [neko-gundan](https://github.com/aliksir/neko-gundan) directly.
If you are using any other CLI, use this package.

---

## License

MIT — see [LICENSE](LICENSE)
