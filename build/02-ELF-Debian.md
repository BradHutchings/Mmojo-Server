## Build ELF Executable for Debian Linux
### About this Step
In this step, you will build an executable file that runs on Debian Linux operating systems for the CPU family in your computer. The supported CPU families are x86_64 and aarch64 (arm64). You can build with three compatibility options:
- **Compatible:** Runs on most systems that use a CPU from your computer's CPU family. 
- **Performant:** Runs on systems that use a recent CPU from your computer's CPU family.
  - For x86_64, these are x86_64 CPUs that support "level 3" flags, as defined by the gnu cc compiler.
  - For aarch64 (arm64), these are aarch64 CPUs that support ??? flags, as defined by the gnu cc compiler. These include all Apple M-series CPUs.
- **Native:** Runs on systems with a CPU that includes all of the CPU flags your computer's CPU includes. This includes your computer.

Windows Subsystem for Linux (WSL) supports NVIDIA GPUs through CUDA libraries. If you're building for WSL, be sure to enable CUDA below.

These build steps work well in a Debian Linux operating system like Ubuntu or Raspberry Pi, or in a Ubuntu WSL instance on Windows 10 or 11.
 
---
### Install Dependencies and GPU Support
Install dependencies. These may take 20 minutes or so to download and install.
```
mm-prepare-install-dependencies.sh
```

Install CUDA and Vulkan support. These may take 10 minutes or so to download and install.
```
sudo apt install -y nvidia-cuda-toolkit
sudo apt install -y libvulkan-dev glslc vulkan-tools
echo "NOTE: Install CUDA and Vulkan tools finished."
```

---
### Build Mmojo Server
Prepare to build Mmojo Server (llama.cpp with patches and extensions):
```
mm-prepare-clone-llama-cpp.sh
mm-prepare-patch-llama-cpp.sh
mm-prepare-customize-webui.sh
```

Choose GPUs for your build if you're not building for Raspberry Pi 5.
```
. mm-gpus-choose.sh
```

Build native Mmojo Server tuned to the specific CPU of your PC:
```
BUILD_SUBDIR=""
ZIP_FILE=""
TOUCH_FILE=""
if [[ $(cat /proc/cpuinfo | grep "Model") == *"Raspberry Pi 5"* ]]; then
    unset $GPUS_CHOICE
    BUILD_SUBDIR="$BUILD_DIR/$BUILD_EXECUTABLE_RPI5_AARCH64"
    ZIP_FILE="Mmojo-Server-aarch64-rpi5.zip"
    TOUCH_FILE="build-aarch64-rpi5"
elif [ $(uname -m) == "x86_64" ]; then
    BUILD_SUBDIR="$BUILD_DIR/$BUILD_EXECUTABLE_NATIVE_X86_64$GPUS_CHOICE"
    ZIP_FILE="Mmojo-Server-x86_64-native$GPUS_CHOICE.zip"
    TOUCH_FILE="build-x86_64-native$GPUS_CHOICE"
elif [ $(uname -m) == "aarch64" ]; then
    BUILD_SUBDIR="$BUILD_DIR/$BUILD_EXECUTABLE_NATIVE_AARCH64$GPUS_CHOICE"
    ZIP_FILE="Mmojo-Server-aarch64-native$GPUS_CHOICE.zip"
    TOUCH_FILE="build-aarch64-native$GPUS_CHOICE"
fi
$MMOJO_SERVER_SCRIPTS/510-Build-for-Platform.sh native "$GPUS_CHOICE"
```

<details>
  <summary><b>Alternatively:</b> Build a more compatible Mmojo Server. It will run on most CPUs in your CPU family (x86_64 or aarch64).</summary>
  
```
$MMOJO_SERVER_SCRIPTS/510-Build-for-Platform.sh compatible "$GPUS_CHOICE"
BUILD_SUBDIR=""
ZIP_FILE=""
if [ $(uname -m) == "x86_64" ]; then
    BUILD_SUBDIR="$BUILD_DIR/$BUILD_EXECUTABLE_COMPATIBLE_X86_64$GPUS_CHOICE"
    ZIP_FILE="Mmojo-Server-x86_64-comp$GPUS_CHOICE.zip"
    TOUCH_FILE="build-x86_64-comp$GPUS_CHOICE"
elif [ $(uname -m) == "aarch64" ]; then
    BUILD_SUBDIR="$BUILD_DIR/$BUILD_EXECUTABLE_COMPATIBLE_AARCH64$GPUS_CHOICE"
    ZIP_FILE="Mmojo-Server-aarch64-comp$GPUS_CHOICE.zip"
    TOUCH_FILE="build-aarch64-comp$GPUS_CHOICE"
fi
```
</details>

