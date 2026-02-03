#!/bin/bash

################################################################################
# This script adds certs from the Mmojo Share to the mmojo-server.zip packaging
# file.
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
# printf "\n**********\n*\n* STARTED: $SCRIPT_NAME.\n*\n**********\n\n"

unset CHOSEN_MODEL
unset CHOSEN_MODEL_MNEMONIC

echo ""
echo "These models are available to package:"
PS3="Please choose a model:"

cd $LOCAL_MODELS_DIR
select filename in *.gguf; do
  case $filename in
    "")
      echo "That was not a valid choice. \$CHOSEN_MODEL has been unset."
      break
      ;;
    *)
      export CHOSEN_MODEL=$filename
      break
      ;;
  esac
done

if [ -v CHOSEN_MODEL ]; then
  export CHOSEN_MODEL_MNEMONIC=$(grep $CHOSEN_MODEL $LOCAL_MODEL_MAP | awk '{print $2}')
  echo ""
  echo "You chose: $CHOSEN_MODEL - $CHOSEN_MODEL_MNEMONIC"
  echo ""

  if [ -d "$RUN_DIR" ]; then
      rm -f "$RUN_DIR"/*.gguf
      echo "Copying chosen model to $RUN_DIR."
      cp "$LOCAL_MODELS_DIR/$CHOSEN_MODEL" "$RUN_DIR"
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
