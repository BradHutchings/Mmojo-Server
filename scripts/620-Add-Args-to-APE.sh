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
APP_FILE="$PACKAGE_MMOJO_SERVER_APE_FILE"
ARGS_FILE="$PACKAGE_MMOJO_SERVER_ARGS_FILE"
if [ "$branding" == "llama-server" ]; then
    THIS_PACKAGE_DIR="$LLAMA_SERVER_PACKAGE_DIR/$PACKAGE_SUBDIRECTORY"
    ZIP_FILE="$PACKAGE_LLAMA_SERVER_ZIP_FILE"
    APP_FILE="$PACKAGE_LLAMA_SERVER_APE_FILE"
    ARGS_FILE="$PACKAGE_LLAMA_SERVER_ARGS_FILE"
fi

if [ "$variation" == "compatible" ]; then
    APP_FILE+="-comp"
elif [ "$variation" == "performant" ]; then
    APP_FILE+="-perf"
fi

echo "             Variation: $variation"
echo "                Attire: $attire"
echo "              Branding: $branding"
echo "              Zip File: $ZIP_FILE"
echo "              App File: $APP_FILE"
echo "  Package Subdirectory: $PACKAGE_SUBDIRECTORY"
echo "This Package Directory: $THIS_PACKAGE_DIR"

if [ -d "$THIS_PACKAGE_DIR" ]; then
    THIS_ZIP_FILE="$THIS_PACKAGE_DIR/$ZIP_FILE"

    cd "$THIS_PACKAGE_DIR"
cat << EOF > $ARGS_FILE
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
EOF

    if [ "$branding" == "" ]; then
cat << EOF >> $ARGS_FILE
--batch-sleep-ms
0
EOF
    fi

    if [ $ADDED_CERTS ]; then
cat << EOF >> $ARGS_FILE
--ssl-key-file
/zip/certs/cert.key
--ssl-cert-file
/zip/certs/cert.crt
EOF
    fi

    if [ $ADDED_MMOJO_COMPLETE ]; then
cat << EOF >> $ARGS_FILE
--path
/zip/Mmojo-Complete
--default-ui-endpoint
chat
EOF
    fi

    # Memory mapping through Coscmo libc does not work. If we add a model, make sure we don't use mmap.
    # We need an enable mmap paramter to override this.

    if [ $ADDED_MODEL ] && [ -v CHOSEN_MODEL ] && [ "$attire" == "attired" ]; then
cat << EOF >> $ARGS_FILE
--no-mmap
--model
/zip/$CHOSEN_MODEL
EOF
    fi

cat << EOF >> $ARGS_FILE
...
EOF

    echo ""
    echo "$ARGS_FILE:"
    cat $ARGS_FILE

    echo ""
    echo "Adding $ARGS_FILE file to $THIS_ZIP_FILE."
    zip -0 -r $THIS_ZIP_FILE $ARGS_FILE

    echo ""
    echo "Contents of $THIS_ZIP_FILE:"
    unzip -l $THIS_ZIP_FILE 

    echo ""
    echo "Cleaning up."
    mv $THIS_ZIP_FILE $APP_FILE
    rm -r -f Mmojo-Complete certs $ARGS_FILE

    echo ""
    echo "Listing packaging directory: $THIS_PACKAGE_DIR"
    ls -al $THIS_PACKAGE_DIR
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
