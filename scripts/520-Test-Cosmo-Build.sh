#!/bin/bash

################################################################################
# This script tests the specified Cosmo build of mmojo-server.
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
printf "\n$STARS\n*\n* STARTED: $SCRIPT_NAME $1 $2 $3 $4.\n*\n$STARS\n\n"

processor=$1
variation=$2
chat_ui=$3
branding=$4

if [ "$processor" == "arm64" ]; then
    processor="aarch64"
fi

if [ "$processor" != "x86_64" ] && [ "$processor" != "aarch64" ]; then
    echo "Resetting processor."
    processor="x86_64"
fi

if [ "$variation" != "compatible" ] && [ "$variation" != "performant" ]; then
    echo "Resetting variation."
    variation="compatible"
fi

if [ "$chat_ui" == "" ] || [ "$chat_ui" != "1" ]; then
    echo "Resetting chat_ui."
    chat_ui="0"
fi

if [ "$branding" != "llama-server" ]; then
    echo "Resetting branding."
    branding=""
fi

THIS_BUILD_DIR=$BUILD_DIR
EXECUTABLE_FILE=$PACKAGE_MMOJO_SERVER_FILE
ARGS_FILE=$PACKAGE_MMOJO_SERVER_ARGS_FILE
SUPPORT_DIR=$PACKAGE_MMOJO_SERVER_SUPPORT_DIR
if [ "$branding" == "llama-server" ]; then
    THIS_BUILD_DIR=$LLAMA_SERVER_BUILD_DIR
    EXECUTABLE_FILE=$PACKAGE_LLAMA_SERVER_FILE
    ARGS_FILE=$PACKAGE_LLAMA_SERVER_ARGS_FILE
    SUPPORT_DIR=$PACKAGE_LLAMA_SERVER_SUPPORT_DIR
fi

BUILD_SUBDIRECTORY=""
if [ "$processor" == "x86_64" ]; then
    BUILD_SUBDIRECTORY="$BUILD_COSMO_COMPATIBLE_X86_64"
    if [ "$variation" == "performant" ]; then
        BUILD_SUBDIRECTORY="$BUILD_COSMO_PERFORMANT_X86_64"
    fi
fi
if [ "$processor" == "aarch64" ]; then
    BUILD_SUBDIRECTORY="$BUILD_COSMO_COMPATIBLE_AARCH64"
    if [ "$variation" == "performant" ]; then
        BUILD_SUBDIRECTORY="$BUILD_COSMO_PERFORMANT_AARCH64"
    fi
fi

echo "        Processor: $processor"
echo "        Variation: $variation"
echo "          Chat UI: $chat_ui"
echo "         Branding: $branding"
echo "     subdirectory: $BUILD_SUBDIRECTORY"
echo "       testing in: $THIS_BUILD_DIR/$BUILD_SUBDIRECTORY"
echo "  executable file: $EXECUTABLE_FILE"
echo "        args file: $ARGS_FILE"
echo "support directory: $SUPPORT_DIR"
echo ""

if [ -d $THIS_BUILD_DIR/$BUILD_SUBDIRECTORY ]; then
    cd $THIS_BUILD_DIR/$BUILD_SUBDIRECTORY

    MODEL_PARAM="Google-Gemma-1B-Instruct-v3-q8_0.gguf"
    if [[ -v CHOSEN_MODEL ]]; then
        echo "       Model: $CHOSEN_MODEL."
        if [ -f "$LOCAL_MODELS_DIR/$CHOSEN_MODEL" ]; then
            echo "              Model found."
            MODEL_PARAM=$CHOSEN_MODEL
        fi
    fi    
    # echo "\$MODEL_PARAM: $MODEL_PARAM"
    # sleep 5s
    
    THREADS_PARAM=""
    if [[ -v TEST_CPU_THREADS ]]; then
        THREADS_PARAM=" --threads $TEST_CPU_THREADS "
    fi
    # echo "\$THREADS_PARAM: $THREADS_PARAM"
    # sleep 5s

    UI_PARAMS=" --path $BUILD_DIR/Mmojo-Complete/ --default-ui-endpoint /chat "
    if [ "$chat_ui" != "0" ]; then 
        # echo "Using chat UI."
        UI_PARAMS=""
    fi
    # echo "\$UI_PARAMS: $UI_PARAMS"
    # sleep 5s

    rm -f $ARGS_FILE
    rm -r -f $SUPPORT_DIR

    # --mlock is not needed to run this.
    EXECUTABLE_PATH="$THIS_BUILD_DIR/$BUILD_SUBDIRECTORY/bin/$EXECUTABLE_FILE"
    echo ""
    echo "Launching $EXECUTABLE_PATH."
    echo ""
    $EXECUTABLE_PATH --model $LOCAL_MODELS_DIR/$MODEL_PARAM $UI_PARAMS $THREADS_PARAM \
        --host 0.0.0.0 --port 8080 --batch-size 64 --threads-http 8 --ctx-size 32768

    echo ""
    echo "Verify that args file and support folder do not exist."
    ls -ald $ARGS_FILE
    ls -ald $SUPPORT_DIR
fi

cd $HOME

printf "\n$STARS\n*\n* FINISHED: $SCRIPT_NAME $1 $2 $3 $4.\n*\n$STARS\n\n"

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
