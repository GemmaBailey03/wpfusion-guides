# WP Fusion marketing automation — EC2 handoff

**Production host:** `54.242.190.238` (Amazon Linux 2023)  
**SSH user:** `ec2-user`  
**Project on server:** `/home/ec2-user/wp-fusion`  
**Browser Hub on EC2:** `/home/ec2-user/browser-hub` (port **3847** — not on Mac for scheduled runs)  
**WhatsApp bridge:** `http://127.0.0.1:8080` (already on server)

Mac **LaunchAgent** `com.gemmabailey.wpfusion-marketing` has been **booted out** — scheduling lives on **EC2 only**.

---

## What was deployed

1. **Rsync** from Mac `AiStuff/AWS WP Fusion/` → `~/wp-fusion/` (includes `.git`, excludes `node_modules`).
2. **Rsync** from Mac `AiStuff/Playwrite Browser /` → `~/browser-hub/` (excludes `node_modules`, `runs`).
3. **Scripts** in `~/wp-fusion/scripts/` (auto-detect Mac vs EC2):
   - `run-marketing-agent.sh` — Cursor `agent` CLI, `CURSOR_API_KEY` auth, git push via `GITHUB_TOKEN`, Thu Browser Hub ensure, WhatsApp notify on failure.
   - `ensure-browser-hub.sh` — health check, `npm install` if needed, start hub if down.
4. **Cursor Agent CLI** installed for `ec2-user` via `curl https://cursor.com/install -fsS | bash` → `~/.local/bin/agent`.
5. **systemd user units** (`~/.config/systemd/user/`):
   - `wpfusion-marketing.service` — oneshot run of marketing script; `EnvironmentFile=/home/ec2-user/wp-fusion/.env`
   - `wpfusion-marketing.timer` — **Tue & Thu 10:30 Europe/London**
   - `browser-hub.service` — always-on Browser Hub (`npm run dev` in `~/browser-hub`)
6. **`loginctl enable-linger ec2-user`** so user timers/services survive logout.
7. **Git** remote: `https://github.com/GemmaBailey03/wpfusion-guides.git`  
   Local git user on EC2: Gemma Bailey / gemma@gemmabailey.com

---

## Required configuration

### 1. `CURSOR_API_KEY` (required)

Edit on EC2: `~/wp-fusion/.env`

Set `CURSOR_API_KEY=` from [cursor.com](https://cursor.com) (Dashboard → API keys).  
Without it, the script **WhatsApps you and exits** (by design).

### 2. `GITHUB_TOKEN` (required for automated pushes)

Without this, the agent can still create guides and commit locally, but **GitHub Pages will not update** until someone pushes from elsewhere.

**Full setup guide:** [`docs/GITHUB-TOKEN-SETUP.md`](docs/GITHUB-TOKEN-SETUP.md)

Quick summary:

1. GitHub → Settings → Developer settings → **Fine-grained token**
2. Repo: `GemmaBailey03/wpfusion-guides`, permission: **Contents read/write**
3. Add to `~/wp-fusion/.env` as `GITHUB_TOKEN=...` (same file as `CURSOR_API_KEY`)
4. Also add to `~/hostcert/.env` on the same EC2 (HostCert uses this server)

**Do not** copy keys from chat or commit `.env`.

---

## Schedule

| When | What |
|------|------|
| Tue 10:30 Europe/London | Marketing agent run (SEO guide) |
| Thu 10:30 Europe/London | Marketing agent run + **Browser Hub** on EC2 (forum steps) |

Check next run:

```bash
TZ=Europe/London systemctl --user list-timers wpfusion-marketing.timer
```

Manual run (on EC2):

```bash
~/wp-fusion/scripts/run-marketing-agent.sh
# or
systemctl --user start wpfusion-marketing.service
```

Logs: `~/wp-fusion/logs/run-*.log`

---

## Normal behaviour (don't worry about these)

| What you see | Why it's OK |
|--------------|-------------|
| `agent status` → **Not logged in** on EC2 | Expected with API-key auth. Runs use `CURSOR_API_KEY` from `.env`, not interactive login. |
| Two WhatsApp messages (completed + not completed) | Usually means the agent finished but **git push failed** — add `GITHUB_TOKEN` (see above). |
| GitHub Pages takes 1–2 min after push | Normal deploy delay. |

After a successful push, confirm guides live, e.g.:  
https://gemmabailey03.github.io/wpfusion-guides/guides/memberpress-crm-tags.html

---

## Verify / ops

```bash
# Timer
TZ=Europe/London systemctl --user list-timers wpfusion-marketing.timer

# Browser Hub (EC2)
curl -sf http://127.0.0.1:3847/ && echo OK
systemctl --user status browser-hub.service

# Cursor agent
~/.local/bin/agent --version
~/.local/bin/agent status   # "Not logged in" is normal on EC2

# Redeploy from Mac (WP Fusion)
rsync -avz -e 'ssh -i "/Users/gemmabailey/AiStuff/Cursor Stuff.pem"' \
  --exclude node_modules "/Users/gemmabailey/AiStuff/AWS WP Fusion/" \
  ec2-user@54.242.190.238:~/wp-fusion/

# Redeploy Browser Hub
rsync -avz -e 'ssh -i "/Users/gemmabailey/AiStuff/Cursor Stuff.pem"' \
  --exclude node_modules --exclude runs \
  "/Users/gemmabailey/AiStuff/Playwrite Browser /" \
  ec2-user@54.242.190.238:~/browser-hub/
ssh -i "/Users/gemmabailey/AiStuff/Cursor Stuff.pem" ec2-user@54.242.190.238 \
  'cd ~/browser-hub && npm install && systemctl --user restart browser-hub.service'
```

After rsync, scripts in the repo auto-detect EC2 paths — no manual re-copy needed.

---

## Mac vs EC2

| | Mac (legacy) | EC2 (production) |
|--|--------------|------------------|
| Schedule | LaunchAgent (disabled) | systemd timer Tue/Thu 10:30 London |
| Cursor auth | `cursor agent login` | `CURSOR_API_KEY` in `~/wp-fusion/.env` |
| Git push | `gh` CLI | `GITHUB_TOKEN` in `~/wp-fusion/.env` |
| Browser Hub | Was on Mac | **EC2 port 3847** |

---

## Tue 30 Jun 2026 test run

| Step | Result |
|------|--------|
| Agent run with `CURSOR_API_KEY` | ✅ |
| MemberPress guide created | ✅ `site/guides/memberpress-crm-tags.html` |
| Queue / metrics updated | ✅ |
| Commit on EC2 (`ce999c6`) | ✅ |
| Push from EC2 | ❌ `GITHUB_TOKEN` empty |
| Push from Mac (manual fix) | ✅ `bd33b6f` on `main` — Pages deployed |

---

*Last updated: 2026-06-30*
