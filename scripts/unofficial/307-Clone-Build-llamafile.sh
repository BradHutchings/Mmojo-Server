#!/bin/bash

################################################################################
# This script clones and builds the llamafile Github repository, then rolls it
# back to a known release we know how to build. I used llamafile for the
# zipalign tool, but have since absorbed zipalign into this repo. I thank
# Justine Tunney, Mozilla Foundation, and all contributors for the inspiration
# llamafile gave me to create the Mmojo Server project. -Brad 
#
# See licensing note at end.
################################################################################

export BUILD_LLAMAFILE_DIR="$HOME/300-BUILD-llamafile"


if [ "$BUILD_LLAMAFILE_DIR" != "" ] && [ -d "$BUILD_LLAMAFILE_DIR" ]; then
    rm -r -f $BUILD_LLAMAFILE_DIR
fi

git clone https://github.com/Mozilla-Ocho/llamafile $BUILD_LLAMAFILE_DIR
# Roll back to: https://github.com/mozilla-ai/llamafile/commit/ff0c02e6c560d88324966e88a718485989b41c1e
cd $BUILD_LLAMAFILE_DIR
git checkout ff0c02e6c560d88324966e88a718485989b41c1e

# Build llamafile
make -j8
make install PREFIX=.

cd $HOME

printf "\n**********\n*\n* FINISHED: 307-Clone-Build-llamafile.sh.\n*\n**********\n\n"

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
