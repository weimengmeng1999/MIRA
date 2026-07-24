#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

docker compose -f src/backend/hapi-fhir-server/docker-compose.yml up -d

echo "FHIR backend requested. Check health at: http://localhost:8080/fhir/metadata"
