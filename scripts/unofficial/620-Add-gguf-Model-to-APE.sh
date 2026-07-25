#!/bin/bash

################################################################################
# This script builds the specified version of mmojo-server and other llama.cpp 
# targets.
#
# See licensing note at end.
################################################################################
SCRIPT_NAME=$(basename -- "$0")
printf "\n$STARS\n*\n* STARTED: $SCRIPT_NAME $1 $2 $3.\n*\n$STARS\n\n"

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
ZIP_FILE="$PACKAGE_MMOJO_SERVER_ZIP_FILE"
if [ "$branding" == "llama-server" ]; then
    THIS_PACKAGE_DIR="$LLAMA_SERVER_PACKAGE_DIR/$PACKAGE_SUBDIRECTORY"
    ZIP_FILE=$PACKAGE_LLAMA_SERVER_ZIP_FILE
fi

echo "             Variation: $variation"
echo "                Attire: $attire"
echo "              Branding: $branding"
echo "              Zip File: $ZIP_FILE"
echo "  Package Subdirectory: $PACKAGE_SUBDIRECTORY"
echo "This Package Directory: $THIS_PACKAGE_DIR"

if [ -d "$THIS_PACKAGE_DIR" ] && [ "$attire" == "attired" ]; then
    THIS_ZIP_FILE="$THIS_PACKAGE_DIR/$ZIP_FILE"

    if [ -v CHOSEN_MODEL ]; then
        echo "Chosen model: $CHOSEN_MODEL"
        MODEL_FILE="$LOCAL_MODELS_DIR/$CHOSEN_MODEL"
        if [ -f "$MODEL_FILE" ]; then
            cd $LOCAL_MODELS_DIR

            # mmap() in cosmo libc appears to have a problem with how llama.cpp is calling it.
            # Punting on memort mapping for now.
            echo ""
            echo "Adding $MODEL_FILE to $ZIP_FILE."
            zip -0 -r -q $THIS_ZIP_FILE $CHOSEN_MODEL

            # Aligning the model to 65536 isn't allowing Cosmo libc mmap() to work as llama.cpp
            # wants it to. Try to fix this another day.
            # echo "mm-zipalign-ing $MODEL_FILE."
            # $ZIPALIGN -a 4096 $ZIP_FILE $CHOSEN_MODEL
            # $ZIPALIGN -a 65536 $ZIP_FILE $CHOSEN_MODEL
        fi
    fi

    echo ""
    echo "Contents of $THIS_ZIP_FILE:"
    unzip -l $THIS_ZIP_FILE 
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
#  brad@Mmojo.net
################################################################################
