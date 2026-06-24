# Cursor Automation — WP Fusion Tue/Thu marketing

**Primary automation (installed):** local LaunchAgent — see [`docs/AUTOMATION.md`](../docs/AUTOMATION.md).

Runs Tue & Thu **10:30** using Cursor Agent CLI + `marketing/RUNBOOK.md`. This is required for Thursday Browser Hub forum work on your Mac.

---

## Optional: Cloud Cursor Automation (Tuesdays only)

Use this only if you want a **cloud backup** for Tuesday SEO when your Mac is off. Cloud runs cannot reach Browser Hub on localhost for Thursday forums.

| Field | Value |
| --- | --- |
| **Name** | WP Fusion Tue SEO (cloud backup) |
| **Schedule** | Tue 10:30 — cron `30 10 * * 2` |
| **Repo** | `GemmaBailey03/wpfusion-guides` · `main` |

Create in **Agents Window** (Automations editor) with prompt:

```
Follow marketing/RUNBOOK.md — Tuesday SEO section only.
Affiliate link: https://wpfusion.com/ref/599/
Publish next guide from marketing/content-queue.md, update site, commit and push.
WhatsApp 447932656999 summary when done.
```

Wire format reference:

```yaml
name: "WP Fusion Tue SEO (cloud backup)"
description: "SEO guides only when Mac is off. Primary automation is local LaunchAgent."
workflow:
  triggers:
    - cron:
        cron: "30 10 * * 2"
  actions: []
  prompts:
    - |
      Follow marketing/RUNBOOK.md — Tuesday SEO section only.
      Affiliate link: https://wpfusion.com/ref/599/
      Publish next guide from marketing/content-queue.md, update site, commit and push.
      WhatsApp 447932656999 summary when done.
  memoryEnabled: true
  gitConfig:
    repo: GemmaBailey03/wpfusion-guides
    branch: main
```
