#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <pip-package-spec> [--prune-dist-info]"
  exit 1
fi

PKG_SPEC="$1"
PRUNE_DIST_INFO="${2:-}"

BASENAME="$(
python - "$PKG_SPEC" <<'PY'
import re, sys
spec = sys.argv[1]
name = re.split(r'[<>=!~; ]', spec, 1)[0]
name = re.sub(r'\[.*\]','', name)
print(name.strip() or "package")
PY
)"

PYTAG="$(
python - <<'PY'
import sys
v = sys.version_info
print(f"{v.major}-{v.minor}")
PY
)"

OUTDIR="/package/layers"
WORKDIR="/tmp/pkgbuild/${BASENAME}"
DESTDIR="$WORKDIR/python/lib/python${PYTAG//-/.}/site-packages"
ZIPNAME="${BASENAME}${PYTAG}.zip"

rm -rf "$WORKDIR"
mkdir -p "$DESTDIR"

echo "==> Installing '$PKG_SPEC' into $DESTDIR (Python $(python -V 2>&1))"
python -m pip install \
  --no-cache-dir \
  --no-compile \
  --upgrade \
  -t "$DESTDIR" \
  "$PKG_SPEC"

echo "==> Pruning non-essential files"
find "$DESTDIR" -type d -name "__pycache__" -print0 | xargs -0r rm -rf
find "$DESTDIR" -type f -name "*.pyc" -delete
find "$DESTDIR" -type f -name "*.pyo" -delete
find "$DESTDIR" -type d \( -iname "tests" -o -iname "test" -o -iname "testing" -o -iname "docs" -o -iname "examples" \) -print0 | xargs -0r rm -rf

if [[ -n "$PRUNE_DIST_INFO" ]]; then
  echo "==> Aggressive prune of *.dist-info and *.egg-info (keeping METADATA)"
  find "$DESTDIR" -type d -name "*.egg-info" -print0 | xargs -0r rm -rf
  while IFS= read -r -d '' di; do
    find "$di" -type f ! -name METADATA ! -name entry_points.txt -delete || true
    find "$di" -mindepth 1 -type d -exec rm -rf {} + 2>/dev/null || true
  done < <(find "$DESTDIR" -type d -name "*.dist-info" -print0)
fi

mkdir -p "$OUTDIR"
rm -f "$OUTDIR/$ZIPNAME"

echo "==> Creating zip: $ZIPNAME"
cd "$WORKDIR"
zip -9 -r "$OUTDIR/$ZIPNAME" . \
  -x "*/__pycache__/*" "*.pyc" "*.pyo" \
     "*/tests/*" "*/test/*" "*/testing/*" \
     "*/docs/*" "*/examples/*" "*.so.debug"
echo "==> Wrote: $OUTDIR/$ZIPNAME"
