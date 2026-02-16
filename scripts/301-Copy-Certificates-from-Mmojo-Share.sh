#!/bin/bash

################################################################################
# This script copies certifcates from the Mmojo Share.
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
printf "\n$STARS\n*\n* STARTED: $SCRIPT_NAME.\n*\n$STARS\n\n"

if [ ! -d $MMOJO_SHARE_MOUNT_POINT ]; then
    echo "You have not created your Mmojo Share mount point."
    exit 1
fi

if [[ ! $(findmnt $MMOJO_SHARE_MOUNT_POINT) ]]; then
    mm-share-mount.sh
fi

if [[ $(findmnt $MMOJO_SHARE_MOUNT_POINT) ]]; then
    if [ -d $MMOJO_SHARE_CERTIFICATES ]; then
        cp $MMOJO_SHARE_CERTIFICATES/cert.crt $CERTIFICATES_DIR
        cp $MMOJO_SHARE_CERTIFICATES/cert.key  $CERTIFICATES_DIR
        cp $MMOJO_SHARE_CERTIFICATES/selfsignCA.crt $CERTIFICATES_DIR
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
