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

echo "Installing cifs-utils."
sudo apt install -y cifs-utils

#----------------------------------------
# Create mount point: /mnt/mmojo
#----------------------------------------
if [ ! -d "$MMOJO_SHARE_MOUNT_POINT" ]; then
    echo "Creating Mmojo Share mount point - $MMOJO_SHARE_MOUNT_POINT."
    sudo mkdir -p $MMOJO_SHARE_MOUNT_POINT
fi

#----------------------------------------
# Create a `mm-mount-mmojo-share.sh` script.
#----------------------------------------
echo "Copying $MOUNT_MMOJO_SHARE_SCRIPT script."
cp "$MMOJO_SERVER_SCRIPTS/-$MOUNT_MMOJO_SHARE_SCRIPT" "$HOME_SCRIPTS/$MOUNT_MMOJO_SHARE_SCRIPT"
chmod a+x "$HOME_SCRIPTS/$MOUNT_MMOJO_SHARE_SCRIPT"

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
