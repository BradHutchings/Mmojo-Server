#!/bin/bash

################################################################################
# This script clones these repos to set up a $LOCAL_MODELS_DIR:
# - llama.cpp
#   - https://github.com/ggml-org/llama.cpp
#
# Thank you to Georgi Gerganov and his team for llama.cpp! Thank you to the
# developers behind the rest of the repos for their support as well!
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
printf "\n$STARS\n*\n* STARTED: $SCRIPT_NAME.\n*\n$STARS\n\n"

mkdir -p $LOCAL_MODELS_DIR
cd $LOCAL_MODELS_DIR

echo "Cloning llama.cpp locally for gguf python stack."
git clone https://github.com/ggml-org/llama.cpp $LOCAL_MODELS_DIR/llama.cpp

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
