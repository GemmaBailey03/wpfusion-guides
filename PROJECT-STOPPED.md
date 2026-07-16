# Project stopped

**Status:** Shut down by Gemma — 16 Jul 2026  
**Reason:** Affiliate promotion for WP Fusion (`ref/599/`) — not a priority; automation caused Reddit and WordPress.org account issues; Cursor token spend not justified.

## What was disabled

| Component | Action |
|-----------|--------|
| EC2 systemd timer `wpfusion-marketing.timer` | **Stopped and disabled** (no more Tue/Thu 10:30 runs) |
| Mac LaunchAgent `com.gemmabailey.wpfusion-marketing` | **Booted out** |
| Forum outreach (Reddit, WordPress.org) | Already disabled — accounts blocked |

## What still exists (inactive)

- **Guides site** may still be live at https://gemmabailey03.github.io/wpfusion-guides/ (GitHub Pages — no cost unless you delete the repo)
- **EC2 files** at `~/wp-fusion` on `54.242.190.238` — inert unless you re-enable the timer
- **Browser Hub** on EC2 — still running for other projects; not used by this project anymore

## To restart (only if you change your mind)

```bash
ssh -i "/path/to/Cursor Stuff.pem" ec2-user@54.242.190.238
systemctl --user enable --now wpfusion-marketing.timer
```

## To fully remove later

1. Delete or archive GitHub repo `GemmaBailey03/wpfusion-guides`
2. Disable GitHub Pages in repo Settings
3. `rm -rf ~/wp-fusion` on EC2 (optional)
4. Remove `CURSOR_API_KEY` / project `.env` on EC2 if no longer needed

No further agent runs or WhatsApp notifications are scheduled for this project.
