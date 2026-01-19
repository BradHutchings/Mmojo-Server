#!/bin/bash

################################################################################
# This script zips up the package directory.
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
printf "\n$STARS\n*\n* STARTED: $SCRIPT_NAME.\n*\n$STARS\n\n"

if [ -v CHOSEN_BUILD ] && [ -v CHOSEN_BUILD_PATH ]; then
    THIS_PACKAGE_DIR="$PACKAGE_DIR/$PACKAGE_ZIP-$CHOSEN_BUILD_INFO"
    ZIP_FILE_NAME="mmojo-server-$CHOSEN_BUILD_INFO.zip"

    if [ -d "$THIS_PACKAGE_DIR" ]; then
        cd $THIS_PACKAGE_DIR
        zip -r -9 $ZIP_FILE_NAME *
        mv $ZIP_FILE_NAME $PACKAGE_DIR

        echo ""
        echo "Listing packaging directory: $PACKAGE_DIR"
        ls -al $PACKAGE_DIR
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
