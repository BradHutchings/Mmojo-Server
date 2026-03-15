#!/bin/bash

################################################################################
# This script adds certificates to a Mmojo Runner archive, updates vars.sh.
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
cert_file="$2"
key_file="$3"

# Convert $runner_dir to an absolute path.
case $runner_dir in
  ("/"*) ;;
  (*)    runner_dir="$(pwd)/$runner_dir";;
esac

# Strip a trailing "/" from $runner_dir if it has one.
runner_dir="$(dirname $runner_dir)/$(basename $runner_dir)"

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

echo ""
echo " \$runner_dir: $runner_dir"
echo "  \$cert_file: $cert_file"
echo "   \$key_file: $key_file"
echo "\$archive_zip: $archive_zip"
echo "\$support_dir: $support_dir"
echo "   \$app_name: $app_name"

if [ -d "$runner_dir" ] && [ -f "$cert_file" ] && [ -f "$key_file" ]; then
    echo ""
    echo "Copying .crt and .key files."
    mkdir -p "$support_dir/certs"
    cp "$cert_file" "$support_dir/certs"
    cp "$key_file" "$support_dir/certs"

    echo ""
    echo "Adding certs to $archive_zip."
    cd $runner_dir
    zip -u -0 -q "$archive_zip" "$support_directory_name"/certs/*

    echo ""
    echo "Updating vars.sh."
    $SED -i -e '/ssl_cert_file/d' "$runner_dir/vars.sh"
    $SED -i -e '/ssl_key_file/d' "$runner_dir/vars.sh"
cat << EOF >> "$runner_dir/vars.sh"
export ssl_cert_file="certs/$(basename $cert_file)"
export ssl_key_file="certs/$(basename $key_file)"
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
