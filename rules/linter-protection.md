> Ported from [neko-gundan](https://github.com/aliksir/neko-gundan). CLI-agnostic version.

# Linter Config Protection Module

> **Module**: `linter_protection` | **Default**: ON | **Scale**: All

Prevents agents from silencing linter errors by editing linter configuration instead of fixing code.

## Problem

AI agents frequently "fix" linter errors by:
- Adding `// eslint-disable-next-line` or `# noqa` comments
- Editing `.eslintrc`, `ruff.toml`, `tsconfig.json` to weaken rules
- Adding files to `.eslintignore` or exclude patterns

This silences errors without fixing the underlying code quality issue.

Source: Harness Engineering research — "The model should fix the code, not the config."

## Protected Files

The following files should **not** be edited by agents unless explicitly instructed by the human:

### JavaScript/TypeScript
- `.eslintrc*` (`.eslintrc.json`, `.eslintrc.js`, `.eslintrc.yml`)
- `eslint.config.*` (`eslint.config.js`, `eslint.config.mjs`)
- `.eslintignore`
- `tsconfig.json` (compiler strictness options)
- `.prettierrc*`, `.prettierignore`
- `biome.json`, `biome.jsonc`

### Python
- `ruff.toml`, `.ruff.toml`
- `pyproject.toml` (`[tool.ruff]`, `[tool.mypy]`, `[tool.pylint]` sections)
- `.flake8`
- `mypy.ini`, `.mypy.ini`
- `.pylintrc`
- `setup.cfg` (linter sections)

### Rust
- `clippy.toml`, `.clippy.toml`
- `rustfmt.toml`

### Go
- `.golangci.yml`, `.golangci.yaml`

### General
- `.editorconfig`
- Any `*ignore` file that excludes source code from linting

## Rules

1. **Fix code, not config**: When a linter reports an error, fix the code to satisfy the rule
2. **No inline suppressions without justification**: `eslint-disable`, `noqa`, `#[allow(...)]` require a comment explaining **why** the rule doesn't apply (not just "to silence the error")
3. **Config changes need human approval**: If a linter rule is genuinely wrong for the project, the human decides — not the agent
4. **New project setup is exempt**: When explicitly setting up a new project's linter config, agents may create these files

## Completion Gate

When this module is active, add gate item: "No linter config weakened — verify no linter rules disabled without justification"

## Integration Points

| Agent | Phase | Action |
|-------|-------|--------|
| worker agent | During implementation | Do not edit protected linter config files; fix code instead |
| reviewer agent | During review | Verify no linter rules disabled/weakened in diff |
| manager agent | Completion gate | Check gate item (no linter config weakened) |
