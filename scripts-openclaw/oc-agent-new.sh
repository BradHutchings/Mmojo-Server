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

echo
read -p "What name would you like for our new agent? " agent_name

duplicate=false
if [ "$agent_name" != "" ]; then
    if [ -d "$HOME/.openclaw/agents/$agent_name" ]; then
        duplicate=true
    fi
fi

if (! $duplicate); then
    echo
    echo "Creating agent $agent_name."
else
    echo
    echo "An agent named $agent_name already exists."
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
#  brad@Mmojo.net
################################################################################
