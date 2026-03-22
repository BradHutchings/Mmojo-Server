## 01. Build Mmojo Server (for macOS)
**THIS GUIDE IS A WORK IN PROGRESS.**
### About this Step
In this step, you will build Mach-O executables of Mmojo Server, Mmojo RPC Server, and llama.cpp targets for Apple Silicon (i.e. M1, M2, M3, M4, and M5). Intel CPUs are not supported yet. 

---
### Latest Xcode Tools
Install the latest Xcode Tools from the App Store. The build will likely break if you do not have the latest tools.

---
### Install Dependencies
Install dependencies. These may take 10 minutes or so to download and install.
```
brew install gnu-sed
brew install npm
brew install gcc
brew install cmake
```

`npm` seems to get caught up with certificate problems, so run this:
```
npm config set strict-ssl false
```

---
### Create the Build Directory
Prepare to build Mmojo Server (llama.cpp with patches and extensions):
```
if [ ! -d "$BUILD_DIR" ]; then
    mm-prepare-clone-llama-cpp.sh
    mm-prepare-patch-llama-cpp.sh
    mm-prepare-customize-webui.sh
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

Choose GPUs for your build. **SHOULD WE JUST GO METAL? NO, OK TO BUILD WITHOUT.**
```
mm-gpus-choose.sh
_GPUS_CHOICE=$(cat /tmp/mm-gpus-choose.out)
rm /tmp/mm-gpus-choose.out
```

Build native Mmojo Server tuned to the specific CPU of your PC:
```
_BUILD_SUBDIR=""
_PACKAGE_FILE=""
_RPC_PACKAGE_FILE=""
_TOUCH_FILE=""
if [ $(uname -m) = "x86_64" ]; then
    echo "Building for Intel Macs is not supported yet."
    # _BUILD_SUBDIR="$BUILD_DIR/$EXECUTABLE_NATIVE_X86_64$_GPUS_CHOICE"
    # _PACKAGE_FILE="Mmojo-Server-macos-x86_64-native$_GPUS_CHOICE.zip"
    # _RPC_PACKAGE_FILE="Mmojo-RPC-Server-aarch64-rpi5.zip"
    # _TOUCH_FILE="build-macos-x86_64-$_BUILD_CHOICE$_GPUS_CHOICE"
elif [ $(uname -m) = "aarch64" ] || [ $(uname -m) = "arm64" ]; then
    _BUILD_SUBDIR="$BUILD_DIR/$EXECUTABLE_NATIVE_AARCH64$_GPUS_CHOICE"
    _PACKAGE_FILE="Mmojo-Server-macos-arm64-native$_GPUS_CHOICE.zip"
    _RPC_PACKAGE_FILE="Mmojo-RPC-Server-macos-arm64-native.zip"
    _TOUCH_FILE="build-macos-arm64-$_BUILD_CHOICE$_GPUS_CHOICE"
fi
mm-build-for-platform.sh "$_BUILD_CHOICE" "$_GPUS_CHOICE"
```

---
### Create a Deploy Directory
Create a deploy directory:
```
if [ "$DEPLOY_DIR" != "" ]; then
    mkdir -p "$DEPLOY_DIR"
    find $DEPLOY_DIR/* ! -name "*.gguf" -delete
    cp "$_BUILD_SUBDIR/bin/$_PACKAGE_MMOJO_SERVER_FILE" "$DEPLOY_DIR"
    cp -r "$BUILD_DIR/Mmojo-Complete" "$DEPLOY_DIR"
    cp "$REPO_DIR/build/support-files/mmojo-server-args-complete" "$DEPLOY_DIR/$_PACKAGE_MMOJO_SERVER_ARGS_FILE"
    cp "$REPO_DIR/build/support-files/mmojo-chat.html" "$DEPLOY_DIR/Connect-to-Mmojo-Chat.html"
    cp "$REPO_DIR/build/support-files/mmojo-connect.html" "$DEPLOY_DIR/Connect-to-Mmojo-Connect.html"
    cp "$REPO_DIR/LICENSE" "$DEPLOY_DIR"
    cp "$_BUILD_SUBDIR/bin/$_PACKAGE_MMOJO_RPC_SERVER_FILE" "$DEPLOY_DIR"
    cp "$REPO_DIR/build/support-files/mmojo-rpc-server-args" "$DEPLOY_DIR/$_PACKAGE_MMOJO_RPC_SERVER_ARGS_FILE"
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
Let's list the contents of the `$HOME/Mmojo-Server` directory and review your work:
```
ls -l $DEPLOY_DIR
```

It should look like:

<img width="500" height="191" alt="image" src="https://github.com/user-attachments/assets/b1d61521-6d05-4d3e-9cc7-d0de55f29c91" />

---
### Proceed
- **Next:** [02. Test Mmojo Server](02-Test-Mmojo-Server.md)
- **Previous:** This is the first step in this guide.
- **Up:** [Build Mmojo Server for macOS](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
