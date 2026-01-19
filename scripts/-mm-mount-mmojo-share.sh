#!/bin/bash

################################################################################
# This script mounts the Mmojo Share on your network. It is usually run as
# needed by scripts that want to copy to/from the Mmojo Share.
#
#
# See licensing note at end.
################################################################################

# Setup step: Replace [HOST] and [USER] with your Mmojo Share's hostname and user.
# If you leave HOST="[HOST]" this script will fail silently in scripts that call
# this script. So, it's OK if you don't have a Mmojo Share.

HOST="[HOST]"
USER="[USER]"
SHARE="mmojo"

SCRIPT_NAME=$(basename -- "$0")
printf "\n$STARS\n*\n* STARTED: $SCRIPT_NAME.\n*\n$STARS\n\n"

if [ ! -d $MMOJO_SHARE_MOUNT_POINT ]; then
    echo "You have not created your Mmojo Share mount point."
    exit 1
fi

if [ "$HOST" == "[HOST]" ]; then
   echo "Your mm-mount-mmojo-share.sh script is not configured."
   exit
fi

RUNNING_IN_WSL=0
if [[ $(uname -r) =~ Microsoft|WSL ]]; then
    RUNNING_IN_WSL=1
fi

if [[ ! $(findmnt $MMOJO_SHARE_MOUNT_POINT) ]]; then
   echo "Attempting to mount Mmojo Share as cifs. You may be prompted for your share password."
   sudo mount -t cifs -o user=$USER //$HOST/$SHARE $MMOJO_SHARE_MOUNT_POINT
fi
if [[ ! $(findmnt $MMOJO_SHARE_MOUNT_POINT) ]]; then
   if [ $RUNNING_IN_WSL == 1 ]; then
        echo "Attemoting to mount Mmojo Share as drvfs. You may be prompted for your share password."
        sudo mount -t drvfs -o user=$USER "\\\\$HOST\\$SHARE" $MMOJO_SHARE_MOUNT_POINT
   fi
fi

# Previous logic was not right.
# if [[ ! $(findmnt $MMOJO_SHARE_MOUNT_POINT) ]]; then
#     if [ $RUNNING_IN_WSL == 1 ]; then
#         echo "Mounting Mmojo Share as drvfs. You may be prompted for your share password."
#         sudo mount -t drvfs -o user=$USER "\\\\$HOST\\$SHARE" $MMOJO_SHARE_MOUNT_POINT
#     else
#         echo "Mounting Mmojo Share as cifs. You may be prompted for your share password."
#         sudo mount -t cifs -o user=$USER //$HOST/$SHARE $MMOJO_SHARE_MOUNT_POINT
#     fi
# fi

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
