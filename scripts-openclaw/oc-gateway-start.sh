#!/bin/bash

################################################################################
# This script starts the OpenClaw gateway.
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
# printf "\n$STARS\n*\n* STARTED: $SCRIPT_NAME.\n*\n$STARS\n\n"

if [ "$(oc-gateway-status.sh)" == "Not running" ]; then
    echo "Starting the OpenClaw gateway."
    echo ""
    system_prompts_dir="$HOME/.openclaw/system-prompts"
    if [ -d "$system_prompts_dir" ]; then
        rm "$system_prompts_dir/"*
    fi
    openclaw gateway start
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
