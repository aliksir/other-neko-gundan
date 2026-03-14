# Neko Gundan Conventions (for Aider)

## Core Rules

**Implementer != Reviewer.** Never review your own code.
**Max 3 review cycles.** Escalate if unresolved after 3 rounds.
**Evidence-based completion.** No gate item passes without a verifiable check.

## Before Coding

1. Create `plans/{task}.md` with scope, steps, and success criteria
2. Create `checklist/{date}_{project}.md` with work + QA items

## During Coding

- Fix linter errors in code, not in config files
- Do not edit `.eslintrc`, `ruff.toml`, `tsconfig.json` to silence errors
- Move deleted files to `_deleted/` instead of `rm`

## Before Declaring Done

- [ ] Tests pass
- [ ] `git status` clean
- [ ] Plan saved in `plans/`
- [ ] Report saved in `result/`

## On Failure

Record a Reflexion entry:
- What happened (facts only)
- Why it happened (root cause)
- Next time: [specific action, not "be careful"]

## Safety Tiers

**Tier 1 — Never do:**
- `rm -rf` on project or system directories
- Edit linter config to silence errors
- Skip or delete tests to make them "pass"

**Tier 2 — Confirm first:**
- Changes to 5+ files at once
- External API calls with side effects
- Database schema changes
