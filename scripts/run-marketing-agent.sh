#!/usr/bin/env bash
set -euo pipefail

# EC2 production (Amazon Linux, ec2-user)
if [ -d "/home/ec2-user/wp-fusion" ] && [ "$(id -un)" = "ec2-user" ]; then
  ROOT="/home/ec2-user/wp-fusion"
  AGENT="${HOME}/.local/bin/agent"
  LOG_DIR="${ROOT}/logs"
  IS_EC2=1
else
  # Mac (legacy / manual runs)
  ROOT="/Users/gemmabailey/AiStuff/WP Fusion"
  CURSOR="/Applications/Cursor.app/Contents/Resources/app/bin/cursor"
  LOG_DIR="$HOME/Library/Logs/wpfusion-marketing"
  IS_EC2=0
fi

WA_BRIDGE="http://127.0.0.1:8080/api/send"
mkdir -p "$LOG_DIR"

if [ -f "${ROOT}/.env" ]; then
  set -a
  # shellcheck source=/dev/null
  source "${ROOT}/.env"
  set +a
fi

STAMP="$(date +%Y-%m-%d_%H%M)"
DAY_NAME="$(date +%A)"
LOG="${LOG_DIR}/run-${STAMP}.log"

notify() {
  local msg="$1"
  echo "$msg" >>"$LOG"
  python3 -c 'import json,sys,urllib.request; msg=sys.stdin.read(); payload=json.dumps({"recipient":"447932656999","message":msg}).encode(); urllib.request.urlopen(urllib.request.Request("http://127.0.0.1:8080/api/send", data=payload, headers={"Content-Type":"application/json"}), timeout=10)' <<<"$msg" 2>/dev/null \
    && echo "WhatsApp sent" >>"$LOG" \
    || echo "WhatsApp bridge unavailable" >>"$LOG"
}

configure_git_for_push() {
  if [ -n "${GITHUB_TOKEN:-}" ]; then
    git -C "$ROOT" remote set-url origin "https://x-access-token:${GITHUB_TOKEN}@github.com/GemmaBailey03/wpfusion-guides.git"
  fi
}

check_unpushed_commits() {
  local ahead=0
  git -C "$ROOT" fetch origin main >/dev/null 2>&1 || true
  ahead="$(git -C "$ROOT" rev-list --count origin/main..HEAD 2>/dev/null || echo 0)"
  if [ "$ahead" -gt 0 ]; then
    if [ -z "${GITHUB_TOKEN:-}" ]; then
      notify "❌ WP Fusion marketing — NOT COMPLETED $(date +%-d\ %b)

• Failed at: git push to GitHub
• Error: GITHUB_TOKEN is not set — commits are on the server but the live site was not updated
• Partial work: guide/content may be committed locally on EC2
• Action: Add GITHUB_TOKEN to ~/wp-fusion/.env — see docs/GITHUB-TOKEN-SETUP.md"
      return 1
    fi
    notify "❌ WP Fusion marketing — NOT COMPLETED $(date +%-d\ %b)

• Failed at: git push to GitHub
• Error: $ahead commit(s) on EC2 were not pushed (token may be invalid or expired)
• Action: Check GITHUB_TOKEN in ~/wp-fusion/.env — see docs/GITHUB-TOKEN-SETUP.md"
    return 1
  fi
  return 0
}

{
  echo "=== WP Fusion marketing run $STAMP ($DAY_NAME) ==="
  cd "$ROOT"

  # Browser Hub no longer used — forum outreach disabled Jul 2026

  if [ "$IS_EC2" -eq 1 ]; then
    if [ -z "${CURSOR_API_KEY:-}" ]; then
      notify "⚠️ WP Fusion marketing — NOT STARTED $(date +%-d\ %b)

• Blocked at: CURSOR_API_KEY not set in ${ROOT}/.env
• Action: add CURSOR_API_KEY from cursor.com (Dashboard → API keys), then re-run or wait for next timer."
      exit 1
    fi
    export CURSOR_API_KEY

    if ! command -v "$AGENT" >/dev/null 2>&1; then
      notify "⚠️ WP Fusion marketing — NOT STARTED $(date +%-d\ %b)

• Blocked at: Cursor agent CLI not installed at ${AGENT}
• Action: curl https://cursor.com/install -fsS | bash"
      exit 1
    fi

    configure_git_for_push
    PROMPT="$(cat "${ROOT}/marketing/agent-run-prompt.txt")"

    if "$AGENT" --print --trust --force --workspace "$ROOT" "$PROMPT" >>"$LOG" 2>&1; then
      echo "Agent run completed"
    else
      notify "❌ WP Fusion marketing — agent run failed $(date +%-d\ %b). Check $LOG"
      exit 1
    fi

    check_unpushed_commits || exit 1
  else
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
  fi
} >>"$LOG" 2>&1
