#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

DEST="${1:-$ROOT_DIR/MIMIC_Dataset_demo}"

cat >&2 <<'MSG'
This downloads the open-access MIMIC-IV Clinical Database Demo only.
It is useful for schema inspection, but it is NOT enough for MIRA reproduction:
MIRA also reads MIMIC-IV-Note discharge/radiology files and MIMIC-IV-ED files.
MSG

mkdir -p "$DEST"
wget -r -N -c -np -nH --cut-dirs=2 -P "$DEST" \
  https://physionet.org/files/mimic-iv-demo/2.2/

echo "Downloaded demo to: $DEST"
