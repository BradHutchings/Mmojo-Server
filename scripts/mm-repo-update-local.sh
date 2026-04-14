#!/bin/bash

################################################################################
# This script updates your local clone of the Mmojo Server repo, then copies
# all of the mm- scripts to $HOME/scripts.
#
# See licensing note at end.
################################################################################

printf "\n$STARS\n*\n* STARTED: mm-update-local-mmojo-server-repo.sh.\n*\n$STARS\n\n"

wd=$(pwd)

if [ -d "$REPO_DIR" ]; then
    cd "$REPO_DIR"
    git reset --hard
    git pull

    # on darwin, change "/bin/bash" to "/usr/local/bin/bash"
    if ($MMOJO_DARWIN); then
        cd "$REPO_DIR_SCRIPTS"
        for file in mm*.sh; do
            # echo "Fixing $file."
            $MMOJO_SED -i -e '1c#!/usr/local/bin/bash' "$file"
        done

        cd "$REPO_DIR_SCRIPTS_OPENCLAW"
        for file in oc*.sh; do
            # echo "Fixing $file."
            $MMOJO_SED -i -e '1c#!/usr/local/bin/bash' "$file"
        done
    fi

    parent=$(dirname -- $0)
    # echo "Parent of this script: $parent"
    bash "$parent/mm-repo-copy-scripts.sh"
else
  echo "The $REPO_DIR directory does not exist."
fi

cd "$wd"

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
