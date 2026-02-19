#!/bin/bash

################################################################################
# This script adds certs from the Mmojo Share to the mmojo-server.zip packaging
# file.
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
# printf "\n**********\n*\n* STARTED: $SCRIPT_NAME.\n*\n**********\n\n"

wd=$(pwd)
cd $PACKAGES_DIR
unset options
options=($(ls))
for ((i=0;i<${#options[@]};i++)); do 
  string="$(($i+1))) ${options[$i]}"
  printf "%s\n" "$string"
done
cd $pwd

echo
read -p 'Which package would you like to use? ' opt
echo

if [ "$opt" -gt "0" ] && [ "$opt" -le "${#options[@]}" ]; then
    package=${options[$opt-1]}
    echo "You chose $opt: $package."
    mkdir -p $RUN_DIR
    rm -r -f "$RUN_DIR"/*
    unzip "$PACKAGES_DIR/$package" -d "$RUN_DIR"
else
    echo "Your choice was out of range."
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
