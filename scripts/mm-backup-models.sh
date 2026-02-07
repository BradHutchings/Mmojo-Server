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

if [ ! -d $MMOJO_SHARE_MOUNT_POINT ]; then
    echo "You have not created your Mmojo Share mount point."
    exit 1
fi

# mount the mmojo share
if [[ ! $(findmnt $MMOJO_SHARE_MOUNT_POINT) ]]; then
    mm-mount-mmojo-share.sh
fi

if [[ $(findmnt $MMOJO_SHARE_MOUNT_POINT) ]]; then
    mkdir -p $MMOJO_SHARE_MODELS_DIR
fi

# Create $LOCAL_MODELS_DIR is needed.
if [ ! -d $LOCAL_MODELS_DIR ]; then
    mkdir -p $LOCAL_MODELS_DIR
fi

BackupModel() {
    MODEL_FILE=$1
    # MODEL_MNEMONIC=$2
    if [ ! -f "$MMOJO_SHARE_MODELS_DIR/$MODEL_FILE" ]; then 
        echo ""
        echo "Backing up $MODEL_FILE to $MMOJO_SHARE_MODELS_DIR."
        # echo "Backing up $MODEL_FILE ($MODEL_MNEMONIC) to $MMOJO_SHARE_MODELS_DIR."
        sudo rsync -ah --progress "$LOCAL_MODELS_DIR/$MODEL_FILE" "$MMOJO_SHARE_MODELS_DIR/$MODEL_FILE"
        sudo chmod a-x "$MMOJO_SHARE_MODELS_DIR/$MODEL_FILE"
# sudo cat << EOF >> $MMOJO_SHARE_MODEL_MAP
# $MODEL_FILE $MODEL_MNEMONIC
# EOF
        backed_up_one=1
    fi
}

# if [[ $(findmnt $MMOJO_SHARE_MOUNT_POINT) ]] && [ -d $MMOJO_SHARE_MODELS_DIR ] && [ -f $LOCAL_MODEL_MAP ]; then
if [[ $(findmnt $MMOJO_SHARE_MOUNT_POINT) ]] && [ -d $MMOJO_SHARE_MODELS_DIR ]; then
    # iterate over the local LOCAL_MODEL_MAP
        # if a model in the LOCAL_MODEL_MAP isn't in the MMOJO_SHARE_MODEL_MAP, copy the model, copy to the share and 
        # add to the share MODEL_MAP.

    cd $LOCAL_MODELS_DIR
    for file in *.gguf; do
        if [ -f "$file" ]; then
            BackupModel $file
        fi
    done

    #unset mnemonics
    #declare -A mnemonics

   # while IFS=$' ' read -r gguf mnemonic ; do
    #    if [[ "$gguf" != "#" ]] && [[ -n "$gguf" ]]; then
   #         mnemonics["${gguf}"]="${mnemonic}"
   #     fi
   # done < "$LOCAL_MODEL_MAP"

   # for key in "${!mnemonics[@]}"; do
   #     # echo ""
   #     # echo "key: $key"
   #     # echo "mnemonic: ${mnemonics["$key"]}"
   #     BackupModel $key ${mnemonics["$key"]}
    #done
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
