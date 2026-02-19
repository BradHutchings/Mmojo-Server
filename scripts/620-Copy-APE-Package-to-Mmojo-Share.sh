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

variation=$1
attire=$2
branding=$3

if [ "$variation" != "compatible" ] && [ "$variation" != "performant" ]; then
    variation="compatible"
fi

if [ "$attire" != "attired" ] && [ "$attire" != "naked" ]; then
    attire="attired"
fi

if [ "$branding" != "llama-server" ]; then
    branding=""
fi

PACKAGE_SUBDIRECTORY="$PACKAGE_COMPATIBLE_APE"
if [ "$attire" == "naked" ]; then
    PACKAGE_SUBDIRECTORY="$PACKAGE_COMPATIBLE_NAKED_APE"
fi
if [ "$variation" == "performant" ]; then
    PACKAGE_SUBDIRECTORY="$PACKAGE_PERFORMANT_APE"
    if [ "$attire" == "naked" ]; then
        PACKAGE_SUBDIRECTORY="$PACKAGE_PERFORMANT_NAKED_APE"
    fi
fi

if [ "$attire" == "attired" ] && [ -v CHOSEN_MODEL_MNEMONIC ]; then
    PACKAGE_SUBDIRECTORY+="-$CHOSEN_MODEL_MNEMONIC"
fi

THIS_PACKAGE_DIR="$PACKAGE_DIR/$PACKAGE_SUBDIRECTORY"
EXECUTABLE_FILE=$PACKAGE_MMOJO_SERVER_APE_FILE
if [ "$branding" == "llama-server" ]; then
    THIS_PACKAGE_DIR="$LLAMA_SERVER_PACKAGE_DIR/$PACKAGE_SUBDIRECTORY"
    EXECUTABLE_FILE=$PACKAGE_LLAMA_SERVER_APE_FILE
fi
if [ "$variation" == "compatible" ]; then
    EXECUTABLE_FILE+="-comp"
elif [ "$variation" == "performant" ]; then
    EXECUTABLE_FILE+="-perf"
fi
EXE_FILE="$EXECUTABLE_FILE.exe"

echo "      Variation: $variation"
echo "         Attire: $attire"
echo "       Branding: $branding"
echo "   subdirectory: $PACKAGE_SUBDIRECTORY"
echo "   packaging in: $THIS_PACKAGE_DIR/$PACKAGE_SUBDIRECTORY"
echo "     copying to: $MMOJO_SHARE_PACKAGES/$PACKAGE_SUBDIRECTORY"
echo "executable file: $EXECUTABLE_FILE"
echo "      .exe file: $EXE_FILE"
echo ""

if [ -d "$THIS_PACKAGE_DIR" ] && [ "$PACKAGE_SUBDIRECTORY" != "" ]; then
    if [[ ! $(findmnt $MMOJO_SHARE_MOUNT_POINT) ]]; then
        mm-share-mount.sh
    fi
    
    if [[ $(findmnt $MMOJO_SHARE_MOUNT_POINT) ]]; then
        echo "Creating directories on Mmojo Share."
        sudo mkdir -p "$MMOJO_SHARE_PACKAGES"
        sudo mkdir -p "$MMOJO_SHARE_PACKAGES/$PACKAGE_SUBDIRECTORY"

        if [ -d "$MMOJO_SHARE_PACKAGES/$PACKAGE_SUBDIRECTORY" ]; then
            echo "Copying mmojo-server to Mmojo Share."
            # Should have been packaged with model name in it.
            sudo cp -f $THIS_PACKAGE_DIR/$EXECUTABLE_FILE $MMOJO_SHARE_PACKAGES/$PACKAGE_SUBDIRECTORY
            sudo cp -f $THIS_PACKAGE_DIR/$EXECUTABLE_FILE $MMOJO_SHARE_PACKAGES/$PACKAGE_SUBDIRECTORY/$EXE_FILE
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