<details>
  <summary><b>Alternatively:</b> Build a performant Mmojo Server. It will run on recent CPUs in your CPU family (x86_64 or aarch64).</summary>
  
```
$MMOJO_SERVER_SCRIPTS/510-Build-for-Platform.sh performant "$GPUS_CHOICE"
BUILD_SUBDIR=""
ZIP_FILE=""
if [ $(uname -m) == "x86_64" ]; then
    BUILD_SUBDIR="$BUILD_DIR/$BUILD_EXECUTABLE_PERFORMANT_X86_64$GPUS_CHOICE"
    ZIP_FILE="Mmojo-Server-x86_64-perf$GPUS_CHOICE.zip"
    TOUCH_FILE="build-x86_64-perf$GPUS_CHOICE"
elif [ $(uname -m) == "aarch64" ]; then
    BUILD_SUBDIR="$BUILD_DIR/$BUILD_EXECUTABLE_PERFORMANT_AARCH64$GPUS_CHOICE"
    ZIP_FILE="Mmojo-Server-aarch64-perf$GPUS_CHOICE.zip"
    TOUCH_FILE="build-aarch64-perf$GPUS_CHOICE"
fi
```
</details>

---
### Create a Run Directory
Create a run directory:
```
mkdir -p $RUN_DIR
rm -r -f "$RUN_DIR"/*
cp $BUILD_SUBDIR/bin/$PACKAGE_MMOJO_SERVER_FILE $RUN_DIR
cp -r $BUILD_DIR/Mmojo-Complete $RUN_DIR
# make a $PACKAGE_MMOJO_SERVER_ARGS_FILE file
touch "$RUN_DIR/$TOUCH_FILE"
```

Create a mmojo-server-args file in the $RUN_DIR to launch Mmojo Server with the Mmojo Complete UI:
```
cp -r $BUILD_DIR/Mmojo-Complete $RUN_DIR
# make a $PACKAGE_MMOJO_SERVER_ARGS_FILE file
cat << EOF > "$RUN_DIR/$PACKAGE_MMOJO_SERVER_ARGS_FILE"
--path
/app/Mmojo-Complete
--default-ui-endpoint
chat
--host
0.0.0.0
--port
8080
--batch-size
2048
--threads-http
8
--ctx-size
32768 
EOF
```

<details>
  <summary><b>Alternatively:</b> Create a <code>mmojo-server-args</code> file in the <code>$RUN_DIR</code> to launch Mmojo Server with chat UI.</summary>
<br/>
    
Chat user interfaces are an abomination, but have at it if you must! 😆  -Brad
```
# make a $PACKAGE_MMOJO_SERVER_ARGS_FILE file
cat << EOF > "$RUN_DIR/$PACKAGE_MMOJO_SERVER_ARGS_FILE"
--host
0.0.0.0
--port
8080
--batch-size
2048
--threads-http
8
--ctx-size
32768 
EOF
```
</details>

**Future:** These are good candidate for mm-scripts.

---
### Review Your Work
Let's list the contents of the `$HOME/Mmojo-Server` directory and review your work:
```
ls -al $RUN_DIR
```

It should look like:

<img width="814" height="159" alt="image" src="https://github.com/user-attachments/assets/7d59ae18-90ff-4137-840e-dbf7e9c10891" />

---
### Test Your Build
Choose a model to include in your `.zip` file. I'd suggest choosing **Google Gemma 270M Instruct v3**.
```
mm-model-choose.sh
```

```
mm-debug
```

---
### (Optional) Create a .zip Package
You can create a `.zip` package that can be restored to the run directory later. Packages are saved to your `$HOME/mm-packages` directory after zipping. You don't need to do this.

Make a `.zip` file and move it to your `$PACKAGES_DIR` directory:
```
if test -n "$RUN_DIR"; then
  cd "$RUN_DIR"
  zip -r $ZIP_FILE mmojo-server mmojo-server-args Mmojo-Complete $TOUCH_FILE
  mkdir -p $PACKAGES_DIR
  mv -f $ZIP_FILE $PACKAGES_DIR
  cd $HOME
fi
```

---
### Proceed
- **Next:** [03. Build ELF Executable for Red Hat Enterprise Linux](03-ELF-RHEL.md)
- **Previous:** [01. Build APE for All Platforms](01-APE-All-Platforms.md)
- **Up:** [Build Mmojo Server](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
