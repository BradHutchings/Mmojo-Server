#!/bin/bash

################################################################################
# This script creates the models directory and creates a model map file in that
# directory. The model map file tell us what models are available to download or
# copy.
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
printf "\n$STARS\n*\n* STARTED: $SCRIPT_NAME.\n*\n$STARS\n\n"

mkdir -p $MODELS_DIR
cd $MODELS_DIR

if ! test -f "$MODEL_QUEUE"; then
cat << EOF > "$MODEL_QUEUE"
Google-Gemma-270M-Instruct-v3-q8_0.gguf
Google-Gemma-1B-Instruct-v3-q8_0.gguf
Google-Gemma-4B-Instruct-v3-q8_0.gguf
EOF
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
