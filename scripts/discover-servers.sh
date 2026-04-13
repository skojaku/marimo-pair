#!/usr/bin/env bash
# List running marimo instances from the server registry.
# Cleans up stale entries (dead PIDs) and outputs live servers as JSON.
# No marimo installation required.
set -euo pipefail

# Locate the servers directory
is_windows=false
if [[ "$OSTYPE" == msys* || "$OSTYPE" == cygwin* ]]; then
  is_windows=true
  servers_dir="$HOME/.marimo/servers"
else
  servers_dir="${XDG_STATE_HOME:-$HOME/.local/state}/marimo/servers"
fi

if [[ ! -d "$servers_dir" ]]; then
  echo "[]"
  exit 0
fi

results="[]"
for f in "$servers_dir"/*.json; do
  [[ -e "$f" ]] || continue

  pid=$(jq -r '.pid' "$f" 2>/dev/null) || continue

  # Skip the liveness check on Windows: Git Bash/MSYS2 `kill` operates on
  # Cygwin PIDs, not the native Windows PIDs marimo writes, so it would
  # treat every live server as dead and delete valid registry entries.
  if [[ "$is_windows" == false ]]; then
    if ! kill -0 "$pid" 2>/dev/null; then
      rm -f "$f"
      continue
    fi
  fi

  entry=$(jq '.' "$f" 2>/dev/null) || continue
  results=$(echo "$results" | jq --argjson e "$entry" '. + [$e]')
done

echo "$results" | jq .
