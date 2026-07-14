## 01. Build Mmojo Server (for Debian Linux)
### About this Step
In this step, you will build ELF executables of Mmojo Server, Mmojo RPC Server, and llama.cpp targets for your computer's CPU family &mdash; x86_64 or aarch64 (arm64).

---
### Install Dependencies and GPU Support
Install dependencies. These may take 20 minutes or so to download and install. Reinstalling nodejs is necessary to get the right tools in place to rebuild the webui. You only need to do these steps once on your system.
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
### Create the Build Directory
Prepare to build Mmojo Server (llama.cpp with patches and extensions):
```
if [ ! -d "$BUILD_DIR" ]; then
    mm-prepare-clone-llama-cpp.sh
    mm-prepare-patch-llama-cpp.sh
    # mm-prepare-customize-webui.sh
fi
```

---
### Build Mmojo Server
Choose the build type (native, performant, compatible):
```
mm-build-choose.sh
_BUILD_CHOICE="-$(cat /tmp/mm-build-choose.out)"
rm /tmp/mm-build-choose.out
```

Choose GPUs for your build:
```
mm-gpus-choose.sh
_GPUS_CHOICE=$(cat /tmp/mm-gpus-choose.out)
rm /tmp/mm-gpus-choose.out
```

Enable 8 CPU cores for the build:
```
export CMAKE_BUILD_PARALLEL_LEVEL=8
```

Build Mmojo Server with your build choice and gpus choice:
```
_BUILD_SUBDIR=""
_PACKAGE_FILE=""
_RPC_PACKAGE_FILE=""
_TOUCH_FILE=""
if [[ $(cat /proc/cpuinfo | grep "Model") = *"Raspberry Pi 5"* ]] && [ "$_BUILD_CHOICE" = "-native" ]; then
    _GPUS_CHOICE=""
    _BUILD_CHOICE="pi"
    _BUILD_SUBDIR="$BUILD_DIR/$EXECUTABLE_RPI5_AARCH64"
    _PACKAGE_FILE="Mmojo-Server-aarch64-rpi5.zip"
    _RPC_PACKAGE_FILE="Mmojo-RPC-Server-aarch64-rpi5.zip"
    _TOUCH_FILE="build-aarch64-rpi5"
elif [ $(uname -m) = "x86_64" ]; then
    echo "Building for Intel Macs is not supported yet."
    _BUILD_SUBDIR="$BUILD_SUBDIRECTORY_DEBIAN_X86_64$_BUILD_CHOICE$_GPUS_CHOICE"
    _PACKAGE_FILE="Mmojo-Server-macos-x86_64-native$_GPUS_CHOICE.zip"
    _RPC_PACKAGE_FILE="Mmojo-RPC-Server-aarch64-rpi5.zip"
    _TOUCH_FILE="$BUILD_SUBDIRECTORY_DEBIAN_X86_64$_BUILD_CHOICE$_GPUS_CHOICE"
elif [ $(uname -m) = "aarch64" ] || [ $(uname -m) = "arm64" ]; then
    _BUILD_SUBDIR="$BUILD_SUBDIRECTORY_DEBIAN_AARCH64$_BUILD_CHOICE$_GPUS_CHOICE"
    _PACKAGE_FILE="Mmojo-Server-macos-arm64-$_BUILD_CHOICE$_GPUS_CHOICE.zip"
    _RPC_PACKAGE_FILE="Mmojo-RPC-Server-macos-arm64-$_BUILD_CHOICE$_GPUS_CHOICE.zip"
    _TOUCH_FILE="$BUILD_SUBDIRECTORY_DEBIAN_AARCH64$_BUILD_CHOICE$_GPUS_CHOICE"
fi
mm-build-for-platform.sh "$_BUILD_SUBDIR" "$_BUILD_CHOICE" "$_GPUS_CHOICE"
```

---
### Create a Deploy Directory
Create a `$DEPLOY_DIR` directory and copy Mmojo Server, Mmojo RPC Server, and supporting files into it:
```
if [ "$DEPLOY_DIR" != "" ]; then
    mkdir -p "$DEPLOY_DIR"
    find $DEPLOY_DIR/* \( ! -name "*.gguf" -a ! -name "*-args" \) -delete
    cp "$BUILD_DIR/$_BUILD_SUBDIR/bin/$_PACKAGE_MMOJO_SERVER_FILE" "$DEPLOY_DIR"
    cp -r "$BUILD_DIR/Mmojo-Complete" "$DEPLOY_DIR"
    if [ ! -f "$DEPLOY_DIR/$_PACKAGE_MMOJO_SERVER_ARGS_FILE" ]; then
        cp "$REPO_DIR/build/support-files/mmojo-server-args-complete" "$DEPLOY_DIR/$_PACKAGE_MMOJO_SERVER_ARGS_FILE"
    fi
    cp "$REPO_DIR/build/support-files/mmojo-chat.html" "$DEPLOY_DIR/Connect-to-Mmojo-Chat.html"
    cp "$REPO_DIR/build/support-files/mmojo-connect.html" "$DEPLOY_DIR/Connect-to-Mmojo-Connect.html"
    cp "$REPO_DIR/LICENSE" "$DEPLOY_DIR"
    cp "$BUILD_DIR/$_BUILD_SUBDIR/bin/$_PACKAGE_MMOJO_RPC_SERVER_FILE" "$DEPLOY_DIR"
    if [ ! -f "$DEPLOY_DIR/$_PACKAGE_MMOJO_RPC_SERVER_ARGS_FILE" ]; then
        cp "$REPO_DIR/build/support-files/mmojo-rpc-server-args" "$DEPLOY_DIR/$_PACKAGE_MMOJO_RPC_SERVER_ARGS_FILE"
    fi
    cp "$BUILD_DIR/$_BUILD_SUBDIR/bin/llama-quantize" "$DEPLOY_DIR"
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

---
### Review Your Work
Let's list the contents of the `$DEPLOY_DIR` directory and review your work:
```
ls -l $DEPLOY_DIR
```

It should look like:

<img width="500" alt="image" src="https://github.com/user-attachments/assets/5c9dfe30-353d-4783-8b22-d1eb3bd5a0f6" />

---
### Proceed
- **Next:** [02. Test Mmojo Server](02-Test-Mmojo-Server.md)
- **Previous:** This is the first step in this guide.
- **Up:** [Build Mmojo Server for Debian Linux](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
