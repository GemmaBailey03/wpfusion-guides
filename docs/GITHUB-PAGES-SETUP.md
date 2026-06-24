# GitHub Pages setup

Repo: https://github.com/GemmaBailey03/wpfusion-guides

Live URL (once enabled): https://gemmabailey03.github.io/wpfusion-guides/

## One setting required in GitHub

1. Open https://github.com/GemmaBailey03/wpfusion-guides/settings/pages
2. Under **Build and deployment** → **Source**, choose **GitHub Actions** (not “Deploy from branch”)
3. Save — no other fields needed

Then either wait for the next push, or re-run the workflow:

```bash
gh workflow run "Deploy GitHub Pages" --repo GemmaBailey03/wpfusion-guides
```

Check progress: https://github.com/GemmaBailey03/wpfusion-guides/actions

## Verify site is live

```bash
curl -I https://gemmabailey03.github.io/wpfusion-guides/
```

You want `HTTP/2 200`.

## Cursor Automation

After the site returns 200, create the Tue/Thu automation using [`marketing/cursor-automation-setup.md`](../marketing/cursor-automation-setup.md) in the Agents Window.
