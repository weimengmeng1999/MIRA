#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

mkdir -p src/raw/runtime/qdrant/main

docker run --rm \
  -p 6333:6333 \
  -p 6334:6334 \
  -v "$ROOT_DIR/src/raw/runtime/qdrant/main:/qdrant/storage:z" \
  -e QDRANT__TELEMETRY_DISABLED=true \
  qdrant/qdrant
