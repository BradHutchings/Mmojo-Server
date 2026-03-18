## 01. Build ELF Executable for Debian Linux
### About this Step
In this step, you will build an executable file that runs on Debian Linux operating systems for the CPU family in your computer. The supported CPU families are x86_64 and aarch64 (arm64). You can build with three compatibility options:
- **Compatible:** Runs on most systems that use a CPU from your computer's CPU family. 
- **Performant:** Runs on systems that use a recent CPU from your computer's CPU family.
  - For x86_64, these are x86_64 CPUs that support "level 3" flags, as defined by the gnu cc compiler.
  - For aarch64 (arm64), these are aarch64 CPUs that support ??? flags, as defined by the gnu cc compiler. These include all Apple M-series CPUs.
- **Native:** Runs on systems with a CPU that includes all of the CPU flags your computer's CPU includes. This includes your computer.

Windows Subsystem for Linux (WSL) supports NVIDIA GPUs through CUDA libraries. If you're building for WSL, be sure to enable CUDA below.

These build steps should be performed in a Debian Linux operating system like Ubuntu or Raspberry Pi. Please prepare your Debian environment by working through one these deploy recipes:
- [Deploy Mmojo Server on Windows (WSL)](/deploy/Windows-WSL/README.md) 
- [Deploy Mmojo Server on Debian / Ubuntu / Raspberry Pi](/deploy/Debian-Ubuntu-Pi/README.md) 
 
---
### Install Dependencies and GPU Support
Install dependencies. These may take 20 minutes or so to download and install. Reinstalling nodejs is necessary to get the right tools in place to rebuild the webui.
```
mm-prepare-install-dependencies.sh
mm-prepare-reinstall-nodejs.sh
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
if [ ! -d "$BUILD_DIR" ]; then
    mm-prepare-clone-llama-cpp.sh
    mm-prepare-patch-llama-cpp.sh
    mm-prepare-customize-webui.sh
fi
```

<!--
The customize script &mdash; `mm-prepare-customize-webui.sh` &mdash; occasionally skips setting the build date in the Mmojo Complete user interface. Run this command to make sure it only returns two results. If it returns more than two, delete the `$BUILD_DIR` and run the snippet above again.
```
grep -r "\[\[UPDATED" $BUILD_DIR
```
-->

Choose GPUs for your build if you're not building for Raspberry Pi 5.
```
. mm-gpus-choose.sh
```

Build native Mmojo Server tuned to the specific CPU of your PC:
```
_BUILD_SUBDIR=""
_PACKAGE_FILE=""
_TOUCH_FILE=""
_VARIATION="native"
if [[ $(cat /proc/cpuinfo | grep "Model") == *"Raspberry Pi 5"* ]]; then
    unset $GPUS_CHOICE
    _BUILD_SUBDIR="$BUILD_DIR/$EXECUTABLE_RPI5_AARCH64"
    _PACKAGE_FILE="Mmojo-Server-aarch64-rpi5.zip"
    _TOUCH_FILE="build-aarch64-rpi5"
    _VARIATION="pi"
elif [ $(uname -m) == "x86_64" ]; then
    _BUILD_SUBDIR="$BUILD_DIR/$EXECUTABLE_NATIVE_X86_64$GPUS_CHOICE"
    _PACKAGE_FILE="Mmojo-Server-x86_64-native$GPUS_CHOICE.zip"
    _TOUCH_FILE="build-x86_64-native$GPUS_CHOICE"
    _VARIATION="native"
elif [ $(uname -m) == "aarch64" ] || [ $(uname -m) == "arm64" ]; then
    _BUILD_SUBDIR="$BUILD_DIR/$EXECUTABLE_NATIVE_AARCH64$GPUS_CHOICE"
    _PACKAGE_FILE="Mmojo-Server-aarch64-native$GPUS_CHOICE.zip"
    _TOUCH_FILE="build-aarch64-native$GPUS_CHOICE"
    _VARIATION="native"
fi
mm-build-for-platform.sh $_VARIATION "$GPUS_CHOICE"
```

<details>
  <summary><b>Alternatively:</b> Build a more compatible Mmojo Server. It will run on most CPUs in your CPU family (x86_64 or aarch64).</summary>
  
```
_BUILD_SUBDIR=""
_PACKAGE_FILE=""
if [ $(uname -m) == "x86_64" ]; then
    _BUILD_SUBDIR="$BUILD_DIR/$EXECUTABLE_COMPATIBLE_X86_64$GPUS_CHOICE"
    _PACKAGE_FILE="Mmojo-Server-x86_64-comp$GPUS_CHOICE.zip"
    _TOUCH_FILE="build-x86_64-comp$GPUS_CHOICE"
elif [ $(uname -m) == "aarch64" ]; then
    _BUILD_SUBDIR="$BUILD_DIR/$EXECUTABLE_COMPATIBLE_AARCH64$GPUS_CHOICE"
    _PACKAGE_FILE="Mmojo-Server-aarch64-comp$GPUS_CHOICE.zip"
    _TOUCH_FILE="build-aarch64-comp$GPUS_CHOICE"
fi
mm-build-for-platform.sh compatible "$GPUS_CHOICE"
```
</details>

