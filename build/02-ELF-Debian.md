## Build ELF Executable for Debian Linux
**THE BUILD SSECTION IS UNDER CONSTRUCTION. THESE INSTRUCTIONS PROBABLY DON'T WORK.**

---
### About this Step
In this step, you will build an executable file that runs on Debian Linux operating systems for the CPU family in your computer. The supported CPU families are x86_64 and aarch64 (arm64). You can build with three compatibility options:
- **Compatible:** Runs on most systems that use a CPU from your computer's CPU family. 
- **Performant:** Runs on systems that use a recent CPU from your computer's CPU family.
  - For x86_64, these are x86_64 CPUs that support "level 3" flags, as defined by the gnu cc compiler.
  - For aarch64 (arm64), these are aarch64 CPUs that support ??? flags, as defined by the gnu cc compiler. These include all Apple M-series CPUs.
- **Native:** Runs on systems with a CPU that includes all of the CPU flags your computer's CPU includes. This includes your computer.

Windows Subsystem for Linux (WSL) supports NVIDIA GPUs through CUDA libraries. If you're building for WSL, be sure to enable CUDA below.

These build steps work well in a Debian Linux operating system like Ubuntu or Raspberry Pi, or in a Ubuntu WSL instance on Windows 10 or 11.

**Jump Back:** (Does this make sense here?)
- Deploy Mmojo Server APE: ???
- **(remove)** Deploy Mmojo Server on Debian / Ubuntu / Raspberry Pi: [05. Download Mmojo Server](05-Download-Mmojo-Server.md)
- **(remove)** Deploy Mmojo Server on Windows (WSL): [05. Download Mmojo Server](../200-Windows-WSL/05-Download-Mmojo-Server.md)
 
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
### Build Native Mmojo Server
Prepare to build:
```
mm-prepare-clone-repo.sh
mm-prepare-patch-llama-cpp.sh
mm-prepare-customize-webui-sh
```

Choose GPUs for your build if you're not building for Raspberry Pi 5.
```
. mm-use-gpus.sh
```

Build native Mmojo Server tuned to the specific CPU of your PC:
```
BUILD_SUBDIR=""
ZIP_FILE=""
TOUCH_FILE=""
if [[ $(cat /proc/cpuinfo | grep "Model") == *"Raspberry Pi 5"* ]]; then
    unset $CHOSEN_GPUS
    BUILD_SUBDIR="$BUILD_DIR/$BUILD_EXECUTABLE_RPI5_AARCH64"
    ZIP_FILE="Mmojo-Server-aarch64-rpi5.zip"
    TOUCH_FILE="build-aarch64-rpi5"
elif [ $(uname -m) == "x86_64" ]; then
    BUILD_SUBDIR="$BUILD_DIR/$BUILD_EXECUTABLE_NATIVE_X86_64$CHOSEN_GPUS"
    ZIP_FILE="Mmojo-Server-x86_64-native$CHOSEN_GPUS.zip"
    TOUCH_FILE="build-x86_64-native$CHOSEN_GPUS"
elif [ $(uname -m) == "aarch64" ]; then
    BUILD_SUBDIR="$BUILD_DIR/$BUILD_EXECUTABLE_NATIVE_AARCH64$CHOSEN_GPUS"
    ZIP_FILE="Mmojo-Server-aarch64-native$CHOSEN_GPUS.zip"
    TOUCH_FILE="build-aarch64-native$CHOSEN_GPUS"
fi
$MMOJO_SERVER_SCRIPTS/510-Build-for-Platform.sh native "$CHOSEN_GPUS"
```

<details>
  <summary>Alternatively, build a more compatible Mmojo Server. It will run on most CPUs in your CPU family (x86_64 or aarch64).</summary>
  
```
$MMOJO_SERVER_SCRIPTS/510-Build-for-Platform.sh compatible "$CHOSEN_GPUS"
BUILD_SUBDIR=""
ZIP_FILE=""
if [ $(uname -m) == "x86_64" ]; then
    BUILD_SUBDIR="$BUILD_DIR/$BUILD_EXECUTABLE_COMPATIBLE_X86_64$CHOSEN_GPUS"
    ZIP_FILE="Mmojo-Server-x86_64-comp$CHOSEN_GPUS.zip"
    TOUCH_FILE="build-x86_64-comp$CHOSEN_GPUS"
elif [ $(uname -m) == "aarch64" ]; then
    BUILD_SUBDIR="$BUILD_DIR/$BUILD_EXECUTABLE_COMPATIBLE_AARCH64$CHOSEN_GPUS"
    ZIP_FILE="Mmojo-Server-aarch64-comp$CHOSEN_GPUS.zip"
    TOUCH_FILE="build-aarch64-comp$CHOSEN_GPUS"
fi
```
</details>

