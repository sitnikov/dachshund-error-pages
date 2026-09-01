#!/usr/bin/env bash
# Assembles the static preview site into _site/ (what GitHub Pages serves).
set -euo pipefail

cd "$(dirname "$0")/.."
out=_site

rm -rf "$out"
mkdir -p "$out/pages"
cp pages/*.html "$out/pages/"
cp preview/index.html "$out/index.html"
# GitHub Pages serves 404.html from the site root as the real 404 page.
cp pages/404.html "$out/404.html"
touch "$out/.nojekyll"

# manifest.json: every NNN.html in pages/ with the headline from its <h1>.
python3 - "$out" <<'PY'
import json, pathlib, re, sys

out = pathlib.Path(sys.argv[1])
pages = []
for f in sorted(out.glob("pages/*.html")):
    if not re.fullmatch(r"\d{3}", f.stem):
        continue
    m = re.search(r"<h1>(.*?)</h1>", f.read_text(encoding="utf-8"), re.S)
    title = re.sub(r"\s+", " ", m.group(1)).strip() if m else ""
    pages.append({"code": int(f.stem), "title": title})

(out / "manifest.json").write_text(json.dumps({"pages": pages}, indent=2) + "\n", encoding="utf-8")
print(f"manifest.json: {len(pages)} pages")
PY

test -s "$out/index.html"
test -s "$out/404.html"
python3 -m json.tool "$out/manifest.json" >/dev/null
echo "built $out/"
