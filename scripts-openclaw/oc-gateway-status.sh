#!/bin/bash

################################################################################
# This script returns the gateway status: "Not running", "Running", ???
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
# printf "\n$STARS\n*\n* STARTED: $SCRIPT_NAME.\n*\n$STARS\n\n"

if [ $MMOJO_DARWIN ]; then
    running=$(launchctl print gui/$(id -u openclaw)/ai.openclaw.gateway | grep "state = running")

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

    running=false
    if [ "$local_is_running" == "true" ] || [ "$system_is_running" == "true" ]; then
        running=true
    fi
else
    running=$(systemctl --user status openclaw-gateway.service | grep "running")
fi

if [ "$running" != "" ]; then
    echo "Running"
else
    echo "Not running"
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
