> Ported from [neko-gundan](https://github.com/aliksir/neko-gundan). CLI-agnostic version.

# Faceted Prompting Module

> **Module**: `faceted_prompting` | **Default**: ON | **Scale**: All

Design guideline for structuring agent prompts using Separation of Concerns (SoC). Based on TAKT's Faceted Prompting approach.

## Problem

Agent prompt definitions grow over time. When rules, instructions, and personality are mixed together, two issues emerge:

1. **Lost in the Middle**: LLMs pay most attention to the beginning and end of prompts. Rules placed in the middle get forgotten
2. **Maintenance burden**: Changing one rule requires finding and updating it across a mixed document

## Solution: 5 Facets

Structure agent definitions into 5 distinct facets, ordered to exploit attention bias:

| # | Facet | What it defines | Attention zone |
|---|-------|----------------|---------------|
| 1 | **Persona** | Who the agent is — identity, tone, catchphrases | Beginning (Primacy) |
| 2 | **Knowledge** | What to reference — modules, data sources, external info | Middle |
| 3 | **Instruction** | What to do — procedures, workflows, decision flows | Middle |
| 4 | **Output Contract** | How to output — report formats, templates, schemas | Middle→End |
| 5 | **Policy** | What constraints to enforce — rules, prohibitions, safety | **End (Recency)** |

## Recency Effect Placement

**Critical**: Policy (behavioral rules, safety tiers, objection protocols) must be placed at the **end** of agent definitions.

LLMs exhibit a U-shaped attention curve:
- **Beginning**: Strong attention (Primacy effect) → Place Persona here
- **Middle**: Weakest attention (Lost in the Middle) → Procedure and reference content
- **End**: Strong attention (Recency effect) → Place Policy/constraints here

This is why rules written in the middle of agent definitions get ignored — it's not disobedience, it's attention bias.

## Recommended Agent Definition Order

```
# Agent Name
  ├── Compaction Recovery Protocol    (Meta — recovery needs)
  ├── Character & Tone                (Persona — identity first)
  ├── Role                            (Instruction — what to do)
  ├── Work Procedure / Judge Flow     (Instruction — how to do it)
  ├── Report Format                   (Output Contract — how to report)
  ├── Active Modules                  (Knowledge — what's available)
  ├── Behavioral Rules                (Policy — constraints)    <- Recency zone
  ├── Objection Protocol              (Policy — escalation)     <- Recency zone
  └── Safety Tiers (if applicable)    (Policy — hard limits)    <- Recency zone
```

## Facet Mapping

| Facet | Equivalent in agent system | Files |
|-------|--------------------------|-------|
| Persona | Character & Tone section in each agent | `agents/*.md` |
| Knowledge | Active Modules, Data Source Rules | `agents/*.md` + `rules/*.md` |
| Instruction | Role, Work Procedure, Task Decomposition | `agents/*.md` |
| Output Contract | Report Format, Instruction Format | `agents/*.md` |
| Policy | Behavioral Rules, Safety Tiers, Objection Protocols | `agents/*.md` + `rules/*.md` |

## Shared Policy (DRY)

Cross-agent policies go in `rules/` (shared) rather than duplicated in each agent:

```
rules/
  ├── review-protocol.md      (Shared Policy: review loop rules)
  ├── completion-gates.md     (Shared Policy: gate items)
  ├── safety-tiers.md         (Shared Policy: deletion safety)
  └── ...

agents/
  ├── worker-agent.md         (Agent-specific Policy at end)
  ├── manager-agent.md        (Agent-specific Policy at end)
  └── ...
```

Change a shared rule once in `rules/` → all agents pick it up.

## When Creating or Modifying Agent Definitions

1. Identify which facet the new content belongs to
2. Place it in the correct zone (beginning/middle/end)
3. If it's a constraint or prohibition → it's Policy → put it at the end
4. If it applies to multiple agents → put it in `rules/` instead

"Structure controls attention. Put what matters most where the AI looks last."
