#!/bin/bash

################################################################################
# This script backs up the models in the $HOME/mm-models directory to Mmojo 
# Share. It only backs up models that are not on the share.
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
printf "\n$STARS\n*\n* STARTED: $SCRIPT_NAME.\n*\n$STARS\n\n"

cd $HOME

backed_up_one=0

if [ ! -d "$MMOJO_SHARE_MOUNT_POINT" ]; then
    # Fail silently, since we're now called by mm-models-download.sh.
    # echo "You have not created your Mmojo Share mount point."
    exit 1
fi

# mount the mmojo share
if [[ ! $(findmnt "$MMOJO_SHARE_MOUNT_POINT") ]]; then
    mm-share-mount.sh
fi

if [[ $(findmnt "$MMOJO_SHARE_MOUNT_POINT") ]]; then
    mkdir -p "$MMOJO_SHARE_PACKAGES_DIR"
fi

# Create $PACKAGES_DIR is needed.
if [ ! -d "$PACKAGES_DIR" ]; then
    mkdir -p "$PACKAGES_DIR"
fi

BackupPackage() {
    PACKAGE_FILE=$1
    if [ ! -f "$MMOJO_SHARE_PACKAGES_DIR/$PACKAGE_FILE" ]; then 
        echo ""
        echo "Backing up $PACKAGE_FILE to $MMOJO_SHARE_PACKAGES_DIR."
        sudo rsync -ah --progress "$PACKAGES_DIR/$PACKAGE_FILE" "$MMOJO_SHARE_PACKAGES_DIR/$PACKAGE_FILE"
        sudo chmod a-x "$MMOJO_SHARE_PACKAGES_DIR/$PACKAGE_FILE"
        backed_up_one=1
    fi
}

if [[ $(findmnt "$MMOJO_SHARE_MOUNT_POINT") ]] && [ -d "$MMOJO_SHARE_PACKAGES_DIR" ] && [ -d "$PACKAGES_DIR" ]; then
    cd "$PACKAGES_DIR"
    for file in *.zip; do
        if [ -f "$file" ]; then
            BackupPackage "$file"
        fi
    done
fi

if [ "$backed_up_one" == "0" ]; then
    echo ""
    echo "There are no new packages to back up."
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
