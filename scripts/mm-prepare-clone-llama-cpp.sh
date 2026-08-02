#!/bin/bash

################################################################################
# This script clones these repos to set up a $BUILD_DIR:
# - llama.cpp
#   - https://github.com/ggml-org/llama.cpp
# - Google minja (for llama.cpp) - chat templates
#    - https://github.com/google/minja - 
#
# It rolls back the llama.cpp cloned repo to a recent known release where our 
# patches have been tested.
#
# Thank you to Georgi Gerganov and his team for llama.cpp! Thank you to the
# developers behind the rest of the repos for their support as well!
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
printf "\n$STARS\n*\n* STARTED: $SCRIPT_NAME $1.\n*\n$STARS\n\n"

cd $HOME

THIS_BUILD_DIR=$BUILD_DIR
if [ "$1" == "llama-server" ]; then
    THIS_BUILD_DIR=$BUILD_DIR_LLAMA_SERVER
fi

if [ "$THIS_BUILD_DIR" != "" ] && [ -d "$THIS_BUILD_DIR" ]; then
    rm -r -f $THIS_BUILD_DIR
fi

echo "Cloning into: $THIS_BUILD_DIR/"
echo ""

################################################################################
# Clone the repos.
################################################################################

git clone https://github.com/ggml-org/llama.cpp $THIS_BUILD_DIR
cd $THIS_BUILD_DIR

################################################################################
# Rollback llama.cpp repo tp last tested working.
################################################################################

cd $THIS_BUILD_DIR
# Roll the llama.cpp repo back to last known working.
# Up through: https://github.com/ggml-org/llama.cpp/commit/a7a6d0d269c896218b6c78e0933bd6a17519d3f6
# a7a6d0d269c896218b6c78e0933bd6a17519d3f6

# Verified: 2026-08-01
git checkout a7a6d0d269c896218b6c78e0933bd6a17519d3f6 

# Verified: 2026-07-11
# Previous: e3546c7948e3af463d0b401e6421d5a4c2faf565

# To see where you're checked out:
# git log -1

cd $HOME

printf "\n$STARS\n*\n* FINISHED: $SCRIPT_NAME $1.\n*\n$STARS\n\n"

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
