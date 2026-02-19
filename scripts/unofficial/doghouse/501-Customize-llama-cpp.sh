#!/bin/bash

################################################################################
# This script patches up source code right before we compile so I don't have to 
# maintain all the changed files within this repo's /files directory. -Brad
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
printf "\n$STARS\n*\n* STARTED: $SCRIPT_NAME.\n*\n$STARS\n\n"

cd $DOGHOUSE_BUILD_DIR

# In tools/server/server-mmojo.cpp, customize for Doghouse
sed -i -e 's/PROCESS_NAME\ \"mmojo-server\"/PROCESS_NAME\ \"doghouse\"/g' tools/server/server-mmojo.cpp
sed -i -e 's/ARGS_FILENAME\ \"mmojo-server-args\"/ARGS_FILENAME\ \"doghouse-args\"/g' tools/server/server-mmojo.cpp
sed -i -e 's/SUPPORT_DIRECTORY_NAME\ \"mmojo-server-support\"/SUPPORT_DIRECTORY_NAME\ \"doghouse-support\"/g' tools/server/server-mmojo.cpp
sed -i -e 's/PRODUCT_NAME\ \"Mmojo Server\"/PRODUCT_NAME\ \"Doghouse\"/g' tools/server/server-mmojo.cpp

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
