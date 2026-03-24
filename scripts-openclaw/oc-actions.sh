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

########################################
# User chooses aan action to view.
########################################

WORKSPACE_ACTIONS="$HOME/.openclaw/workspace/actions"
mkdir -p $WORKSPACE_ACTIONS

cd $WORKSPACE_ACTIONS
actions=("None")
actions=()
for file in *; do
    # echo "Adding $file"
    actions+=($file)
done

echo
echo "Please pick an action to view:"
for ((i=0;i<${#actions[@]};i++)); do
    string="$(($i+1))) ${actions[$i]}"
    printf "%s\n" "$string"
done

echo
read -p 'Which action would you like to view? ' opt

choice=""
if [ "$opt" -gt "0" ] && [ "$opt" -le ${#actions[@]} ]; then
    choice=${actions[$opt-1]}
fi

echo
echo "You chose: $choice"

if [ "$choice" != "" ] }&& [ -f "$WORKSPACE_REPORTS/$choice" ]; then
    echo
    cat "$WORKSPACE_REPORTS/$choice"
    echo

    read -p 'Would you like to edit $choice? (Y/N) ' opt

    if [[ "$opt" == "y"* ]]; then
        nano "$WORKSPACE_REPORTS/$choice"
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
