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

  # DELETE THIS BLOCK WHEN THE SCRIPTS ARE GONE. -Brad 2026-03-16
  # These are the scripts. They need to be executable.
  chmod -f a+x $REPO_DIR_SCRIPTS/3*.sh
  chmod -f a+x $REPO_DIR_SCRIPTS/4*.sh

  ### Links don't work - end up modifying repo files on chmod.
  if [ -d "$HOME_SCRIPTS" ]; then
      cp $REPO_DIR_SCRIPTS/mm-*.sh $HOME_SCRIPTS
      chmod a+x $HOME_SCRIPTS/mm-*.sh
  fi
  
  mm-repo-copy-scripts.sh
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
