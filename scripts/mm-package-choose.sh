#!/bin/bash

################################################################################
# This script adds certs from the Mmojo Share to the mmojo-server.zip packaging
# file.
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
# printf "\n**********\n*\n* STARTED: $SCRIPT_NAME $1.\n*\n**********\n\n"

DEPLOY_DIR="$DEPLOY_DIR"

if [ -d "$PACKAGES_DIR" ]; then
    wd=$(pwd)
    cd "$PACKAGES_DIR"
    unset options
    options=($(ls))

    if [ "${#options[@]}" -gt "0" ]; then
        for ((i=0;i<${#options[@]};i++)); do 
          string="$(($i+1))) ${options[$i]}"
          printf "%s\n" "$string"
        done
        cd "$pwd"
        
        echo
        read -p 'Which package would you like to use? ' opt
        echo
        
        if [ "$opt" -gt "0" ] && [ "$opt" -le "${#options[@]}" ]; then
            package=${options[$opt-1]}
            echo "You chose $opt: $package."
            echo "Unzipping into $DEPLOY_DIR."
            if [ "$DEPLOY_DIR" != "" ] && [ -d "$DEPLOY_DIR" ]; then
                mkdir -p "$DEPLOY_DIR"
                rm -r -f "$DEPLOY_DIR"/*
            fi
            unzip "$PACKAGES_DIR/$package" -d "$DEPLOY_DIR"
        else
            echo "Your choice was out of range."
        fi
    else
        echo "The $PACKAGES_DIR is empty."
    fi
else
    echo "The $PACKAGES_DIR does not exist."
fi
cd $HOME

# printf "\n**********\n*\n* FINISHED: $SCRIPT_NAME.\n*\n**********\n\n"

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