<details>
  <summary><b>Alternatively:</b> Build a performant Mmojo Server. It will run on recent CPUs in your CPU family (x86_64 or aarch64).</summary>
  
```
_BUILD_SUBDIR=""
_PACKAGE_FILE=""
if [ $(uname -m) == "x86_64" ]; then
    _BUILD_SUBDIR="$BUILD_DIR/$EXECUTABLE_PERFORMANT_X86_64$GPUS_CHOICE"
    _PACKAGE_FILE="Mmojo-Server-x86_64-perf$GPUS_CHOICE.zip"
    _TOUCH_FILE="build-x86_64-perf$GPUS_CHOICE"
elif [ $(uname -m) == "aarch64" ]; then
    _BUILD_SUBDIR="$BUILD_DIR/$EXECUTABLE_PERFORMANT_AARCH64$GPUS_CHOICE"
    _PACKAGE_FILE="Mmojo-Server-aarch64-perf$GPUS_CHOICE.zip"
    _TOUCH_FILE="build-aarch64-perf$GPUS_CHOICE"
fi
mm-build-for-platform.sh performant "$GPUS_CHOICE"
```
</details>

---
### Create a Deploy Directory
Create a `$DEPLOY_DIR` directory and copy Mmojo Server into it:
```
if [ "$DEPLOY_DIR" != "" ]; then
    mkdir -p "$DEPLOY_DIR"
    # rm -r -f "$DEPLOY_DIR"/*
    find $DEPLOY_DIR/* ! -name "*.gguf" -delete
    cp "$_BUILD_SUBDIR/bin/$_PACKAGE_MMOJO_SERVER_FILE" "$DEPLOY_DIR"
    cp -r "$BUILD_DIR/Mmojo-Complete" "$DEPLOY_DIR"
    cp "$REPO_DIR/build/support-files/mmojo-server-args-complete" "$DEPLOY_DIR/$_PACKAGE_MMOJO_SERVER_ARGS_FILE"
    cp "$REPO_DIR/LICENSE" "$DEPLOY_DIR"
    touch "$DEPLOY_DIR/$_TOUCH_FILE"
fi
```

<details>
  <summary><b>Optional:</b> Create a <code>mmojo-server-args</code> file in the <code>$DEPLOY_DIR</code> to launch Mmojo Server with chat UI.</summary>
<br/>
    
Chat user interfaces are an abomination, but have at it if you must! 😆  -Brad
```
cp "$REPO_DIR/build/support-files/mmojo-server-args-chat" "$DEPLOY_DIR/$_PACKAGE_MMOJO_SERVER_ARGS_FILE"
```
</details>


<!--
Create a mmojo-server-args file in the `$DEPLOY_DIR` directory to launch Mmojo Server with the Mmojo Complete UI:
```
# make a $_PACKAGE_MMOJO_SERVER_ARGS_FILE file
cat << EOF > "$DEPLOY_DIR/$_PACKAGE_MMOJO_SERVER_ARGS_FILE"
--path
/app/Mmojo-Complete
--default-ui-endpoint
chat
--host
127.0.0.1
--port
8080
--batch-size
256
--threads-http
8
--ctx-size
32768 
EOF
```

<details>
  <summary><b>Alternatively:</b> Create a <code>mmojo-server-args</code> file in the <code>$DEPLOY_DIR</code> to launch Mmojo Server with chat UI.</summary>
<br/>
    
Chat user interfaces are an abomination, but have at it if you must! 😆  -Brad
```
# make a $_PACKAGE_MMOJO_SERVER_ARGS_FILE file
cat << EOF > "$DEPLOY_DIR/$_PACKAGE_MMOJO_SERVER_ARGS_FILE"
--host
127.0.0.1
--port
8080
--batch-size
256
--threads-http
8
--ctx-size
32768 
EOF
```
</details>

**Future:** These are good candidate for mm-scripts.
-->

---
### Optional: Add mmojo-rpc-server to Deploy Directory
You built the Mmojo RPC Server too. You can copy it to the `$DEPLOY_DIR` directory as well.
```
cp "$_BUILD_SUBDIR/bin/$_PACKAGE_MMOJO_RPC_SERVER_FILE" "$DEPLOY_DIR"
cp "$REPO_DIR/build/support-files/mmojo-rpc-server-args" "$DEPLOY_DIR/$_PACKAGE_MMOJO_RPC_SERVER_ARGS_FILE"
```

---
### Review Your Work
Let's list the contents of the `$DEPLOY_DIR` directory and review your work:
```
ls -l $DEPLOY_DIR
```

It should look like:

<img width="656" height="118" alt="image" src="https://github.com/user-attachments/assets/fb38bb9a-8285-42f5-a5ca-92301585ba72" />

---
### Proceed
- **Next:** [02. Test ELF Executable for Debian Linux](02-Test-ELF-Debian-Linux.md)
- **Previous:** This is the first step in this section.
- **Up:** [Build Mmojo Server](../README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
