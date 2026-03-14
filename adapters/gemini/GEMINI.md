# Neko Gundan Rules (for Gemini CLI)

## Quality Rules

This project uses the neko-gundan quality rule set. Before any implementation:

1. Read `rules/review-protocol.md` — Implementer != Reviewer, max 3 review cycles
2. Read `rules/completion-gates.md` — Evidence-based completion checks
3. Read `rules/safety-tiers.md` — Destructive operation control

## On Every Task

- For non-trivial tasks (3+ files, design decisions), create a plan before coding (see `templates/plan.md` and `rules/process-weight.md` for when to skip)
- For non-trivial tasks, create a checklist (see `templates/checklist.md`)
- Run completion gate checks before declaring done
- Record failures with Reflexion format (see `rules/reflexion.md`)

## File Protection

- Do not edit linter config files to silence errors (see `rules/linter-protection.md`)
- Move deleted files to `_deleted/` instead of removing them

## Review Rules

- The implementer must not review their own code
- Reviewers are read-only: add comments only, do not modify code
- Review loops are capped at 3 cycles; escalate if unresolved

## Completion Checklist (before declaring done)

- [ ] Tests pass (or N/A with justification)
- [ ] `git status` is clean (all changes committed)
- [ ] No linter config files were weakened
- [ ] Deleted files moved to `_deleted/` (not removed)
- [ ] Plan document saved in `plans/`
- [ ] Result report saved in `result/`
