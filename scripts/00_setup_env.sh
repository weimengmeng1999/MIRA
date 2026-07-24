#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"
export UV_CACHE_DIR="$ROOT_DIR/.uv-cache"
mkdir -p "$UV_CACHE_DIR"

if ! command -v python3.12 >/dev/null 2>&1; then
  echo "python3.12 is required but was not found on PATH." >&2
  exit 1
fi

python3.12 -m venv src/.venv
source src/.venv/bin/activate

python -m pip install -U pip uv
uv sync --project src

if [[ ! -f src/.env ]]; then
  cp src/.env.example src/.env
  echo "Created src/.env from src/.env.example."
  echo "Edit src/.env before dataset/runs: set OPENAI_API_KEY and MIRA_MIMIC_RAW_BASE_DIR."
fi

echo "Environment ready. Activate it with: source src/.venv/bin/activate"
