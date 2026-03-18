#!/bin/bash

################################################################################
# This script lets the user choose which GPU support to include in a build.
#
# TO-DO:
# - Figure out has_metal.
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
printf "\n$STARS\n*\n* STARTED: $SCRIPT_NAME.\n*\n$STARS\n\n"

build="native"

builds=()
builds+=("native")
builds+=("perf")
builds+=("comp")

if [ ${#builds[@]} -gt "0" ]; then
    echo "Please pick the build you would like to perform:"
    for ((i=0;i<${#builds[@]};i++)); do 
        string="$(($i+1))) ${builds[$i]}"
        printf "%s\n" "$string"
    done

    echo
    read -p 'Which build would you like to perform? ' opt
    echo
    
    echo "You chose: $opt"

    choice="None"
    if [ "$opt" -gt "0" ] && [ "$opt" -le ${#builds[@]} ]; then
        choice=${builds[$opt-1]}
    fi
    
    if [ "$choice" == "None" ]; then
        build="native"
    else
        build=$choice
    fi
    echo "Build: $build"
else
    echo "No builds are available."
fi

cd $HOME

echo $build > "/tmp/${SCRIPT_NAME%.*}.out"

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
