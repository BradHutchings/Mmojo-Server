#!/bin/bash

################################################################################
# This script builds the specified version of mmojo-server and other llama.cpp 
# targets.
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
printf "\n$STARS\n*\n* STARTED: $SCRIPT_NAME $1 $2.\n*\n$STARS\n\n"

processor=$1
variation=$2

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


THIS_BUILD_DIR=$BUILD_DIR

cd $THIS_BUILD_DIR

ARCH_LEVEL_PARAM=""
BUILD_SUBDIRECTORY=""
GGML_PARAMS="-DGGML_AVX=OFF -DGGML_AVX2=OFF -DGGML_BMI2=OFF -DGGML_F16C=OFF -DGGML_FMA=OFF "
GGML_PARAMS+="-DGGML_SCHED_MAX_COPIES=4 -DGGML_SSE42=OFF -DGGML_USE_CPU_REPACK=OFF "
GGML_PARAMS+="-DGGML_USE_LLAMAFILE=OFF -DGGML_USE_OPENMP=OFF"
VERBOSE="OFF"

if [ $processor == "x86_64" ]; then
    BUILD_SUBDIRECTORY="$BUILD_COSMO_COMPATIBLE_X86_64"
    ARCH_LEVEL_PARAM=" -march=$ARCH_X86_64_COMPATIBLE "
    if [ $variation == "performant" ]; then
        BUILD_SUBDIRECTORY="$BUILD_COSMO_PERFORMANT_X86_64"
        ARCH_LEVEL_PARAM=" -march=$ARCH_X86_64_PERFORMANT  "
        # Reference that x86-64-v3 supports these:
        # https://infotechys.com/x86-64-v3-architecture/
        GGML_PARAMS="-DGGML_AVX=ON -DGGML_AVX2=ON -DGGML_BMI2=ON -DGGML_F16C=ON -DGGML_FMA=ON "
        GGML_PARAMS+="-DGGML_SCHED_MAX_COPIES=4 -DGGML_SSE42=ON -DGGML_USE_CPU_REPACK=ON "
        GGML_PARAMS+="-DGGML_USE_LLAMAFILE=ON -DGGML_USE_OPENMP=ON "
    fi
fi
if [ $processor == "aarch64" ]; then
    BUILD_SUBDIRECTORY="$BUILD_COSMO_COMPATIBLE_AARCH64"
    ARCH_LEVEL_PARAM=" -march=$ARCH_AARCH64_COMPATIBLE "
    if [ $variation == "performant" ]; then
        BUILD_SUBDIRECTORY="$BUILD_COSMO_PERFORMANT_AARCH64"
        ARCH_LEVEL_PARAM=" -march=$ARCH_AARCH64_PERFORMANT  "
        GGML_PARAMS=""
    fi
fi

echo "   Processor: $processor"
echo "   Variation: $variation"
echo "  arch param: $ARCH_LEVEL_PARAM"
echo "subdirectory: $BUILD_SUBDIRECTORY"
echo " building in: $THIS_BUILD_DIR/$BUILD_SUBDIRECTORY"
echo " GGML Params: $GGML_PARAMS"
echo ""

unset CC
unset CXX
unset AR
export PATH="$(pwd)/cosmocc/bin:$SAVE_PATH"

if [ "$processor" == "x86_64" ]; then
    # Recent discovery -- cosmo-cc and cosmo-c++ can figure out the -I and -L related to cosmo.
    # No need to specify them here.
    export CC="x86_64-unknown-cosmo-cc \
        -nostdinc -O3 $ARCH_LEVEL_PARAM"
    export CXX="x86_64-unknown-cosmo-c++ \
        -DCOSMOCC=1 -nostdinc -nostdinc++ -O3 -Wno-format-truncation -fpermissive $ARCH_LEVEL_PARAM  \
        -I$(pwd)/openssl/include \
        -L$(pwd)/openssl"
    export AR="cosmoar"
fi

if [ "$processor" == "aarch64" ]; then
    # Recent discovery -- cosmo-cc and cosmo-c++ can figure out the -I and -L related to cosmo.
    # No need to specify them here.
    export CC="aarch64-unknown-cosmo-cc  \
        -nostdinc -O3 $ARCH_LEVEL_PARAM"
    export CXX="aarch64-unknown-cosmo-c++ \
        -DCOSMOCC=1 -nostdinc -nostdinc++ -O3 -Wno-format-truncation -fpermissive $ARCH_LEVEL_PARAM \
        -I$(pwd)/openssl/include \
        -L$(pwd)/openssl/.aarch64/"
    export AR="cosmoar"
fi

if [ -v CC ]; then
    # The OpenSSL linking got moved to vendor/cpp-httplib/CMakeLists.txt.
    cp vendor/cpp-httplib/CMakeLists.txt vendor/cpp-httplib/CMakeLists-orig.txt

    # Make temporary change to CMake system so we link in static OpenSSL.
    sed -i -e 's/PUBLIC OpenSSL::SSL OpenSSL::Crypto/PUBLIC libssl.a libcrypto.a/g' vendor/cpp-httplib/CMakeLists.txt
    # Delete the rejection test for OpenSSL.
    sed -i -e '/#include <openssl\/opensslv.h>/d' vendor/cpp-httplib/CMakeLists.txt
    sed -i -e '/error bad version/d' vendor/cpp-httplib/CMakeLists.txt

    # Prepare the build folder
    if [ "$THIS_BUILD_DIR/$BUILD_SUBDIRECTORY" != "" ]; then
        rm -r -f "$THIS_BUILD_DIR/$BUILD_SUBDIRECTORY"
    fi
    cmake -B "$BUILD_SUBDIRECTORY" -DBUILD_SHARED_LIBS=OFF -DLLAMA_CURL=OFF -DLLAMA_OPENSSL=ON \
      -DCMAKE_SYSTEM_NAME=Linux -DCMAKE_SYSTEM_PROCESSOR=$processor \
      -DCMAKE_VERBOSE_MAKEFILE=$VERBOSE $GGML_PARAMS

    # Revert to original CMake system.
    # The OpenSSL linking got moved to vendor/cpp-httplib/CMakeLists.txt.
    mv vendor/cpp-httplib/CMakeLists-orig.txt vendor/cpp-httplib/CMakeLists.txt

    # Build
    cmake --build "$BUILD_SUBDIRECTORY" --config Release

    echo
    echo "Build command: cmake --build \"$BUILD_SUBDIRECTORY\" --config Release"

    # Show off what we built
    printf "\nBuild of Cosmo $processor of llama.cpp is complete.\n\n"
    printf "\$ ls -al $THIS_BUILD_DIR/$BUILD_SUBDIRECTORY/bin/\n"
    ls -al $THIS_BUILD_DIR/$BUILD_SUBDIRECTORY/bin
    printf "\n"
fi

export PATH=$SAVE_PATH
unset CC
unset CXX
unset AR

cd $HOME

printf "\n$STARS\n*\n* FINISHED: $SCRIPT_NAME $1 $2.\n*\n$STARS\n\n"

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
