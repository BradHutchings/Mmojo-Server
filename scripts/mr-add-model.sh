#!/bin/bash

################################################################################
# This script adds a .ggug model to a Mmojo Runner archive, updates vars.sh.
#
# Sticking it in /models looks forward to managing multiple models one day.
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
printf "\n$STARS\n*\n* STARTED: $SCRIPT_NAME $1 $2.\n*\n$STARS\n\n"

if [ "$1" == "--help" ] || [ "$1" == "-h" ] || [ "$1" == "" ]; then
    echo "mr_new_runner.sh [RUNNER_DIR] [APP_NAME] [SUPPORT_DIR_NAME]"
    echo "  Creates a new runner directory and preamble file."
    exit 1
fi

runner_dir="$1"
model_file="$2"

# Convert $runner_dir to an absolute path.
case $runner_dir in
  ("/"*) ;;
  (*)    runner_dir="$(pwd)/$runner_dir";;
esac

# Strip a trailing "/" from $runner_dir and $model_file if either has one.
runner_dir="$(dirname $runner_dir)/$(basename $runner_dir)"
model_file="$(dirname $model_file)/$(basename $model_file)"

archive_zip="$runner_dir/archive.zip"
models_dir="$runner_dir/models"

echo ""
echo " \$runner_dir: $runner_dir"
echo " \$model_file: $model_file"
echo "\$archive_zip: $archive_zip"
echo " \$models_dir: $models_dir"

if [ -d $runner_dir ] && [ -f "$archive_zip" ] && [ -d "$models_dir" ] && [ -f $model_file ]; then
    echo ""
    echo "Copying $model_file to $models_dir."
    cp "$model_file" "$models_dir"

    echo ""
    echo "Adding $(basename $model_file) to $archive_zip."
    SAVE_DIR=$(pwd)
    cd "$runner_dir"
    zip -u -0 -q "$archive_zip" "models/$(basename $model_file)"

    echo ""
    echo "Updating vars.sh."
    MMOJO_SED -i -e '/model/d' "$runner_dir/vars.sh"
cat << EOF >> "$runner_dir/vars.sh"
export model="$(basename $model_file)"
EOF
fi

echo ""
echo "Contents of $runner_dir/vars.sh:"
echo "$STARS"
cat "$runner_dir/vars.sh"
echo "$STARS"

echo ""
echo "Contents of $runner_dir/archive.zip:"
echo "$STARS"
unzip -l "$runner_dir/archive.zip"
echo "$STARS"

# echo ""
# echo "Files in $runner_dir:"
# ls -alR "$runner_dir"

printf "\n$STARS\n*\n* FINISHED: $SCRIPT_NAME $1 $2.\n*\n$STARS\n\n"

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
