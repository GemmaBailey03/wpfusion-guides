#!/usr/bin/env bash
set -euo pipefail

ROOT="/Users/gemmabailey/AiStuff/WP Fusion"
CURSOR="/Applications/Cursor.app/Contents/Resources/app/bin/cursor"
LOG_DIR="$HOME/Library/Logs/wpfusion-marketing"
WA_BRIDGE="http://127.0.0.1:8080/api/send"
WA_RECIPIENT="447932656999"
mkdir -p "$LOG_DIR"

STAMP="$(date +%Y-%m-%d_%H%M)"
DAY_NAME="$(date +%A)"
LOG="$LOG_DIR/run-${STAMP}.log"

notify() {
  local msg="$1"
  echo "$msg" >>"$LOG"
  python3 -c 'import json,sys,urllib.request; msg=sys.stdin.read(); payload=json.dumps({"recipient":"447932656999","message":msg}).encode(); urllib.request.urlopen(urllib.request.Request("http://127.0.0.1:8080/api/send", data=payload, headers={"Content-Type":"application/json"}), timeout=10)' <<<"$msg" 2>/dev/null \
    && echo "WhatsApp sent" >>"$LOG" \
    || echo "WhatsApp bridge unavailable" >>"$LOG"
}

{
  echo "=== WP Fusion marketing run $STAMP ($DAY_NAME) ==="
  cd "$ROOT"

  if [ "$(date +%u)" = "4" ]; then
    "$ROOT/scripts/ensure-browser-hub.sh" || notify "⚠️ WP Fusion marketing — Browser Hub failed to start Thu $(date +%-d\ %b). Forum step may skip."
  fi

  if ! "$CURSOR" agent status 2>&1 | grep -qi "logged in"; then
    notify "⚠️ WP Fusion marketing — NOT STARTED $(date +%-d\ %b)

• Blocked at: Cursor agent CLI not logged in
• Action: run once in Terminal:
  /Applications/Cursor.app/Contents/Resources/app/bin/cursor agent login"
    exit 1
  fi

  PROMPT="$(cat "$ROOT/marketing/agent-run-prompt.txt")"

  if "$CURSOR" agent --print --trust --force --workspace "$ROOT" "$PROMPT" >>"$LOG" 2>&1; then
    echo "Agent run completed"
  else
    notify "❌ WP Fusion marketing — agent run failed $(date +%-d\ %b). Check $LOG"
    exit 1
  fi
} >>"$LOG" 2>&1
