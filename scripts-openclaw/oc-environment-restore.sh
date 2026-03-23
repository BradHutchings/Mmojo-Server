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
# User chooses a backup.
########################################

OPENCLAW_BACKUPS="$HOME/openclaw-backups"
mkdir -p $OPENCLAW_BACKUPS

cd $OPENCLAW_BACKUPS
backups=("None")
backups=()
for file in *.zip; do
    # echo "Adding $file"
    backups+=($file)
done

echo
echo "Please pick a backup to use:"
for ((i=0;i<${#backups[@]};i++)); do
    string="$(($i+1))) ${backups[$i]}"
    printf "%s\n" "$string"
done

echo
read -p 'Which backup would you like to use? ' opt

choice=""
if [ "$opt" -gt "0" ] && [ "$opt" -le ${#backups[@]} ]; then
    choice=${backups[$opt-1]}
fi

echo
echo "You chose: $choice"

########################################
# Zip up the .openclaw directory
# Delete the .openclaw directory
# Restore the .openclaw directory from backup.
########################################

if [ "$choice" != "" ]; then
    isRunning=false
    status=$(oc-gateway-status.sh) 
    if [ "$status" = "Running" ]; then
        isRunning=true
    fi

    if ($isRunning); then
        echo "Stopping OpenClaw gateway."
        oc-gateway-stop.sh
    fi

    cd $HOME

    openclawSave="openclaw-save"
    if [ -f "$openclawSave.zip" ]; then
        i=1
        while [ -f "$openclawSave-$i.zip" ]; do
            i=i+1
        done
        openclawSave="openclaw-save-$i.zip"
    fi

    echo "Archiving .openclaw."
    zip -r "$openclawSave" .openclaw

    echo
    echo "Archiving .openclaw."
    rm -r -f .openclaw

    echo "Copying $choice."
    cp "$OPENCLAW_BACKUPS/$choice" .

    echo "Restoring $choice."
    unzip "$choice"
    rm "$choice"

    if ($isRunning); then
        echo "Starting OpenClaw gateway."
        oc-gateway-start.sh
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
