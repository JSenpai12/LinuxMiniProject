#!/usr/bin/env bash
set -euo pipefail

# Minimal wrapper to let you keep mySolution.sh as-is.
# First invocation: call mySolution.sh to perform extraction and setup.
# When mySolution.sh calls "generateSecret.sh" at the end, this script
# will run again but with WRAPPER_ACTIVE=1 — in that case we compute the secret.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# If not already active, call mySolution.sh with a marker env var
if [[ -z "${WRAPPER_ACTIVE-}" ]]; then
  export WRAPPER_ACTIVE=1
  # Call mySolution.sh from the repo root (same dir as this wrapper)
  /bin/bash "$SCRIPT_DIR/mySolution.sh"
  exit $?
fi

# When WRAPPER_ACTIVE=1, perform the actual secret computation (final step)
cd "$SCRIPT_DIR"

# Ensure src exists
if [[ ! -d src ]]; then
  echo "ERROR: src/ directory not found" >&2
  exit 1
fi

# Remove malicious artifacts if present (defensive)
rm -rf src/maliciousFiles
rm -f src/important.link

# Compute deterministic secret from regular files under src/
secret=$(find src -type f -print0 \
  | sort -z \
  | xargs -0 sha256sum 2>/dev/null \
  | sha256sum \
  | awk '{print $1}')

# Save and print secret
mkdir -p secretDir
echo "$secret" | tee secretDir/.secret
chmod 600 secretDir/.secret

# Print secret to stdout as tests expect
echo "$secret"
