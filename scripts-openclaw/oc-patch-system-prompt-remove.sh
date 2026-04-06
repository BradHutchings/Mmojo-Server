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

echo "Removing system prompt patch."
PATCH_FILE="$REPO_DIR/files-openclaw/patches/buildAgentSystemPrompt.js"
DIST_DIR="$HOME/.npm-global/lib/node_modules/openclaw/dist"
SOURCE_SEARCH="function buildAgentSystemPrompt(params)"
PATCHED_SEARCH="Mmojo Patch START - buildAgentSystemPrompt"
SOURCE_FILE=$(grep -lr --include="*.js" "$SOURCE_SEARCH" "$DIST_DIR")
if [ -f "$SOURCE_FILE" ]; then
    echo "SOURCE_FILE: $SOURCE_FILE."
    PATCH_LINE_GREP=$(grep -n "$PATCHED_SEARCH" "$SOURCE_FILE")
    PATCH_LINE=${PATCH_LINE_GREP%%:*}
    echo "PATCH_LINE_GREP: $PATCH_LINE_GREP"
    echo "PATCH_LINE: $PATCH_LINE"
    if [ "$PATCH_LINE" != "" ] && [ "$PATCH_LINE" -gt "0" ]; then
		ACTIVE_FUNCTION="function buildAgentSystemPrompt(params)"
		INACTIVE_FUNCTION="function buildAgentSystemPrompt_inactive(params)"
        # Remove the patch at the bottom
        # Restore the function name.
        echo "Removing patch: $SOURCE_FILE."
        $MMOJO_SED -i -e "/$PATCHED_SEARCH/,\$d" "$SOURCE_FILE"
        $MMOJO_SED -i -e "s/$INACTIVE_FUNCTION/$ACTIVE_FUNCTION/g" "$SOURCE_FILE"
	else
        echo "File is not patched: $SOURCE_FILE."
	fi
else
	echo "No source file was found."
fi
echo

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
