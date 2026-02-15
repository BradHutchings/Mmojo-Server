#!/bin/bash

################################################################################
# This script clones and builds the Cosmpolitan Github repository. We use it to 
# build Actual Portable Executables (APE). Thank you to Justine Tunney and team 
# for the Cosmopolitan project!
#
# https://github.com/jart/cosmopolitan
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
printf "\n$STARS\n*\n* STARTED: $SCRIPT_NAME.\n*\n$STARS\n\n"

if [ -d "$BUILD_COSMOPOLITAN_DIR" ]; then
    rm -r -f $BUILD_COSMOPOLITAN_DIR
fi

git clone https://github.com/jart/cosmopolitan.git $BUILD_COSMOPOLITAN_DIR
cd $BUILD_COSMOPOLITAN_DIR

# Roll the Cosmopolitan repo back to last known working.
# Problem shows up when we run a build. Server responds to API calls with "400". Not fun to debug. Will do it someday if needed.
# Up through: https://github.com/jart/cosmopolitan/commit/f1e83d52403060d674161944e849b51f95707c9a
# f1e83d52403060d674161944e849b51f95707c9a 
git checkout f1e83d52403060d674161944e849b51f95707c9a 

# To see where you're checked out:
# git log -1

# Edit the memchr_sse() function to check params.
sed -i '39i \  if ((s == NULL) || (n == 0)) return 0;' libc/intrin/memchr.c

# Build Cosmo
tool/cosmocc/package.sh

echo "#include <linux/limits.h>" > $BUILD_COSMOPOLITAN_DIR/cosmocc/include/sys/syslimits.h

# Show off what we built
printf "\nBuild of Cosmopolitan is complete.\n\n"
printf "\$ ls -al $BUILD_COSMOPOLITAN_DIR/cosmocc/bin/\n"
ls -al $BUILD_COSMOPOLITAN_DIR/cosmocc/bin/
printf "\n"

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
