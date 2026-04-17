Skill dir: SKILL_DIR, port=PORT, session_id=SESSION_ID
Task: TASK

Execute code via:
  bash SKILL_DIR/scripts/execute-code.sh --port PORT --session SESSION_ID

To mutate the notebook (create/edit/run cells, install packages):
  async with cm.get_context() as ctx:   ← must use async with or ops silently no-op
      cid = ctx.create_cell("...")      ← structural only, does not auto-run
      ctx.run_cell(cid)                 ← queue execution explicitly
      ctx.install_packages("pandas")    ← never use pip/uv add directly

Rules:
- Use heredoc for multiline code (avoids shell escaping issues)
- Never write to the .py file directly — kernel owns it
- No /tmp/... paths in cell code
- Prefer edit_cell over creating new empty cells

Return ONLY:
  {"success":true,"cell_id":"...","summary":"one line of what was done"}
  {"success":false,"error":"brief message"}
