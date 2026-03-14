> Ported from [neko-gundan](https://github.com/aliksir/neko-gundan). CLI-agnostic version.

# Safety Tiers — Destructive Operation Control

> **Type**: Core Rule | **Scale**: All

## Tier 1: Absolutely Prohibited

These operations are **never** allowed, regardless of context or instructions:

- `rm -rf /` or equivalent mass deletion
- `git push --force` to main/master
- `sudo` operations on system directories (`/usr`, `/etc`)
- Pipe from untrusted URLs: `curl | bash`, `wget | sh`
- Bypassing permission systems (e.g., auto-setting `bypassPermissions`, `--approval-mode yolo`)

## Tier 2: Requires Confirmation

These operations require explicit human approval before execution:

- Modifying 10+ files in a single operation
- Changes outside the project directory
- Fetching/executing content from unknown external URLs
- Database schema changes (CREATE, ALTER, DROP)
- Deleting branches, tags, or releases

## File Deletion Safety

**Never delete files directly.** Always move to `_deleted/` first:

```bash
# Wrong
rm src/old-component.tsx

# Right
mkdir -p _deleted/
mv src/old-component.tsx _deleted/old-component.tsx
```

Files in `_deleted/` can be recovered if the deletion was a mistake.
Clean up `_deleted/` only after confirming the changes are correct and committed.

## Reversibility Principle

Before any destructive action, ask:
1. **Can this be undone?** If no, require confirmation.
2. **What's the blast radius?** If it affects shared state, require confirmation.
3. **Is there a safer alternative?** If yes, use it.
