> Ported from [neko-gundan](https://github.com/aliksir/neko-gundan). CLI-agnostic version.

# Spec-Driven Review Module

> **Module**: `spec_driven_review` | **Default**: OFF | **Scale**: Platoon+ (recommended for squad with specs)

Verifies not just "does the code work" but also "does it align with the project spec/requirements."

## Flow

```
1. Before starting review, read the project spec/requirements
2. Check if changes align with the spec's direction
3. If misaligned -> return to implementer (state reason)
4. If spec is outdated/missing -> update spec first
```

## Review Checklist Additions

- [ ] Are changes related to the spec's stated main features?
- [ ] No unauthorized new features added beyond the spec?
- [ ] Does the tech stack align with the spec?

## Integration Points

| Agent | Phase | Action |
|-------|-------|--------|
| reviewer agent | Pre-review | Read project spec/requirements before starting code review |
| reviewer agent | Review | Check changes against spec direction; return to implementer if misaligned |
| manager agent | Pre-review (when spec is outdated/missing) | Update spec before review proceeds |
