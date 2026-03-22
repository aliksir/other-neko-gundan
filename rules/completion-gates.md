> Ported from [neko-gundan](https://github.com/aliksir/neko-gundan). CLI-agnostic version.

# Completion Gates

Quality checkpoints that must be passed before declaring any task complete. No exceptions, even for single-line changes.

## Start Gate (Before Beginning Work)

Execute before starting any mission. The gate is **not complete until all artifacts exist**.

| # | Check | How to verify |
|---|-------|---------------|
| 1 | Task scope is clear | Purpose + success criteria defined |
| 2 | New or existing project? | Check your project list to confirm. New project = will add to list at completion. Existing = will update version at completion |
| 3 | Target files identified | File list exists |
| 4 | No unresolved blockers | Check dashboard/whiteboard |
| 5 | Current state understood | Read target files, `git status` |
| 6 | Plan document created | `plans/{project}_*.md` exists with scope, steps, success criteria |
| 7 | QA/Work checklist created | `checklist/{date}_{project}.md` exists with work items + QA items derived from the plan |
| 8 | Dashboard initialized (multi-agent) | `status/dashboard.md` populated with What/Why/Who/Constraints/Current State |
| 9 | **Artifact existence confirmed** | `ls` confirms plan + checklist (+ dashboard for multi-agent) all exist. **Gate incomplete until all artifacts are present** |

## Pre-Report Checkpoint (Before Saying "Done" — Fires Unconditionally)

Regardless of scale or process weight, always run through this checkpoint before reporting completion to the commander.

| # | Check | How to verify |
|---|-------|---------------|
| 1 | **Request vs. result match** | Does what you actually did match what was requested? |
| 2 | **Evidence of working** | Not "I did it" but "here's proof it works" (command output, file existence, test results) |
| 3 | **Project list update** | New project → add to your project list. Existing project → update version info to match the work done |

\#1-2 are mental checks. #3 requires action.

---

## Completion Gate (Before Saying "Done")

Every item must be checked with evidence. "I confirmed it" is not evidence — "Here's the command output showing it works" is.

### Gate Execution Protocol (Mandatory)

1. **Forced Read**: Read this section before starting the gate. **Memory-based gate execution is prohibited.**
2. **Sequential execution**: Process items from #1 in order. For each item: run verification command → record evidence → move to next. Do not batch-mark items as "done."
3. **Item count check**: Report the total in the result: "**N items checked (PASS: X, N/A: Y)**". If the total doesn't match, there are missing items.

### Checklist: Created at Planning, Verified at Gate

The task checklist is created at the **start of planning** (not at gate time). See `rules/checklist-export.md` for the template and lifecycle.

At the completion gate, verify:
1. All checklist items are PASS or N/A (no unchecked items remain)
2. The checklist file exists in the configured output directory
3. Task-specific review items have been verified by the reviewer agent

### Gate Items (8 core + module additions)

| # | Check | How to verify | Evidence format |
|---|-------|---------------|--------------------|
| 1 | All success criteria met | Run tests, verify output | Test results / command output |
| 2 | No unintended changes | `git diff` review | Diff output showing only intended changes |
| 3 | Tests pass | Run test suite | Test pass/fail output |
| 4 | No new lint errors | Run linter | Linter output |
| 5 | No uncommitted new files | `git status` | Status output showing clean state |
| 6 | Existing features not broken | Run full test suite or smoke test | Test results |
| 7 | Files not accidentally deleted | Compare with start state | `git status` / file listing |
| 8 | Project list updated | Pre-Report Checkpoint #3 completed: new project added to list, or existing project version updated | Project list diff |

### Module-Specific Gate Items (When Active)

These items are added to the gate when the corresponding module is enabled.

| # | Module | Check | How to verify |
|---|--------|-------|---------------|
| 9 | whiteboard | Whiteboard archived | Move to archive, update dashboard |
| 10 | checklist_export | All checklist items PASS/N/A | Checklist file verified, no unchecked items |
| 11 | quality_metrics | Metrics updated | Metrics file updated with current task |
| 12 | isv | ISV recorded | Result dimensions filled, appended to ISV log |
| 13 | linter_protection | No linter config weakened | Diff shows no linter rule removals |
| 14 | reflexion | Failure reflection recorded (if applicable) | Reflexion section in report |
| 15 | progress_visibility | Dashboard finalized | `status/dashboard.md` has final status, "Mission: COMPLETE" |
| 16 | audit_trail | Audit trail recorded | Traceability: all REQs VERIFIED or DEFERRED. Approvals logged. Changes logged. Summary generated. |
| 17 | test_plan | Test plan completed | Test plan matrix exists, all unit test items (normal + abnormal) and integration test items checked. `[N/A]` if no code changes (docs/config only) |

## Process Weight Variants

Completion gate scope varies by process weight (see `rules/process-weight.md`):

| Weight | Gate Scope | Review |
|--------|-----------|--------|
| **Light** | Quick gate: items #1, #2, #5 only | Self-check allowed |
| **Standard** | Full gate: all core items (#1-#8) + active module items | Independent reviewer required |
| **Strict** | Full gate + ensemble judge + mandatory ISV | Independent reviewer + ensemble |

Default is **Standard** unless specified otherwise.

## Gate Evidence Format

Record gate results in a table:

```markdown
| # | Item | Status | Evidence |
|---|------|--------|----------|
| 1 | Success criteria | PASS | `npm test` output: 42 passed, 0 failed |
| 2 | No unintended changes | PASS | `git diff` shows only 3 target files |
| ... | ... | ... | ... |
```

## Rules

- All items must be `PASS` or `N/A` (with justification)
- If any item is `FAIL`, fix before declaring complete
- Manager agent executes the gate; reviewer agent independently verifies
- "I'll check later" is prohibited — check now or don't declare done

## File Deletion Safety

When deleting files:
1. Move to `_deleted/` directory first (never instant-delete)
2. Verify no references to the file remain
3. Next session can confirm and permanently remove
