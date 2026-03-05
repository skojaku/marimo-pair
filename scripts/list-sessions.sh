#!/usr/bin/env bash
# List running marimo sessions from the session registry.
# Cleans up stale entries (dead PIDs) and outputs live sessions as JSON.
# No marimo installation required.
set -euo pipefail

# Locate the sessions directory
if [[ "$OSTYPE" == msys* || "$OSTYPE" == cygwin* ]]; then
  sessions_dir="$HOME/.marimo/sessions"
else
  sessions_dir="${XDG_STATE_HOME:-$HOME/.local/state}/marimo/sessions"
fi

if [[ ! -d "$sessions_dir" ]]; then
  echo "[]"
  exit 0
fi

results="[]"
for f in "$sessions_dir"/*.json; do
  [[ -e "$f" ]] || continue

  pid=$(jq -r '.pid' "$f" 2>/dev/null) || continue

  # Clean up stale entries
  if ! kill -0 "$pid" 2>/dev/null; then
    rm -f "$f"
    continue
  fi

  entry=$(jq 'del(.auth_token)' "$f" 2>/dev/null) || continue
  results=$(echo "$results" | jq --argjson e "$entry" '. + [$e]')
done

echo "$results" | jq .
