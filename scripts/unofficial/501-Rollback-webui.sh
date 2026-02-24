#!/bin/bash

################################################################################
# This script rolls back the webui directory to the commit before the new Svelte 
# based webui was introduced. Rolling back ensures we can run the chat web UI on 
# a non-root endpoint. -Brad
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
printf "\n$STARS\n*\n* STARTED: $SCRIPT_NAME.\n*\n$STARS\n\n"

cd $BUILD_DIR

rm -r -f tools/server/webui
git checkout 6c019cb04e86e2dacfe62ce7666c64e9717dde1f tools/server/webui/

APP_NAME='Mmojo Chat'
sed -i -e "s/>.*llama.cpp.*</>$APP_NAME</g" tools/server/webui/index.html
sed -i -e "s/>.*llama.cpp.*</>$APP_NAME</g" tools/server/webui/src/components/Header.tsx

cd $HOME

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
