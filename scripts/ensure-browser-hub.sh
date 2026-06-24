#!/usr/bin/env bash
set -euo pipefail

HUB_URL="http://127.0.0.1:3847/health"
HUB_DIR="/Users/gemmabailey/AiStuff/Playwrite Browser "

if curl -sf "$HUB_URL" >/dev/null 2>&1; then
  echo "Browser Hub already running"
  exit 0
fi

echo "Starting Browser Hub..."
cd "$HUB_DIR"
nohup npm run dev >>"$HOME/Library/Logs/wpfusion-marketing/browser-hub.out.log" 2>>"$HOME/Library/Logs/wpfusion-marketing/browser-hub.err.log" &

for _ in $(seq 1 30); do
  if curl -sf "$HUB_URL" >/dev/null 2>&1; then
    echo "Browser Hub started"
    exit 0
  fi
  sleep 2
done

echo "Browser Hub failed to start within 60s"
exit 1
