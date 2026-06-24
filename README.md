# WP Fusion Guides — automated affiliate marketing

Hands-off SEO guides + forum outreach promoting [WP Fusion](https://wpfusion.com) via affiliate link https://wpfusion.com/ref/599/.

## Structure

- `marketing/` — agent runbook, content queue, forum log, product facts
- `site/` — static SEO microsite (GitHub Pages)
- `scripts/` — Browser Hub task templates for forum posting

## Agent runbook

Scheduled runs follow [`marketing/RUNBOOK.md`](marketing/RUNBOOK.md):

- **Tuesday 10:30** — publish SEO guide
- **Thursday 10:30** — one helpful forum reply (Browser Hub)

## Quick start (GitHub Pages)

1. Repo: https://github.com/GemmaBailey03/wpfusion-guides
2. Follow [`docs/GITHUB-PAGES-SETUP.md`](docs/GITHUB-PAGES-SETUP.md) to enable Pages (one-time workflow push)
3. Site live at `https://gemmabailey03.github.io/wpfusion-guides/`

## Browser Hub (Thursday forum runs)

```bash
cd "../Playwrite Browser " && npm run dev
```

Dashboard: http://127.0.0.1:3847/

## Cursor Automation

See [`marketing/cursor-automation-setup.md`](marketing/cursor-automation-setup.md).

## One-time setup for Gemma

1. Confirm WP Fusion affiliate area is active (ref `/599/`)
2. Create GitHub repo + enable Pages
3. Approve Cursor Automation in Agents Window
4. Log into Reddit / WordPress.org via Browser Hub when agent requests it
