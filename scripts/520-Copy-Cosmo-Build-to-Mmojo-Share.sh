#!/bin/bash

################################################################################
# This script builds the specified version of mmojo-server and other llama.cpp 
# targets.
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
printf "\n$STARS\n*\n* STARTED: $SCRIPT_NAME $1 $2 $3.\n*\n$STARS\n\n"

if [ ! -d $MMOJO_SHARE_MOUNT_POINT ]; then
    echo "You have not created your Mmojo Share mount point."
    exit 1
fi

cd $BUILD_DIR

processor=$1
variation=$2
branding=$3

if [ $processor == "arm64" ]; then
    processor="aarch64"
fi

if [ $processor != "x86_64" ] && [ $processor != "aarch64" ]; then
    processor="x86_64"
fi

if [ $variation != "compatible" ] && [ $variation != "performant" ]; then
    variation="compatible"
fi

if [ "$branding" != "llama-server" ]; then
    branding=""
fi

THIS_BUILD_DIR=$BUILD_DIR
EXECUTABLE_FILE=$PACKAGE_MMOJO_SERVER_FILE
if [ "$branding" == "llama-server" ]; then
    THIS_BUILD_DIR=$LLAMA_SERVER_BUILD_DIR
    EXECUTABLE_FILE=$PACKAGE_LLAMA_SERVER_FILE
fi

BUILD_SUBDIRECTORY=""
if [ $processor == "x86_64" ]; then
    BUILD_SUBDIRECTORY="$BUILD_COSMO_COMPATIBLE_X86_64"
    if [ $variation == "performant" ]; then
        BUILD_SUBDIRECTORY="$BUILD_COSMO_PERFORMANT_X86_64"
    fi
fi
if [ $processor == "aarch64" ]; then
    BUILD_SUBDIRECTORY="$BUILD_COSMO_COMPATIBLE_AARCH64"
    if [ $variation == "performant" ]; then
        BUILD_SUBDIRECTORY="$BUILD_COSMO_PERFORMANT_AARCH64"
    fi
fi

echo "         Processor: $processor"
echo "         Variation: $variation"
echo "          Branding: $branding"
echo "subdirectory: $BUILD_SUBDIRECTORY"
echo " building in: $THIS_BUILD_DIR/$BUILD_SUBDIRECTORY"
echo "  copying to: $MMOJO_SHARE_BUILDS/$BUILD_SUBDIRECTORY"

if [ -d "$THIS_BUILD_DIR" ] && [ "$BUILD_SUBDIRECTORY" != "" ]; then
    if [[ ! $(findmnt $MMOJO_SHARE_MOUNT_POINT) ]]; then
        mm-share-mount.sh
    fi
    
    if [[ $(findmnt $MMOJO_SHARE_MOUNT_POINT) ]]; then
        echo "Creating directories on Mmojo Share."
        sudo mkdir -p "$MMOJO_SHARE_BUILDS"
        sudo mkdir -p "$MMOJO_SHARE_BUILDS/$BUILD_SUBDIRECTORY"

        if [ -d "$MMOJO_SHARE_BUILDS/$BUILD_SUBDIRECTORY" ]; then
            echo "Copying mmojo-server-$processor to Mmojo Share."
            sudo cp -f $BUILD_DIR/$BUILD_SUBDIRECTORY/bin/mmojo-server $MMOJO_SHARE_BUILDS/$BUILD_SUBDIRECTORY
        fi
    fi
fi

cd $HOME

printf "\n$STARS\n*\n* FINISHED: $SCRIPT_NAME $1 $2 $3.\n*\n$STARS\n\n"

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
