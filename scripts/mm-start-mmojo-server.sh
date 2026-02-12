#!/bin/bash

################################################################################
# This script adds certs from the Mmojo Share to the mmojo-server.zip packaging
# file.
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
printf "\n**********\n*\n* STARTED: $SCRIPT_NAME.\n*\n**********\n\n"

background=$1
runInBackground=false;

if [ "$background" != "" ]; then
    runInBackground=true;
fi

# printf "\n\$RUN_DIR: $RUN_DIR\n\n"
# printf "\n\$PACKAGE_MMOJO_SERVER_FILE: $PACKAGE_MMOJO_SERVER_FILE\n\n"

MMOJO_SERVER_EXEC=""

if [ -d "$RUN_DIR" ]; then
    if [ -f "$RUN_DIR/$PACKAGE_MMOJO_SERVER_FILE" ]; then
        MMOJO_SERVER_EXEC="$RUN_DIR/$PACKAGE_MMOJO_SERVER_FILE"
    elif [ -f "$RUN_DIR/$PACKAGE_MMOJO_SERVER_APE_FILE" ]; then
        MMOJO_SERVER_EXEC="$RUN_DIR/$PACKAGE_MMOJO_SERVER_APE_FILE"
    fi
    MMOJO_SERVER_LOG="$MMOJO_SERVER_EXEC.log"
else
    echo "The run directory < $RUN_DIR > does not exist."
fi

mmojoServerRunning=$(pgrep "mmojo-server")
if ! $mmojoServerRunning ; then
    if [ -f "$MMOJO_SERVER_EXEC" ]; then
        if ($runInBackground); then
            echo "Starting mmojo-server in the background."
            nohup "$MMOJO_SERVER_EXEC" > "$MMOJO_SERVER_LOG" 2>&1 &
        else
            "$MMOJO_SERVER_EXEC"
        fi
    fi
else
    echo "Mmojo Server is already running."
fi

cd $HOME

printf "\n**********\n*\n* FINISHED: $SCRIPT_NAME.\n*\n**********\n\n"

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
