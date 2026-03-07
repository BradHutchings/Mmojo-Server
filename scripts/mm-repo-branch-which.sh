#!/bin/bash

################################################################################
# This script switches your local clone of the Mmojo Server repo to the main
# branch, then copies all of the mm- scripts to $HOME/scripts.
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
# printf "\n$STARS\n*\n* STARTED: $SCRIPT_NAME.\n*\n$STARS\n\n"

if [ -d "$REPO_DIR" ]; then
  WD=$(pwd)
  cd $REPO_DIR
  branch=$(git branch --show-current)
  cd $WD

  echo "You are in the \"$branch\" branch of the $REPO_DIR repo directory."
else
  echo "The $REPO_DIR directory does not exist."
fi

# printf "\n$STARS\n*\n* FINISHED: $SCRIPT_NAME.\n*\n$STARS\n\n"

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
