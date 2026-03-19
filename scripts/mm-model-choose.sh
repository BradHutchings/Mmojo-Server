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

echo "You chose: $opt"

choice=""
if [ "$opt" -gt "0" ] && [ "$opt" -le ${#models[@]} ]; then
    choice=${models[$opt-1]}
fi

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

exit



echo ""
echo "These models are available to package:"
PS3="Please choose a model:"

cd $MODELS_DIR
select filename in *.gguf; do
  case $filename in
    "")
      echo "That was not a valid choice. \$MODEL_CHOICE has been unset."
      break
      ;;
    *)
      export MODEL_CHOICE=$filename
      break
      ;;
  esac
done

# if [ -v MODEL_CHOICE ]; then
if [ "$MODEL_CHOICE" != "" ]; then
  echo ""
  echo "You chose: $MODEL_CHOICE"
  echo ""

  if [ "$DEPLOY_DIR" != "" ] && [ -d "$DEPLOY_DIR" ]; then
      rm -f "$DEPLOY_DIR"/*.gguf
      echo "Soft linking $MODEL_CHOICE to $DEPLOY_DIR."
      ln -s "$MODELS_DIR/$MODEL_CHOICE" "$DEPLOY_DIR/$MODEL_CHOICE"
  fi
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
