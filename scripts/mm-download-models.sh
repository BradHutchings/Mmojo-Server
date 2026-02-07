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
        echo "Downloading $MODEL_FILE to $LOCAL_MODELS_DIR."
        DOWNLOAD_FILE_NAME="$MODEL_FILE.download"
        wget $URL --show-progress --quiet -O $DOWNLOAD_FILE_NAME
        mv $DOWNLOAD_FILE_NAME $MODEL_FILE
    fi
}

cd $LOCAL_MODELS_DIR
downloaded=0
unset ggufs
declare -A ggufs

while IFS=$' ' read -r gguf ; do
  if [[ "$gguf" != "#" ]] && [[ -n "$gguf" ]]; then
    ggufs["${gguf}"]="1"
  fi
done < "$LOCAL_MODEL_QUEUE"

for key in "${!ggufs[@]}"; do
    echo ""
    echo "Considering: $key"

    FILE_ON_MMOJO_SHARE="$MMOJO_SHARE_MODELS_DIR/$key"

    if [ -f "$LOCAL_MODELS_DIR/$key" ]; then
        echo "File already exists in $LOCAL_MODELS_DIR."
        
    elif [ -f "$FILE_ON_MMOJO_SHARE" ]; then
        sudo rsync -ah --progress "$FILE_ON_MMOJO_SHARE" "$LOCAL_MODELS_DIR/$key" 
        sudo chmod a-x "$LOCAL_MODELS_DIR/$key"
        
    elif [ "$count" -gt "0" ]; then
        if [ "$downloaded" -ge "$count" ]; then
            echo "Already downloaded $count models."
        fi
    else
        DownloadModel $key
        if [ -f "$LOCAL_MODELS_DIR/$key" ]; then
            ((downloaded++))
        fi
    fi
done

if [ "$downloaded" -gt "0" ]; then
    mm-backup-models.sh
fi

cd $HOME

echo -e "\nLocal models directory:"
ls -al $LOCAL_MODELS_DIR/*.gguf

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
