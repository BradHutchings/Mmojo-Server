#!/bin/bash

################################################################################
# This script sets environment variables for building, testing, and packaging
# all of the things we build, test, and package in this repo. It is copied
# to your $HOME/scripts directory for convenient access.
#
# Run from the command-line like this so all the variables are exported to
# the shell environment:
#
#     . mm-environment-variables.sh
#
# See licensing note at end.
################################################################################

export STARS="********************************************************************************"
printf "\n$STARS\n*\n* STARTED: mm-environment-variables.sh.\n*\n$STARS\n\n"

cd $HOME

# Reset these compiler environment variables. Set in build step scripts as needed.
unset CC
unset CXX
unset AR

echo "Setting mm-scripts paths."
export HOME_SCRIPTS="$HOME/mm-scripts"
export TILDE_SCRIPTS="~/mm-scripts"

# Directory names
export CERTIFICATES_DIR_NAME="mm-certificates"
export MOOELS_DIR_NAME="mm-models"
export PACKAGES_DIR_NAME="mm-packages"

echo "Setting Mmojo-Server repo paths."
export MMOJO_SERVER_REPO_DIR="$HOME/mm-mmojo-server-repo"
export MMOJO_SERVER_REPO_FILES="$MMOJO_SERVER_REPO_DIR/files"
export MMOJO_SERVER_REPO_SCRIPTS="$MMOJO_SERVER_REPO_DIR/scripts"

echo "Setting Mmojo Share paths."
if [ "$(uname -s)" = "Darwin" ]; then
export MMOJO_SHARE_MOUNT_POINT="/Volumes/mmojo"
else
export MMOJO_SHARE_MOUNT_POINT="/mnt/mmojo"
fi

export MMOJO_SHARE_CERTIFICATES_DIR="$MMOJO_SHARE_MOUNT_POINT/$CERTIFICATES_DIR_NAME"
export MMOJO_SHARE_MODELS_DIR="$MMOJO_SHARE_MOUNT_POINT/$MOOELS_DIR_NAME"
export MMOJO_SHARE_PACKAGES_DIR="$MMOJO_SHARE_MOUNT_POINT/$PACKAGES_DIR_NAME"

export MMOJO_SHARE_BUILDS="$MMOJO_SHARE_MOUNT_POINT/builds"
export MMOJO_SHARE_BUILDS_APE="$MMOJO_SHARE_BUILDS/ape"
export MMOJO_SHARE_BUILDS_COMPATIBLE_APE="$MMOJO_SHARE_BUILDS/compatible-ape"
export MMOJO_SHARE_BUILDS_PERFORMANT_APE="$MMOJO_SHARE_BUILDS/performant-ape"
export MMOJO_SHARE_BUILDS_CPU_NATIVE="$MMOJO_SHARE_BUILDS/cpu-native"
export MMOJO_SHARE_BUILDS_CUDA="$MMOJO_SHARE_BUILDS/cuda"
export MMOJO_SHARE_BUILDS_VULKAN="$MMOJO_SHARE_BUILDS/vulkan"
export MMOJO_SHARE_PACKAGES_APE="$MMOJO_SHARE_PACKAGES_DIR/ape"
export MMOJO_SHARE_PACKAGES_COMPATIBLE_APE="$MMOJO_SHARE_PACKAGES_DIR/compatible-ape"
export MMOJO_SHARE_PACKAGES_PERFORMANT_APE="$MMOJO_SHARE_PACKAGES_DIR/performant-ape"
export MMOJO_SHARE_PACKAGES_ZIP="$MMOJO_SHARE_PACKAGES_DIR/zip"

export MMOJO_SHARE_MOUNT_SCRIPT="mm-share-mount.sh"

echo "Setting local models paths."
export MODELS_DIR="$HOME/$MOOELS_DIR_NAME"
export _MODEL_QUEUE="$MODELS_DIR/model-queue.txt"

echo "Setting Build paths."
export BUILD_DIR="$HOME/mm-build"
export BUILD_DIR_LLAMA_SERVER="$HOME/mm-build-llama-server"
export BUILD_DIR_COSMOPOLITAN="$HOME/mm-build-cosmopolitan"
export BUILD_DIR_OPENSSSL="$HOME/mm-build-openssl"
export BUILD_DIR_VULKAN_SDK="$HOME/mm-build-vulkan-sdk"

echo "Setting Build Pieces paths."
export CERTIFICATES_DIR="$HOME/mm-certificates"
export COSMOCC_DIR="$BUILD_DIR_COSMOPOLITAN/cosmocc"

export VULKAN_VERSION="1.4.328.1"
if [[ -z "${VULKAN_SIMULTANEOUS_COMPILES}" ]]; then
  export VULKAN_SIMULTANEOUS_COMPILES=4
fi
VULKAN_SETUP_ENV="$BUILD_DIR_VULKAN_SDK/$VULKAN_VERSION/setup-env.sh"
if [ -e "$VULKAN_SETUP_ENV" ]; then
  source $VULKAN_SETUP_ENV
fi

