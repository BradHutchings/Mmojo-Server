#!/bin/bash

################################################################################
# This script adds certs from the Mmojo Share to the mmojo-server.zip packaging
# file.
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
# printf "\n**********\n*\n* STARTED: $SCRIPT_NAME.\n*\n**********\n\n"

#-------------------------------------------------------------------------------
# Get list of available models in the $MODELS_DIR directory.
#-------------------------------------------------------------------------------

wd=$(pwd)
cd $MODELS_DIR

models=()
for file in *.gguf; do
    # echo "Adding $file"
    models+=($file)
done
# echo "Count: ${#models[@]}"

cd $wd

#-------------------------------------------------------------------------------
# User picks one of the models.
#-------------------------------------------------------------------------------

echo
echo "Please pick a model to use:"
for ((i=0;i<${#models[@]};i++)); do
    string="$(($i+1))) ${models[$i]}"
    printf "%s\n" "$string"
done

echo
read -p 'Which model would you like to use? ' opt
echo

choice=""
if [ "$opt" -gt "0" ] && [ "$opt" -le ${#models[@]} ]; then
    choice=${models[$opt-1]}
fi

echo "You chose: $choice"

#-------------------------------------------------------------------------------
# Copy the choice.
#-------------------------------------------------------------------------------

if [ "$choice" != "" ] && [ "$DEPLOY_DIR" != "" ]; then
    mkdir -p "$DEPLOY_DIR"
    if [ -d "$DEPLOY_DIR" ]; then
        rm -f "$DEPLOY_DIR"/*.gguf
        echo "Soft linking $choice to $DEPLOY_DIR."
        ln -s "$MODELS_DIR/$choice" "$DEPLOY_DIR/$choice"
    fi
fi

#-------------------------------------------------------------------------------
# Write out answer for caller to use.
#-------------------------------------------------------------------------------

echo
echo $choice > "/tmp/${SCRIPT_NAME%.*}.out"

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
