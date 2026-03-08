#!/usr/bin/env bash
set -euo pipefail

echo "encrypt-secrets.sh is deprecated. Use scripts/seal-secrets.sh instead."
./scripts/seal-secrets.sh "$@"
