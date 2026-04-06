#!/bin/bash

################################################################################
# This script restarts the OpenClaw gateway.
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
# printf "\n$STARS\n*\n* STARTED: $SCRIPT_NAME.\n*\n$STARS\n\n"

################################################################################
# Install the patch on the file that contains buildAgentSystemPrompt if the 
# patch does not exist.
################################################################################

PATCH_FILE="$REPO_DIR/files-openclaw/patches/buildAgentSystemPrompt.js"
FUNCTION_DEF=""
START_SEARCH="function buildAgentSystemPrompt(params)"
END_SEARCH="function buildRuntimeLine"
DIST_DIR="$HOME/.npm-global/lib/node_modules/openclaw/dist"
PATCH_SEARCH="Mmojo Patch START"
SOURCE_FILE=$(grep -lr --include="*.js" "$START_SEARCH" "$DIST_DIR")
if [ -f "$SOURCE_FILE" ]; then
    echo "SOURCE_FILE: $SOURCE_FILE."
    PATCH_LINE_GREP=$(grep -n "$PATCH_SEARCH" "$SOURCE_FILE")
    PATCH_LINE=${PATCH_LINE_GREP%%:*}
    echo "PATCH_LINE_GREP: $PATCH_LINE_GREP"
    echo "PATCH_LINE: $PATCH_LINE"
    echo
    if [ "$PATCH_LINE" -gt "0" ]; then
        echo "File is patched: $SOURCE_FILE."
    else
        echo "File is not patched: $SOURCE_FILE."
    fi
else
    echo "No source file was found."
fi

# printf "\n$STARS\n*\n* FINISHED: $SCRIPT_NAME.\n*\n$STARS\n\n"

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
