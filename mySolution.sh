#!/bin/bash

wget https://exit-zero-academy.github.io/DevOpsTheHardWayAssets/linux_project/secretGenerator.tar.gz
tar -xvzf secretGenerator.tar.gz


# go to correct folder (safe even if run elsewhere)
cd src

# clean / prepare environment
rm -rf maliciousFiles
rm -f important.link

mkdir -p secretDir
touch secretDir/.secret
chmod 600 secretDir/.secret

# generate the secret
/bin/bash generateSecret.sh