export COSMO_COMPATIBLE_X86_64="build-cosmo-compatible-x86_64"
export COSMO_COMPATIBLE_AARCH64="build-cosmo-compatible-aarch64"
export COSMO_COMPATIBLE_APE="build-cosmo-compatible-ape"
export COSMO_PERFORMANT_X86_64="build-cosmo-performant-x86_64"
export COSMO_PERFORMANT_AARCH64="build-cosmo-performant-aarch64"
export COSMO_PERFORMANT_APE="build-cosmo-performant-ape"

export EXECUTABLE_COMPATIBLE_X86_64="build-executable-compatible-x86_64"
export EXECUTABLE_COMPATIBLE_AARCH64="build-executable-compatible-aarch64"
export EXECUTABLE_PERFORMANT_X86_64="build-executable-performant-x86_64"
export EXECUTABLE_PERFORMANT_AARCH64="build-executable-performant-aarch64"
export EXECUTABLE_NATIVE_X86_64="build-executable-native-x86_64"
export EXECUTABLE_NATIVE_AARCH64="build-executable-native-aarch64"

export EXECUTABLE_RPI5_AARCH64="build-executable-rpi5-aarch64"

# Split out build commands so we can edit locally, build the delta.
export LAST_BUILD_COMMAND=".last-build-command.sh"
export LAST_BUILD_COMMAND_PATH="$HOME/$LAST_BUILD_COMMAND"

echo "Setting Test paths."
export TEST_WORKING_DIR="$HOME/500-TEST-working-directory"

# Reset this when we update environment variables.
unset TEST_MODEL
unset TEST_CPU_THREADS
unset TEST_WITH_CHAT_UI

echo "Setting packages paths."
export PACKAGES_DIR="$HOME/$PACKAGES_DIR_NAME"

# export PACKAGE_DIR="$HOME/600-PACKAGE-mmojo-server"

# REMOVE THESE IN FUTURE. -Brad 2026-03-05
# export PACKAGE_APE="ape"
# export PACKAGE_COMPATIBLE_APE="compatible-ape"
# export PACKAGE_PERFORMANT_APE="performant-ape"
# export PACKAGE_COMPATIBLE_NAKED_APE="compatible-naked-ape"
# export PACKAGE_PERFORMANT_NAKED_APE="performant-naked-ape"
# export PACKAGE_ZIP="zip"
# export PACKAGE_SEAS="seas"

export _PACKAGE_MMOJO_SERVER_FILE="mmojo-server"
export _PACKAGE_MMOJO_SERVER_APE_FILE="mmojo-server-ape"
export _PACKAGE_LLAMA_SERVER_FILE="llama-server"

export _PACKAGE_MMOJO_SERVER_APE_COMPATIBLE_FILE="mmojo-server-ape-compatible"
export _PACKAGE_MMOJO_SERVER_APE_PERFORMANT_FILE="mmojo-server-ape-performant"
export _PACKAGE_MMOJO_SERVER_ARGS_FILE="mmojo-server-args"
export _PACKAGE_MMOJO_SERVER_SUPPORT_DIR="mmojo-server-support"

export _PACKAGE_MMOJO_SERVER_EXE_FILE="mmojo-server.exe"
export _PACKAGE_MMOJO_SERVER_ZIP_FILE="mmojo-server.zip"

echo "Setting architectuire value for compilers."
export ARCH_X86_64_COMPATIBLE="x86-64"
export ARCH_X86_64_PERFORMANT="x86-64-v3"
export ARCH_X86_64_NATIVE="native"
# Raspberry Pi 5, Apple M1 (armv8.4-a), NVIDIA Jetson Orin Nano (armv8.2-a -- same features as armv8.1-a)
export ARCH_AARCH64_COMPATIBLE="armv8-a"
export ARCH_AARCH64_PERFORMANT="armv8.4-a"
export ARCH_AARCH64_NATIVE="native"

# Keep these around for if the mmap issue with Cosmo gets resolved and we can align .gguf in an APE.
# export BUILD_DIR_LLAMAFILE="$HOME/305-BUILD-llamafile"
# export ZIPALIGN="$BUILD_DIR_LLAMAFILE/bin/zipalign"
# export ZIPALIGN="$HOME/tools/mm-zipalign"

# Deploy directory for deployment only
export DEPLOY_DIR="$HOME/mm-deploy"

# Proxy directory for deployment only
export PROXY_DIR="$HOME/mm-proxy"

# Run this script when user starts a session.
SEARCH_STRING="\. mm-environment-variables.sh"
COMMAND_STRING=". mm-environment-variables.sh"
BASHRC_PATH="$HOME/.bashrc"
if ! grep -q "$SEARCH_STRING" "$BASHRC_PATH"; then
    echo $COMMAND_STRING >> $BASHRC_PATH
fi

if [ -z "$SAVE_PATH" ]; then
  export SAVE_PATH=$PATH
fi

printf "\n$STARS\n*\n* FINISHED: mm-environment-variables.sh.\n*\n$STARS\n\n"


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
