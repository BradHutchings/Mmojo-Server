#!/bin/bash

################################################################################
# This script clones these repos to set up a $BUILD_DIR:
# - llama.cpp
#   - https://github.com/ggml-org/llama.cpp
# - Google minja (for llama.cpp) - chat templates
#    - https://github.com/google/minja - 
#
# No longer need these -- see vendors subdirectory of llama.cpp.
# - cpp-httplib (for llama.cpp)- HTTPS/HTTPS server library.
#   - https://github.com/yhirose/cpp-httplib
# - miniaudio (for llama.cpp)
#   - https://github.com/mackron/miniaudio
# - stb (for llama.cpp)
#   - https://github.com/nothings/stb
# - json (for llama.cpp)
#   - https://github.com/nlohmann/json
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

branding=$1

if [ "$branding" != "doghouse" ] && [ "$branding" != "llama-server" ]; then
    branding=""
fi

THIS_BUILD_DIR=$BUILD_DIR
if [ "$branding" == "doghouse" ]; then
    THIS_BUILD_DIR=$DOGHOUSE_BUILD_DIR
elif [ "$branding" == "llama-server" ]; then
    THIS_BUILD_DIR=$LLAMA_SERVER_BUILD_DIR
fi

if [ -d "$THIS_BUILD_DIR" ]; then
    rm -r -f $THIS_BUILD_DIR
fi

echo "  Branding: $branding"
echo "cloning in: $THIS_BUILD_DIR/"
echo ""

################################################################################
# Clone the repos.
################################################################################

git clone https://github.com/ggml-org/llama.cpp $THIS_BUILD_DIR
cd $THIS_BUILD_DIR
git clone https://github.com/google/minja.git google-minja
# git clone https://github.com/yhirose/cpp-httplib.git cpp-httplib
# git clone https://github.com/mackron/miniaudio.git miniaudio
# git clone https://github.com/nothings/stb.git stb
# git clone https://github.com/nlohmann/json.git nlohmann-json
cp -r $BUILD_COSMOPOLITAN_DIR/cosmocc .
cp -r $BUILD_OPENSSSL_DIR/openssl .

################################################################################
# Rollback cpp-httplib repo. No need to do this anymore. -Brad 2025-01-11
################################################################################

# cpp-httplib has still not fixed whatever problem they introduced. -Brad 2025-12-16
# cd cpp-httplib
# git checkout 1d36013fc3aa14f39f5e8071be445e5a75fafff7 # worked!
# git checkout dbd5ca4bf2da438da1c6dcd0ba7c725f7f2cc7b7 $ failed

# git checkout 143019a38cb88661ce78ca3799dc1c0779c6c563 # Try this. -Brad 2026-01-10


################################################################################
# Rollback llama.cpp repo tp last tested working.
################################################################################

cd $THIS_BUILD_DIR
# Roll the llama.cpp repo back to last known working.
# Up through: https://github.com/ggml-org/llama.cpp/commit/785a71008573e2d84728fb0ba9e851d72d3f8fab
# 785a71008573e2d84728fb0ba9e851d72d3f8fab

# Verified: 2026-01-15
git checkout 785a71008573e2d84728fb0ba9e851d72d3f8fab 

# Verified: 2026-01-10
# Previous: b1377188784f9aea26b8abde56d4aee8c733eec7

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
