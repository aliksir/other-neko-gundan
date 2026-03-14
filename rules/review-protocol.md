> Ported from [neko-gundan](https://github.com/aliksir/neko-gundan). CLI-agnostic version.

# Review Loop Protocol

Quality assurance flow applied at all scales.

## 3 Principles (Core — Always Active)

1. **Implementer != Reviewer**: The agent who wrote it doesn't review it
2. **Reviewer is read-only**: No code modifications. Point out issues only, return to implementer for fixes
3. **Loop limit 3 cycles**: After 3 cycles, a senior arbiter intervenes to decide continue or abort

### Process Weight Exception

The "implementer != reviewer" principle has one defined exception:
- **Light mode** (see `rules/process-weight.md`): Self-check is allowed for simple, low-risk changes
- Light mode includes ESCALATION-001: if complexity exceeds expectations, the process weight is upgraded and independent review becomes mandatory
- This exception does NOT apply to Standard or Strict modes

All other principles (reviewer is read-only, loop limit 3) apply regardless of process weight.

## Flow

```
implement -> review(edit:false) -> [issues found] -> fix -> review -> ... (max 3 times)
                                   [no issues]    -> supervise -> COMPLETE
```

## Context Rot Prevention

During fix phases, don't carry over previous session responses. Share information via review report files.

## Agent-as-a-Judge (Structured Review)

The reviewer agent uses a rubric with 5 aspects: correctness, safety, maintainability, testing, purpose alignment.
Eliminates subjective "looks good" with structured judgment.
When confidence is `low`, escalate to a senior/arbiter agent.

## Self-Verification Methods

| Method | When to use |
|--------|-------------|
| Test execution | After code changes, run the test suite |
| Expected output | Provide "this input -> this output is correct" for self-checking |
| Screenshot verification | For UI changes, use browser tools for visual check |
| Lint/type check | Static verification before review |

## Optional Extensions

The following features are available as modules (see `rules/`):
- `rules/jit-tests.md` — Just-in-Time disposable tests from PR diffs
- `rules/spec-driven-review.md` — Verify alignment with project spec

## Integration Points

| Agent | Phase | Action |
|-------|-------|--------|
| worker agent | Implementation | Write code, hand off to reviewer agent |
| reviewer agent | Review (edit:false) | Apply rubric, return REQUEST_CHANGES or APPROVE |
| manager agent | Loop monitoring | Escalate to arbiter after 3 cycles |
| lead agent / arbiter | On 3+ cycle limit | Intervene: gather info, issue ruling, unblock |
