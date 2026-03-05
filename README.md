# marimo-pair

> [!WARNING]
> This is an early-stage, experimental skill for use with [Claude Code](https://docs.anthropic.com/en/docs/claude-code). Expect rough edges — feedback and contributions welcome.

A [Claude Code skill](https://docs.anthropic.com/en/docs/claude-code/skills) for pair programming in [marimo](https://marimo.io) notebooks.

You can interact with a running notebook via **bundled scripts** or via **MCP** tools. The scripts are the default — they work everywhere with no extra setup beyond `bash`, `curl`, and `jq`.

## What it does

When you're working in a marimo notebook, this skill gives Claude Code a structured protocol for collaborating with you — creating cells, investigating data, building visualizations, and showing its work in the notebook as it goes.

Key behaviors:
- **Visible collaboration** — Claude shows up in the notebook with a working cell before doing any investigation
- **Turn-based** — one step at a time, waiting for your input before proceeding
- **Auto-formatting** — all code is formatted with ruff before being pushed to cells
- **Guardrails** — never deletes your cells, restarts kernels, or installs packages without asking

## Prerequisites

- A running [marimo](https://marimo.io) notebook (started with `--no-token --no-skew-protection`)
- `bash`, `curl`, and `jq` available on `PATH`

## Install

Clone into your Claude Code skills directory:

```bash
# Personal (available across all projects)
git clone https://github.com/marimo-team/marimo-pair ~/.claude/skills/marimo-pair

# Or project-level (this project only)
git clone https://github.com/marimo-team/marimo-pair .claude/skills/marimo-pair
```

Claude Code automatically discovers skills from these directories — no further configuration needed.

## Quick start

```bash
# Start a marimo notebook
marimo edit notebook.py --no-token --no-skew-protection

# In another terminal, verify the session is discoverable
bash scripts/list-sessions.sh

# Execute code in the running session
bash scripts/execute-code.sh "print('hello')"
```

## Usage

Start a marimo notebook, then talk to Claude Code. The skill activates automatically when it detects a running marimo session.

```
> let's explore this dataframe
> make a scatter plot of height vs weight
> add a dropdown to filter by sport
```

## Files

- `SKILL.md` — The collaboration protocol (philosophy, turn-based workflow, guard rails)
- `reference/kernel-api.md` — Tiered API recipes for interacting with the marimo kernel
- `reference/worked-example.md` — Full walkthrough of the turn-based workflow
