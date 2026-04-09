#!/bin/bash

################################################################################
# This script creates a /mnt/mmojo mount point for an SMB share on your network.
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
printf "\n$STARS\n*\n* STARTED: $SCRIPT_NAME.\n*\n$STARS\n\n"

#----------------------------------------
# Create mount point: /$HOME/mm-share
#----------------------------------------
if [ ! -d "$SHARE_DIR_MOUNT_POINT" ]; then
    echo "Creating Mmojo Share mount point - $SHARE_DIR_MOUNT_POINT."
    mkdir -p $SHARE_DIR_MOUNT_POINT
fi

#----------------------------------------
# Create a `mm-share-mount.sh` script.
#----------------------------------------
echo "Copying $SHARE_DIR_MOUNT_SCRIPT script."
if [ -d "$HOME_SCRIPTS" ]; then
    cp "$REPO_DIR_SCRIPTS/-$SHARE_DIR_MOUNT_SCRIPT_MACOS" "$HOME_SCRIPTS/$SHARE_DIR_MOUNT_SCRIPT"
    chmod a+x "$HOME_SCRIPTS/$SHARE_DIR_MOUNT_SCRIPT"
fi
if [ -d "$HOME_OC_SCRIPTS" ]; then
    cp "$REPO_DIR_SCRIPTS/-$SHARE_DIR_MOUNT_SCRIPT_MACOS" "$HOME_OC_SCRIPTS/$SHARE_DIR_MOUNT_SCRIPT"
    chmod a+x "$HOME_OC_SCRIPTS/$SHARE_DIR_MOUNT_SCRIPT"
fi

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
