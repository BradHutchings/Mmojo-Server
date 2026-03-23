#!/bin/bash

################################################################################
# This script updates your local clone of the Mmojo Server repo, then copies
# all of the mm- scripts to $HOME/scripts.
#
# See licensing note at end.
################################################################################

printf "\n$STARS\n*\n* STARTED: mm-update-local-mmojo-server-repo.sh.\n*\n$STARS\n\n"

if [ -d "$REPO_DIR" ]; then
  WD=$(pwd)
  cd $REPO_DIR
  git reset --hard
  git pull
  cd $WD

  # DELETE THIS BLOCK WHEN THE SCRIPTS ARE GONE. -Brad 2026-03-16
  # These are the scripts. They need to be executable.
  chmod -f a+x $REPO_DIR_SCRIPTS/3*.sh
  chmod -f a+x $REPO_DIR_SCRIPTS/4*.sh

  ### Links don't work - end up modifying repo files on chmod.
  if [ -d "$HOME_SCRIPTS" ]; then
      cp $REPO_DIR_SCRIPTS/mm-*.sh $HOME_SCRIPTS
      chmod a+x $HOME_SCRIPTS/mm-*.sh
  fi
  
  if [ -d "$HOME_OC_SCRIPTS" ]; then
      cp $REPO_DIR_SCRIPTS_OPENCLAW/oc-*.sh $HOME_OC_SCRIPTS
      cp $REPO_DIR_SCRIPTS/mm-environment-variables.sh $HOME_OC_SCRIPTS
      cp $REPO_DIR_SCRIPTS/mm-repo-*.sh $HOME_OC_SCRIPTS
      chmod a+x $HOME_OC_SCRIPTS/mm-*.sh
      chmod a+x $HOME_OC_SCRIPTS/oc-*.sh
  fi

  if [ -d "$BUILD_DIR" ]; then
      # This copies the $REPO_DIR_FILES tree into the $BUILD_DIR tree.
      cp -r $REPO_DIR_FILES/* $BUILD_DIR/
      mm-prepare-mmojo-complete.sh
      # In tools/server .cpp files, replace "defer(" with "defer_task(" to make Cosmo STL happy.
      $MMOJO_SED -i -e 's/defer(/defer_task(/g' "$BUILD_DIR/tools/server/server-context-mmojo.cpp"
  fi
else
  echo "The $REPO_DIR directory does not exist."
fi

printf "\n$STARS\n*\n* FINISHED: mm-update-local-mmojo-server-repo.sh.\n*\n$STARS\n\n"

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
