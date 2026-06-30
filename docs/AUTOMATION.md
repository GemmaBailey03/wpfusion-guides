# Scheduled marketing automation

**Production runs on EC2** — not your Mac.

| | |
|--|--|
| **Host** | `54.242.190.238` (`ec2-user`) |
| **Project** | `~/wp-fusion` |
| **Schedule** | Tue & Thu **10:30 Europe/London** (systemd user timer) |
| **Browser Hub** | EC2 port **3847** (`~/browser-hub`) |
| **Logs** | `~/wp-fusion/logs/run-*.log` |

Mac LaunchAgent (`com.gemmabailey.wpfusion-marketing`) is **disabled**. See [`AGENT-HANDOFF.md`](../AGENT-HANDOFF.md) for full EC2 ops.

---

## One-time EC2 setup

Both keys go in **`~/wp-fusion/.env`** on EC2:

| Variable | Purpose | Guide |
|----------|---------|-------|
| `CURSOR_API_KEY` | Runs the Cursor agent CLI | [cursor.com](https://cursor.com) → Dashboard → API keys |
| `GITHUB_TOKEN` | Pushes commits so GitHub Pages deploys | [`docs/GITHUB-TOKEN-SETUP.md`](GITHUB-TOKEN-SETUP.md) |

Also add `GITHUB_TOKEN` to `~/hostcert/.env` on the same server (HostCert project).

Without `CURSOR_API_KEY`, runs WhatsApp you and stop.  
Without `GITHUB_TOKEN`, guides can be created and committed on EC2 but **won't go live** until someone pushes.

---

## Cursor agent auth on EC2

EC2 uses **API key auth**, not interactive login.

If you SSH in and run `~/.local/bin/agent status`, it may say **Not logged in** — that is **normal**. Scheduled runs still work when `CURSOR_API_KEY` is set in `.env`.

---

## What each run does

1. **Thursday only:** ensures Browser Hub is up on EC2 (`http://127.0.0.1:3847`)
2. Runs Cursor agent with `marketing/agent-run-prompt.txt` (follows `marketing/RUNBOOK.md`)
3. Agent commits SEO guides / forum replies, pushes to `main`, WhatsApps you a summary

---

## Manual test (on EC2)

```bash
~/wp-fusion/scripts/run-marketing-agent.sh
# or
systemctl --user start wpfusion-marketing.service
```

Check timer:

```bash
TZ=Europe/London systemctl --user list-timers wpfusion-marketing.timer
```

---

## Redeploy from Mac

```bash
rsync -avz -e 'ssh -i "/Users/gemmabailey/AiStuff/Cursor Stuff.pem"' \
  --exclude node_modules "/Users/gemmabailey/AiStuff/AWS WP Fusion/" \
  ec2-user@54.242.190.238:~/wp-fusion/
```

---

## Mac-only legacy install (not used for production)

The Mac LaunchAgent installer still exists for local testing:

```bash
./scripts/install-automation.sh
```

That path uses `cursor agent login` on Mac and Mac Browser Hub — **not** the production setup.

---

## Cursor Cloud Automations (optional)

Cloud automations at cursor.com/automations cannot reach Browser Hub on EC2 for Thursday forum work unless you expose it (not recommended). The EC2 systemd timer is the primary automation for this project.

Draft cloud-only ideas: `marketing/cursor-automation-setup.md`
