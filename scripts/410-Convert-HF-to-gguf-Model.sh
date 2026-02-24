#!/bin/bash

################################################################################
# This script converts a Hugging Face repo with safetensor files into a .gguf 
# model.
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
printf "\n$STARS\n*\n* STARTED: $SCRIPT_NAME $1 $2 $3 $4.\n*\n$STARS\n\n"

model_name=$1
model_type=$2
model_mnemonic=$3
model_repo=$4

# $model_type doesn't go in the $MODEL_SOURCE_DIR so we can reuse the download to create different versions.
MODEL_SOURCE_DIR="$LOCAL_MODELS_DIR/$model_name"
MODEL_FILE="$model_name-$model_type.gguf"

echo "      model_name: $model_name"
echo "      model_type: $model_type"
echo "  model_mnemonic: $model_mnemonic"
echo "      model_repo: $model_repo"
echo "MODEL_SOURCE_DIR: $MODEL_SOURCE_DIR"
echo "      MODEL_FILE: $MODEL_FILE"

if [ "$model_name" != "" ] && [ "$model_type" != "" ] && [ "$model_mnemonic" != "" ] && [ "$model_repo" != "" ]; then
    mkdir -p "$LOCAL_MODELS_DIR"

    if [ "$MODEL_SOURCE_DIR" != "" ] &&  [ -d "$MODEL_SOURCE_DIR" ] && [ ! -f "$MODEL_SOURCE_DIR/cloned" ]; then
        echo ""
        echo "Deleting existing model directory that doesn't look complete."
        rm -r -f "$MODEL_SOURCE_DIR"
    fi
    
    if [ "$MODEL_SOURCE_DIR" != "" ] &&  [ ! -d "$MODEL_SOURCE_DIR" ]; then
        echo ""
        echo "Cloning $model_repo."
        git clone "$model_repo" "$MODEL_SOURCE_DIR"
        rm -r -f "$MODEL_SOURCE_DIR/.git"
        touch "$MODEL_SOURCE_DIR/cloned"
    fi

    echo ""
    echo "Converting to $model_name-$model_type.gguf."
    python3 "$LOCAL_MODELS_DIR/llama.cpp/convert_hf_to_gguf.py" "$MODEL_SOURCE_DIR" \
        --outfile "$LOCAL_MODELS_DIR/$MODEL_FILE" \
        --outtype "$model_type"

    if [ -f "$LOCAL_MODELS_DIR/$MODEL_FILE" ]; then
        echo ""
        echo "Updating $LOCAL_MODEL_MAP."
        sed -i -e "/$MODEL_FILE/d" $LOCAL_MODEL_MAP
cat << EOF >> $LOCAL_MODEL_MAP
$MODEL_FILE $model_mnemonic
EOF
    fi

fi

cd $HOME

printf "\n$STARS\n*\n* FINISHED: $SCRIPT_NAME $1 $2 $3 $4.\n*\n$STARS\n\n"

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
