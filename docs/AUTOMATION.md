# Scheduled marketing automation

Runs **Tue & Thu at 10:30** on your Mac via `launchd` + Cursor Agent CLI.

## Installed by

```bash
./scripts/install-automation.sh
```

Launch agent label: `com.gemmabailey.wpfusion-marketing`

Logs: `~/Library/Logs/wpfusion-marketing/`

## One-time: Cursor agent login

The scheduler uses the Cursor Agent CLI (same engine as Cursor Automations). Log in once:

```bash
/Applications/Cursor.app/Contents/Resources/app/bin/cursor agent login
```

Until this is done, runs will WhatsApp you that login is required.

## What each run does

1. **Thursday only:** starts Browser Hub if needed (forum posting)
2. Runs Cursor agent with `marketing/agent-run-prompt.txt` (follows `marketing/RUNBOOK.md`)
3. Agent commits SEO guides / forum replies and WhatsApp you a summary

## Manual test

```bash
./scripts/run-marketing-agent.sh
```

## Stop / restart

```bash
launchctl bootout "gui/$(id -u)/com.gemmabailey.wpfusion-marketing"
./scripts/install-automation.sh
```

## Cursor Cloud Automations (optional)

Cloud automations at cursor.com/automations cannot reach Browser Hub on your Mac for Thursday forum work. The local launch agent above is the primary automation for this project.

If you later want cloud-only Tuesday SEO runs, use the draft in `marketing/cursor-automation-setup.md` in the Agents Window.
