#!/bin/bash

################################################################################
# This script updates your local clone of the Mmojo Server repo, then copies
# all of the mm- scripts to $HOME/scripts.
#
# See licensing note at end.
################################################################################

printf "\n$STARS\n*\n* STARTED: mm-update-local-mmojo-server-repo.sh.\n*\n$STARS\n\n"

if [ -d "$MMOJO_SERVER_DIR" ]; then
  WD=$(pwd)
  cd $MMOJO_SERVER_DIR
  git reset --hard
  git pull
  cd $WD

  # These are the scripts. They need to be executable.
  chmod -f a+x $MMOJO_SERVER_SCRIPTS/2*.sh
  chmod -f a+x $MMOJO_SERVER_SCRIPTS/3*.sh
  chmod -f a+x $MMOJO_SERVER_SCRIPTS/4*.sh
  chmod -f a+x $MMOJO_SERVER_SCRIPTS/5*.sh
  chmod -f a+x $MMOJO_SERVER_SCRIPTS/6*.sh
  chmod -f a+x $LLAMA_SERVER_SCRIPTS/4*.sh
  chmod -f a+x $LLAMA_SERVER_SCRIPTS/5*.sh
  chmod -f a+x $LLAMA_SERVER_SCRIPTS/6*.sh

  ### Links don't work - end up modifying repo files on chmod.
  cp $MMOJO_SERVER_SCRIPTS/mm-*.sh $HOME_SCRIPTS
  chmod a+x $HOME_SCRIPTS/mm-*.sh

  cp $MMOJO_SERVER_SCRIPTS/mr-*.sh $HOME_SCRIPTS
  chmod a+x $HOME_SCRIPTS/mr-*.sh

  # This copies the $MMOJO_SERVER_FILES tree into the $BUILD_DIR tree.
  if [ -d "$BUILD_DIR" ]; then
      cp -r $MMOJO_SERVER_FILES/* $BUILD_DIR/
  fi
else
  echo "The $MMOJO_SERVER_DIR directory does not exist."
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
