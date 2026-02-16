#!/bin/bash

################################################################################
# This script copies the CPU build of mmojo-server to the right place on the 
# Mmojo Share.
#
# TO-DO:
# - Use processor, variation, gpus, and branding to determine source and
#   destination.
# - Copy all executables, as advertised. Or have a parameter for that.
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
printf "\n$STARS\n*\n* STARTED: $SCRIPT_NAME $1 $2 $3.\n*\n$STARS\n\n"

if [ ! -d $MMOJO_SHARE_MOUNT_POINT ]; then
    echo "You have not created your Mmojo Share mount point."
    exit 1
fi

processor=$(uname -m)
variation=$1
gpus=$2
branding=$3

if [ "$processor" == "arm64" ]; then
    processor="aarch64"
fi

if [ "$processor" != "x86_64" ] && [ "$processor" != "aarch64" ]; then
    processor="x86_64"
fi

if [ "$variation" != "compatible" ] && [ "$variation" != "performant" ] && [ "$variation" != "native" ]; then
    variation="native"
fi

if [ "$branding" != "doghouse" ] && [ "$branding" != "llama-server" ]; then
    branding=""
fi

THIS_BUILD_DIR=$BUILD_DIR
EXECUTABLE_FILE=$PACKAGE_MMOJO_SERVER_FILE
if [ "$branding" == "doghouse" ]; then
    THIS_BUILD_DIR=$DOGHOUSE_BUILD_DIR
    EXECUTABLE_FILE=$PACKAGE_DOGHOUSE_FILE
elif [ "$branding" == "llama-server" ]; then
    THIS_BUILD_DIR=$LLAMA_SERVER_BUILD_DIR
    EXECUTABLE_FILE=$PACKAGE_LLAMA_SERVER_FILE
fi

BUILD_SUBDIRECTORY=""
VERBOSE="OFF"

if [ $processor == "x86_64" ]; then
    BUILD_SUBDIRECTORY="$BUILD_EXECUTABLE_COMPATIBLE_X86_64"
    if [ $variation == "performant" ]; then
        BUILD_SUBDIRECTORY="$BUILD_EXECUTABLE_PERFORMANT_X86_64"
    elif [ $variation == "native" ]; then
        BUILD_SUBDIRECTORY="$BUILD_EXECUTABLE_NATIVE_X86_64"
    fi
fi
if [ $processor == "aarch64" ]; then
    BUILD_SUBDIRECTORY="$BUILD_EXECUTABLE_COMPATIBLE_AARCH64"
    if [ $variation == "performant" ]; then
        BUILD_SUBDIRECTORY="$BUILD_EXECUTABLE_PERFORMANT_AARCH64"
    elif [ $variation == "native" ]; then
        BUILD_SUBDIRECTORY="$BUILD_EXECUTABLE_NATIVE_AARCH64"
    fi
fi

BUILD_SUBDIRECTORY+="$gpus"

echo "      Processor: $processor"
echo "      Variation: $variation"
echo "           GPUs: $gpus"
echo "       Branding: $branding"
echo "   subdirectory: $BUILD_SUBDIRECTORY"
echo "    building in: $THIS_BUILD_DIR/$BUILD_SUBDIRECTORY"
echo "     copying to: $MMOJO_SHARE_BUILDS/$BUILD_SUBDIRECTORY"
echo "executable file: $EXECUTABLE_FILE"
echo ""

if [ -d "$THIS_BUILD_DIR" ] && [ "$BUILD_SUBDIRECTORY" != "" ]; then
    if [[ ! $(findmnt $MMOJO_SHARE_MOUNT_POINT) ]]; then
        mm-share-mount.sh
    fi

    if [[ $(findmnt $MMOJO_SHARE_MOUNT_POINT) ]]; then
        echo "Creating directories on Mmojo Share."
        sudo mkdir -p "$MMOJO_SHARE_BUILDS"
        sudo mkdir -p "$MMOJO_SHARE_BUILDS/$BUILD_SUBDIRECTORY"

        # TO-DO: What CPU options/level?
        ARCH=$(uname -m)

        if [ -d "$MMOJO_SHARE_BUILDS/$BUILD_SUBDIRECTORY" ]; then
            echo "Copying mmojo-server-cpu-$ARCH to Mmojo Share."
            sudo cp -f $BUILD_DIR/$BUILD_SUBDIRECTORY/bin/$EXECUTABLE_FILE $MMOJO_SHARE_BUILDS/$BUILD_SUBDIRECTORY
        fi
    fi
fi

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
