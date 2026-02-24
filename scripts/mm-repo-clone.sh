#!/bin/bash

################################################################################
# This script backs up the models in the $HOME/mm-models directory to Mmojo Share.
# It only backs up models that are not on the share.
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
printf "\n$STARS\n*\n* STARTED: $SCRIPT_NAME.\n*\n$STARS\n\n"

# export MMOJO_SERVER_DIR="$HOME/mm-mmojo-server"
# export MMOJO_SERVER_SCRIPTS="$MMOJO_SERVER_DIR/scripts"
cd $HOME
if [ "$MMOJO_SERVER_DIR" != "" ] && [ -d "$MMOJO_SERVER_DIR" ] ; then
  rm -r -f $MMOJO_SERVER_DIR
fi
mkdir -p $MMOJO_SERVER_DIR
git clone https://github.com/BradHutchings/mmojo-server.git $MMOJO_SERVER_DIR

# mm-repo-update-local.sh uses these variables, so set them first.
. $MMOJO_SERVER_SCRIPTS/mm-environment-variables.sh

# mm-repo-update-local.sh copies mm- scripts to $HOME/mm-scripts
. $MMOJO_SERVER_SCRIPTS/mm-repo-update-local.sh

if ! grep -q "mm-env=" "$HOME/.bashrc"; then
cat << EOF1 >> $HOME/.bashrc
alias mm-env=". mm-environment-variables.sh"
mm-env
EOF1
source $HOME/.bashrc
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
