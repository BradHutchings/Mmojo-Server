#!/bin/bash

################################################################################
# This is a self extracting archive script that runs on:
# - Linux (x86_64)
# - Linux (aarch64 / arm64)
# - macOS (x86_64)
# - macOS (aarch64 / arm64)
#
# Window users, you can run this under Windows Subsystem for Linux. Go here to
# find out how:
#
# [ link to Mmojo Runner info. ]
#
# What's in this archive:
# - Preamble script
#   - unzips support assets, .gguf models, and application (if not already present)
#   - runs application
#
# - /models/[model-name].gguf
#   - This gets unzipped to support folder.
#   - Extracted 2nd.
#
# - /[SUPPORT_DIRECTORY_NAME]/...
#   - Stuff in the support directory: certs, website, args.
#   - Extracted 1st.
#
# - /elf/x86_64/Compatible/[APP_NAME]      - first app option for elf/x86_64
#   /elf/x86_64/Compatible/description
#   /elf/x86_64/Performant/[APP_NAME]
#   /elf/x86_64/Performant/description
#   /elf/x86_64/Performant-NVIDIA/[APP_NAME]
#   /elf/x86_64/Performant-NVIDIA/description
#   ...
# - /elf/aarch64/Compatible/[APP_NAME]      - first app option for elf/aarch64
#   /elf/aarch64/Compatible/description
#   /elf/aarch64/Performant/[APP_NAME]
#   /elf/aarch64/Performant/description
#   ...
# - /mach-o/x86_64/1/[APP_NAME]      - first app option for mach-o/x86_64
#   /mach-o/x86_64/1/description
#   /mach-o/x86_64/2/[APP_NAME]
#   /mach-o/x86_64/2/description
#   ...
# - /mach-o/aarch64/1/[APP_NAME]      - first app option for mach-o/aarch64
#   /mach-o/aarch64/1/description
#   /mach-o/aarch64/2/[APP_NAME]
#   /mach-o/aarch64/2/description
#   ...
# 
# There might be multiple options to support, e.g. performance levels, GPU builds, etc.
#
# See licensing note at end.
################################################################################

my_path="$0"
os=$(uname -s)
hw=$(uname -m)
format=""
app_name="[APP_NAME]"
support_directory_name="[SUPPORT_DIRECTORY_NAME]"
this_directory = "$(dirname $0)"

case "$os" in
    Linux)
        format="elf"
        ;;
    Darwin)
        format="mach-o"
        ;;
    *) # The default case
        echo "I'm sorry. This application does not run on this operating system."
        exit 1
        ;;
esac

echo "               my_path: $my_path"
echo "                    os: $os"
echo "                    hw: $hw"
echo "                format: $format"
echo "              app_name: $app_name"
echo "support_directory_name: $support_directory_name"

# if $app_name exists in the local directory and is executable, run it nohup, exit script.
if [ -f "$this_directory/$app_name" ]; then
    # is it executable?
    if [ 1 ]; then
        cd "$this_directory"
        nohup $app_name &
        exit
    fi
fi

# Find candidates for app extraction
format_hw="$format/$hw"
candidates=$(unzip -j "$my_path" "$format_hw/*'")

echo ""
echo "Candidates:"
echo $candidates

# User chooses a candidate, or if there is just one, it's chosen without user intervention.

# Unzip the support folder into the local directory.
# Unzip the model(s) into the support folder.
# Unzip the chosen candidate into the local directory as $app_name.
# chmod the app a+x
# Run the app.

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
