#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if [[ -f src/.env ]]; then
  set -a
  # shellcheck disable=SC1091
  source src/.env
  set +a
fi

BASE="${MIRA_MIMIC_RAW_BASE_DIR:-$ROOT_DIR/mimiciv}"
HOSP="${MIRA_MIMIC_HOSP_DIR:-$BASE/physionet.org/files/mimiciv/2.2/hosp}"
NOTE="${MIRA_MIMIC_NOTE_DIR:-$BASE/physionet.org/files/mimic-iv-note/2.2/note}"
ED="${MIRA_MIMIC_ED_DIR:-$BASE/physionet.org/files/mimic-iv-ed/2.2/ed}"

required=(
  "$HOSP/patients.csv"
  "$HOSP/admissions.csv"
  "$HOSP/transfers.csv"
  "$HOSP/d_icd_diagnoses.csv"
  "$HOSP/diagnoses_icd.csv"
  "$HOSP/d_icd_procedures.csv"
  "$HOSP/procedures_icd.csv"
  "$HOSP/labevents.csv"
  "$HOSP/d_labitems.csv"
  "$HOSP/prescriptions.csv"
  "$HOSP/microbiologyevents.csv"
  "$NOTE/discharge.csv"
  "$NOTE/radiology.csv"
  "$NOTE/radiology_detail.csv"
  "$ED/diagnosis.csv"
  "$ED/edstays.csv"
  "$ED/medrecon.csv"
  "$ED/pyxis.csv"
  "$ED/triage.csv"
  "$ED/vitalsign.csv"
)

missing=0
for path in "${required[@]}"; do
  if [[ ! -f "$path" ]]; then
    echo "missing: $path"
    missing=1
  fi
done

if [[ "$missing" -ne 0 ]]; then
  echo "One or more required MIMIC files are missing." >&2
  exit 1
fi

echo "MIMIC paths look complete:"
echo "  hosp: $HOSP"
echo "  note: $NOTE"
echo "  ed:   $ED"
