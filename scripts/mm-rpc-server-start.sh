#!/bin/bash

################################################################################
# This script adds certs from the Mmojo Share to the mmojo-server.zip packaging
# file.
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
# printf "\n**********\n*\n* STARTED: $SCRIPT_NAME $1.\n*\n**********\n\n"

background=$1
runInBackground=false;

if [ "$background" != "" ]; then
    runInBackground=true;
fi

# echo "runInBackground: $runInBackground"

# printf "\n\$DEPLOY_DIR: $DEPLOY_DIR\n\n"
# printf "\n\$_PACKAGE_MMOJO_RPC_SERVER_FILE: $_PACKAGE_MMOJO_RPC_SERVER_FILE\n\n"

MMOJO_RPC_SERVER_EXEC=""
MMOJO_RPC_SERVER_PARAMS=""
APP_NAME=""

if [ -d "$DEPLOY_DIR" ]; then
    if [ -f "$DEPLOY_DIR/$_PACKAGE_MMOJO_RPC_SERVER_FILE" ]; then
        MMOJO_RPC_SERVER_EXEC="$DEPLOY_DIR/$_PACKAGE_MMOJO_RPC_SERVER_FILE"
        APP_NAME="Mmojo RPC Server"
    fi
    MMOJO_RPC_SERVER_LOG="$MMOJO_RPC_SERVER_EXEC.log"
else
    echo "The run directory < $DEPLOY_DIR > does not exist."
fi

serverRunningId=$(pgrep -x "mmojo-rpc-serve")
# echo "serverRunningId: $serverRunningId"

# Stop Mmojo RPC Server if we're not running background
if [ ! -z "$serverRunningId" ]; then
    if [ -f "$MMOJO_RPC_SERVER_EXEC" ]; then
        if (! $runInBackground); then
            echo "Stopping Mmojo RPC Server with process id: $serverRunningId."
            kill $serverRunningId
            sleep 5s
            serverRunningId=$(pgrep -x "mmojo-rpc-serve")
        fi
    fi
fi

if [ -z "$serverRunningId" ]; then
    if [ -f "$MMOJO_RPC_SERVER_EXEC" ]; then
        COMMAND="$MMOJO_RPC_SERVER_EXEC $MMOJO_RPC_SERVER_PARAMS"
        echo $COMMAND
        echo ""
        if ($runInBackground); then
            echo "Starting $APP_NAME in the background."
            nohup bash -c "$COMMAND" > /dev/null 2>&1 &
        else
            # COMMAND="$MMOJO_SERVER_EXEC $MMOJO_SERVER_PARAMS"
            # echo $COMMAND
            # echo ""
            bash -c "$COMMAND"
            # bash -c "$MMOJO_SERVER_EXEC $MMOJO_SERVER_PARAMS"
        fi
    fi
else
    if ($runInBackground); then
        echo "Mmojo RPC Server is already running with process id: $serverRunningId."
    fi
fi

# printf "\n**********\n*\n* FINISHED: $SCRIPT_NAME.\n*\n**********\n\n"

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