<details>
  <summary>Alternatively, build a performant Mmojo Server. It will run on recent CPUs in your CPU family (x86_64 or aarch64).</summary>
  
```
$MMOJO_SERVER_SCRIPTS/510-Build-for-Platform.sh performant "$CHOSEN_GPUS"
BUILD_SUBDIR=""
ZIP_FILE=""
if [ $(uname -m) == "x86_64" ]; then
    BUILD_SUBDIR="$BUILD_DIR/$BUILD_EXECUTABLE_PERFORMANT_X86_64$CHOSEN_GPUS"
    ZIP_FILE="Mmojo-Server-x86_64-perf$CHOSEN_GPUS.zip"
    TOUCH_FILE="build-x86_64-perf$CHOSEN_GPUS"
elif [ $(uname -m) == "aarch64" ]; then
    BUILD_SUBDIR="$BUILD_DIR/$BUILD_EXECUTABLE_PERFORMANT_AARCH64$CHOSEN_GPUS"
    ZIP_FILE="Mmojo-Server-aarch64-perf$CHOSEN_GPUS.zip"
    TOUCH_FILE="build-aarch64-perf$CHOSEN_GPUS"
fi
```
</details>

---
### Create a Run Directory
Create a run directory.
```
mkdir -p $RUN_DIR
rm -r -f "$RUN_DIR"/*
cp $BUILD_SUBDIR/bin/$PACKAGE_MMOJO_SERVER_FILE $RUN_DIR
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
touch "$RUN_DIR/$TOUCH_FILE"
```

**Future:** This is a good candidate for an mm-script.

<details>
  <summary>Alternatively, create a run directory where Mmojo Server runs in chat mode..</summary>
<br/>
    
Chat user interfaces are an abomination, but have at it if you must! 😆  -Brad
```
mkdir -p $RUN_DIR
rm -r -f "$RUN_DIR"/*
cp $BUILD_SUBDIR/bin/$PACKAGE_MMOJO_SERVER_FILE $RUN_DIR
cp -r $BUILD_DIR/Mmojo-Complete $RUN_DIR
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
touch "$RUN_DIR/$TOUCH_FILE"
```
</details>

---
### Review Your Work
Let's list the contents of the `$HOME/Mmojo-Server` directory and review your work:
```
ls -al $RUN_DIR
```

It should look like:

<img width="814" height="159" alt="image" src="https://github.com/user-attachments/assets/7d59ae18-90ff-4137-840e-dbf7e9c10891" />

---
### (Optional) Make a .zip File
Brad makes .zip files for the Hugging Face downloads. They are moved to your `$HOME` directory after zipping. You don't need to do this.
```
if test -n "$RUN_DIR"; then
  cd "$RUN_DIR"
  # TODO: If we're on aarch64, change the $ZIP_FILE from -x86- to -arm-
  zip -r $ZIP_FILE mmojo-server mmojo-server-args Mmojo-Complete $TOUCH_FILE
  mv $ZIP_FILE $HOME
  cd $HOME
fi
```

---
### Proceed
- **Next:**
  - Deploy Mmojo Server on Debian / Ubuntu / Raspberry Pi: [06. Control Mmojo Server](06-Control-Mmojo-Server.md)
  - Deploy Mmojo Server on Windows (WSL): [06. Control Mmojo Server](../200-Windows-WSL/06-Control-Mmojo-Server.md)
- **Previous:**
  - Deploy Mmojo Server on Debian / Ubuntu / Raspberry Pi: [05. Download Mmojo Server](05-Download-Mmojo-Server.md)
  - Deploy Mmojo Server on Windows (WSL): [05. Download Mmojo Server](../200-Windows-WSL/05-Download-Mmojo-Server.md)
- **Up:**
  - [Deploy Mmojo Server on Debian / Ubuntu / Raspberry Pi](README.md)
  - [Deploy Mmojo Server on Windows (WSL)](../200-Windows-WSL/README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
