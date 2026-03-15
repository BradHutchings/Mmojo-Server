#!/bin/bash

################################################################################
# This script rebuilds the chat web UI so that it can be customized and used 
# with Mmojo Server.
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
printf "\n$STARS\n*\n* STARTED: $SCRIPT_NAME.\n*\n$STARS\n\n"

if [ "$1" == "" ]; then
    wd=$(pwd)
    cd $BUILD_DIR
    echo ""
    echo "Customizing Mmojo Complete."
    rm -r -f Mmojo-Complete-original
    cp -r Mmojo-Complete Mmojo-Complete-original

    TODAY=$(date +%Y-%m-%d)
    $SED -i -e "s/\[\[UPDATED\]\]/$TODAY/g" Mmojo-Complete/scripts.js
    $SED -i -e "s/\[\[UPDATED\]\]/$TODAY/g" Mmojo-Complete/bookmark-scripts.js
    cd $wd
fi

printf "\n$STARS\n*\n* FINISHED: $SCRIPT_NAME.\n*\n$STARS\n\n"

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
