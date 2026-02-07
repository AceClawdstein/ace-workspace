#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# ClawdVegas GitHub Pages Deployment
#
# Pushes floor data + living map to GitHub Pages.
# Run after update-floor-data.sh.
#
# Usage:
#   ./visualization/deploy.sh
# ============================================================

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)

cd "$PROJECT_DIR"

# Check for changes to deploy
if git diff --quiet clawdvegas/floor/data/ 2>/dev/null; then
    echo "[$TIMESTAMP] No floor data changes to deploy."
    exit 0
fi

# Stage data files
git add clawdvegas/floor/data/*.json 2>/dev/null || true

# Commit
git commit -m "Floor data update $TIMESTAMP" || {
    echo "[$TIMESTAMP] Nothing to commit."
    exit 0
}

# Push
git push origin main || {
    echo "[$TIMESTAMP] ERROR: Failed to push. Will retry next cycle."
    exit 1
}

echo "[$TIMESTAMP] Deployed floor data to GitHub Pages."
