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

echo "Setting mmojo-server paths."
export MMOJO_SERVER_DIR="$HOME/200-mmojo-server"
export MMOJO_SERVER_FILES="$MMOJO_SERVER_DIR/files"
export MMOJO_SERVER_SCRIPTS="$MMOJO_SERVER_DIR/scripts"

echo "Setting Mmojo Share paths."
if [ "$(uname -s)" = "Darwin" ]; then
export MMOJO_SHARE_MOUNT_POINT="/Volumes/mmojo"
else
export MMOJO_SHARE_MOUNT_POINT="/mnt/mmojo"
fi
export MMOJO_SHARE_CERTIFICATES="$MMOJO_SHARE_MOUNT_POINT/certificates"
export MMOJO_SHARE_BUILDS="$MMOJO_SHARE_MOUNT_POINT/builds"
export MMOJO_SHARE_BUILDS_APE="$MMOJO_SHARE_BUILDS/ape"
export MMOJO_SHARE_BUILDS_COMPATIBLE_APE="$MMOJO_SHARE_BUILDS/compatible-ape"
export MMOJO_SHARE_BUILDS_PERFORMANT_APE="$MMOJO_SHARE_BUILDS/performant-ape"
export MMOJO_SHARE_BUILDS_CPU_NATIVE="$MMOJO_SHARE_BUILDS/cpu-native"
export MMOJO_SHARE_BUILDS_CUDA="$MMOJO_SHARE_BUILDS/cuda"
export MMOJO_SHARE_BUILDS_VULKAN="$MMOJO_SHARE_BUILDS/vulkan"
export MMOJO_SHARE_PACKAGES="$MMOJO_SHARE_MOUNT_POINT/packages"
export MMOJO_SHARE_PACKAGES_APE="$MMOJO_SHARE_PACKAGES/ape"
export MMOJO_SHARE_PACKAGES_COMPATIBLE_APE="$MMOJO_SHARE_PACKAGES/compatible-ape"
export MMOJO_SHARE_PACKAGES_PERFORMANT_APE="$MMOJO_SHARE_PACKAGES/performant-ape"
export MMOJO_SHARE_PACKAGES_ZIP="$MMOJO_SHARE_PACKAGES/zip"

export MOUNT_MMOJO_SHARE_SCRIPT="mm-mount-mmojo-share.sh"

# Prefix is 300- so we can wipe them out quickly, and changing script numbers doesn't mess stuff up.
echo "Setting Build Pieces paths."
export CERTIFICATES_DIR="$HOME/300-CERTIFICATES"
export BUILD_COSMOPOLITAN_DIR="$HOME/300-BUILD-cosmopolitan"
export COSMOCC_DIR="$BUILD_COSMOPOLITAN_DIR/cosmocc"
export BUILD_OPENSSSL_DIR="$HOME/300-BUILD-openssl"
export INSTALL_CUDA_TOOLKIT_DIR="$HOME/300-INSTALL-cuda-toolkit"
export BUILD_VULKAN_SDK_DIR="$HOME/300-BUILD-vulkan-sdk"
export VULKAN_VERSION="1.4.328.1"
if [[ -z "${VULKAN_SIMULTANEOUS_COMPILES}" ]]; then
  export VULKAN_SIMULTANEOUS_COMPILES=4
fi

VULKAN_SETUP_ENV="$BUILD_VULKAN_SDK_DIR/$VULKAN_VERSION/setup-env.sh"
if [ -e "$VULKAN_SETUP_ENV" ]; then
  source $VULKAN_SETUP_ENV
fi

echo "Setting Local and Share Models paths."
export LOCAL_MODELS_DIR="$HOME/400-MODELS"
export LOCAL_MODEL_MAP="$LOCAL_MODELS_DIR/model-map.txt"
export LOCAL_DOWNLOAD_MODEL_MAP="$LOCAL_MODELS_DIR/download-model-map.txt"

export MMOJO_SHARE_MODELS_DIR="$MMOJO_SHARE_MOUNT_POINT/models"
export MMOJO_SHARE_MODEL_MAP="$MMOJO_SHARE_MODELS_DIR/model-map.txt"
export MMOJO_SHARE_RESTORE_MODEL_MAP="$MMOJO_SHARE_MODELS_DIR/restore-model-map.txt"

echo "Setting Build paths."
export BUILD_DIR="$HOME/500-BUILD-mmojo-server"
export BUILD_DEBUG="build-debug"
export BUILD_COSMO_APE="build-cosmo-ape"
export BUILD_COSMO_COMPATIBLE_X86_64="build-cosmo-compatible-x86_64"
export BUILD_COSMO_COMPATIBLE_AARCH64="build-cosmo-compatible-aarch64"
export BUILD_COSMO_COMPATIBLE_APE="build-cosmo-compatible-ape"
export BUILD_COSMO_PERFORMANT_X86_64="build-cosmo-performant-x86_64"
export BUILD_COSMO_PERFORMANT_AARCH64="build-cosmo-performant-aarch64"
export BUILD_COSMO_PERFORMANT_APE="build-cosmo-performant-ape"

