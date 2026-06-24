# Cursor Automation — WP Fusion Tue/Thu marketing

Use this file to create the scheduled automation in the **Agents Window** (Automations editor).

## Draft summary

| Field | Value |
| --- | --- |
| **Name** | WP Fusion Tue/Thu affiliate marketing |
| **Description** | Publish SEO guides Tuesdays; helpful forum replies Thursdays. WhatsApp summary every run. |
| **Schedule** | Tue & Thu 10:30 local — cron `30 10 * * 2,4` |
| **Repo** | `GemmaBailey03/wpfusion-guides` branch `main` |
| **Memory** | Enabled |

## Instructions (paste into automation prompt)

```
Follow WP Fusion/marketing/RUNBOOK.md exactly.

Affiliate link: https://wpfusion.com/ref/599/

Tuesday: publish next SEO guide from marketing/content-queue.md, update site/sitemap.xml and site/index.html, commit and push.

Thursday: run one forum reply via Browser Hub using scripts/browser-hub-forum-reddit.json or browser-hub-forum-wordpress-org.json (see forum-log.md rotation). Max 1 comment. Skip if Browser Hub down or login required — WhatsApp Gemma with NEED YOU message.

Always update marketing/forum-log.md weekly metrics.

Always WhatsApp 447932656999 at end with success or failure summary (templates in RUNBOOK.md).

Read marketing/affiliate-rules.md for disclosure text and limits.
Read marketing/product-knowledge.md for accurate WP Fusion facts.
Never skip affiliate disclosure.
```

## Tools to enable

- Git (repo checkout)
- WhatsApp MCP (for end-of-run notifications)
- Browser Hub is HTTP-only — agent uses curl to `http://127.0.0.1:3847` on Thursdays when Mac is on

## Wire format (for open_automation prefill)

```yaml
name: "WP Fusion Tue/Thu affiliate marketing"
description: "SEO guides Tue; forum help Thu. WhatsApp Gemma every run."
workflow:
  triggers:
    - cron:
        cron: "30 10 * * 2,4"
  actions: []
  prompts:
    - |
      Follow WP Fusion/marketing/RUNBOOK.md exactly.

      Affiliate link: https://wpfusion.com/ref/599/

      Tuesday: publish next SEO guide from marketing/content-queue.md, update site/sitemap.xml and site/index.html, commit and push.

      Thursday: run one forum reply via Browser Hub using scripts/browser-hub-forum-reddit.json or browser-hub-forum-wordpress-org.json (see forum-log.md rotation). Max 1 comment. Skip if Browser Hub down or login required — WhatsApp Gemma with NEED YOU message.

      Always update marketing/forum-log.md weekly metrics.

      Always WhatsApp 447932656999 at end with success or failure summary (templates in RUNBOOK.md).

      Read marketing/affiliate-rules.md for disclosure text and limits.
      Read marketing/product-knowledge.md for accurate WP Fusion facts.
      Never skip affiliate disclosure.
  model: ""
  agentOptions:
    skipInstall: false
  memoryEnabled: true
  gitConfig:
    repo: GemmaBailey03/wpfusion-guides
    branch: main
```

## After creating the repo

1. Push this project to `GemmaBailey03/wpfusion-guides`
2. Enable GitHub Pages (GitHub Actions workflow included)
3. Open Automations editor with the draft above
4. Confirm schedule timezone in the editor UI

## Note on Cloud vs local

- **Tuesday SEO runs** work in Cloud Agents (git push only)
- **Thursday forum runs** need Browser Hub on Gemma's Mac — automation should skip gracefully and notify via WhatsApp when Hub is unavailable
