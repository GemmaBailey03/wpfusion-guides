#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CONFIG="$ROOT/site-config.json"
ANALYTICS_CFG="$ROOT/site/js/analytics-config.js"

python3 << PY
import json
import re
from pathlib import Path

root = Path("$ROOT")
config = json.loads((root / "site-config.json").read_text())
ga4 = (config.get("ga4MeasurementId") or "").strip()
gsc = (config.get("gscVerification") or "").strip()
affiliate = config.get("affiliateLink", "https://wpfusion.com/ref/599/")

(root / "site/js/analytics-config.js").write_text(
    "// Populated by scripts/apply-measurement.sh from site-config.json — do not edit by hand.\n"
    f'window.WPF_GUIDES = {{\n'
    f'  ga4MeasurementId: "{ga4}",\n'
    f'  gscVerification: "{gsc}",\n'
    f'  affiliateLink: "{affiliate}"\n'
    f'}};\n'
)

MARKER = "<!-- wpf-measurement -->"
gsc_meta = (
    f'  <meta name="google-site-verification" content="{gsc}">\n' if gsc else ""
)
ga4_scripts = ""
if ga4:
    ga4_scripts = (
        f'  <script async src="https://www.googletagmanager.com/gtag/js?id={ga4}"></script>\n'
        f'  <script src="{{config_js}}"></script>\n'
        f'  <script src="{{analytics_js}}"></script>\n'
    )
else:
    ga4_scripts = (
        f'  <script src="{{config_js}}"></script>\n'
        f'  <script src="{{analytics_js}}"></script>\n'
    )

for html_path in sorted((root / "site").rglob("*.html")):
    rel = html_path.relative_to(root / "site")
    depth = len(rel.parts) - 1
    prefix = "../" * depth if depth else ""
    config_js = f"{prefix}js/analytics-config.js"
    analytics_js = f"{prefix}js/analytics.js"

    block = MARKER + "\n" + gsc_meta + ga4_scripts.format(
        config_js=config_js, analytics_js=analytics_js
    ) + MARKER.replace("<!--", "<!-- /")

    text = html_path.read_text()
    if MARKER in text:
        text = re.sub(
            re.escape(MARKER) + r"[\s\S]*?" + re.escape(MARKER.replace("<!--", "<!-- /")),
            block.strip(),
            text,
            count=1,
        )
    else:
        text = text.replace("<head>", "<head>\n" + block.strip() + "\n", 1)

    html_path.write_text(text)

print(f"Applied measurement config (GA4={'set' if ga4 else 'empty'}, GSC={'set' if gsc else 'empty'})")
PY
