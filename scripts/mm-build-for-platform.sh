#!/bin/bash

################################################################################
# This script builds llama.cpp with Mmojo Server extensions for the CPU of the
# build environment machine. CPU optimizations are enabled. Thank you to Georgi 
# Gerganov and his team for llama.cpp!
#
# https://github.com/ggml-org/llama.cpp
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
printf "\n$STARS\n*\n* STARTED: $SCRIPT_NAME $1 $2 $3 $4.\n*\n$STARS\n\n"

processor=$(uname -m)
build_subdirectory=$1
variation=$2
gpus=$3

if [ "$processor" == "arm64" ]; then
    processor="aarch64"
fi

if [ "$processor" != "x86_64" ] && [ "$processor" != "aarch64" ]; then
    processor="x86_64"
fi

if [ "$variation" != "compatible" ] && [ "$variation" != "performant" ] && \
    [ "$variation" != "native" ] && [ "$variation" != "pi" ]; then
    variation="native"
fi

if [ "$build_subdirectory" == "" ]; then
    build_subdirectory="build-$processor-$variation-$gpus"
fi

THIS_BUILD_DIR=$BUILD_DIR
if [ "$4" == "llama-server" ]; then
    THIS_BUILD_DIR=$BUILD_DIR_LLAMA_SERVER
fi

BUILD_SUBDIRECTORY=$build_subdirectory
ARCH_LEVEL_PARAM=""
GGML_PARAMS="-DGGML_NATIVE=OFF -DGGML_AVX=OFF -DGGML_AVX2=OFF -DGGML_BMI2=OFF -DGGML_F16C=OFF "
GGML_PARAMS+="-DGGML_FMA=OFF -DGGML_SCHED_MAX_COPIES=4 -DGGML_SSE42=OFF -DGGML_USE_CPU_REPACK=OFF "
GGML_PARAMS+="-DGGML_USE_LLAMAFILE=OFF -DGGML_USE_OPENMP=OFF -DGGML_RPC=ON "
VERBOSE="OFF"

if [ $processor == "x86_64" ]; then
    ARCH_LEVEL_PARAM=" -march=$ARCH_X86_64_COMPATIBLE "
    if [ $variation == "performant" ]; then
        ARCH_LEVEL_PARAM=" -march=$ARCH_X86_64_PERFORMANT  "
        # Reference that x86-64-v3 supports these:
        # https://infotechys.com/x86-64-v3-architecture/
        GGML_PARAMS="-DGGML_NATIVE=OFF -DGGML_AVX=ON -DGGML_AVX2=ON -DGGML_BMI2=ON -DGGML_F16C=ON -DGGML_FMA=ON "
        GGML_PARAMS+="-DGGML_SCHED_MAX_COPIES=4 -DGGML_SSE42=ON -DGGML_USE_CPU_REPACK=ON "
        GGML_PARAMS+="-DGGML_USE_LLAMAFILE=ON -DGGML_USE_OPENMP=ON "
    elif [ $variation == "native" ]; then
        ARCH_LEVEL_PARAM=" -march=$ARCH_X86_64_NATIVE  "
        GGML_PARAMS=""
    fi
fi
if [ $processor == "aarch64" ]; then
    ARCH_LEVEL_PARAM=" -march=$ARCH_AARCH64_COMPATIBLE "
    if [ $variation == "performant" ]; then
        ARCH_LEVEL_PARAM=" -march=$ARCH_AARCH64_PERFORMANT  "
    elif [ $variation == "native" ]; then
        ARCH_LEVEL_PARAM=" -march=$ARCH_AARCH64_NATIVE "
        GGML_PARAMS=""
    fi
fi

# A special exception for Raspberry Pi 5 - Means I can't build comp/per -cud. Grrrr.
# if [[ $(cat /proc/cpuinfo | grep "Model") == *"Raspberry Pi 5"* ]]; then

