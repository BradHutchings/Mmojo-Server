#!/bin/bash

################################################################################
# This script stops the OpenClaw gateway.
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
# printf "\n$STARS\n*\n* STARTED: $SCRIPT_NAME.\n*\n$STARS\n\n"

if [ "$(oc-gateway-status.sh)" == "Running" ]; then
    echo "Stopping the OpenClaw gateway."
    echo ""
    
    if [ "$MMOJO_DARWIN" == "true" ]; then
        local_list=$(launchctl list | grep ai.openclaw.gateway)
        local_is_running=false
        if [ "$local_list" != "" ]; then
            echo "- Local OpenClaw gateway agent is running."
            local_is_running=true
        fi
        
        system_list=$(sudo launchctl list | grep ai.openclaw.gateway)
        system_is_running=false
        if [ "$system_list" != "" ]; then
            echo "- System OpenClaw gateway daemon is running."
            system_is_running=true
        fi

        if [ "$local_is_running" == "true" ]; then
            echo "- Stopping local OpenClaw gateway agent."
            launchctl stop ai.openclaw.gateway
        fi

        if [ "$system_is_running" == "true" ]; then
            echo "- Stopping system OpenClaw gateway daemon."
            sudo launchctl stop ai.openclaw.gateway
        fi
    else
        openclaw gateway stop
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
