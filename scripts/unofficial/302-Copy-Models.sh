#!/bin/bash

################################################################################
# This script copies models from the Mmojo Share.
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
printf "\n$STARS\n*\n* STARTED: $SCRIPT_NAME.\n*\n$STARS\n\n"

CopyModel() {
  MODEL_FILE=$1
  if [ ! -f $MODEL_FILE ]; then 
    echo "Copying $MODEL_FILE."
    # cp -v /mnt/mmojo/models/$MODEL_FILE .
    rsync -ah --progress /mnt/mmojo/models/$MODEL_FILE .
    chmod a-x $MODEL_FILE
  fi
}

cd $MODELS_DIR
mm-share-mount.sh
unset apefiles
declare -A apefiles

while IFS=$' ' read -r gguf apefile ; do
  if [[ "$gguf" != "#" ]] && [[ -n "$gguf" ]]; then
    apefiles["${gguf}"]="${apefile}"
  fi
done < "$MODEL_MAP"

for key in "${!apefiles[@]}"; do
  CopyModel $key 
done

cd $HOME

echo -e "\nModels directory:"
ls -al $MODELS_DIR/*.gguf

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
