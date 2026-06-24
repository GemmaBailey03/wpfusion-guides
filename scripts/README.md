# Browser Hub — forum posting

Templates for Thursday community runs. Submit via:

```bash
curl -X POST http://127.0.0.1:3847/tasks \
  -H "Content-Type: application/json" \
  -d @scripts/browser-hub-forum-reddit.json
```

Poll status: `curl http://127.0.0.1:3847/tasks/<task-id>`

## Prerequisites

1. Browser Hub running: `cd "../Playwrite Browser " && npm run dev`
2. Dashboard: http://127.0.0.1:3847/
3. **One-time login** (per platform) — agent will WhatsApp Gemma when needed

## One-time login procedure (Gemma)

When the agent sends **NEED YOU**:

1. Open http://127.0.0.1:3847/
2. Open the running task’s browser (or start a manual task to the login page)
3. Log into **Reddit** or **WordPress.org** in that browser window
4. Reply **done** in chat — the agent saves the session in the shared Browser Hub profile

Login URLs:

- Reddit: https://www.reddit.com/login/
- WordPress.org: https://login.wordpress.org/

## Platform files

| File | Platform |
| --- | --- |
| `browser-hub-forum-reddit.json` | r/Wordpress, r/learndash, r/woocommerce (change startUrl subreddit/search) |
| `browser-hub-forum-wordpress-org.json` | wordpress.org/support |

## Rotation

See platform order in `marketing/forum-log.md`. Agent updates `startUrl` search query per rotation.

## Rules

- Max 1 posted reply per Thursday run
- Value-first answer; disclosure required
- Do not submit Reddit comment click step until agent verifies draft text
- Skip if subreddit rules prohibit affiliate links
