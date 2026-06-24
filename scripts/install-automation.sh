#!/usr/bin/env bash
set -euo pipefail

ROOT="/Users/gemmabailey/AiStuff/WP Fusion"
PLIST_SRC="$ROOT/launch/com.gemmabailey.wpfusion-marketing.plist"
PLIST_DST="$HOME/Library/LaunchAgents/com.gemmabailey.wpfusion-marketing.plist"
LABEL="com.gemmabailey.wpfusion-marketing"
GUI_UID="$(id -u)"

chmod +x "$ROOT/scripts/run-marketing-agent.sh"
chmod +x "$ROOT/scripts/ensure-browser-hub.sh"

mkdir -p "$HOME/Library/Logs/wpfusion-marketing"
cp "$PLIST_SRC" "$PLIST_DST"

launchctl bootout "gui/$GUI_UID/$LABEL" 2>/dev/null || true
launchctl bootstrap "gui/$GUI_UID" "$PLIST_DST"

echo "Installed $LABEL — runs Tue & Thu at 10:30"
launchctl print "gui/$GUI_UID/$LABEL" | head -20
