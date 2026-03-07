#!/bin/bash

################################################################################
# This script downloads models from Hugging Face.
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
printf "\n$STARS\n*\n* STARTED: $SCRIPT_NAME $1.\n*\n$STARS\n\n"

count=$1
if [ -z "$count" ] || [[ "$count" -lt 1 ]]; then
    count=0
fi

DownloadModel() {
    MODEL_FILE=$1
    URL="https://huggingface.co/bradhutchings/Mmojo-Server/resolve/main/models/$MODEL_FILE?download=true"
    if [ ! -f $MODEL_FILE ]; then
        echo "Downloading $MODEL_FILE to $MODELS_DIR."
        DOWNLOAD_FILE_NAME=".$MODEL_FILE.download"
        wget $URL --show-progress --quiet -O $DOWNLOAD_FILE_NAME
        mv $DOWNLOAD_FILE_NAME $MODEL_FILE
    fi
}

cd $MODELS_DIR
downloaded=0
unset ggufs
declare -A ggufs

if [ -f "$_MODEL_QUEUE" ]; then
    while IFS=$' ' read -r gguf ; do
        if [[ "$gguf" != "#" ]] && [[ -n "$gguf" ]]; then
            ggufs["${gguf}"]="1"
        fi
    done < "$_MODEL_QUEUE"
fi

for key in "${!ggufs[@]}"; do
    echo ""
    echo "Considering: $key"

    FILE_ON_MMOJO_SHARE="$SHARE_MODELS_DIR/$key"

    if [ -f "$MODELS_DIR/$key" ]; then
        echo "File already exists in $MODELS_DIR."
        
    elif [ -f "$FILE_ON_MMOJO_SHARE" ]; then
        echo "Copying $key from your Mmojo Share."
        sudo rsync -ah --progress "$FILE_ON_MMOJO_SHARE" "$MODELS_DIR/$key" 
        sudo chmod a-x "$MODELS_DIR/$key"
        
    elif [ "$count" -gt "0" ]; then
        if [ "$downloaded" -ge "$count" ]; then
            echo "Already downloaded $count models."
        fi
    else
        DownloadModel $key
        if [ -f "$MODELS_DIR/$key" ]; then
            ((downloaded++))
        fi
    fi
done

if [ "$downloaded" -gt "0" ]; then
    mm-models-backup.sh
fi

cd $MODELS_DIR
echo -e "\nmm-models directory:"
# if [ -f *.gguf ]; then
    ls -al *.gguf
# fi

cd $HOME

printf "\n$STARS\n*\n* FINISHED: $SCRIPT_NAME $1.\n*\n$STARS\n\n"

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
