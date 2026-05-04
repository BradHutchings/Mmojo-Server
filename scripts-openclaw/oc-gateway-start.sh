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

        if [ "$local_is_running" == "false" ] && [ "$system_is_running" == "false" ]; then
            if [ ! -f "/Library/LaunchDaemons/ai.openclaw.gateway.plist" ]; then
                echo "- Copying local agent plist to system daemon directory."
                sudo cp "~/Library/LaunchAgents/ai.openclaw.gateway.plist" "/Library/LaunchDaemons/ai.openclaw.gateway.plist"
            fi
            echo "- Unloading local agent."
            launchctl unload ~/Library/LaunchAgents/ai.openclaw.gateway.plist

            echo "- Loading system daemon."
            sudo launchctl load /Library/LaunchDaemons/ai.openclaw.gateway.plist

            echo "- Starting system daemon."
            sudo launchctl start ai.openclaw.gateway
        fi
    else
        system_prompts_dir="$HOME/.openclaw/system-prompts"
        if [ -d "$system_prompts_dir" ]; then
            rm "$system_prompts_dir/"*
        fi
        openclaw gateway start
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
