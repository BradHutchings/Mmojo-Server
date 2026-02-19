#!/bin/bash

################################################################################
# This script runs the debug build with command-line arguments.
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
printf "\n$STARS\n*\n* STARTED: $SCRIPT_NAME $1 $2 $3.\n*\n$STARS\n\n"

args=$1
chat_ui=$2
branding=$3

if [ "$args" != "command-line" ] && [ "$args" != "find-executable-dir" ] && \
    [ "$args" != "find-working-dir" ] && [ "$args" != "find-support-dir" ] &&  \
    [ "$args" != "args-file" ] && [ "$args" != "support-directory" ]; then
    args="command-line"
fi

if [ "$chat_ui" == "" ] || [ "$chat_ui" != "1" ]; then
    chat_ui="0"
fi

if [ "$branding" != "llama-server" ]; then
    branding=""
fi

THIS_BUILD_DIR=$BUILD_DIR
EXECUTABLE_FILE=$PACKAGE_MMOJO_SERVER_FILE
ARGS_FILE=$PACKAGE_MMOJO_SERVER_ARGS_FILE
SUPPORT_DIR=$PACKAGE_MMOJO_SERVER_SUPPORT_DIR
if [ "$branding" == "llama-server" ]; then
    chat_ui=1
    THIS_BUILD_DIR=$LLAMA_SERVER_BUILD_DIR
    EXECUTABLE_FILE=$PACKAGE_LLAMA_SERVER_FILE
    ARGS_FILE=$PACKAGE_LLAMA_SERVER_ARGS_FILE
    SUPPORT_DIR=$PACKAGE_LLAMA_SERVER_SUPPORT_DIR
fi

BUILD_SUBDIRECTORY=$BUILD_DEBUG

echo "             Args: $args"
echo "          Chat UI: $chat_ui"
echo "         Branding: $branding"
echo "  executable file: $EXECUTABLE_FILE"
echo "        args file: $ARGS_FILE"
echo "support directory: $SUPPORT_DIR"
echo "     subdirectory: $BUILD_SUBDIRECTORY"
echo "      building in: $THIS_BUILD_DIR/$BUILD_SUBDIRECTORY"
echo ""

