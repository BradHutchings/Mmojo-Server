#!/bin/bash

################################################################################
# This script restarts the OpenClaw gateway.
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
# printf "\n$STARS\n*\n* STARTED: $SCRIPT_NAME.\n*\n$STARS\n\n"

isRunning=false
status=$(oc-gateway-status.sh) 
if [ "$status" = "Running" ]; then
    isRunning=true
fi

hasSystemPromptPath=false
patched=$(oc-patch-system-prompt-is-patched.sh)
echo "patched: $patched"
if [[ "$patched" == *"File is patched"* ]]; then
    echo "The system prompt patch is installed. Removing patch before updating."
    hasSystemPromptPath=true
    oc-patch-system-prompt-remove.sh
fi

if ($isRunning); then
    echo "Stopping OpenClaw gateway."
    oc-gateway-stop.sh
fi

openclaw update

oc-patch.sh

if ($hasSystemPromptPath); then
    echo "Installing system prompt patch."
    oc-patch-system-prompt-install.sh
fi

# Updating may have started the gateway.
# If it was running when this script started, but isn't running now, start it.
if ($isRunning); then
    status=$(oc-gateway-status.sh) 
    if [ "$status" != "Running" ]; then
        echo "Starting OpenClaw gateway."
        oc-gateway-start.sh
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
