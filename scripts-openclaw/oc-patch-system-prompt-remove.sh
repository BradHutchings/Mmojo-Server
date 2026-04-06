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

DIST_DIR="$HOME/.npm-global/lib/node_modules/openclaw/dist"
PATCHED_SEARCH="Mmojo Patch START - buildAgentSystemPrompt"
PATCHED_FILE=$(grep -lr --include="*.js" "$PATCHED_FILE" "$DIST_DIR")
INACTIVE_FUNCTION="function buildAgentSystemPrompt_inactive(params)"
ACTIVE_FUNCTION="function buildAgentSystemPrompt(params)"
if [ -f "$PATCHED_FILE" ]; then
    echo "PATCHED_FILE: $PATCHED_FILE."
    PATCH_LINE_GREP=$(grep -n "$PATCHED_SEARCH" "$PATCHED_FILE")
    PATCH_LINE=${PATCH_LINE_GREP%%:*}
    echo "PATCH_LINE_GREP: $PATCH_LINE_GREP"
    echo "PATCH_LINE: $PATCH_LINE"
    echo
    if [ "$PATCH_LINE" -gt "0" ]; then
        # Remove the patch at the bottom
        # Restore the function name.
        echo "Removing patch: $PATCHED_FILE."
        $MMOJO_SED -i -e "/$PATCH_SEARCH/,\$d" "$PATCHED_FILE"
        $MMOJO_SED -i -e "s/$INACTIVE_FUNCTION/$ACTIVE_FUNCTION/g" "$PATCHED_FILE"
    else
        # Should never happen.
        echo "Not patched: $PATCHED_FILE."
    fi
else
    echo "No patched file was found."
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
