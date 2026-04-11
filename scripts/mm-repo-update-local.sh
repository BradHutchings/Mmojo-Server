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
  cd "$REPO_DIR"
  git reset --hard
  git pull
  cd "$WD"

  mm-repo-copy-scripts.sh
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
