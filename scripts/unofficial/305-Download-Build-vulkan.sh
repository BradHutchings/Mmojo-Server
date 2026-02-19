#!/bin/bash

################################################################################
# This script downloads and builds a recent Vulkan source tarball. We hope to
# use it to provide "good enough" GPU acceleration of GGML on machines that
# have the Vulkan shared libraries installed.
#
# This script is expected to take an hour or several hours to run!
#
# https://vulkan.lunarg.com/sdk/home
#
# See licensing note for this script at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
printf "\n$STARS\n*\n* STARTED: $SCRIPT_NAME.\n*\n$STARS\n\n"

mkdir $BUILD_VULKAN_SDK_DIR
cd $BUILD_VULKAN_SDK_DIR
wget https://sdk.lunarg.com/sdk/download/$VULKAN_VERSION/linux/vulkansdk-linux-x86_64-$VULKAN_VERSION.tar.xz
tar xf vulkansdk-linux-x86_64-$VULKAN_VERSION.tar.xz
cd $VULKAN_VERSION/
source setup-env.sh 
sed -i -e 's/apt-get update/apt-get update || true/g' vulkansdk

# TO-DO: add =y to apt-get upgrade in vulkansdk

SIMULTANEOUS_COMPILES=$VULKAN_SIMULTANEOUS_COMPILES
if [[ -z "${SIMULTANEOUS_COMPILES}" ]]; then
  SIMULTANEOUS_COMPILES=4
fi
./vulkansdk -j $SIMULTANEOUS_COMPILES

# TO-DO: Show off what we built. What did we build?!? Where is it?

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
