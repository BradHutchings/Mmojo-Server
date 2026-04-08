#!/bin/bash

################################################################################
# This script switches your local clone of the Mmojo Server repo to the main
# branch, then copies all of the mm- scripts to $HOME/scripts.
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
# printf "\n$STARS\n*\n* STARTED: $SCRIPT_NAME.\n*\n$STARS\n\n"

### Links don't work - end up modifying repo files on chmod.
if [ -d "$HOME_SCRIPTS" ]; then
    cp $REPO_DIR_SCRIPTS/mm-*.sh $HOME_SCRIPTS
    chmod a+x $HOME_SCRIPTS/mm-*.sh

    # on darwin, change "/bin/bash" to "/usr/local/bash"
    if [ "$(uname -s)" == "Darwin" ]; then
        $MMOJO_SED -i -e "1s|#!/usr/local/bash" $HOME_SCRIPTS/mm-*.sh
    fi
fi

if [ -d "$HOME_OC_SCRIPTS" ]; then
    cp $REPO_DIR_SCRIPTS_OPENCLAW/oc-*.sh $HOME_OC_SCRIPTS
    cp $REPO_DIR_SCRIPTS/mm-environment-variables.sh $HOME_OC_SCRIPTS
    cp $REPO_DIR_SCRIPTS/mm-repo-*.sh $HOME_OC_SCRIPTS
    cp $REPO_DIR_SCRIPTS/mm-share-*.sh $HOME_OC_SCRIPTS
    chmod a+x $HOME_OC_SCRIPTS/mm-*.sh
    chmod a+x $HOME_OC_SCRIPTS/oc-*.sh
    
    # on darwin, change "/bin/bash" to "/usr/local/bash"
    if [ "$(uname -s)" == "Darwin" ]; then
        $MMOJO_SED -i -e "1s|#!/usr/local/bash" $HOME_OC_SCRIPTS/mm-*.sh
        $MMOJO_SED -i -e "1s|#!/usr/local/bash" $HOME_OC_SCRIPTS/oc-*.sh
    fi
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
