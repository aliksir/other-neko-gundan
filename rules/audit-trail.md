> Ported from [neko-gundan](https://github.com/aliksir/neko-gundan). CLI-agnostic version.

# Audit Trail Module

> **Module**: `audit_trail` | **Default**: OFF | **Scale**: Squad+

Records structured audit evidence across the software development lifecycle: requirements traceability, approval records, change management, and audit summary reports.

## Why

Multi-agent systems already record process quality (checklists, metrics, ISV) but lack **audit-ready** evidence:

- **Traceability gap**: No link from requirements → design → commits → tests
- **Approval records vanish**: Review approvals live in conversation context and disappear on compaction
- **Change management is scattered**: Reasons for changes depend on git commit messages alone
- **No consolidated view**: Auditors need a single entry point, not scattered artifacts

## Configuration

Set the output directory in your project config:

```
audit_output_dir: /path/to/audit/
```

If not configured, defaults to `{project_root}/audit/`.

## Output Files

One cumulative file per record type per project:

```
{audit_output_dir}/{project_name}_traceability.md   # Requirements traceability matrix
{audit_output_dir}/{project_name}_approvals.md       # Approval log
{audit_output_dir}/{project_name}_changes.md         # Change management ledger
{audit_output_dir}/{project_name}_audit-report.md    # Consolidated audit summary
```

Templates are in `templates/audit-trail/`.

---

## 1. Traceability Matrix

Links requirements to design documents, implementation commits, and test evidence.

See `templates/audit-trail/traceability.md` for the full template.

### Status Values

| Status | Meaning |
|--------|---------|
| `PENDING` | Requirement defined, not yet implemented |
| `IMPLEMENTED` | Code committed, test not yet verified |
| `VERIFIED` | Implementation tested and confirmed working |
| `DEFERRED` | Explicitly moved out of scope (with reason) |

### REQ-ID Convention

```
REQ-{NNN}  — Sequential within a project mission
```

---

## 2. Approval Log

Structured record of all approval decisions. Persists what currently vanishes in conversation context.

See `templates/audit-trail/approvals.md` for the full template.

### Approval Types

| Type | Who approves | When recorded |
|------|-------------|---------------|
| `Plan approval` | Lead agent / human | After plan review |
| `Design review` | Reviewer (≠ designer) | After DB/API/UI design review |
| `Code review` | Reviewer agent | After code review (APPROVE only) |
| `Gate approval` | Manager agent | After completion gate passes |
| `Human approval` | Human | When human explicitly approves |

Only positive verdicts are logged here. Rejections are tracked in the review protocol's normal flow.

---

## 3. Change Management Ledger

Tracks scope changes, design pivots, and process weight escalations with reasons and impact analysis.

See `templates/audit-trail/changes.md` for the full template.

### What Gets Recorded

| Trigger | Change type | Who records |
|---------|------------|-------------|
| Scope change (adding/removing features) | Scope | Manager agent |
| Design pivot after review feedback | Design | Manager agent |
| ESCALATION-001 (process weight upgrade) | Process | Manager agent |
| Emergency fix / hotfix | Unplanned | Manager agent |
| Human mid-task instruction change | Directive | Lead agent |

### CHG-ID Convention

```
CHG-{NNN}  — Sequential within a project mission
```

---

## 4. Audit Summary Report

Consolidates all audit artifacts into a single entry point for auditors. Generated at the completion gate.

See `templates/audit-trail/audit-report.md` for the full template.

### When Generated

Manager agent generates the audit summary as part of the completion gate, after all other gate items are checked.

---

## 5. Log Reconstruction (Rebuild)

Reconstructs audit logs after the fact — from git history, existing artifacts (plans/, result/, checklist/), and project files.

### Reconstruction Sources

| Scenario | Primary data source |
|----------|-------------------|
| "Where did that file go?" | `git log --all --full-history -- "**/filename"`, `_deleted/` |
| "Who approved this change?" | `result/*`, `git log --grep="APPROVE"` |
| "What requirements did this task cover?" | `plans/*`, `git log`, test files |
| "Why was the scope changed?" | `git log`, `result/*`, whiteboard archives |

Reconstructed logs are output with a `_rebuilt` suffix and never overwrite originals.

---

## Scale Variants

| Scale | Traceability | Approvals | Changes | Summary |
|-------|-------------|-----------|---------|---------|
| **Squad** | Lite (REQ-ID + commit only) | Review approvals only | On scope change only | Skip |
| **Platoon+** | Full | Full | Full | Full |

---

## Completion Gate Item

When this module is active, add to the completion gate:

| # | Check | How to verify |
|---|-------|---------------|
| 15 | Audit trail recorded | Traceability: all REQs VERIFIED or DEFERRED. Approvals: all reviews logged. Changes: all scope changes logged. Summary: generated (platoon+) |

---

## Integration Points

| Agent | Phase | Action |
|-------|-------|--------|
| manager agent | Task decomposition | Create traceability matrix with REQ-IDs from plan requirements |
| manager agent | During work (on scope/design changes) | Append to change management ledger |
| manager agent | Completion gate | Verify all REQs VERIFIED/DEFERRED, generate audit summary |
| reviewer agent | Post-review (APPROVE verdict) | Append to approval log |
| worker agent | Post-work (completion report) | Include commit hashes and test references for traceability |
| lead agent | On human approval / directive changes | Append to approval log / change ledger |
