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

echo "- Fixing page title on front page."
file="tools/ui/src/routes/(chat)/+page.svelte"
if [ -f "$file" ]; then
    $MMOJO_SED -i -e "s/>{APP_NAME}<\/title>/>$APP_SHORT_NAME<\/title>/g" "$file"
else
    echo "  - FILE NOT FOUND: $file"
fi

echo "- Fixing page title on chat page."
file="tools/ui/src/routes/(chat)/chat/[id]/+page.svelte"
if [ -f "$file" ]; then
    $MMOJO_SED -i -e "s/{APP_NAME}/$APP_SHORT_NAME/g" "$file"
else
    echo "  - FILE NOT FOUND: $file"
fi

echo "- Fixing welcome message and instructions of front page."
file="tools/ui/src/lib/components/app/chat/ChatScreen/ChatScreenGreeting.svelte"
if [ -f "$file" ]; then
    $MMOJO_SED -i -e "s/Hello there/$APP_NAME/g" "$file"
    $MMOJO_SED -i -e "s/files to get started/files to get started./g" "$file"
else
    echo "  - FILE NOT FOUND: $file"
fi

echo "- Fixing header on sidebar."
file="tools/ui/src/lib/components/app/navigation/SidebarNavigation/SidebarNavigation.svelte"
if [ -f "$file" ]; then
    $MMOJO_SED -i -e "s/{APP_NAME}/$APP_NAME/g" "$file"
else
    echo "  - FILE NOT FOUND: $file"
fi

echo "Rebuilding chat user interface."
SAVE_WD=$(pwd)
cd tools/ui
npm i
npm run build
cd $SAVE_WD

echo "Replacing loading.html with loading-mmojo.html."
mv "tools/ui/dist/loading.html" "tools/ui/dist/loading-orig.html"
cp "tools/ui/dist/loading-mmojo.html" "tools/ui/dist/loading.html"

echo "- Fixing bundle.js after recompile."
file="tools/ui/dist/bundle.js"
if [ -f "$file" ]; then
    $MMOJO_SED -i -e "s/\.\/v1\//\/v1\//g" "$file"
else
    echo "  - FILE NOT FOUND: $file"
fi

mm-prepare-mmojo-complete.sh

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
