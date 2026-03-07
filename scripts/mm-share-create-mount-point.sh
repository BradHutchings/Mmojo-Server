#!/bin/bash

################################################################################
# This script creates a /mnt/mmojo mount point for an SMB share on your network.
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
printf "\n$STARS\n*\n* STARTED: $SCRIPT_NAME.\n*\n$STARS\n\n"

#--------------------------------------------------------------------------------
# Haven't installed system updates and dependencies yet.
#--------------------------------------------------------------------------------

if [ $(cat /etc/os-release | grep "debian") != "" ]; then
    echo "Installing cifs-utils."
    sudo apt install -y cifs-utils
fi

#----------------------------------------
# Create mount point: /mnt/mmojo
#----------------------------------------
if [ ! -d "$SHARE_MOUNT_POINT" ]; then
    echo "Creating Mmojo Share mount point - $SHARE_MOUNT_POINT."
    sudo mkdir -p $SHARE_MOUNT_POINT
fi

#----------------------------------------
# Create a `mm-share-mount.sh` script.
#----------------------------------------
echo "Copying $SHARE_MOUNT_SCRIPT script."
cp "$REPO_SCRIPTS/-$SHARE_MOUNT_SCRIPT" "$HOME_SCRIPTS/$SHARE_MOUNT_SCRIPT"
chmod a+x "$HOME_SCRIPTS/$SHARE_MOUNT_SCRIPT"

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
