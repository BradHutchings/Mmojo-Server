#!/bin/bash

################################################################################
# This script adds .gguf model from /300-MODELS to the package.
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
printf "\n$STARS\n*\n* STARTED: $SCRIPT_NAME.\n*\n$STARS\n\n"

if [ -v CHOSEN_BUILD ] && [ -v CHOSEN_BUILD_PATH ] && [ -v CHOSEN_MODEL ]; then
    THIS_PACKAGE_DIR="$PACKAGE_DIR/$PACKAGE_ZIP-$CHOSEN_BUILD_INFO"
    SUPPORT_DIR="$THIS_PACKAGE_DIR/$PACKAGE_MMOJO_SERVER_SUPPORT_DIR"
    CHOSEN_MODEL_FILE="$LOCAL_MODELS_DIR/$CHOSEN_MODEL"

    if [ -d "$THIS_PACKAGE_DIR" ] && [ -d "$SUPPORT_DIR" ] && [ -f "$CHOSEN_MODEL_FILE" ]; then
        cp $CHOSEN_MODEL_FILE $SUPPORT_DIR
        
        echo ""
        echo "$SUPPORT_DIR:"
        ls -al "$SUPPORT_DIR"
    fi
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
