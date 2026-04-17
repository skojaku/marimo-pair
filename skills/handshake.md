Skill dir: SKILL_DIR

1. bash SKILL_DIR/scripts/discover-servers.sh
   - If no servers: start one as background task (see SKILL_DIR/reference/finding-marimo.md), wait 3s, re-run.
   - If multiple: pick first.
2. bash SKILL_DIR/scripts/execute-code.sh --port PORT -c "import marimo._code_mode as cm; help(cm)"
3. Return ONLY:
   {"port":N,"session_id":"...","ctx_methods":["create_cell","edit_cell","run_cell",...]}
