#!/usr/bin/env bash
set -euo pipefail

HUB_URL="http://127.0.0.1:3847/health"

if [ -d "/home/ec2-user/browser-hub" ] && [ "$(id -un)" = "ec2-user" ]; then
  HUB_DIR="/home/ec2-user/browser-hub"
  LOG_DIR="/home/ec2-user/wp-fusion/logs"
else
  HUB_DIR="/Users/gemmabailey/AiStuff/Playwrite Browser "
  LOG_DIR="$HOME/Library/Logs/wpfusion-marketing"
fi

mkdir -p "$LOG_DIR"

if curl -sf "$HUB_URL" >/dev/null 2>&1; then
  echo "Browser Hub already running"
  exit 0
fi

echo "Starting Browser Hub..."
cd "$HUB_DIR"
nohup npm run dev >>"${LOG_DIR}/browser-hub.out.log" 2>>"${LOG_DIR}/browser-hub.err.log" &

for _ in $(seq 1 30); do
  if curl -sf "$HUB_URL" >/dev/null 2>&1; then
    echo "Browser Hub started"
    exit 0
  fi
  sleep 2
done

echo "Browser Hub failed to start within 60s"
exit 1
