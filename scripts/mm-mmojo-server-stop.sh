#!/bin/bash

################################################################################
# This script adds certs from the Mmojo Share to the mmojo-server.zip packaging
# file.
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
# printf "\n**********\n*\n* STARTED: $SCRIPT_NAME.\n*\n**********\n\n"

mmojoServerRunning=$(pgrep -x "mmojo-server")
# echo "\$mmojoServerRunning: $mmojoServerRunning"

if [ -z "$mmojoServerRunning" ] ; then
    echo "Mmojo Server is not running."
else
    echo "Stopping Mmojo Server with process id: $mmojoServerRunning."
    kill $mmojoServerRunning
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
