# GitHub Pages setup

Repo: https://github.com/GemmaBailey03/wpfusion-guides

Live URL: https://gemmabailey03.github.io/wpfusion-guides/

## About failure emails

If you received deploy failure emails on **24 June 2026**, those were from the first few pushes **before** GitHub Pages was set to **GitHub Actions** as the source. Later runs succeeded. You can ignore those old notifications.

The workflow now only runs when files under `site/` change (not marketing docs only), so you should get fewer deploy emails going forward.

## One setting required in GitHub

1. Open https://github.com/GemmaBailey03/wpfusion-guides/settings/pages
2. Under **Build and deployment** → **Source**, choose **GitHub Actions**
3. Save — no other fields needed

Then either wait for the next `site/` push, or re-run the workflow:

```bash
gh workflow run "Deploy GitHub Pages" --repo GemmaBailey03/wpfusion-guides
```

## Scheduled marketing (not GitHub)

Tue/Thu marketing runs on your Mac — see [`AUTOMATION.md`](AUTOMATION.md), not this workflow.
