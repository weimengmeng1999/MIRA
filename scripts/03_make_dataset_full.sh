#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"
export UV_CACHE_DIR="$ROOT_DIR/.uv-cache"
mkdir -p "$UV_CACHE_DIR"

if [[ -f src/.env ]]; then
  set -a
  # shellcheck disable=SC1091
  source src/.env
  set +a
fi

if [[ -f src/.venv/bin/activate ]]; then
  # shellcheck disable=SC1091
  source src/.venv/bin/activate
fi

unset MIRA_DATASET_DIAGNOSES
unset MIRA_MAX_HADM_IDS_PER_DIAGNOSIS
unset MIRA_MAX_DIAGNOSES
export MIRA_OVERWRITE_DATASETS="${MIRA_OVERWRITE_DATASETS:-ask}"

echo "Building full diagnosis datasets with MIRA_OVERWRITE_DATASETS=$MIRA_OVERWRITE_DATASETS"
uv run --project src python src/dataset/make_dataset.py
