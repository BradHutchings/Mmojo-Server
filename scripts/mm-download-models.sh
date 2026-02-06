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
    MODEL_MNEMONIC=$2
    URL="https://huggingface.co/bradhutchings/Mmojo-Server/resolve/main/models/$MODEL_FILE?download=true"
    if [ ! -f $MODEL_FILE ]; then
        echo "Downloading $MODEL_FILE to $LOCAL_MODELS_DIR."
        wget $URL --show-progress --quiet -O $MODEL_FILE
        if [ -f $MODEL_FILE ]; then
            if [ -f "$LOCAL_MODEL_MAP" ]; then
                sed -i -e "/$MODEL_FILE/d" $LOCAL_MODEL_MAP
            fi
sudo cat << EOF >> $LOCAL_MODEL_MAP
$MODEL_FILE $MODEL_MNEMONIC
EOF
        fi
    fi
}

cd $LOCAL_MODELS_DIR
downloaded=0
unset mnemonics
declare -A mnemonics

while IFS=$' ' read -r gguf mnemonic ; do
  if [[ "$gguf" != "#" ]] && [[ -n "$gguf" ]]; then
    mnemonics["${gguf}"]="${mnemonic}"
  fi
done < "$LOCAL_DOWNLOAD_MODEL_MAP"

for key in "${!mnemonics[@]}"; do
    mnemonic=${mnemonics["$key"]}

    echo ""
    echo "Considering: $key -- $mnemonic"

    if [ -f "$LOCAL_MODELS_DIR/$key" ]; then
        echo "File already exists in $LOCAL_MODELS_DIR."
    elif [ "$count" -ge "0" ]; then
        if [ "$downloaded" -ge "$count" ]; then
            echo "Already downloaded $count models."
        fi
    else
        DownloadModel $key $mnemonic
        # echo "Downloading: $key -- $mnemonic"
        if [ -f "$LOCAL_MODELS_DIR/$key" ]; then
            ((downloaded++))
        fi
    fi
done

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
