# GitHub Pages setup

Repo: https://github.com/GemmaBailey03/wpfusion-guides

The workflow file lives at `.github/workflows/pages.yml` but may need a **one-time push from your machine** (GitHub OAuth here lacks `workflow` scope).

## Option A — Push workflow from your Mac (recommended)

In Terminal:

```bash
cd "/Users/gemmabailey/AiStuff/WP Fusion"
git add .github/workflows/pages.yml
git commit -m "Add GitHub Pages deploy workflow"
git push
```

If push is rejected for workflow scope, run once:

```bash
gh auth refresh -h github.com -s workflow
git push
```

Then in GitHub: **Settings → Pages → Build and deployment → Source: GitHub Actions**.

Site URL: https://gemmabailey03.github.io/wpfusion-guides/

## Option B — Paste workflow in GitHub UI

1. Open https://github.com/GemmaBailey03/wpfusion-guides
2. **Add file** → `.github/workflows/pages.yml`
3. Paste contents from local `.github/workflows/pages.yml`
4. Commit to `main`
5. **Settings → Pages → GitHub Actions**

## Cursor Automation

After repo is live, create the scheduled automation using [`marketing/cursor-automation-setup.md`](../marketing/cursor-automation-setup.md) in the Agents Window.
