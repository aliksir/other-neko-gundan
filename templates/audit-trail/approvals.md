# Approvals: {project_name}

Updated: {date} {time}

> Structured record of all approval decisions. Only positive verdicts (APPROVE, CONDITIONAL) are logged here.
> Rejections are tracked in the review protocol's normal flow.

## Log

| Date | Approver | Subject | Type | Verdict | Basis |
|------|----------|---------|------|---------|-------|
| {YYYY-MM-DD HH:MM} | {reviewer agent} | {PR/task description} | Code review | APPROVE | {rubric result, e.g., "4/4 aspects PASS, confidence: high"} |
| {YYYY-MM-DD HH:MM} | {lead agent} | {plan description} | Plan approval | APPROVE | {basis} |
| {YYYY-MM-DD HH:MM} | {human} | {subject} | Human approval | APPROVE | {basis} |

## Approval Types

| Type | Who approves | When recorded |
|------|-------------|---------------|
| `Plan approval` | Lead agent / human | After plan review |
| `Design review` | Reviewer (≠ designer) | After DB/API/UI design review |
| `Code review` | Reviewer agent | After code review (APPROVE verdict only) |
| `Gate approval` | Manager agent | After completion gate passes |
| `Human approval` | Human | When human explicitly approves |

## Verdict Values

| Verdict | Meaning |
|---------|---------|
| `APPROVE` | Approved to proceed |
| `CONDITIONAL` | Approved with noted conditions (record conditions in Basis column) |

## Who Records

| Event | Recorder |
|-------|----------|
| Code review approval | Reviewer agent appends after issuing APPROVE verdict |
| Design review approval | Reviewer appends after design gate passes |
| Plan/Gate approval | Manager agent appends |
| Human approval | Manager agent or lead agent appends when human approves |
