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

unset CHOSEN_GPUS
unset CHOSEN_GPUS_NAMES

gpu_combos=()
has_cuda=0
has_hip=0
has_vulkan=0
has_metal=0

if command -v nvcc >/dev/null 2>&1; then
    has_cuda=1
fi
if command -v hipconfig >/dev/null 2>&1; then
    has_hip=1
fi
if command -v vulkaninfo >/dev/null 2>&1; then
    has_vulkan=1
fi
# Metal???

gpu_combos+=("None")
if (( has_cuda == 1 )); then                                     gpu_combos+=("CUDA");                   fi
if (( has_cuda == 1 && has_hip == 1 )); then                     gpu_combos+=("CUDA + HIP");             fi
if (( has_cuda == 1 && has_hip == 1 && has_vulkan == 1 )); then  gpu_combos+=("CUDA + HIP + VULKAN");    fi
if (( has_cuda == 1 && has_vulkan == 1 )); then                  gpu_combos+=("CUDA + VULKAN");          fi
if (( has_hip == 1 )); then                                      gpu_combos+=("HIP");                    fi
if (( has_hip == 1 && has_vulkan == 1 )); then                   gpu_combos+=("HIP + VULKAN");           fi
if (( has_vulkan == 1 )); then                                   gpu_combos+=("VULKAN");                 fi
if (( has_metal == 1 )); then                                    gpu_combos+=("METAL");                  fi

if [ ${#gpu_combos[@]} > 0 ]; then
    echo "Please pick the GPU combination you want your build to support:"
    select choice in "${gpu_combos[@]}"; do
        break
    done
    echo "You chose: $choice"
    if [ "$choice" == "None" ]; then
        gpus=""
        choice=""
    else
        gpus="-${choice/ + /-}"
        gpus="${gpus/CUDA/CUD}"
        gpus="${gpus/HIP/HIP}"
        gpus="${gpus/VULKAN/VUL}"
        gpus="${gpus/METAL/MET}"
        gpus=${gpus,,}
        echo "GPUs: $gpus"
    fi
    
    export CHOSEN_GPUS=$gpus
    export CHOSEN_GPUS_NAMES=$choice
else
    echo "Could not find dev kits for CUDA, HIP, or VULKAN."
fi

cd $HOME

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
