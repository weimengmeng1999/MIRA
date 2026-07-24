#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

DEST="${1:-$ROOT_DIR/MIMIC_Dataset}"

if [[ -z "${PHYSIONET_USERNAME:-}" ]]; then
  echo "Set PHYSIONET_USERNAME before running this script." >&2
  echo "Example: PHYSIONET_USERNAME=your_user bash scripts/download_mimic_required_sources.sh" >&2
  exit 1
fi

cat >&2 <<'MSG'
This downloads the source directories required by MIRA:
  - MIMIC-IV hosp v2.2
  - MIMIC-IV-Note note v2.2
  - MIMIC-IV-ED ed v2.2

You must already be approved for each restricted PhysioNet project.
This is not a small patient sample; MIRA's small-batch mode happens after
these source tables are local.
MSG

mkdir -p "$DEST"

wget -r -N -c -np --user "$PHYSIONET_USERNAME" --ask-password -P "$DEST" \
  https://physionet.org/files/mimiciv/2.2/hosp/ \
  https://physionet.org/files/mimic-iv-note/2.2/note/ \
  https://physionet.org/files/mimic-iv-ed/2.2/ed/

echo "Downloaded required MIMIC sources under: $DEST"
echo "Set MIRA_MIMIC_RAW_BASE_DIR=\"$DEST\" in src/.env"
