#!/bin/bash

################################################################################
# This script clones the Mmojo Server Github repository into mm-repo.
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
printf "\n$STARS\n*\n* STARTED: $SCRIPT_NAME.\n*\n$STARS\n\n"

# export REPO_DIR="$HOME/mm-repo"
# export REPO_DIR_FILES="$REPO_DIR/scripts"
cd $HOME
if [ "$REPO_DIR" != "" ] && [ -d "$REPO_DIR" ] ; then
  rm -r -f $REPO_DIR
fi
mkdir -p $REPO_DIR
git clone https://github.com/BradHutchings/mmojo-server.git $REPO_DIR

# mm-repo-update-local.sh uses these variables, so set them first.
source $REPO_DIR_SCRIPTS/mm-environment-variables.sh

# mm-repo-update-local.sh copies mm- scripts to $HOME/mm-scripts
$REPO_DIR_SCRIPTS/mm-repo-update-local.sh

if ! grep -q "mm-env=" "$HOME/$MMOJO_RC_FILE"; then
cat << EOF1 >> $HOME/$MMOJO_RC_FILE
alias mm-env=". mm-environment-variables.sh"
mm-env
EOF1
source $HOME/$MMOJO_RC_FILE
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
