# Browser Hub — forum posting

Templates for **Thursday** community runs (WordPress.org only).

Submit via EC2 Browser Hub (`http://127.0.0.1:3847` on server `54.242.190.238`):

```bash
curl -X POST http://127.0.0.1:3847/tasks \
  -H "Content-Type: application/json" \
  -d @scripts/browser-hub-forum-wordpress-org.json
```

Poll status: `curl http://127.0.0.1:3847/tasks/<task-id>`

## Reddit — do not use

Gemma's Reddit account is **permanently blocked**. `browser-hub-forum-reddit.json` is deprecated. Agents must never submit Reddit tasks or WhatsApp asking for Reddit login.

## Prerequisites

1. Browser Hub running on EC2 (`browser-hub.service`)
2. **One-time WordPress.org login** — agent will WhatsApp Gemma when needed

## One-time login (WordPress.org)

When the agent sends **NEED YOU**:

1. Log in at https://login.wordpress.org/ in the Browser Hub browser on EC2
2. Reply **done** in chat

## Platform file

| File | Platform |
| --- | --- |
| `browser-hub-forum-wordpress-org.json` | wordpress.org/support — rotate search query per `marketing/forum-log.md` |

## Rules

- Max 1 posted reply per Thursday run
- Value-first answer; disclosure required
- Skip if no suitable thread or rules prohibit links
