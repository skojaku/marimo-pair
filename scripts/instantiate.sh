#!/usr/bin/env bash
# Instantiate a marimo notebook (run all cells) via the HTTP API.
# Use after starting the server on the user's behalf so cells are ready.
# No marimo installation required — talks directly to the HTTP API.
#
# Usage:
#   instantiate.sh [--port PORT]
set -euo pipefail

port=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --port) port="$2"; shift 2 ;;
    -*)     echo "Unknown option: $1" >&2; exit 1 ;;
    *)      break ;;
  esac
done

# Locate the servers directory
if [[ "$OSTYPE" == msys* || "$OSTYPE" == cygwin* ]]; then
  servers_dir="$HOME/.marimo/servers"
else
  servers_dir="${XDG_STATE_HOME:-$HOME/.local/state}/marimo/servers"
fi

# Find a live registry entry
entry=""
count=0
for f in "$servers_dir"/*.json; do
  [[ -e "$f" ]] || continue

  pid=$(jq -r '.pid' "$f" 2>/dev/null) || continue
  if ! kill -0 "$pid" 2>/dev/null; then
    rm -f "$f"
    continue
  fi

  e=$(cat "$f")

  if [[ -n "$port" ]]; then
    e_port=$(echo "$e" | jq -r '.port')
    if [[ "$e_port" == "$port" ]]; then
      entry="$e"
      count=1
      break
    fi
    continue
  fi

  entry="$e"
  count=$((count + 1))
done

if [[ $count -eq 0 ]]; then
  echo "No running marimo instances found." >&2
  exit 1
fi

if [[ $count -gt 1 ]]; then
  echo "Multiple instances found. Use --port to specify." >&2
  exit 1
fi

host=$(echo "$entry" | jq -r '.host')
e_port=$(echo "$entry" | jq -r '.port')
base_url=$(echo "$entry" | jq -r '.base_url')
base="http://${host}:${e_port}${base_url}"

# Discover session ID
sessions_resp=$(curl -sf "${base}/api/sessions") || {
  echo "Failed to connect to marimo server at ${base}" >&2
  exit 1
}

session_ids=$(echo "$sessions_resp" | jq -r 'keys[]')

if [[ -z "$session_ids" ]]; then
  echo "No active sessions on the server." >&2
  exit 1
fi

session_count=$(echo "$session_ids" | wc -l | tr -d ' ')

if [[ $session_count -gt 1 ]]; then
  echo "Multiple sessions on server. Use --port to specify." >&2
  exit 1
fi

session_id=$(echo "$session_ids" | head -1)

# Instantiate the notebook (run all cells)
resp=$(curl -sf -X POST "${base}/api/kernel/instantiate" \
  -H "Content-Type: application/json" \
  -H "Marimo-Session-Id: ${session_id}" \
  -d '{"objectIds": [], "values": []}' \
  --max-time 30) || {
  echo "Failed to instantiate notebook." >&2
  exit 1
}

echo "Notebook instantiated."
