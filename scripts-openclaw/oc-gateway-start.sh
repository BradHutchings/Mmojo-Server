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
                original="$HOME/Library/LaunchAgents/ai.openclaw.gateway.plist"
                file="/Library/LaunchDaemons/ai.openclaw.gateway.plist"

                sudo cp "$original" "$file"

                after="<string>ai.openclaw.gateway</string>"
                search="<key>UserName</key>"
                plist="plist.txt"

cat << EOF > $plist

    <key>UserName</key>
    <string>openclaw</string>
    <key>GroupName</key>
    <string>staff</string>

EOF

                search=$(sed -n '2p' $plist)
                insertLine=$(sudo grep -n -m 1 $after $file | cut -d: -f1)
                echo "-----"
                sudo grep -n -m 1 $after $file
                sudo grep -n -m 1 $after $file | cut -d: -f1
                echo "-----"
                echo "insertLine: $insertLine"
                echo "-----"

                found=$(sudo grep $search $file)
                if [ "$found" == "" ]; then
                    sedCommand="${insertLine}r $plist"
                    echo "  - Patching $file."
                    echo "    - Inserting UserName and GroupName."
                    echo "    - sedCommand: $sedCommand"
                    sudo sed -i -e "${insertLine}r $plist" $file
                else
                    echo "  - $file is already patched."
                fi

                # Add this to the main <dict> in that .plist:
                #     <key>UserName</key>
                #     <string>openclaw</string>
                #     <key>GroupName</key>
                #     <string>staff</string>
                # Otherwise, root runs it and ends up owning $HOME/.openclaw/openclaw.json.
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
