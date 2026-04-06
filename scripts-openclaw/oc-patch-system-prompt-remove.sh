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
START_SEARCH_1="function buildAgentSystemPrompt(params)"
START_SEARCH_2="function buildAgentSystemPrompt_inactive(params)"
END_SEARCH="function buildRuntimeLine"
DIST_DIR="$HOME/.npm-global/lib/node_modules/openclaw/dist"
PATCH_SEARCH="Mmojo Patch START"
SOURCE_FILE=$(grep -lr --include="*.js" "$START_SEARCH" "$DIST_DIR")
if [ -f "$SOURCE_FILE" ]; then
    echo "SOURCE_FILE: $SOURCE_FILE."
    START_LINE_1_GREP=$(grep -n "$START_SEARCH_1" "$SOURCE_FILE")
    START_LINE_1=${START_LINE_1_GREP%%:*}
    START_LINE_2_GREP=$(grep -n "$START_SEARCH_2" "$SOURCE_FILE")
    START_LINE_2=${START_LINE_2_GREP%%:*}
    END_LINE_GREP=$(grep -n "$END_SEARCH" "$SOURCE_FILE")
    END_LINE=$(( ${END_LINE_GREP%%:*}-1 ))
    PATCH_LINE_GREP=$(grep -n "$PATCH_SEARCH" "$SOURCE_FILE")
    PATCH_LINE=${PATCH_LINE_GREP%%:*}
    echo "START_LINE_1_GREP: $START_LINE_1_GREP"
    echo "START_LINE_1: $START_LINE_1"
    echo "START_LINE_2_GREP: $START_LINE_2_GREP"
    echo "START_LINE_2: $START_LINE_2"
    echo "END_LINE_GREP: $END_LINE_GREP"
    echo "END_LINE: $END_LINE"
    echo "PATCH_LINE_GREP: $PATCH_LINE_GREP"
    echo "PATCH_LINE: $PATCH_LINE"
    echo
    if ( [ "$START_LINE_1" -gt "0" ] || [ "$START_LINE_2" -gt "0" ] ) && [ "$END_LINE" -gt "0" ]; then
        if [ "$PATCH_LINE" = "" ]; then
            echo "Not patched: $FILE."
        else
            # Remove the patch at the bottom
            # Restore the function name.
            echo "Removing patch: $SOURCE_FILE."
            $MMOJO_SED -i -e "/$PATCH_SEARCH/,\$d" "$SOURCE_FILE"
            $MMOJO_SED -i -e "s/$START_LINE_2/$START_LINE_1/g" "$SOURCE_FILE"
        fi
    else
        echo "No source file was found."
    fi
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