export BUILD_EXECUTABLE_COMPATIBLE_X86_64="build-executable-compatible-x86_64"
export BUILD_EXECUTABLE_COMPATIBLE_AARCH64="build-executable-compatible-aarch64"
export BUILD_EXECUTABLE_PERFORMANT_X86_64="build-executable-performant-x86_64"
export BUILD_EXECUTABLE_PERFORMANT_AARCH64="build-executable-performant-aarch64"
export BUILD_EXECUTABLE_NATIVE_X86_64="build-executable-native-x86_64"
export BUILD_EXECUTABLE_NATIVE_AARCH64="build-executable-native-aarch64"

export BUILD_MINGW_COMPATIBLE_X86_64="build-mingw-compatible-x86_64"
export BUILD_MINGW_COMPATIBLE_AARCH64="build-mingw-compatible-aarch64"
export BUILD_MINGW_PERFORMANT_X86_64="build-mingw-performant-x86_64"
export BUILD_MINGW_PERFORMANT_AARCH64="build-mingw-performant-aarch64"

# Split out build commands so we can edit locally, build the delta.
export LAST_BUILD_COMMAND=".last-build-command.sh"
export LAST_BUILD_COMMAND_PATH="$HOME/$LAST_BUILD_COMMAND"

echo "Setting Test paths."
export TEST_WORKING_DIR="$HOME/500-TEST-working-directory"

# Reset this when we update environment variables.
unset TEST_MODEL
unset TEST_CPU_THREADS
unset TEST_WITH_CHAT_UI

echo "Setting Package paths."
export PACKAGE_DIR="$HOME/600-PACKAGE-mmojo-server"

export PACKAGE_APE="ape"
export PACKAGE_COMPATIBLE_APE="compatible-ape"
export PACKAGE_PERFORMANT_APE="performant-ape"
export PACKAGE_COMPATIBLE_NAKED_APE="compatible-naked-ape"
export PACKAGE_PERFORMANT_NAKED_APE="performant-naked-ape"
export PACKAGE_ZIP="zip"
export PACKAGE_SEAS="seas"

export PACKAGE_MMOJO_SERVER_FILE="mmojo-server"
export PACKAGE_MMOJO_SERVER_APE_FILE="mmojo-server-ape"
export PACKAGE_MMOJO_SERVER_ZIP_FILE="mmojo-server.zip"
export PACKAGE_MMOJO_SERVER_EXE_FILE="mmojo-server.exe"
export PACKAGE_MMOJO_SERVER_ARGS_FILE="mmojo-server-args"
export PACKAGE_MMOJO_SERVER_SUPPORT_DIR="mmojo-server-support"

echo "Setting Doghouse paths and filenames."
export DOGHOUSE_FILES="$MMOJO_SERVER_DIR/files/doghouse"
export DOGHOUSE_SCRIPTS="$MMOJO_SERVER_DIR/scripts/doghouse"
export DOGHOUSE_BUILD_DIR="$HOME/500-BUILD-doghouse"
export DOGHOUSE_PACKAGE_DIR="$HOME/600-PACKAGE-doghouse"

export PACKAGE_DOGHOUSE_FILE="doghouse"
export PACKAGE_DOGHOUSE_APE_FILE="doghouse-ape"
export PACKAGE_DOGHOUSE_ZIP_FILE="doghouse.zip"
export PACKAGE_DOGHOUSE_EXE_FILE="doghouse.exe"
export PACKAGE_DOGHOUSE_ARGS_FILE="doghouse-args"
export PACKAGE_DOGHOUSE_SUPPORT_DIR="doghouse-support"

echo "Setting llama-server paths and filenames."
export LLAMA_SERVER_FILES="$MMOJO_SERVER_DIR/files/llama-server"
export LLAMA_SERVER_SCRIPTS="$MMOJO_SERVER_DIR/scripts/llama-server"
export LLAMA_SERVER_BUILD_DIR="$HOME/500-BUILD-llama-server"
export LLAMA_SERVER_PACKAGE_DIR="$HOME/600-PACKAGE-llama-server"

export PACKAGE_LLAMA_SERVER_FILE="llama-server"
export PACKAGE_LLAMA_SERVER_APE_FILE="llama-server-ape"
export PACKAGE_LLAMA_SERVER_ZIP_FILE="llama-server.zip"
export PACKAGE_LLAMA_SERVER_EXE_FILE="llama-server.exe"
export PACKAGE_LLAMA_SERVER_ARGS_FILE="llama-server-args"
export PACKAGE_LLAMA_SERVER_SUPPORT_DIR="llama-server-support"

echo "Setting architectuire value for compilers."
export ARCH_X86_64_COMPATIBLE="x86-64"
export ARCH_X86_64_PERFORMANT="x86-64-v3"
export ARCH_X86_64_NATIVE="native"
# Raspberry Pi 5, Apple M1 (armv8.4-a), NVIDIA Jetson Orin Nano (armv8.2-a -- same features as armv8.1-a)
export ARCH_AARCH64_COMPATIBLE="armv8-a"
export ARCH_AARCH64_PERFORMANT="armv8.4-a"
export ARCH_AARCH64_NATIVE="native"

# Keep these around for if the mmap issue with Cosmo gets resolved and we can align .gguf in an APE.
# export BUILD_LLAMAFILE_DIR="$HOME/305-BUILD-llamafile"
# export ZIPALIGN="$BUILD_LLAMAFILE_DIR/bin/zipalign"
# export ZIPALIGN="$HOME/tools/mm-zipalign"

# Run directory for deployment only
RUN_DIR="$HOME/Mmojo-Server"

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
