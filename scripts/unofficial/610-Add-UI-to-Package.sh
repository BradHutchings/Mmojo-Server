#!/bin/bash

################################################################################
# This script adds the Mmojo Complete user interface from the Mmojo Server repo
# to the mmojo-server-support subdirectory of the package directory.
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
printf "\n$STARS\n*\n* STARTED: $SCRIPT_NAME.\n*\n$STARS\n\n"

if [ -v CHOSEN_BUILD ] && [ -v CHOSEN_BUILD_PATH ]; then
    THIS_PACKAGE_DIR="$PACKAGE_DIR/$PACKAGE_ZIP-$CHOSEN_BUILD_INFO"
    SUPPORT_DIR="$THIS_PACKAGE_DIR/$PACKAGE_MMOJO_SERVER_SUPPORT_DIR"

    if [ -d "$THIS_PACKAGE_DIR" ] && [ -d "$SUPPORT_DIR" ]; then
        WEBSITE="$SUPPORT_DIR/Mmojo-Complete"
        mkdir -p $WEBSITE
        cp -r $BUILD_DIR/Mmojo-Complete/* $WEBSITE

        CA_FILE="$SUPPORT_DIR/certs/selfsignCA.crt"
        if [ -f "$CA_FILE" ]; then
            cp $CA_FILE $WEBSITE/CA.crt
        fi

        echo ""
        echo "$SUPPORT_DIR:"
        ls -al "$SUPPORT_DIR"

        echo ""
        echo "$SUPPORT_DIR/Mmojo-Complete:"
        ls -al "$SUPPORT_DIR/Mmojo-Complete"
    fi
fi

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
