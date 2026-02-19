#!/bin/bash

################################################################################
# This script builds llama.cpp with Mmojo Server extensions for the CPU of the
# build environment machine. This is a debug build with no CPU optimizations.
# Thank you to Georgi Gerganov and his team for llama.cpp!
#
# https://github.com/ggml-org/llama.cpp
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
printf "\n$STARS\n*\n* STARTED: $SCRIPT_NAME $1.\n*\n$STARS\n\n"

branding=$1

if [ "$branding" != "llama-server" ]; then
    branding=""
fi

THIS_BUILD_DIR=$BUILD_DIR
if [ "$branding" == "llama-server" ]; then
    THIS_BUILD_DIR=$LLAMA_SERVER_BUILD_DIR
fi

BUILD_SUBDIRECTORY=$BUILD_DEBUG
VERBOSE="OFF"

echo "    Branding: $branding"
echo "subdirectory: $BUILD_SUBDIRECTORY"
echo " building in: $THIS_BUILD_DIR/$BUILD_SUBDIRECTORY"
echo ""

if [ "$BUILD_SUBDIRECTORY" != "" ]; then
    cd $THIS_BUILD_DIR

    rm -r -f $THIS_BUILD_DIR/$BUILD_SUBDIRECTORY
    cmake -B $BUILD_SUBDIRECTORY -DBUILD_SHARED_LIBS=OFF -DLLAMA_CURL=OFF -DLLAMA_OPENSSL=ON \
        -DCMAKE_BUILD_TYPE=Debug -DCMAKE_VERBOSE_MAKEFILE=$VERBOSE 
    cmake --build $BUILD_SUBDIRECTORY

    echo ""
    echo "Build of debug version of llama.cpp is complete."
    
    # Show off what we built
    echo ""
    echo "\$ ls -al $THIS_BUILD_DIR/$BUILD_SUBDIRECTORY/bin/"
    ls -al $THIS_BUILD_DIR/$BUILD_SUBDIRECTORY/bin
    echo ""
fi

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
