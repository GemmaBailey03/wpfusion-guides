# WP Fusion affiliate marketing — agent runbook

**Project:** WP Fusion affiliate promotion  
**Production:** EC2 `54.242.190.238` · project `~/wp-fusion`  
**Runs:** Tuesday & Thursday **10:30 Europe/London** (systemd timer on EC2)  
**Schedule (cron):** `30 10 * * 2,4`  
**Browser Hub:** EC2 `http://127.0.0.1:3847` (not Mac)  
**Owner:** Cursor automation · **Notify:** WhatsApp Gemma (`447932656999`)  
**Affiliate link:** https://wpfusion.com/ref/599/

**EC2 auth notes:** `agent status` showing **Not logged in** on the server is normal — runs use `CURSOR_API_KEY` from `~/wp-fusion/.env`. Pushes need `GITHUB_TOKEN` in the same file — see [`docs/GITHUB-TOKEN-SETUP.md`](../docs/GITHUB-TOKEN-SETUP.md).

---

## Every run (in order)

### 1. Read current state

- [`marketing/content-queue.md`](content-queue.md) — next SEO topic
- [`marketing/forum-log.md`](forum-log.md) — reply log + weekly metrics
- [`marketing/affiliate-rules.md`](affiliate-rules.md) — disclosure text, limits
- [`marketing/product-knowledge.md`](product-knowledge.md) — facts and doc URLs
- [`site-config.json`](../site-config.json) — live site base URL

### 2. Determine run type

| Day | Activity |
| --- | --- |
| **Tuesday** | SEO: publish one new guide OR refresh an existing guide |
| **Thursday** | Community: one helpful forum reply via Browser Hub |

---

## Tuesday — SEO content

### Publish one new guide

1. Open `marketing/content-queue.md` — find row with **Status: Next**
2. Create `site/guides/<slug>.html` matching existing guide style (see guide #1)
3. Include:
   - Problem → solution → steps (cite official WP Fusion docs)
   - 2–3 internal links to other guides
   - CTA button → https://wpfusion.com/ref/599/
   - Affiliate disclosure in footer (from `affiliate-rules.md`)
4. Add guide card to `site/index.html` guides section
5. Add URL to `site/sitemap.xml` (use base URL from `site-config.json`)
6. Mark guide **Done** in queue; set next row to **Next**
7. Update weekly metrics in `forum-log.md`
8. Commit + push to `main`

### If no new guide (queue empty or refresh week)

- Update “Updated” date on an existing guide
- Add 2–3 sentences of fresh content
- Cross-link guides from homepage if missing
- Verify `sitemap.xml` is complete

### Site check

- Confirm site base URL returns 200 (GitHub Pages may take 1–2 min after push)

---

## Thursday — forum community help

### Rules

- **Max 1 comment** per run
- Answer the question fully first; mention WP Fusion only if it genuinely fits
- Include affiliate disclosure (short version from `affiliate-rules.md`)
- **Do NOT** automate Facebook groups
- **Do NOT** open Browser Hub more than once per run

### Browser Hub procedure

1. Check Browser Hub health: `GET http://127.0.0.1:3847/health`
2. If down: skip forum step, log in `forum-log.md`, WhatsApp Gemma with NEED YOU note (Browser Hub on EC2 must be running — `browser-hub.service`)
3. If up: submit task from [`scripts/browser-hub-forum-wordpress-org.json`](../scripts/browser-hub-forum-wordpress-org.json) only. Rotate search query per `forum-log.md`. **Never use Reddit** — account permanently blocked.
4. Poll `GET http://127.0.0.1:3847/tasks/<id>` until complete or failed
5. If WordPress.org login required: WhatsApp Gemma once for one-time login at https://login.wordpress.org/ — do not ask for Reddit login.
6. Log thread URL + date in `forum-log.md`
7. Commit log update + push

### Platform rotation

See rotation table in `forum-log.md`. Advance to next platform after each successful reply.

---

## Weekly metrics (required every run)

Update the **Weekly metrics** table in [`marketing/forum-log.md`](forum-log.md).

Also update **Organic search** metrics when GSC/GA4 are connected (see [`docs/MEASUREMENT-SETUP.md`](../docs/MEASUREMENT-SETUP.md)):

- Search Console: impressions, clicks, top query (last 7 days)
- GA4: sessions, `affiliate_click` events (last 7 days)
- WP Fusion affiliate portal: clicks if checked

Report **commercial confidence** (High / Medium / Low) with evidence — see `.cursor/rules/commercial-growth.mdc`.

---

## WhatsApp notification (required — success OR failure)

**Always** send to **447932656999** at end of every run.

### Tuesday success

```text
✅ WP Fusion marketing — COMPLETED Tue [date]

• SEO: [published/updated + URL]
• Queue: [X/12 done]
• Site: [base URL] OK
• Next Tue: [next topic from queue]
```

### Thursday success

```text
✅ WP Fusion marketing — COMPLETED Thu [date]

• Forum: [platform + thread URL or "skipped — no login"]
• Next Thu: [next platform in rotation]
```

### On failure

```text
❌ WP Fusion marketing — NOT COMPLETED [Tue/Thu] [date]

• Failed at: [step]
• Error: [plain English]
• Partial work: [what completed]
• Action: [fix needed]
```

### Git push failed (EC2)

If content was committed locally but push failed (empty or invalid token):

```text
❌ WP Fusion marketing — NOT COMPLETED [Tue/Thu] [date]

• Failed at: git push to GitHub
• Error: GITHUB_TOKEN is not set — commits are on the server but the live site was not updated
• Partial work: [guide slug / files committed locally]
• Action: Add GITHUB_TOKEN to ~/wp-fusion/.env — see docs/GITHUB-TOKEN-SETUP.md
```

Do **not** tell Gemma to SSH or use Terminal for routine fixes — point her to the doc above (or ask Cursor to add the token on EC2).

### Blocked on login

```text
⚠️ WP Fusion marketing — NEED YOU Thu [date]

• Blocked at: WordPress.org login required
• Action: Open http://127.0.0.1:3847 — log in, then reply "done"
```

If WhatsApp MCP unavailable, append same text to `forum-log.md` Notes column and retry next run.

---

## Cursor Automation setup (reference)

| Field | Value |
| --- | --- |
| Name | WP Fusion Tue/Thu affiliate marketing |
| Schedule | Tue & Thu **10:30 Europe/London** on EC2 (`30 10 * * 2,4`) |
| Host | EC2 `54.242.190.238` · `~/wp-fusion` |
| Repo | `GemmaBailey03/wpfusion-guides` · `main` |
| Prompt | Follow `marketing/RUNBOOK.md`. Affiliate link: https://wpfusion.com/ref/599/. Always WhatsApp 447932656999 success or failure summary. |
| Tools | Git (needs `GITHUB_TOKEN` on EC2), Browser Hub (Thu only, EC2 :3847), WhatsApp MCP |

See [`marketing/cursor-automation-setup.md`](cursor-automation-setup.md) for editor prefill.

---

## Do not

- Post on coupon/discount sites
- Run paid ads without reading affiliate terms
- Mass-post identical forum comments
- Skip affiliate disclosure
- Invent WP Fusion features not in official docs
- Skip WhatsApp notification
