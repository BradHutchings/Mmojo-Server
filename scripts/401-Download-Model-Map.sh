#!/bin/bash

################################################################################
# This script downloads a model map file from Hugging Face. The model map file
# identifies models we might want to download, and suggest names for their
# self-contaned APE files we will package later.
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
printf "\n$STARS\n*\n* STARTED: $SCRIPT_NAME.\n*\n$STARS\n\n"

MODEL_MAP_URL="https://huggingface.co/bradhutchings/Mmojo-Server/resolve/main/model-map.txt"
wget $MODEL_MAP_URL --quiet -O $LOCAL_DOWNLOAD_MODEL_MAP

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