if [ "$BUILD_SUBDIRECTORY" != "" ]; then
    MODEL_PARAM="Google-Gemma-1B-Instruct-v3-q8_0.gguf"
    if [[ -v CHOSEN_MODEL ]]; then
        echo "\$CHOSEN_MODEL: $CHOSEN_MODEL."
        if [ -f "$LOCAL_MODELS_DIR/$CHOSEN_MODEL" ]; then
            echo "Model found."
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
    if [ ! -z $chat_ui ] && [ $chat_ui != 0 ]; then 
        # echo "Using chat UI."
        UI_PARAMS=""
    fi
    # echo "\$UI_PARAMS: $UI_PARAMS"
    # sleep 5s

    rm -f $THIS_BUILD_DIR/$BUILD_SUBDIRECTORY/bin/$ARGS_FILE
    rm -r -f $THIS_BUILD_DIR/$BUILD_SUBDIRECTORY/bin/$SUPPORT_DIR
    rm -r -f $TEST_WORKING_DIR
    rm -f $THIS_BUILD_DIR/$BUILD_SUBDIRECTORY/bin/*.gguf

    cd $THIS_BUILD_DIR/$BUILD_SUBDIRECTORY/bin

    if [ "$args" == "command-line" ]; then
        # --mlock is not needed to run this.
        $THIS_BUILD_DIR/$BUILD_SUBDIRECTORY/bin/$EXECUTABLE_FILE --model $LOCAL_MODELS_DIR/$MODEL_PARAM \
            $UI_PARAMS $THREADS_PARAM --host 0.0.0.0 --port 8080 --batch-size 64 --threads-http 8 --ctx-size 32768 

        echo ""
        echo "Verify that $ARGS_FILE does not exist and $SUPPORT_DIR does not exist."
        ls -ald $ARGS_FILE
        ls -ald $SUPPORT_DIR

    elif [ "$args" == "find-executable-dir" ]; then
        cp $LOCAL_MODELS_DIR/$MODEL_PARAM $THIS_BUILD_DIR/$BUILD_SUBDIRECTORY/bin

        $THIS_BUILD_DIR/$BUILD_SUBDIRECTORY/bin/$EXECUTABLE_FILE \
            $UI_PARAMS $THREADS_PARAM --host 0.0.0.0 --port 8080 --batch-size 64 --threads-http 8 --ctx-size 32768 --no-mmap

        echo ""
        echo "Verify that $ARGS_FILE does not exist and $SUPPORT_DIR does not exist."
        ls -ald $ARGS_FILE
        ls -ald $SUPPORT_DIR

    elif [ "$args" == "find-working-dir" ]; then
        mkdir -p $TEST_WORKING_DIR
        cp $LOCAL_MODELS_DIR/$MODEL_PARAM $TEST_WORKING_DIR

        cd $TEST_WORKING_DIR
        $THIS_BUILD_DIR/$BUILD_SUBDIRECTORY/bin/$EXECUTABLE_FILE \
            $UI_PARAMS $THREADS_PARAM --host 0.0.0.0 --port 8080 --batch-size 64 --threads-http 8 --ctx-size 32768 --no-mmap

        echo ""
        echo "Verify that $ARGS_FILE does not exist and $SUPPORT_DIR does not exist."
        cd $THIS_BUILD_DIR/$BUILD_SUBDIRECTORY/bin
        ls -ald $ARGS_FILE
        ls -ald $SUPPORT_DIR

    elif [ "$args" == "find-support-dir" ]; then
        mkdir -p $THIS_BUILD_DIR/$BUILD_SUBDIRECTORY/bin/$SUPPORT_DIR
        cp $LOCAL_MODELS_DIR/$MODEL_PARAM $THIS_BUILD_DIR/$BUILD_SUBDIRECTORY/bin/$SUPPORT_DIR

        $THIS_BUILD_DIR/$BUILD_SUBDIRECTORY/bin/$EXECUTABLE_FILE \
            $UI_PARAMS $THREADS_PARAM --host 0.0.0.0 --port 8080 --batch-size 64 --threads-http 8 --ctx-size 32768 --no-mmap

        echo ""
        echo "Verify that $ARGS_FILE does not exist and $SUPPORT_DIR does not exist."
        ls -ald $ARGS_FILE
        ls -ald $SUPPORT_DIR
        
    elif [ "$args" == "args-file" ]; then
        # Write out $ARGS_FILE
cat << EOF > $THIS_BUILD_DIR/$BUILD_SUBDIRECTORY/bin/$ARGS_FILE
--model
$LOCAL_MODELS_DIR/$MODEL_PARAM
--host
0.0.0.0
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
$UI_PARAMS$THREADS_PARAM
...
EOF

        # --mlock is not needed to run this.
        $THIS_BUILD_DIR/$BUILD_SUBDIRECTORY/bin/$EXECUTABLE_FILE

        echo ""
        echo "Verify that $ARGS_FILE exists and $SUPPORT_DIR does not exist."
        ls -ald $ARGS_FILE
        ls -ald $SUPPORT_DIR

    elif [ "$args" == "support-directory" ]; then
        mkdir -p $THIS_BUILD_DIR/$BUILD_SUBDIRECTORY/bin/$SUPPORT_DIR
        cp $LOCAL_MODELS_DIR/$MODEL_PARAM $THIS_BUILD_DIR/$BUILD_SUBDIRECTORY/bin/$SUPPORT_DIR

        # Write out $ARGS_FILE
cat << EOF > $THIS_BUILD_DIR/$BUILD_SUBDIRECTORY/bin/$SUPPORT_DIR/$ARGS_FILE
--model
/support/$MODEL_PARAM
--host
0.0.0.0
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
$UI_PARAMS$THREADS_PARAM
...
EOF

        # --mlock is not needed to run this.
        $THIS_BUILD_DIR/$BUILD_SUBDIRECTORY/bin/$EXECUTABLE_FILE

        echo ""
        echo "Verify that $ARGS_FILE does not and $SUPPORT_DIR exists."
        ls -ald $ARGS_FILE
        ls -ald $SUPPORT_DIR
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
