#!/bin/bash

################################################################################
# This script restores the OpenClaw environment to a chosen backup.
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
# printf "\n$STARS\n*\n* STARTED: $SCRIPT_NAME.\n*\n$STARS\n\n"

wd=$(pwd)
cd $HOME

########################################
# User enters the backup name.
########################################

OPENCLAW_BACKUPS="$HOME/openclaw-backups"
mkdir -p $OPENCLAW_BACKUPS

echo
read -p 'Please enter a name for this backup: ' backupName
echo

backupName="${backupName// /-}"
prefix=""
for i in $(seq -f "%02g" 1 99); do
    if [ ! -f "$OPENCLAW_BACKUPS/$i"* ]; then
        prefix=$i
        break;
    fi
done

if [ "$prefix" != "" ]; then
    backupFile="$i-$backupName.zip"
    echo "Backing up to: $backupFile"
    touch "$OPENCLAW_BACKUPS/$backupFile"
else
    echo "Backups are full."
    backupName=""
fi

########################################
# Archive it and save in backups.
########################################

if [ "$backupName" != "" ]; then
    if [ ! -f "$OPENCLAW_BACKUPS/$backupName" ]; then
        isRunning=($(oc-gateway-status.sh) = "Running")
        if ($isRunning); then
            oc-gateway-stop.sh
        fi
    
        zip -r "$backupName" .openclaw
        mv "$backupName" $OPENCLAW_BACKUPS
    
        if ($isRunning); then
            oc-gateway-start.sh
        fi
    else
        echo "The file $OPENCLAW_BACKUPS/$backupName already exists. It was not overwritten."
    fi
fi

cd $pwd

# printf "\n$STARS\n*\n* FINISHED: $SCRIPT_NAME.\n*\n$STARS\n\n"

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
