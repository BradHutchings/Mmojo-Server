#!/bin/bash

################################################################################
# This script creates a directory and files to start work on a new Mmojo Runner
# archive.
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
printf "\n$STARS\n*\n* STARTED: $SCRIPT_NAME $1 $2 $3 $4 $5.\n*\n$STARS\n\n"

if [ "$1" == "--help" ] || [ "$1" == "-h" ] || [ "$1" == "" ]; then
    echo "mr_new_runner.sh [RUNNER_DIR] [APP_NAME] [SUPPORT_DIR_NAME]"
    echo "  Creates a new runner directory and preamble file."
    exit 1
fi

runner_dir="$1"
app_name="$2"
args_file_name="$3"
args_root="$4"
support_directory_name="$5"

# Convert $runner_dir to an absolute path.
case $runner_dir in
  ("/"*) ;;
  (*)    runner_dir="$(pwd)/$runner_dir";;
esac

# Strip a trailing "/" from $runner_dir and $model_file if either has one.
runner_dir="$(dirname $runner_dir)/$(basename $runner_dir)"

echo "            \$runner_dir: $runner_dir"
echo "              \$app_name: $app_name"
echo "        \$args_file_name: $args_file_name"
echo "             \$args_root: $args_root"
echo "\$support_directory_name: $support_directory_name"

# Clear out a directory that was there. Make a new one.
echo "Creating $runner_dir directory."
if [ ""$runner_dir"" != "" ] && [ -d "$runner_dir" ]; then
    rm -r -f "$runner_dir"
fi
mkdir -p "$runner_dir"

# Make a vars.sh file.
echo ""
echo "Creating vars.sh."
cat << EOF > "$runner_dir/vars.sh"
export app_name="$app_name"
export args_file_name="$args_file_name"
export args_root="$args_root"
export support_directory_name="$support_directory_name"
EOF

echo ""
echo "$runner_dir/vars.sh (first 10 lines):"
echo "$STARS"
head -n 10 "$runner_dir/vars.sh"
echo "$STARS"

# Copy the mr-preamble.sh into the directory. Customize with app name.
echo ""
echo "Copying mr-preamble.sh to $runner_dir/preamble.sh."
cp "$REPO_DIR_SCRIPTS/mr-preamble.sh" "$runner_dir/preamble.sh"

echo ""
echo "Customizing $runner_dir/preamble.sh."
$SED -i -e "s/\[APP_NAME\]/$app_name/g" "$runner_dir/preamble.sh"
$SED -i -e "s/\[SUPPORT_DIRECTORY_NAME\]/$support_directory_name/g" "$runner_dir/preamble.sh"

echo ""
echo "$runner_dir/preamble.sh (first 10 lines):"
echo "$STARS"
head -n 10 "$runner_dir/preamble.sh"
echo "$STARS"

echo ""
echo "Create a models subdirectory for storing .gguf model files in archive.zip."
mkdir -p "$runner_dir/models"

echo ""
echo "Create a $support_directory_name subdirectory for storing support files in archive.zip."
mkdir -p "$runner_dir/$support_directory_name"

echo ""
echo "Creating an empty archive."
rm -r -f "empty_dir"
mkdir -p "empty_dir"
cd "empty_dir"
# Can't create the zip directly in $runner_dir. Zip will error rather than warn of empty zip. Weird.
zip -rjq archive.zip . -i "*"
mv archive.zip "$runner_dir"
cd ..
rm -r -f "empty_dir"

echo ""
echo "Contents of $runner_dir/archive.zip:"
unzip -l "$runner_dir/archive.zip"

echo ""
echo "Files in $runner_dir:"
ls -alR "$runner_dir"

printf "\n$STARS\n*\n* FINISHED: $SCRIPT_NAME $1 $2 $3 $4.\n*\n$STARS\n\n"

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
