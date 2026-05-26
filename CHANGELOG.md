# Changelog

## [1.2.1] - 2026-05-25

### Documentation
- Clarified the relationship with the upstream [neko-gundan](https://github.com/aliksir/neko-gundan) framework. **other-neko-gundan is an intentionally portable subset** of the quality rules, maintained on a separate versioning track for use with any AI CLI (Codex, Gemini CLI, Aider, etc.). The Claude-Code-specific multi-agent orchestration features of the upstream framework are intentionally excluded here.
- Shared quality rules were last synced from upstream as of **2026-03-29**. The upstream framework has since advanced to a higher version; the version gap is expected and does not indicate that this package is out of date.
- This release is documentation-only — no rule behavior changed.

## [1.2.0] - 2026-03-29

### Added
- `review-output.md` — new module to persist review results to files for traceability

### Changed
- `raw-log.md` — rewritten to 1-line-per-action format (no more timestamp headings), added tool-specific format table, enforced no-omission recording rule

## [1.0.0] - 2026-03-15

### Initial Release
- CLI-agnostic quality rules extracted from neko-gundan framework
- Review protocol, gate definitions, reflexion module
- Test plan gate and update checker
- Compatible with Codex, Gemini CLI, Aider, and other AI coding agents
