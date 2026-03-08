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

if [ ! -d "$SHARE_MOUNT_POINT" ]; then
    # Fail silently, since we're now called by mm-models-download.sh.
    # echo "You have not created your Mmojo Share mount point."
    exit 1
fi

# mount the mmojo share
if [[ ! $(findmnt "$SHARE_MOUNT_POINT") ]]; then
    mm-share-mount.sh
fi

if [[ $(findmnt "$SHARE_MOUNT_POINT") ]]; then
    mkdir -p "$SHARE_DIR_MODELS"
fi

# Create $MODELS_DIR is needed.
if [ ! -d "$MODELS_DIR" ]; then
    mkdir -p "$MODELS_DIR"
fi

BackupModel() {
    MODEL_FILE=$1
    if [ ! -f "$SHARE_DIR_MODELS/$MODEL_FILE" ]; then 
        echo ""
        echo "Backing up $MODEL_FILE to $SHARE_DIR_MODELS."
        sudo rsync -ah --progress "$MODELS_DIR/$MODEL_FILE" "$SHARE_DIR_MODELS/$MODEL_FILE"
        sudo chmod a-x "$SHARE_DIR_MODELS/$MODEL_FILE"
        backed_up_one=1
    fi
}

if [[ $(findmnt "$SHARE_MOUNT_POINT") ]] && [ -d "$SHARE_DIR_MODELS" ] && [ -d "$MODELS_DIR" ]; then
    cd "$MODELS_DIR"
    for file in *.gguf; do
        if [ -f "$file" ]; then
            BackupModel "$file"
        fi
    done
fi

if [ "$backed_up_one" == "0" ]; then
    echo ""
    echo "There are no new models to back up."
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
