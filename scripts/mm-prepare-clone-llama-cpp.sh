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
# git clone https://github.com/google/minja.git google-minja
cp -r $BUILD_DIR_COSMOPOLITAN/cosmocc .
cp -r $BUILD_DIR_OPENSSSL/openssl .

################################################################################
# Rollback llama.cpp repo tp last tested working.
################################################################################

cd $THIS_BUILD_DIR
# Roll the llama.cpp repo back to last known working.
# Up through: https://github.com/ggml-org/llama.cpp/commit/23fbfcb1ad6c6f76b230e8895254de785000be46
# 23fbfcb1ad6c6f76b230e8895254de785000be46

# Verified: 2026-03-09
git checkout 23fbfcb1ad6c6f76b230e8895254de785000be46 

# Verified: 2026-02-28
# Previous: 66d65ec29ba7c440cbc31b6f63b74a17b536ba65

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
#  brad@bradhutchings.com
################################################################################
