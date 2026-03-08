#!/bin/bash

################################################################################
# This script switches your local clone of the Mmojo Server repo to the
# work-in-progress branch, then copies all of the mm- scripts to $HOME/scripts.
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
printf "\n$STARS\n*\n* STARTED: $SCRIPT_NAME.\n*\n$STARS\n\n"

if [ -d "$REPO_DIR" ]; then
  WD=$(pwd)
  cd $REPO_DIR
  git reset --hard
  git checkout work-in-progress
  cd $WD

  # These are the scripts. They need to be executable.
  chmod -f a+x $REPO_SCRIPTS/2*.sh
  chmod -f a+x $REPO_SCRIPTS/3*.sh
  chmod -f a+x $REPO_SCRIPTS/4*.sh
  chmod -f a+x $REPO_SCRIPTS/5*.sh
  chmod -f a+x $REPO_SCRIPTS/6*.sh
  chmod -f a+x $LLAMA_SERVER_SCRIPTS/4*.sh
  chmod -f a+x $LLAMA_SERVER_SCRIPTS/5*.sh
  chmod -f a+x $LLAMA_SERVER_SCRIPTS/6*.sh

  ### Links don't work - end up modifying repo files on chmod.
  cp $REPO_SCRIPTS/mm-*.sh $HOME_SCRIPTS
  chmod a+x $HOME_SCRIPTS/mm-*.sh

  cp $REPO_SCRIPTS/mr-*.sh $HOME_SCRIPTS
  chmod a+x $HOME_SCRIPTS/mr-*.sh

  if [ -d "$BUILD_DIR" ]; then
      # This copies the $REPO_DIR_FILES tree into the $BUILD_DIR tree.
      cp -r $REPO_DIR_FILES/* $BUILD_DIR/
      # In tools/server .cpp files, replace "defer(" with "defer_task(" to make Cosmo STL happy.
      sed -i -e 's/defer(/defer_task(/g' "$BUILD_DIR/tools/server/server-context-mmojo.cpp"
  fi
else
  echo "The $REPO_DIR directory does not exist."
fi

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
