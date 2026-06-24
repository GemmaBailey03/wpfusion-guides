# WP Fusion affiliate marketing — agent runbook

**Project:** WP Fusion affiliate promotion  
**Runs:** Tuesday & Thursday **10:00** (local)  
**Schedule (cron):** `0 10 * * 2,4`  
**Owner:** Cursor automation · **Notify:** WhatsApp Gemma (`447932656999`)  
**Affiliate link:** https://wpfusion.com/ref/599/

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
2. If down: skip forum step, log in `forum-log.md`, WhatsApp Gemma with NEED YOU note (Mac must run Browser Hub)
3. If up: submit task from [`scripts/browser-hub-forum-reddit.json`](../scripts/browser-hub-forum-reddit.json) OR [`scripts/browser-hub-forum-wordpress-org.json`](../scripts/browser-hub-forum-wordpress-org.json) based on platform rotation in `forum-log.md`
4. Poll `GET http://127.0.0.1:3847/tasks/<id>` until complete or failed
5. If login required: WhatsApp Gemma — *“Open http://127.0.0.1:3847 — log into [platform] in the open browser, reply done when finished.”* Do not post until login works.
6. Log thread URL + date in `forum-log.md`
7. Commit log update + push

### Platform rotation

See rotation table in `forum-log.md`. Advance to next platform after each successful reply.

---

## Weekly metrics (required every run)

Update the **Weekly metrics** table in [`marketing/forum-log.md`](forum-log.md):

- Week ending (Sunday date)
- Guides live (count)
- Guides published this week (0 or 1)
- Forum replies this week (0 or 1)
- Site URL
- Notes (one line)

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

### Blocked on login

```text
⚠️ WP Fusion marketing — NEED YOU Thu [date]

• Blocked at: [Reddit / WordPress.org] login required
• Action: Open http://127.0.0.1:3847 — log in, then reply "done"
```

If WhatsApp MCP unavailable, append same text to `forum-log.md` Notes column and retry next run.

---

## Cursor Automation setup (reference)

| Field | Value |
| --- | --- |
| Name | WP Fusion Tue/Thu affiliate marketing |
| Schedule | Tue & Thu **10:00** local (`0 10 * * 2,4`) |
| Repo | `GemmaBailey03/wpfusion-guides` · `main` |
| Prompt | Follow `marketing/RUNBOOK.md`. Affiliate link: https://wpfusion.com/ref/599/. Always WhatsApp 447932656999 success or failure summary. |
| Tools | Git, Browser Hub (Thu only, local Mac), WhatsApp MCP |

See [`marketing/cursor-automation-setup.md`](cursor-automation-setup.md) for editor prefill.

---

## Do not

- Post on coupon/discount sites
- Run paid ads without reading affiliate terms
- Mass-post identical forum comments
- Skip affiliate disclosure
- Invent WP Fusion features not in official docs
- Skip WhatsApp notification
