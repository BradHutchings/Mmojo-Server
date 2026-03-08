#!/bin/bash

################################################################################
# This script copies the Mmojo Server files to the specified build directory.
#
# FUTURE: Don't take a branding parameter. Loop over the build folders. If a
# build folder exists, copy and sed files.
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
printf "\n$STARS\n*\n* STARTED: $SCRIPT_NAME.\n*\n$STARS\n\n"

cd $HOME

build_folders=("$BUILD_DIR" "$LLAMA_SERVER_BUILD_DIR")

for build_folder in "${build_folders[@]}"; do
    if [ -d "$build_folder" ]; then
        echo "Copying into: $build_folder/"
        cp -r $MMOJO_SERVER_REPO_DIR_FILES/* $build_folder/

        cd $build_folder

        # In tools/server/server-context-mmojo.cpp, replace "defer(" with "defer_task(" to make Cosmo STL happy.
        sed -i -e 's/defer(/defer_task(/g' tools/server/server-context-mmojo.cpp
        sed -i -e 's/server_queue::defer(/server_queue::defer_task(/g' tools/server/server-queue.cpp
        sed -i -e 's/void\ defer(/void\ defer_task(/g' tools/server/server-queue.h
    fi
done

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
