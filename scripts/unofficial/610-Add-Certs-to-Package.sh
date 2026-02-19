#!/bin/bash

################################################################################
# This script adds certs from the Mmojo Share to the mmojo-server-support
# subdirectory of the package directory.
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
printf "\n$STARS\n*\n* STARTED: $SCRIPT_NAME.\n*\n$STARS\n\n"

if [ ! -d $MMOJO_SHARE_MOUNT_POINT ]; then
    echo "You have not created your Mmojo Share mount point."
    exit 1
fi

if [ -v CHOSEN_BUILD ] && [ -v CHOSEN_BUILD_PATH ]; then
    THIS_PACKAGE_DIR="$PACKAGE_DIR/$PACKAGE_ZIP-$CHOSEN_BUILD_INFO"
    SUPPORT_DIR="$THIS_PACKAGE_DIR/$PACKAGE_MMOJO_SERVER_SUPPORT_DIR"

    if [ -d "$THIS_PACKAGE_DIR" ] && [ -d "$SUPPORT_DIR" ]; then
        if [[ $(findmnt $MMOJO_SHARE_MOUNT_POINT) ]]; then
            echo "Adding certificate files."
            CERTS="$SUPPORT_DIR/certs"
            mkdir -p $CERTS
            cp $CERTIFICATES_DIR/cert.crt $CERTS
            cp $CERTIFICATES_DIR/cert.key $CERTS
            # cp $CERTIFICATES_DIR/selfsignCA.crt $CERTS

            echo ""
            echo "$SUPPORT_DIR:"
            ls -al "$SUPPORT_DIR"

            echo ""
            echo "$SUPPORT_DIR/certs:"
            ls -al "$SUPPORT_DIR/certs"
        fi
    fi
fi

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
