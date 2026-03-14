# Traceability: {project_name}

Updated: {date} {time}

> Links requirements to design documents, implementation commits, and test evidence.
> REQ-IDs are scoped to a single mission. Cross-mission traceability uses the audit summary report.

## Matrix

| ID | Requirement | Design | Commit | Test | Status |
|----|-------------|--------|--------|------|--------|
| REQ-001 | {requirement text from plan} | {plans/design_doc.md or N/A} | {commit hash or —} | {test_file:TestClass or —} | PENDING |
| REQ-002 | {requirement text} | {design doc or N/A} | — | — | PENDING |

## Status Values

| Status | Meaning |
|--------|---------|
| `PENDING` | Requirement defined, not yet implemented |
| `IMPLEMENTED` | Code committed, test not yet verified |
| `VERIFIED` | Implementation tested and confirmed working |
| `DEFERRED` | Explicitly moved out of scope (add reason in Design column) |

## Lifecycle

| When | Who | Action |
|------|-----|--------|
| Task decomposition | Manager agent | Create matrix, assign REQ-IDs from plan's requirements/success criteria |
| Implementation complete | Worker agent | Fill Commit column (hash + summary) |
| Test complete | Worker agent | Fill Test column (file:class/function) |
| Completion gate | Manager agent | Verify all REQs are VERIFIED or DEFERRED (with justification) |

## Squad Lite Format

For squad-level tasks, use the simplified format (no design column):

| ID | Requirement | Commit | Test | Status |
|----|-------------|--------|------|--------|
| REQ-001 | {requirement} | {hash} | {test ref} | VERIFIED |