# Pass in pi as a variation to trigger this.
if [ "$variation" == "pi" ]; then
    ARCH_LEVEL_PARAM=" -march=$ARCH_AARCH64_NATIVE "
    GGML_PARAMS=""
    gpus=""
fi

if [[ "$gpus" == *"cud"* ]]; then
    GGML_PARAMS+=" -DGGML_CUDA=ON";
    # CUDA version reference: https://developer.nvidia.com/cuda-gpus
    # Does supporting a lower version work for higher versions?
    # 86 = GeForce RTX 3050, 87 = Jetson, 89 = GeForce RTX 4050
    GGML_PARAMS+=" -DCMAKE_CUDA_ARCHITECTURES=86;87;89"
fi
if [[ "$gpus" == *"hip"* ]]; then
    GGML_PARAMS+=" -DGGML_HIP=ON";
    # Need to sort out GPU support here. Looks more complicated than CUDA.
    # https://github.com/ggml-org/llama.cpp/blob/master/docs/build.md#hip
    # List of targets: https://llvm.org/docs/AMDGPUUsage.html#processors
    # For now, this should build for the card you have installed. Not ideal.
    # Vulkan looks like an easier route to AMD cards.
fi
if [[ "$gpus" == *"vul"* ]]; then
    GGML_PARAMS+=" -DGGML_VULKAN=ON";
fi
if [[ "$gpus" == *"met"* ]]; then
    GGML_PARAMS+=" -DGGML_METAL=ON";
else
    # Metal is on by default in macOS builds.
    GGML_PARAMS+=" -DGGML_METAL=OFF";
fi

# Always build with RPC.
GGML_PARAMS+=" -DGGML_RPC=ON";

# BUILD_SUBDIRECTORY+="$gpus"

echo "          Processor: $processor"
echo "          Variation: $variation"
echo "               GPUs: $gpus"
echo "         arch param: $ARCH_LEVEL_PARAM"
echo "       subdirectory: $THIS_BUILD_DIR/$BUILD_SUBDIRECTORY"
echo "        building in: $BUILD_SUBDIRECTORY"
echo "        GGML Params: $GGML_PARAMS"
echo "\$MMOJO_EXTRA_PARAMS: $MMOJO_EXTRA_PARAMS"
echo

if [ -d "$THIS_BUILD_DIR" ] && [ "$BUILD_SUBDIRECTORY" != "" ]; then
    cd $THIS_BUILD_DIR

    # This is dangerous if $BUILD_SUBDIRECTORY is ""! See "if" statement above.
    # -DGGML_NATIVE=ON
    if [ "$BUILD_SUBDIRECTORY" != "" ] && [ -d "$BUILD_SUBDIRECTORY" ]; then
        rm -r -f $BUILD_SUBDIRECTORY
    fi
    cmake -B "$BUILD_SUBDIRECTORY" -DBUILD_SHARED_LIBS=OFF -DLLAMA_CURL=OFF -DLLAMA_OPENSSL=ON \
        -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_FLAGS="$ARCH_LEVEL_PARAM" -DCMAKE_CXX_FLAGS="$ARCH_LEVEL_PARAM" \
        -DCMAKE_VERBOSE_MAKEFILE=$VERBOSE $GGML_PARAMS $MMOJO_EXTRA_PARAMS
    cmake --build "$BUILD_SUBDIRECTORY"
    
    # Show off what we built
    printf "\nBuild of CPU Test of llama.cpp is complete.\n\n"
    printf "\$ ls -al $BUILD_SUBDIRECTORY/bin/\n"
    ls -al $BUILD_SUBDIRECTORY/bin

    echo
    echo "Build command: cmake --build \"$BUILD_SUBDIRECTORY\""
else
    echo "Failed build directory test."
    if [ -d "$THIS_BUILD_DIR" ]; then
        echo "Passed -d \$THIS_BUILD_DIR."
    fi
    if  [ "$BUILD_SUBDIRECTORY" != "" ]; then
        echo "Passed \$BUILD_SUBDIRECTORY not empty."
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
