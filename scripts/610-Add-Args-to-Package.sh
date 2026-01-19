#!/bin/bash

################################################################################
# This script adds a default_args file to the mmojo-server-support subdirectory 
# of the package directory.
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
printf "\n$STARS\n*\n* STARTED: $SCRIPT_NAME.\n*\n$STARS\n\n"

if [ -v CHOSEN_BUILD ] && [ -v CHOSEN_BUILD_PATH ]; then
    THIS_PACKAGE_DIR="$PACKAGE_DIR/$PACKAGE_ZIP-$CHOSEN_BUILD_INFO"
    SUPPORT_DIR="$THIS_PACKAGE_DIR/$PACKAGE_MMOJO_SERVER_SUPPORT_DIR"

    cd "$SUPPORT_DIR"

cat << EOF > $PACKAGE_MMOJO_SERVER_ARGS_FILE
--no-mmap
--host
127.0.0.1
--port
8080
--ctx-size
0
--threads-http
8
--batch-size
64
--batch-sleep-ms
0
EOF

if [ $ADDED_CERTS ]; then
cat << EOF >> $PACKAGE_MMOJO_SERVER_ARGS_FILE
--ssl-key-file
/support/certs/mmojo.local.key
--ssl-cert-file
/support/certs/mmojo.local.crt
EOF
fi

if [ $ADDED_MMOJO_COMPLETE ]; then
cat << EOF >> $PACKAGE_MMOJO_SERVER_ARGS_FILE
--path
/support/Mmojo-Complete
--default-ui-endpoint
chat
EOF
fi

if [ $ADDED_MODEL ] && [ -v CHOSEN_MODEL ]; then
cat << EOF >> $PACKAGE_MMOJO_SERVER_ARGS_FILE
--model
/support/$CHOSEN_MODEL
EOF
fi

cat << EOF >> $PACKAGE_MMOJO_SERVER_ARGS_FILE
...
EOF

    # idented from "if" at top.
    echo "$PACKAGE_MMOJO_SERVER_ARGS_FILE:"
    cat $PACKAGE_MMOJO_SERVER_ARGS_FILE

    echo ""
    echo "$SUPPORT_DIR:"
    ls -al "$SUPPORT_DIR"
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
