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

file="tools/ui/src/lib/components/app/chat/ChatScreen/ChatScreen.svelte"
if [ -f "$file" ]; then
    # Sentences need punctuation!
    $MMOJO_SED -i -e "s/upload files to get started/upload files to get started./g" "$file"
else
    echo "FILE NOT FOUND: $file"
fi

file="tools/ui/src/lib/components/app/chat/ChatForm/ChatFormHelperText.svelte"
if [ -f "$file" ]; then
    # Sentences need punctuation!
    $MMOJO_SED -i -e "s/for new line/for new line./g" "$file"
else
    echo "FILE NOT FOUND: $file"
fi

file="tools/ui/src/routes/\(chat\)/+page.svelte"
if [ -f "$file" ]; then
    $MMOJO_SED -i -e "s/>{APP_NAME}<\/title>/>$APP_SHORT_NAME<\/title>/g" "$file"
else
    echo "FILE NOT FOUND: $file"
fi

file="tools/ui/src/routes/\(chat\)/chat/[id]/+page.svelte"
if [ -f "$file" ]; then
    $MMOJO_SED -i -e "s/ - llama.cpp<\/title>/ - $APP_SHORT_NAME<\/title>/g" "$file"
else
    echo "FILE NOT FOUND: $file"
fi

file="tools/ui/src/lib/components/app/chat/ChatScreen/ChatScreen.svelte"
if [ -f "$file" ]; then
    $MMOJO_SED -i -e "s/>Hello there<\/h1>/>$APP_NAME<\/h1>/g" "$file"
else
    echo "FILE NOT FOUND: $file"
fi

file="tools/ui/src/lib/components/app/chat/ChatSidebar/ChatSidebar.svelte"
if [ -f "$file" ]; then
    $MMOJO_SED -i -e "s/{APP_NAME}<\/h1>/$APP_SHORT_NAME<\/h1>/g" "$file"
else
    echo "FILE NOT FOUND: $file"
fi

echo "NEED TO SORT OUT WHAT TO DO WITH loading-mmojo.html."
cp tools/server/public/loading-mmojo.html ./loading-mmojo.html

echo "Rebuilding chat user interface."
SAVE_WD=$(pwd)
cd tools/ui
npm i
npm run build
cd $SAVE_WD
mv loading-mmojo.html tools/server/public/loading-mmojo.html

# Somehow the Svelte recompile misses the "for new line". No idea why. -Brad 2026-03-15
file="tools/server/webui/.svelte-kit/output/prerendered/pages/index.html"
if [ -f "$file" ]; then
    $MMOJO_SED -i -e "s/for new line/for new line./g" "$file"
else
    echo "FILE NOT FOUND: $file"
fi

# Recompile overwrites bundle.js
if [ -f tools/server/public/bundle.js ]; then
    $MMOJO_SED -i -e "s/\.\/v1\//\/v1\//g" tools/server/public/bundle.js
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
