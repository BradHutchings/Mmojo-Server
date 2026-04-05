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

if ($isRunning); then
    echo "Stopping OpenClaw gateway."
    oc-gateway-stop.sh
fi

openclaw update

oc-patch.sh

if ($isRunning); then
    echo "Starting OpenClaw gateway."
    oc-gateway-start.sh
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
