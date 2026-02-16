#!/bin/bash

################################################################################
# This script builds the specified version of mmojo-server and other llama.cpp 
# targets.
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
printf "\n$STARS\n*\n* STARTED: $SCRIPT_NAME $1 $2.\n*\n$STARS\n\n"

if [ ! -d $MMOJO_SHARE_MOUNT_POINT ]; then
    echo "You have not created your Mmojo Share mount point."
    exit 1
fi

cd $BUILD_DIR

variation=$1
branding=$2

if [ $variation != "compatible" ] && [ $variation != "performant" ]; then
    variation="compatible"
fi

if [ "$branding" != "doghouse" ] && [ "$branding" != "llama-server" ]; then
    branding=""
fi

THIS_BUILD_DIR=$BUILD_DIR
EXECUTABLE_FILE=$PACKAGE_MMOJO_SERVER_APE_FILE
if [ "$branding" == "doghouse" ]; then
    THIS_BUILD_DIR=$DOGHOUSE_BUILD_DIR
    EXECUTABLE_FILE=$PACKAGE_DOGHOUSE_APE_FILE
elif [ "$branding" == "llama-server" ]; then
    THIS_BUILD_DIR=$LLAMA_SERVER_BUILD_DIR
    EXECUTABLE_FILE=$PACKAGE_LLAMA_SERVER_APE_FILE
fi
EXE_FILE="$EXECUTABLE_FILE.exe"

BUILD_SUBDIRECTORY=""
    
BUILD_SUBDIRECTORY="$BUILD_COSMO_COMPATIBLE_APE"
if [ $variation == "performant" ]; then
    BUILD_SUBDIRECTORY="$BUILD_COSMO_PERFORMANT_APE"
fi

echo "      Variation: $variation"
echo "       Branding: $branding"
echo "   subdirectory: $BUILD_SUBDIRECTORY"
echo "    building in: $THIS_BUILD_DIR/$BUILD_SUBDIRECTORY"
echo "     copying to: $MMOJO_SHARE_BUILDS/$BUILD_SUBDIRECTORY"
echo "executable file: $EXECUTABLE_FILE"
echo "      .exe file: $EXE_FILE"
echo ""

if [ -d "$THIS_BUILD_DIR" ] && [ "$BUILD_SUBDIRECTORY" != "" ]; then
    if [[ ! $(findmnt $MMOJO_SHARE_MOUNT_POINT) ]]; then
        mm-share-mount.sh
    fi
    
    if [[ $(findmnt $MMOJO_SHARE_MOUNT_POINT) ]]; then
        echo "Creating directories on Mmojo Share."
        sudo mkdir -p $MMOJO_SHARE_BUILDS
        sudo mkdir -p "$MMOJO_SHARE_BUILDS/$BUILD_SUBDIRECTORY"

        if [ -d "$MMOJO_SHARE_BUILDS/$BUILD_SUBDIRECTORY" ]; then
            echo "Copying $EXECUTABLE_FILE to Mmojo Share."
            sudo cp -f $BUILD_DIR/$BUILD_SUBDIRECTORY/$EXECUTABLE_FILE $MMOJO_SHARE_BUILDS/$BUILD_SUBDIRECTORY
            sudo cp -f $BUILD_DIR/$BUILD_SUBDIRECTORY/$EXECUTABLE_FILE $MMOJO_SHARE_BUILDS/$BUILD_SUBDIRECTORY/$EXE_FILE
        fi
    fi
fi

cd $HOME

printf "\n$STARS\n*\n* FINISHED: $SCRIPT_NAME $1 $2.\n*\n$STARS\n\n"

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
