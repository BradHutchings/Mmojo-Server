#!/bin/bash

################################################################################
# This script zips up the package directory.
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
    echo "Creating directories on Mmojo Share."
    sudo mkdir -p $MMOJO_SHARE_PACKAGES
    sudo mkdir -p $MMOJO_SHARE_PACKAGES_ZIP

    if [ -v CHOSEN_BUILD ] && [ -v CHOSEN_BUILD_PATH ]; then
        THIS_PACKAGE_DIR="$PACKAGE_DIR/$PACKAGE_ZIP-$CHOSEN_BUILD_INFO"
        ZIP_FILE_NAME="mmojo-server-$CHOSEN_BUILD_INFO.zip"

          if [ -d "$MMOJO_SHARE_PACKAGES_ZIP" ]; then
              echo "Copying mmojo-server package to Mmojo Share."
              sudo cp "$PACKAGE_DIR/$ZIP_FILE_NAME" "$MMOJO_SHARE_PACKAGES_ZIP"
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
#  brad@Mmojo.net
################################################################################
