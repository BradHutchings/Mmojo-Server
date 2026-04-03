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
APP_SHORT_NAME='Mmojo Chat'
if [ "$1" == "llama-server" ]; then
    THIS_BUILD_DIR=$BUILD_DIR_LLAMA_SERVER
    APP_NAME="llama.cpp"
    APP_SHORT_NAME="llama.cpp"
fi

cd $THIS_BUILD_DIR

echo "Customizing chat user interface files."
if [ -f tools/server/webui/src/lib/components/app/chat/ChatScreen/ChatScreen.svelte ]; then
    # Sentences need punctuation!
    $MMOJO_SED -i -e "s/upload files to get started/upload files to get started./g" tools/server/webui/src/lib/components/app/chat/ChatScreen/ChatScreen.svelte
fi
if [ -f tools/server/webui/src/lib/components/app/chat/ChatForm/ChatFormHelperText.svelte ]; then
    # Sentences need punctuation!
    $MMOJO_SED -i -e "s/for new line/for new line./g" tools/server/webui/src/lib/components/app/chat/ChatForm/ChatFormHelperText.svelte
fi
if [ -f tools/server/webui/src/routes/+page.svelte ]; then
    $MMOJO_SED -i -e "s/>llama.cpp - AI Chat Interface<\/title>/>$APP_NAME<\/title>/g" tools/server/webui/src/routes/+page.svelte
fi
if [ -f tools/server/webui/src/routes/chat/[id]/+page.svelte ]; then
    $MMOJO_SED -i -e "s/ - llama.cpp<\/title>/ - $APP_SHORT_NAME<\/title>/g" tools/server/webui/src/routes/chat/[id]/+page.svelte
fi

if [ -f tools/server/webui/src/lib/components/app/chat/ChatScreen/ChatScreen.svelte ]; then
    $MMOJO_SED -i -e "s/>llama.cpp<\/h1>/>$APP_NAME<\/h1>/g" tools/server/webui/src/lib/components/app/chat/ChatScreen/ChatScreen.svelte
fi
if [ -f tools/server/webui/src/lib/components/app/chat/ChatSidebar/ChatSidebar.svelte ]; then
    $MMOJO_SED -i -e "s/>llama.cpp<\/h1>/>$APP_NAME<\/h1>/g" tools/server/webui/src/lib/components/app/chat/ChatSidebar/ChatSidebar.svelte
fi
if [ -f tools/server/public/bundle.js ]; then
    $MMOJO_SED -i -e "s/\.\/v1\//\/v1\//g" tools/server/public/bundle.js
fi
cp tools/server/public/loading-mmojo.html ./loading-mmojo.html

echo "Rebuilding chat user interface."
SAVE_WD=$(pwd)
cd tools/server/webui
npm i
npm run build
cd $SAVE_WD
mv loading-mmojo.html tools/server/public/loading-mmojo.html

# Somehow the Svelte recompile misses the "for new line". No idea why. -Brad 2026-03-15
if [ -f tools/server/webui/.svelte-kit/output/prerendered/pages/index.html ]; then
    $MMOJO_SED -i -e "s/for new line/for new line./g" tools/server/webui/.svelte-kit/output/prerendered/pages/index.html
fi

mm-prepare-mmojo-complete.sh

# if [ "$1" == "" ]; then
#    echo ""
#    echo "Customizing Mmojo Complete."
#    TODAY=$(date +%Y-%m-%d)
#    cp -r Mmojo-Complete Mmojo-Complete-original
#    sleep 5s
#    $MMOJO_SED -i -e "s/\[\[UPDATED\]\]/$TODAY/g" Mmojo-Complete/scripts.js
#    $MMOJO_SED -i -e "s/\[\[UPDATED\]\]/$TODAY/g" Mmojo-Complete/bookmark-scripts.js
# fi

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
