> Ported from [neko-gundan](https://github.com/aliksir/neko-gundan). CLI-agnostic version.

# Whiteboard Module (WHITEBOARD-001)

> **Module**: `whiteboard` | **Default**: ON | **Scale**: All

Cross-agent knowledge sharing and context persistence through a shared whiteboard file.

## Manager Agent: Whiteboard Management

For all multi-agent missions, create `{WHITEBOARD_DIR}/whiteboard-{mission}.md` as part of the pre-dispatch gate (mandatory — no skip). If a whiteboard with the same project name already exists, reuse it instead of creating a new one.

`WHITEBOARD_DIR` defaults to `whiteboard/` (project root relative). Override in your project config if needed.

### Template

See `templates/whiteboard.md` for the full template.

### Writing Rule: "Would other agents need to know this?" -> YES = write it

| Condition | Write | Don't write |
|-----------|-------|-------------|
| Discovery affecting other agents | Findings | - |
| Fact different from initial assumption | Findings | - |
| Info that might change design decisions | Findings | - |
| Cross-area insight | Cross-Cutting | - |
| Implementation detail within own scope | - | Direct report only |

## Worker Agent: Whiteboard Usage

### Before work
- Read the whiteboard (`{WHITEBOARD_DIR}/whiteboard-*.md`)
- Check other worker agents' Findings section
- Check if anything affects your work

### After work — Write judgment

**"Would other agents need to know this?" -> YES = write it**
- Discovery affecting other agents -> **Write in Findings** (with source)
- Fact different from initial assumption -> **Write in Findings**
- Cross-area insight -> **Write in Cross-Cutting**
- Completed within own scope -> **Don't write** (report directly to manager agent only)

### Knowledge Block Promotion (Focus Agent, 2026-03-28追加, arxiv:2601.07190)

When context compression may occur (long sessions, large codebases), critical information risks being lost. Promote important findings to **knowledge blocks** — compressed, self-contained summaries that survive context compression.

#### When to promote
At each work checkpoint (not just at the end), ask: "If context is compressed right now, would this information be lost?"

#### Knowledge block format
```markdown
## KB: {Topic} (promoted {timestamp})
- **Decision**: [What was decided and why]
- **Constraint**: [Hard limit discovered]
- **State**: [Current state that next agent must know]
```

#### Promotion criteria
| Question | If YES → |
|----------|----------|
| Would losing this change the next agent's approach? | Promote to KB |
| Is this a decision that can't be re-derived from code? | Promote to KB |
| Is this a constraint not documented anywhere else? | Promote to KB |

Knowledge blocks go in the **Findings** section of the whiteboard, prefixed with `## KB:` for easy identification. They are never deleted during the mission — only archived at mission completion.

### Rules
- Whiteboard is for knowledge sharing. Report progress directly to manager agent
- Don't modify other worker agents' Findings. Only update your section
- Don't write everything. Noise disturbs other agents

## Integration Points

| Agent | Phase | Action |
|-------|-------|--------|
| manager agent | Pre-dispatch gate | Create whiteboard, fill team structure (mandatory, no skip) |
| worker agent | Pre-work | Read whiteboard (mandatory for multi-agent, check if exists for single-agent) |
| worker agent | During work (checkpoints) | Promote critical findings to Knowledge Blocks when context compression risk exists |
| worker agent | Post-work | Write findings that affect other agents |
