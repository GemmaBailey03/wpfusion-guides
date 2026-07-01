# Measurement setup — Google Search Console + GA4

Plain-English guide so we can **see traffic and affiliate clicks**, not just publish guides.

**Site URL:** https://gemmabailey03.github.io/wpfusion-guides/

---

## Why this matters

Without Search Console and Analytics, we cannot tell if guides rank, get clicks, or send anyone to the affiliate link. That makes commercial growth guesswork.

After setup, every Tue/Thu run should report:

- Search Console impressions and clicks (last 7 days)
- GA4 sessions and affiliate link clicks
- WP Fusion affiliate portal clicks (check monthly)

---

## Part 1 — Google Search Console (15 minutes, one-time)

### Step 1 — Add the property

1. Open [Google Search Console](https://search.google.com/search-console)
2. Click **Add property**
3. Choose **URL prefix**
4. Enter: `https://gemmabailey03.github.io/wpfusion-guides/`
5. Click **Continue**

### Step 2 — Verify with HTML tag

1. Choose verification method: **HTML tag**
2. Google shows a meta tag like:
   ```html
   <meta name="google-site-verification" content="AbCdEf123..." />
   ```
3. Copy **only the content value** (the part inside `content="..."`) — e.g. `AbCdEf123...`

### Step 3 — Add the code to this project

Ask Cursor: *“Add GSC verification code AbCdEf123 to site-config”*  
Or edit `site-config.json` yourself:

```json
"gscVerification": "AbCdEf123..."
```

Then run (or ask Cursor to run):

```bash
./scripts/apply-measurement.sh
git add site-config.json site/ && git commit -m "Add Search Console verification" && git push
```

Wait 1–2 minutes for GitHub Pages to deploy.

### Step 4 — Verify in Search Console

1. Back in Search Console, click **Verify**
2. Should show **Ownership verified**
3. Submit sitemap: `https://gemmabailey03.github.io/wpfusion-guides/sitemap.xml`

---

## Part 2 — Google Analytics 4 (10 minutes, one-time)

### Step 1 — Create property

1. Open [Google Analytics](https://analytics.google.com/)
2. **Admin** (gear icon) → **Create property**
3. Name: `WP Fusion Guides`
4. Create a **Web** data stream for `https://gemmabailey03.github.io/wpfusion-guides/`
5. Copy the **Measurement ID** — looks like `G-XXXXXXXXXX`

### Step 2 — Add to project

Edit `site-config.json`:

```json
"ga4MeasurementId": "G-XXXXXXXXXX"
```

Run:

```bash
./scripts/apply-measurement.sh
git add site-config.json site/ && git commit -m "Add GA4 tracking" && git push
```

### Step 3 — Confirm data

1. Open the site in a browser
2. In GA4 → **Reports → Realtime** — you should see 1 active user
3. Click a **Try WP Fusion** button — event `affiliate_click` appears under **Events** (may take a few minutes)

---

## Part 3 — Link Search Console to Analytics (optional, 2 minutes)

In GA4 Admin → **Product links** → **Search Console links** → Link the property.

This shows search queries inside Analytics.

---

## Where the code lives

| File | Purpose |
|------|---------|
| `site-config.json` | `gscVerification` and `ga4MeasurementId` (source of truth) |
| `scripts/apply-measurement.sh` | Injects tags into all HTML pages |
| `site/js/analytics.js` | Loads GA4 + tracks affiliate link clicks |
| `marketing/forum-log.md` | Weekly metrics table (update each run) |

---

## Quick check (after both are set)

```bash
curl -s https://gemmabailey03.github.io/wpfusion-guides/ | grep google-site-verification
curl -s https://gemmabailey03.github.io/wpfusion-guides/ | grep googletagmanager
```

Both should return a line of HTML.

---

## If you get stuck

Ask Cursor to complete verification — you only need to paste the verification code or Measurement ID from Google. No SSH or terminal routine required.
