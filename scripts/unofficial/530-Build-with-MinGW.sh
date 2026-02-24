#!/bin/bash

################################################################################
# This script builds the specified version of mmojo-server and other llama.cpp 
# targets.
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
printf "\n$STARS\n*\n* STARTED: $SCRIPT_NAME $1 $2 $3.\n*\n$STARS\n\n"

processor=$1
variation=$2
branding=$3

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

if [ "$branding" != "llama-server" ]; then
    echo "Resetting branding."
    branding=""
fi

THIS_BUILD_DIR=$BUILD_DIR
if [ "$branding" == "llama-server" ]; then
    THIS_BUILD_DIR=$LLAMA_SERVER_BUILD_DIR
fi

cd $THIS_BUILD_DIR

ARCH_LEVEL_PARAM=""
BUILD_SUBDIRECTORY=""
GGML_PARAMS="-DGGML_AVX=OFF -DGGML_AVX2=OFF -DGGML_BMI2=OFF -DGGML_F16C=OFF -DGGML_FMA=OFF "
GGML_PARAMS+="-DGGML_SCHED_MAX_COPIES=4 -DGGML_SSE42=OFF -DGGML_USE_CPU_REPACK=OFF "
GGML_PARAMS+="-DGGML_USE_LLAMAFILE=OFF -DGGML_USE_OPENMP=OFF "
GGML_PARAMS+="-DGGML_OPENMP=OFF -DGGML_NATIVE=OFF"
VERBOSE="OFF"

if [ $processor == "x86_64" ]; then
    BUILD_SUBDIRECTORY="$BUILD_MINGW_COMPATIBLE_X86_64"
    ARCH_LEVEL_PARAM=" -march=$ARCH_X86_64_COMPATIBLE "
    if [ $variation == "performant" ]; then
        BUILD_SUBDIRECTORY="$BUILD_MINGW_PERFORMANT_X86_64"
        ARCH_LEVEL_PARAM=" -march=$ARCH_X86_64_PERFORMANT  "
        # Reference that x86-64-v3 supports these:
        # https://infotechys.com/x86-64-v3-architecture/
        GGML_PARAMS="-DGGML_AVX=ON -DGGML_AVX2=ON -DGGML_BMI2=ON -DGGML_F16C=ON -DGGML_FMA=ON "
        GGML_PARAMS+="-DGGML_SCHED_MAX_COPIES=4 -DGGML_SSE42=ON -DGGML_USE_CPU_REPACK=ON "
        GGML_PARAMS+="-DGGML_USE_LLAMAFILE=ON -DGGML_USE_OPENMP=ON "
    fi
fi
if [ $processor == "aarch64" ]; then
    BUILD_SUBDIRECTORY="$BUILD_MINGW_COMPATIBLE_AARCH64"
    ARCH_LEVEL_PARAM=" -march=$ARCH_AARCH64_COMPATIBLE "
    if [ $variation == "performant" ]; then
        BUILD_SUBDIRECTORY="$BUILD_MINGW_PERFORMANT_AARCH64"
        ARCH_LEVEL_PARAM=" -march=$ARCH_AARCH64_PERFORMANT  "
        GGML_PARAMS=""
    fi
fi

echo "   Processor: $processor"
echo "   Variation: $variation"
echo "    Branding: $branding"
echo "  arch param: $ARCH_LEVEL_PARAM"
echo "subdirectory: $BUILD_SUBDIRECTORY"
echo " building in: $THIS_BUILD_DIR/$BUILD_SUBDIRECTORY"
echo " GGML Params: $GGML_PARAMS"
echo ""

unset CC
unset CXX
unset AR
# export PATH="$(pwd)/cosmocc/bin:$SAVE_PATH"

if [ "$processor" == "x86_64" ]; then
    # No need to specify them here.
    export CC="x86_64-w64-mingw32-gcc \
        -O3 $ARCH_LEVEL_PARAM"
    export CXX="x86_64-w64-mingw32-g++ \
        -O3 -Wno-format-truncation $ARCH_LEVEL_PARAM"
    # export AR="x86_64-w64-mingw32-ld"
    export LDFLAGS="-static"
fi

# if [ "$processor" == "aarch64" ]; then
#     # Recent discovery -- cosmo-cc and cosmo-c++ can figure out the -I and -L related to cosmo.
#     # No need to specify them here.
#     export CC="aarch64-unknown-cosmo-cc  \
#         -nostdinc -O3 $ARCH_LEVEL_PARAM"
#     export CXX="aarch64-unknown-cosmo-c++ \
#         -DCOSMOCC=1 -nostdinc -nostdinc++ -O3 -Wno-format-truncation $ARCH_LEVEL_PARAM \
#         -I$(pwd)/openssl/include \
#         -L$(pwd)/openssl/.aarch64/"
#     export AR="cosmoar"
# fi

if [ -v CC ]; then
    # Prepare the build folder
    if [ "$THIS_BUILD_DIR/$BUILD_SUBDIRECTORY" != "" ] && [ -d "$THIS_BUILD_DIR/$BUILD_SUBDIRECTORY" ]; then
        rm -r -f "$THIS_BUILD_DIR/$BUILD_SUBDIRECTORY"
    fi
    cmake -B "$BUILD_SUBDIRECTORY" -DBUILD_SHARED_LIBS=OFF -DLLAMA_CURL=OFF -DLLAMA_OPENSSL=ON \
      -DCMAKE_SYSTEM_NAME=Windows -DCMAKE_SYSTEM_PROCESSOR=$processor \
      -DCMAKE_VERBOSE_MAKEFILE=$VERBOSE $GGML_PARAMS

    # Build
    # cmake --build $BUILD_SUBDIRECTORY --config Release # --verbose


# LAST_BUILD_COMMAND=".last-build-command.sh"
# LAST_BUILD_COMMAND_PATH="$HOME/$LAST_BUILD_COMMAND"
cat << EOF > "$LAST_BUILD_COMMAND_PATH"
cd $THIS_BUILD_DIR
echo "Building: $branding - $BUILD_SUBDIRECTORY"
cmake --build $BUILD_SUBDIRECTORY --config Release # --verbose
EOF
chmod a+x "$LAST_BUILD_COMMAND_PATH"

    # Show off what we built
    printf "\nBuild of MinGW $processor of llama.cpp is complete.\n\n"
    printf "\$ ls -al $THIS_BUILD_DIR/$BUILD_SUBDIRECTORY/bin/\n"
    ls -al $THIS_BUILD_DIR/$BUILD_SUBDIRECTORY/bin
    printf "\n"
fi

export PATH=$SAVE_PATH
unset CC
unset CXX
unset AR

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
