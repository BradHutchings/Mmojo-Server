#!/bin/bash

################################################################################
# This script rebuilds the chat web UI so that it can be customized and used 
# with Mmojo Server.
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
printf "\n$STARS\n*\n* STARTED: $SCRIPT_NAME.\n*\n$STARS\n\n"

cd $HOME

THIS_BUILD_DIR=$BUILD_DIR
APP_NAME='Mmojo Chat is Private.'
if [ "$1" == "llama-server" ]; then
    THIS_BUILD_DIR=$BUILD_LLAMA_SERVER_DIR
    APP_NAME="llama.cpp"
fi

cd $THIS_BUILD_DIR

if [ -f tools/server/webui/src/routes/+page.svelte ]; then
    sed -i -e "s/>llama.cpp - AI Chat Interface<\/title>/>$APP_NAME<\/title>/g" tools/server/webui/src/routes/+page.svelte
fi
if [ -f tools/server/webui/src/lib/components/app/chat/ChatScreen/ChatScreen.svelte ]; then
    sed -i -e "s/>llama.cpp<\/h1>/>$APP_NAME<\/h1>/g" tools/server/webui/src/lib/components/app/chat/ChatScreen/ChatScreen.svelte
fi
if [ -f tools/server/webui/src/lib/components/app/chat/ChatSidebar/ChatSidebar.svelte ]; then
    sed -i -e "s/>llama.cpp<\/h1>/>$APP_NAME<\/h1>/g" tools/server/webui/src/lib/components/app/chat/ChatSidebar/ChatSidebar.svelte
fi
cp tools/server/public/loading-mmojo.html ./loading-mmojo.html
SAVE_WD=$(pwd)
cd tools/server/webui
npm i
npm run build
cd $SAVE_WD
mv loading-mmojo.html tools/server/public/loading-mmojo.html

TODAY=$(date +%Y-%m-%d)
cp -r Mmojo-Complete Mmojo-Complete-original
sed -i -e "s/\[\[UPDATED\]\]/$TODAY/g" Mmojo-Complete/scripts.js
sed -i -e "s/\[\[UPDATED\]\]/$TODAY/g" Mmojo-Complete/bookmark-scripts.js

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
