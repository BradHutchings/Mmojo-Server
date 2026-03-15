#!/bin/bash

################################################################################
# This script add a UI folder to a Mmojo Runner archive, updates vars.sh.
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
printf "\n$STARS\n*\n* STARTED: $SCRIPT_NAME $1 $2 $3.\n*\n$STARS\n\n"

if [ "$1" == "--help" ] || [ "$1" == "-h" ] || [ "$1" == "" ]; then
    echo "mr-add-certs.sh [RUNNER_DIR] [CERTS_PATH]"
    echo "  Adds a directory of certificates or a certificate file to the runner."
    exit 1
fi

runner_dir="$1"
ui_source_dir="$2"
ca_file="$3"

# Convert $runner_dir to an absolute path.
case $runner_dir in
  ("/"*) ;;
  (*)    runner_dir="$(pwd)/$runner_dir";;
esac

# Strip a trailing "/" from $runner_dir and $ui_source_dir if either has one.
runner_dir="$(dirname $runner_dir)/$(basename $runner_dir)"
ui_source_dir="$(dirname $ui_source_dir)/$(basename $ui_source_dir)"
ca_file="$(dirname $ca_file)/$(basename $ca_file)"

# source $runner_dir/vars.sh
support_directory_name="support"
vars_file="$runner_dir/vars.sh"
if [ -f "$vars_file" ]; then
    echo ""
    echo "Sourcing vars.sh"
    source $vars_file
fi

archive_zip="$runner_dir/archive.zip"
support_dir="$runner_dir/$support_directory_name"
ui_dir="$support_dir/$(basename $ui_source_dir)"

echo ""
echo "   \$runner_dir: $runner_dir"
echo "\$ui_source_dir: $ui_source_dir"
echo "      \$ca_file: $ca_file"
echo "  \$archive_zip: $archive_zip"
echo "  \$support_dir: $support_dir"
echo "       \$ui_dir: $ui_dir"
echo "     \$app_name: $app_name"

echo ""
echo "Copying Mmojo Complete user interface."
mkdir -p "$ui_dir"
cp -r "$ui_source_dir"/* $ui_dir
if [ -f $ca_file ]; then
    cp $ca_file $ui_dir
fi

echo ""
echo "Adding user interface to $archive_zip."
cd $runner_dir
zip -u -0 -r -q "$archive_zip" "$support_directory_name/$(basename $ui_dir)"/*

echo ""
echo "Updating vars.sh."
$SED -i -e '/ui_directory/d' "$runner_dir/vars.sh"
cat << EOF >> "$runner_dir/vars.sh"
export ui_directory="$(basename $ui_dir)"
EOF

echo ""
echo "Contents of $runner_dir/vars.sh:"
echo "$STARS"
cat "$runner_dir/vars.sh"
echo "$STARS"

echo ""
echo "Updating vars.sh."
$SED '/ui_folder/d' "$runner_dir/vars.sh"
cat << EOF >> "$runner_dir/vars.sh"
export ui_folder="$app_name"
export support_directory_name="$(basename $ui_dir)"
EOF

echo ""
echo "$runner_dir/vars.sh (first 10 lines):"
echo "$STARS"
head -n 10 "$runner_dir/vars.sh"
echo "$STARS"

echo ""
echo "Contents of $runner_dir/archive.zip:"
echo "$STARS"
unzip -l "$runner_dir/archive.zip"
echo "$STARS"

# echo ""
# echo "Files in $runner_dir:"
# ls -alR "$runner_dir"

cd $HOME

printf "\n$STARS\n*\n* FINISHED: $SCRIPT_NAME $1 $2 $3.\n*\n$STARS\n\n"

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
