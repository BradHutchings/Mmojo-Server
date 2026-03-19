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
# printf "\n\$_PACKAGE_MMOJO_SERVER_FILE: $_PACKAGE_MMOJO_SERVER_FILE\n\n"

MMOJO_SERVER_EXEC=""
MMOJO_SERVER_PARAMS=""
APP_NAME=""

if [ -d "$DEPLOY_DIR" ]; then
    if [ -f "$DEPLOY_DIR/$_PACKAGE_MMOJO_SERVER_FILE" ]; then
        MMOJO_SERVER_EXEC="$DEPLOY_DIR/$_PACKAGE_MMOJO_SERVER_FILE"
        APP_NAME="Mmojo Server"
    elif [ -f "$DEPLOY_DIR/$_PACKAGE_MMOJO_SERVER_APE_FILE" ]; then
        MMOJO_SERVER_EXEC="$DEPLOY_DIR/$_PACKAGE_MMOJO_SERVER_APE_FILE"
        APP_NAME="Mmojo Server APE"
    elif [ -f "$DEPLOY_DIR/$_PACKAGE_MMOJO_SERVER_APE_COMPATIBLE_FILE" ]; then
        MMOJO_SERVER_EXEC="$DEPLOY_DIR/$_PACKAGE_MMOJO_SERVER_APE_COMPATIBLE_FILE"
        APP_NAME="Mmojo Server APE (Compatible)"
    elif [ -f "$DEPLOY_DIR/$_PACKAGE_MMOJO_SERVER_APE_PERFORMANT_FILE" ]; then
        MMOJO_SERVER_EXEC="$DEPLOY_DIR/$_PACKAGE_MMOJO_SERVER_APE_PERFORMANT_FILE"
        APP_NAME="Mmojo Server APE (Performant)"
    elif [ -f "$DEPLOY_DIR/$_PACKAGE_LLAMA_SERVER_FILE" ]; then
        MMOJO_SERVER_EXEC="$DEPLOY_DIR/$_PACKAGE_LLAMA_SERVER_FILE"
        MMOJO_SERVER_PARAMS="--model $DEPLOY_DIR/*.gguf"
        APP_NAME="llama-server"
    fi
    MMOJO_SERVER_LOG="$MMOJO_SERVER_EXEC.log"
else
    echo "The run directory < $DEPLOY_DIR > does not exist."
fi

serverRunningId=$((pgrep -x "mmojo-server") || (pgrep -x "llama-server"))
# echo "serverRunningId: $serverRunningId"

# Stop Mmojo server if we're not running background
if [ ! -z "$serverRunningId" ]; then
    if [ -f "$MMOJO_SERVER_EXEC" ]; then
        if (! $runInBackground); then
            echo "Stopping Mmojo Server with process id: $serverRunningId."
            kill $serverRunningId
            sleep 5s
            serverRunningId=$((pgrep -x "mmojo-server") || (pgrep -x "llama-server"))
        fi
    fi
fi

if [ -z "$serverRunningId" ]; then
    if [ -f "$MMOJO_SERVER_EXEC" ]; then
        COMMAND="$MMOJO_SERVER_EXEC $MMOJO_SERVER_PARAMS"
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
    if (! $runInBackground); then
        echo "Mmojo Server is already running with process id: $serverRunningId."
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
#  brad@bradhutchings.com
################################################################################
