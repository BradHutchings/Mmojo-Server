#!/bin/bash

################################################################################
# This script clones and builds the OpenSSL Github repository with cosmocc.
# We link the built libraries into our Actual Portable Executables (APE). Thank 
# you to the OpenSSL team for their work!
#
# https://github.com/openssl
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
printf "\n$STARS\n*\n* STARTED: $SCRIPT_NAME.\n*\n$STARS\n\n"

if [ -d "$BUILD_OPENSSSL_DIR" ]; then
    rm -r -f $BUILD_OPENSSSL_DIR
fi

mkdir -p $BUILD_OPENSSSL_DIR
cd $BUILD_OPENSSSL_DIR
cp -r $COSMOCC_DIR .

export PATH="$(pwd)/cosmocc/bin:$SAVE_PATH"
export CC="cosmocc -I$(pwd)/cosmocc/include -L$(pwd)/cosmocc/lib -O3 $EXTRA_FLAGS "
export CXX="cosmocc -I$(pwd)/cosmocc/include \
    -I$(pwd)/cosmocc/include/third_party/libcxx \
    -L$(pwd)/cosmocc/lib -L$(pwd)/openssl -O3 $EXTRA_FLAGS"
export AR="cosmoar"

cp -r /usr/include/openssl/ ./cosmocc/include/

# Copy the right one. This might not get the right one if cross-platform build installed.
# Or, put it in mmojo-server support files and copy that instead?
# cp -r /usr/include/x86_64-linux-gnu/openssl/* ./cosmocc/include/openssl
# cp -r /usr/include/aarch64-linux-gnu/openssl/* ./cosmocc/include/openssl

X86_64_OPENSSL="/usr/include/x86_64-linux-gnu/openssl"
AARCH64_OPENSSL="/usr/include/aarch64-linux-gnu/openssl"
if [ -d "$X86_64_OPENSSL" ]; then
  echo "Using x86_64 openssl platform includes."
  cp -r $X86_64_OPENSSL/* ./cosmocc/include/openssl
elif [ -d "$AARCH64_OPENSSL" ]; then
  echo "Using aarch64 (arm64) openssl platform includes."
  cp -r $AARCH64_OPENSSL/* ./cosmocc/include/openssl
fi

git clone https://github.com/openssl/openssl.git
cd $BUILD_OPENSSSL_DIR/openssl
./Configure no-asm no-dso no-afalgeng no-shared no-pinshared no-apps
make

# Show off what we built
printf "\nBuild of OpenSSL with cosmocc is complete.\n\n"
printf "\$ ls -al $BUILD_OPENSSSL_DIR/openssl/*.a\n"
ls -al $BUILD_OPENSSSL_DIR/openssl/*.a
printf "\n\$ ls -al $BUILD_OPENSSSL_DIR/openssl/*.a\n"
ls -al $BUILD_OPENSSSL_DIR/openssl/.aarch64/*.a
printf "\n"

cd $HOME

export PATH=$SAVE_PATH
unset CC
unset CXX
unset AR

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
