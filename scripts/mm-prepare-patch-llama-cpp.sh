#!/bin/bash

################################################################################
# This script patches up source code right before we compile so I don't have to 
# maintain all the changed files within this repo's /files directory. -Brad
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
printf "\n$STARS\n*\n* STARTED: $SCRIPT_NAME $1.\n*\n$STARS\n\n"

cd $HOME

THIS_BUILD_DIR=$BUILD_DIR
if [ "$1" == "llama-server" ]; then
    THIS_BUILD_DIR=$BUILD_DIR_LLAMA_SERVER
fi

EXECUTABLE_FILE=$_PACKAGE_MMOJO_SERVER_FILE

echo "  executable file: $EXECUTABLE_FILE"
echo "       cloning in: $THIS_BUILD_DIR"
echo ""

# This copies the $REPO_DIR_FILES tree into the $THIS_BUILD_DIR tree.
# This is how the original "Mmojo-Complete" directory gets into the build folder.
cp -r $REPO_DIR_FILES/* $THIS_BUILD_DIR/

cd $THIS_BUILD_DIR

#-------------------------------------------------------------------------------
# Cosmo compatibility
#-------------------------------------------------------------------------------

# --- Here is where to patch common/common.cpp with common/common.cpp.patch-1

# Patch vendor/miniaudio/miniaudio.h for bad cosmo build assumptions
$MMOJO_SED -i -e 's/__COSMOPOLITAN__/__COSMOPOLITAN__XXX/g' vendor/miniaudio/miniaudio.h

# Cosmo headers needed.
if ! grep -q "#include <cstdlib>" "tools/mtmd/deprecation-warning.cpp" ; then
  $MMOJO_SED -i '3i #include <cstdlib>' "tools/mtmd/deprecation-warning.cpp"
fi
if ! grep -q "#include <algorithm>" "src/llama-hparams.cpp" ; then
  $MMOJO_SED -i '4i #include <algorithm>' "src/llama-hparams.cpp"
fi
if ! grep -q "#include <algorithm>" "src/llama-quant.cpp" ; then
  $MMOJO_SED -i '15i #include <algorithm>' "src/llama-quant.cpp"
fi
if ! grep -q "#include <algorithm>" "common/ngram-mod.cpp" ; then
  $MMOJO_SED -i '2i #include <algorithm>' "common/ngram-mod.cpp"
fi

# cpp-httplib has a couple lines with type conversion that the old Cosmo compiler doesn't like
$MMOJO_SED -i -e 's/static_cast<cert_t>(cert)/(void*) cert/g' vendor/cpp-httplib/httplib.cpp
$MMOJO_SED -i -e 's/static_cast<cert_t>(x509)/(void*) x509/g' vendor/cpp-httplib/httplib.cpp

# In tools/server .cpp files, replace "defer(" with "defer_task(" to make Cosmo STL happy.
$MMOJO_SED -i -e 's/defer(/defer_task(/g' tools/server/server-context-mmojo.cpp
$MMOJO_SED -i -e 's/server_queue::defer(/server_queue::defer_task(/g' tools/server/server-queue.cpp
$MMOJO_SED -i -e 's/void\ defer(/void\ defer_task(/g' tools/server/server-queue.h

#-------------------------------------------------------------------------------
# Mmojo Server specific
#-------------------------------------------------------------------------------

# Update the CMake files.
$MMOJO_SED -i -e 's/arg.cpp/arg-mmojo.cpp/g' common/CMakeLists.txt
$MMOJO_SED -i -e 's/common.cpp/common-mmojo.cpp/g' common/CMakeLists.txt
$MMOJO_SED -i -e '/log.h/a \    mmojo-args.h\n\    mmojo-args.c' common/CMakeLists.txt
# Not bothering with zipalign for now. -Brad 2025-11-23
# $MMOJO_SED -i -e 's/add_subdirectory(server)/add_subdirectory(server)\n\tif (COSMOCC)\n\t\tadd_subdirectory(zipalign)\n\tendif()/g' tools/CMakeLists.txt
$MMOJO_SED -i -e 's/server.cpp/server-mmojo.cpp\n    server-additions-mmojo.cpp/g' tools/server/CMakeLists.txt
$MMOJO_SED -i -e 's/server-context.cpp/server-context-mmojo.cpp\n    server-context-additions-mmojo.cpp/g' tools/server/CMakeLists.txt
$MMOJO_SED -i -e 's/server-http.cpp/server-http-mmojo.cpp/g' tools/server/CMakeLists.txt
$MMOJO_SED -i -e "s/set(TARGET llama-server)/set(TARGET $EXECUTABLE_FILE)/g" tools/server/CMakeLists.txt
$MMOJO_SED -i -e 's/loading.html/loading-mmojo.html/g' tools/server/CMakeLists.txt

# --- Here is where to patch common/common.h with common/common.h.patch-1

#-------------------------------------------------------------------------------
# Thread priority patch for MinGW cross-compiler:
#-------------------------------------------------------------------------------

$MMOJO_SED -i -e 's/THREAD_POWER_THROTTLING/PROCESS_POWER_THROTTLING/g' ggml/src/ggml-cpu/ggml-cpu.c

#-------------------------------------------------------------------------------
# Patch vendor/cpp-httplib for compatibility with MinGW. Inline member functions need to be
# declared in class definitions. WE DON'T DO MinGW. REMOVE NEXT TIME. -Bard 2026-03-09
#-------------------------------------------------------------------------------
#if 0
$MMOJO_SED -i -e 's/bool is_readable(/inline bool is_readable(/g' vendor/cpp-httplib/httplib.h
$MMOJO_SED -i -e 's/bool wait_readable(/inline bool wait_readable(/g' vendor/cpp-httplib/httplib.h
$MMOJO_SED -i -e 's/bool wait_writable(/inline bool wait_writable(/g' vendor/cpp-httplib/httplib.h
$MMOJO_SED -i -e 's/ssize_t read(/inline ssize_t read(/g' vendor/cpp-httplib/httplib.h
$MMOJO_SED -i -e 's/ssize_t write(/inline ssize_t write(/g' vendor/cpp-httplib/httplib.h

$MMOJO_SED -i -e 's/bool is_readable(/inline bool is_readable(/g' vendor/cpp-httplib/httplib.cpp
$MMOJO_SED -i -e 's/bool wait_readable(/inline bool wait_readable(/g' vendor/cpp-httplib/httplib.cpp
$MMOJO_SED -i -e 's/bool wait_writable(/inline bool wait_writable(/g' vendor/cpp-httplib/httplib.cpp
$MMOJO_SED -i -e 's/ssize_t read(/inline ssize_t read(/g' vendor/cpp-httplib/httplib.cpp
$MMOJO_SED -i -e 's/ssize_t write(/inline ssize_t write(/g' vendor/cpp-httplib/httplib.cpp
#endif

#-------------------------------------------------------------------------------
# Aggressive warning that goes off in /tokenize
#-------------------------------------------------------------------------------

$MMOJO_SED -i -e 's/(src_parser.empty())/(false \&\& src_parser.empty())/g' common/chat.cpp

#-------------------------------------------------------------------------------
# Future: Just patch common/argc.cpp and eliminate common/argc-mmojo.cpp
# Future: Move loading-mmojo.html to loading.html instead of mangling server-mmojo.cpp. Will this work with .hpp, etc?
#-------------------------------------------------------------------------------

cd $HOME

printf "\n$STARS\n*\n* FINISHED: $SCRIPT_NAME $1.\n*\n$STARS\n\n"

################################################################################
#  This is an original script for the Mmojo Server repo. It is covered by
#  the repo's MIT-style LICENSE:
#
#  https://github.com/BradHutchings/Mmojo-Server/blob/main/LICENSE
#
#  Copyright (c) 2025-26 Brad Hutchings.
#  --
#  Brad Hutchings
#  brad@Mmojo.net
################################################################################
