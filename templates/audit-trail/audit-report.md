# Audit Report: {project_name} — {mission_summary}

Generated: {date} {time}

> Consolidated entry point for auditors. Links all audit artifacts for a single mission.

---

## Mission Overview

- **Objective**: {What was built or changed}
- **Duration**: {start date} — {end date}
- **Scale**: {squad / platoon / battalion}
- **Process weight**: {light / standard / strict}
- **Team**: {list of agents and roles}

---

## Traceability Summary

- Total requirements: {N}
- VERIFIED: {N} | IMPLEMENTED: {N} | PENDING: {N} | DEFERRED: {N}
- Coverage: {VERIFIED / Total}%
- Full matrix: `audit/{project_name}_traceability.md`

---

## Approval Summary

- Total approvals: {N}
- By type: Plan({N}), Design({N}), Code({N}), Gate({N}), Human({N})
- Full log: `audit/{project_name}_approvals.md`

---

## Change Summary

- Total changes: {N}
- APPROVED: {N} | REJECTED: {N} | IMPLEMENTED: {N}
- Full ledger: `audit/{project_name}_changes.md`

---

## Quality Evidence

- Checklist: `checklist/{date}_{project_name}.md` — {PASS}/{Total} items
- Metrics: `metrics/{project_name}_metrics.md`
- ISV: confidence={0.X}, outcome={0.X}, review_cycles={N}

---

## Artifacts

| Artifact | Path | Status |
|----------|------|--------|
| Plan | `plans/{project_name}_*.md` | {Exists / Missing} |
| Checklist | `checklist/{date}_{project_name}.md` | {All PASS / Issues} |
| Traceability | `audit/{project_name}_traceability.md` | {Complete / Incomplete} |
| Approvals | `audit/{project_name}_approvals.md` | {Complete / Incomplete} |
| Changes | `audit/{project_name}_changes.md` | {Complete / Incomplete} |
| Result report | `result/{date}_{project_name}.md` | {Exists / Missing} |
| Raw log | `logs/raw-{mission}-{date}.md` | {Exists / N/A} |
| Metrics | `metrics/{project_name}_metrics.md` | {Updated / N/A} |

---

## Gate Result

{N} completion gate items checked (PASS: {X}, N/A: {Y})

All items: {PASS / ISSUES NOTED}

{If issues: describe what was not PASS and why it was acceptable or what was done.}
