#!/bin/bash

################################################################################
# This script restores models from the Mmojo Share to the $HOME/mm-models
# directory. It only restores models listed in restore-model-map.txt on the 
# Mmojo Share.
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
printf "\n$STARS\n*\n* STARTED: $SCRIPT_NAME.\n*\n$STARS\n\n"

count=$1
if [ -z "$count" ] || [[ "$count" -lt 0 ]]; then
    count=0
fi

cd $HOME

RestoreModel() {
    MODEL_FILE=$1
    MODEL_MNEMONIC=$2
    if [ ! -f "$LOCAL_MODELS_DIR/$MODEL_FILE" ]; then 
        echo "Restoring $MODEL_FILE ($MODEL_MNEMONIC) to $LOCAL_MODELS_DIR."
        sudo rsync -ah --progress "$MMOJO_SHARE_MODELS_DIR/$MODEL_FILE" "$LOCAL_MODELS_DIR/$MODEL_FILE"
        sudo chmod a-x "$LOCAL_MODELS_DIR/$MODEL_FILE"
        if [ -f "$LOCAL_MODEL_MAP" ]; then
            sed -i -e "/$MODEL_FILE/d" $LOCAL_MODEL_MAP
        fi
sudo cat << EOF >> $LOCAL_MODEL_MAP
$MODEL_FILE $MODEL_MNEMONIC
EOF
    fi
}

# mount the mmojo share
if [[ ! $(findmnt $MMOJO_SHARE_MOUNT_POINT) ]]; then
    mm-share-mount.sh
fi

if [[ $(findmnt $MMOJO_SHARE_MOUNT_POINT) ]]; then
    mkdir -p $MMOJO_SHARE_MODELS_DIR
fi

# Create $LOCAL_MODELS_DIR is needed.
if [ ! -d $LOCAL_MODELS_DIR ]; then
    mkdir -p $LOCAL_MODELS_DIR
fi

if [[ $(findmnt $MMOJO_SHARE_MOUNT_POINT) ]] && [ -d $MMOJO_SHARE_MODELS_DIR ]; then
    if [ ! -f "$MMOJO_SHARE_RESTORE_MODEL_MAP" ] || [ "$count" -eq 0 ]; then
        if [ -f "$MMOJO_SHARE_MODEL_MAP" ]; then
            echo ""
            echo "Copying $MMOJO_SHARE_MODEL_MAP to $MMOJO_SHARE_RESTORE_MODEL_MAP."
            cp "$MMOJO_SHARE_MODEL_MAP" "$MMOJO_SHARE_RESTORE_MODEL_MAP"
        fi
    fi

    if [ -f "$MMOJO_SHARE_RESTORE_MODEL_MAP" ] && [ "$count" -gt 0 ]; then
        echo ""
        echo "Restoring the first $count models that aren't in $LOCAL_MODELS_DIR."

        restored=0
        unset mnemonics
        declare -A mnemonics

        while IFS=$' ' read -r gguf mnemonic ; do
            # Comment and blank lines are filtered here.
            if [[ "$gguf" != \#* ]] && [[ -n "$gguf" ]]; then
                mnemonics["${gguf}"]="${mnemonic}"
            fi
        done < "$MMOJO_SHARE_RESTORE_MODEL_MAP"

        for key in "${!mnemonics[@]}"; do
            mnemonic=${mnemonics["$key"]}

            echo ""
            echo "Considering: $key -- $mnemonic"

            if [ ! -f "$MMOJO_SHARE_MODELS_DIR/$key" ]; then
                echo "File does not exist in $MMOJO_SHARE_MODELS_DIR."
            elif [ -f "$LOCAL_MODELS_DIR/$key" ]; then
                echo "File already exists in $LOCAL_MODELS_DIR."
            elif [ "$restored" -ge "$count" ]; then
                echo "Already restored $count models."
            else
                RestoreModel $key $mnemonic
                # echo "Restoring: $key -- $mnemonic"
                if [ -f "$LOCAL_MODELS_DIR/$key" ]; then
                    ((restored++))
                fi
            fi
        done
    fi
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
