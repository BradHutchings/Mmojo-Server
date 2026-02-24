#!/bin/bash

################################################################################
# This script creates the certificates directory.
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
printf "\n$STARS\n*\n* STARTED: $SCRIPT_NAME.\n*\n$STARS\n\n"

echo "Creating $CERTIFICATES_DIR."
if [ "$CERTIFICATES_DIR" != "" ] && [ -d "$CERTIFICATES_DIR" ]; then
    rm -r -f $CERTIFICATES_DIR
fi

mkdir -p $CERTIFICATES_DIR
cd $CERTIFICATES_DIR

echo ""
echo "Creating sample certs with mkcert."
fqdn="mmojo.local"
mkcert $fqdn > /dev/null 2>&1
mv "$fqdn.pem" cert.crt
mv "$fqdn-key.pem" cert.key
cp "$(mkcert -CAROOT)/rootCA.pem" selfsignCA.crt

echo ""
echo "Directory $CERTIFICATES_DIR:"
ls -al $CERTIFICATES_DIR

cd $HOME

printf "\n$STARS\n*\n* FINISHED: $SCRIPT_NAME.\n*\n$STARS\n\n"

################################################################################
#  This is an original script for the Mmojo Server repo. It is covered by
#  the repo's MIT-style LICENSE:
#
#  https://github.com/BradHutchings/Mmojo-Server/blob/main/LICENSE
#
#  Copyright (c) 2025-26 Brad Hutchings.
#  --
#  Brad Hutchings
#  brad@bradhutchings.com
################################################################################
