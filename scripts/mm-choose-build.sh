#!/bin/bash

################################################################################
# This script lets the user choose a mmojo-server build.
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
printf "\n**********\n*\n* STARTED: mm-choose-build.sh.\n*\n**********\n\n"

unset CHOSEN_BUILD
unset CHOSEN_BUILD_PATH
unset CHOSEN_BUILD_INFO

build_paths=()
build_paths+=("$BUILD_DIR/$BUILD_DEBUG/bin/mmojo-server")
build_paths+=("$BUILD_DIR/$BUILD_COSMO_COMPATIBLE_APE/mmojo-server-ape")
build_paths+=("$BUILD_DIR/$BUILD_COSMO_PERFORMANT_APE/mmojo-server-ape")
build_paths+=("$BUILD_DIR/$BUILD_EXECUTABLE_COMPATIBLE_X86_64/bin/mmojo-server")
build_paths+=("$BUILD_DIR/$BUILD_EXECUTABLE_PERFORMANT_X86_64/bin/mmojo-server")
build_paths+=("$BUILD_DIR/$BUILD_EXECUTABLE_NATIVE_X86_64/bin/mmojo-server")
build_paths+=("$BUILD_DIR/$BUILD_EXECUTABLE_COMPATIBLE_AARCH64/bin/mmojo-server")
build_paths+=("$BUILD_DIR/$BUILD_EXECUTABLE_PERFORMANT_AARCH64/bin/mmojo-server")
build_paths+=("$BUILD_DIR/$BUILD_EXECUTABLE_NATIVE_AARCH64/bin/mmojo-server")

build_names=()
build_names+=("DEBUG")
build_names+=("APE-Compatible")
build_names+=("APE-Performant")
build_names+=("CPU-Compatible-x86_64")
build_names+=("CPU-Performant-x86_64")
build_names+=("CPU-Native-x86_64")
build_names+=("CPU-Compatible-aarch64")
build_names+=("CPU-Performant-aarch64")
build_names+=("CPU-Native-aarch64")

available_build_paths=()
available_build_names=()
i=0
for build_path in "${build_paths[@]}"; do
  if [ -f "${build_path}" ]; then
    # echo "$i. $build_path -- ${build_names[$i]}"
    available_build_paths+=($build_path)
    available_build_names+=(${build_names[$i]})
  fi
  i=$((i+1))
done

# List the builds and their paths.
if true; then
  echo ""
  echo "Build names and paths."
  i=0
  for build_path in "${build_paths[@]}"; do
    echo "$i. ${build_names[$i]} -- $build_path"
    i=$((i+1))
  done
fi

# List the available builds and their paths.
if true; then
  echo ""
  echo "Available build names and paths."
  i=0
  for build_path in "${available_build_paths[@]}"; do
    echo "$i. ${available_build_names[$i]} -- $build_path"
    i=$((i+1))
  done
fi

echo ""
echo "These builds are available to package:"

PS3="Please choose a build:"
select choice in "${available_build_names[@]}"; do
    export CHOSEN_BUILD=$choice
    echo "\$choice: $choice."

    if [[ -n "$choice" ]]; then
        # Find the index of the selected item
        for i in "${!build_names[@]}"; do
            if [[ "${build_names[$i]}" == "$choice" ]]; then
                echo "You selected: $choice (index: $i)"
                export CHOSEN_BUILD_PATH=${build_paths[$i]}
                break # Exit the inner loop once found
            fi
        done
        break # Exit the select loop
    else
        unset CHOSEN_BUILD
        unset CHOSEN_BUILD_PATH
        unset CHOSEN_BUILD_INFO
        break
    fi
done

if [ -v CHOSEN_BUILD ]; then
    cbi=$CHOSEN_BUILD
    # if [ "$cbi" != "APE" ]; then
    #    cbi+="-$(uname -m)-$(uname -s)"
    # fi
    export CHOSEN_BUILD_INFO=$cbi
fi

echo ""
echo "Your chosen build, build info, build path:"
echo "$CHOSEN_BUILD - $CHOSEN_BUILD_INFO - $CHOSEN_BUILD_PATH"

cd $HOME

printf "\n**********\n*\n* FINISHED: mm-choose-build.sh.\n*\n**********\n\n"

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
