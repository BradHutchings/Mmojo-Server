#!/bin/bash

################################################################################
# This script restores the OpenClaw environment to a chosen backup.
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
# printf "\n$STARS\n*\n* STARTED: $SCRIPT_NAME.\n*\n$STARS\n\n"

wd=$(pwd)
cd $HOME

shopt -s nullglob

########################################
# User chooses an agent.
########################################

openclaw_json="$HOME/.openclaw/openclaw.json"
workspace_directory="$HOME/.openclaw/workspace"

agent_index=-1
agent=""
agents=()
agent_count=$(cat "$openclaw_json" | jq "[.agents.list.[].id]" | jq "length")
for (( i=0; i<$agent_count; i++ )); do
    agent=$(cat "$openclaw_json" | jq ".agents.list.[$i].id")
    agents+=(${agent//\"/})
done

if [ "${#agents[@]}" -gt "1" ]; then
    echo
    echo "Please pick an agent:"
    for ((i=0;i<${#agents[@]};i++)); do
        string="$(($i+1))) ${agents[$i]}"
        printf "%s\n" "$string"
    done

    echo
    read -p "Which agent? " opt

    agent=""
    if [ "$opt" -gt "0" ] && [ "$opt" -le ${#agents[@]} ]; then
        agent_index=$((opt-1))
        agent=${agents[$opt-1]}
    fi
else
    agent=$agents[0]
fi

if [ "$agent_index" -ge "0" ]; then
    temp_workspace_directory=$(cat "$openclaw_json" | jq ".agents.list.[$agent_index].workspace")
    if [ "$temp_workspace_directory" != null ] && [ "$temp_workspace_directory" != "" ]; then
        workspace_directory=${temp_workspace_directory//\"/}
    fi
fi

# echo
# echo "agent_index: $agent_index"
# echo "agent: $agent"
# echo "workspace_directory: $workspace_directory"


if [ "$workspace_directory" != "" ]; then
    ########################################
    # User chooses aan action to view.
    ########################################

    WORKSPACE_ACTIONS="$workspace_directory/actions"
    # echo
    # echo "WORKSPACE_ACTIONS: $WORKSPACE_ACTIONS"
    mkdir -p $WORKSPACE_ACTIONS

    cd $WORKSPACE_ACTIONS
    actions=("None")
    actions=()
    for file in *; do
        # echo "Adding $file"
        actions+=($file)
    done

    if [ "${#actions[@]}" -gt "0" ]; then
        echo
        echo "Please pick an action to view:"
        for ((i=0;i<${#actions[@]};i++)); do
            string="$(($i+1))) ${actions[$i]}"
            printf "%s\n" "$string"
        done
    
        echo
        read -p "Which action would you like to view? " opt
        
        choice=""
        if [ "$opt" -gt "0" ] && [ "$opt" -le ${#actions[@]} ]; then
            choice=${actions[$opt-1]}
        fi
    
        echo
        echo "You chose: $choice"
    
        if [ "$choice" != "" ] && [ -f "$WORKSPACE_ACTIONS/$choice" ]; then
            echo
            echo "----------------------------------------"
            cat "$WORKSPACE_ACTIONS/$choice"
            echo
            echo "----------------------------------------"
            echo
            
            read -p "Would you like to edit $choice? (Y/N) " opt
        
            if [[ "$opt" == "y"* ]]; then
                nano "$WORKSPACE_ACTIONS/$choice"
            fi
        fi
    else
        echo
        echo "There are no actions for $agent."
    fi
fi

cd $pwd

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
