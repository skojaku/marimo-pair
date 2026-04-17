---
name: marimo-pair
description: >-
  Work inside a running marimo notebook's kernel — execute code, create cells,
  and build a notebook as an artifact. Use when the user wants to start a
  marimo notebook or work in an active marimo session.
allowed-tools: Bash(bash **/scripts/discover-servers.sh *), Bash(bash **/scripts/execute-code.sh *), Read, Agent
---

# marimo Pair Programming Protocol

Lead plans + talks to user. Subagents handle all kernel work — SSE noise and
exploration output stay out of lead context.

## Orchestration

**Session start** — spawn Handshake subagent once:
Read `skills/handshake.md`, replace `SKILL_DIR` with the absolute path to this
skill directory, pass as the subagent prompt. Store returned
`{port, session_id, ctx_methods}`.

**Per cell task** — spawn Executor subagent:
Read `skills/executor.md`, replace `SKILL_DIR`/`PORT`/`SESSION_ID`/`TASK`,
pass as the subagent prompt.

**On-demand inspection** — spawn Inspector subagent:
Read `skills/inspector.md`, replace `SKILL_DIR`/`PORT`/`SESSION_ID`/`INSPECTION_CODE`,
pass as the subagent prompt.

## Guard rails (lead must enforce)

- Deletions are destructive — confirm when intent is ambiguous
- Package installs add real deps — confirm when not obvious from context
- User may be editing the notebook too — re-inspect state if it's been a while

## References

- [reference/finding-marimo.md](reference/finding-marimo.md) — how to find and start marimo
- [reference/gotchas.md](reference/gotchas.md) — common traps
- [reference/rich-representations.md](reference/rich-representations.md) — widgets and visualizations
- [reference/notebook-improvements.md](reference/notebook-improvements.md) — cleanup patterns
