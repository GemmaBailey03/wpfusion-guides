# GitHub token for EC2 (plain English)

Your marketing automations run on the **AWS server**, not your Mac. When the agent writes a new guide, it **commits on the server** then **pushes to GitHub** so the live site updates.

Push needs a **GitHub token** — a one-time password you create on GitHub and paste into a file on the server.

**You already added `CURSOR_API_KEY`** (that runs the AI). **`GITHUB_TOKEN`** is separate (that publishes to GitHub).

---

## Step 1 — Create the token (in your browser)

1. Open **[github.com/settings/tokens?type=beta](https://github.com/settings/tokens?type=beta)** (Fine-grained tokens).
2. Click **Generate new token**.
3. **Name:** `EC2 automations` (or anything you’ll recognise).
4. **Expiration:** pick 90 days or “No expiration” (your choice).
5. **Repository access:** **Only select repositories** → tick:
   - `wpfusion-guides`
   - `hostcert`
6. **Permissions → Repository permissions:**
   - **Contents:** Read and write
7. Click **Generate token**.
8. **Copy the token immediately** — GitHub only shows it once. It starts with `github_pat_` or `ghp_`.

Do **not** paste this token in WhatsApp, email, or chat.

---

## Step 2 — Add it on the server (one file per project)

You need the token in **two** `.env` files on EC2 (same token in both is fine):

| Project | File on server |
|---------|----------------|
| WP Fusion | `~/wp-fusion/.env` |
| HostCert | `~/hostcert/.env` |

### Open Terminal on your Mac

Connect to the server:

```bash
ssh -i "/Users/gemmabailey/AiStuff/Cursor Stuff.pem" ec2-user@54.242.190.238
```

When you see `[ec2-user@... ~]$`, you’re on the server.

### WP Fusion

```bash
nano ~/wp-fusion/.env
```

Make sure these two lines exist (paste your token after the `=` on the second line if empty):

```
CURSOR_API_KEY=already-set-leave-as-is
GITHUB_TOKEN=paste-your-token-here
```

Save: **Ctrl+O**, Enter. Exit: **Ctrl+X**.

### HostCert (same visit)

```bash
nano ~/hostcert/.env
```

Add the same `GITHUB_TOKEN=...` line (and keep `CURSOR_API_KEY` as-is).

Save and exit the same way.

Type `exit` to leave the server.

---

## Step 3 — Push anything stuck from the failed run (optional)

If a run WhatsApp’d you that push failed but the guide was committed on the server, an agent or you can push once the token is set:

```bash
ssh -i "/Users/gemmabailey/AiStuff/Cursor Stuff.pem" ec2-user@54.242.190.238
cd ~/wp-fusion && git push origin main
```

Or ask the WP Fusion project agent to push for you after the token is in place.

---

## How you’ll know it worked

- Next Tue/Thu (WP Fusion) or Mon/Wed (HostCert) run finishes with **one** ✅ WhatsApp, not a second ❌ about git push.
- New guides appear on the live site within a couple of minutes.

---

## If something goes wrong

| Message | Fix |
|---------|-----|
| `GITHUB_TOKEN empty` | Complete Step 2 above |
| `403` or `permission denied` on push | Regenerate token with **Contents: Read and write** on the right repo |
| Guide on server but not on website | Run Step 3 push, or wait for next scheduled run after token is set |

---

*Last updated: 2026-06-30*
