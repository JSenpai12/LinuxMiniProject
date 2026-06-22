#!/bin/bash

# go to correct folder (safe even if run elsewhere)
cd "$(dirname "$0")"

# clean / prepare environment
rm -rf maliciousFiles
rm -f important.link

mkdir -p secretDir
touch secretDir/.secret
chmod 600 secretDir/.secret

# generate the secret
/bin/bash generateSecret.sh