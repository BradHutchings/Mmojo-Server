## 01. Build Mmojo Server (for mac OS)
**THIS GUIDE IS A WORK IN PROGRESS.**
### About this Step
In this step, you will build Mach-O executables of Mmojo Server, Mmojo RPC Server, and llama.cpp targets for Apple Silicon (i.e. M1, M2, M3, M4, and M5). Intel CPUs are not supported yet. 

---
### Latest Xcode Tools
Install the latest Xcode Tools from the App Store. The build will likely break if you do not have the latest tools.

---
### Install Dependencies and GPU Support
Install dependencies. These may take 20 minutes or so to download and install. Reinstalling nodejs is necessary to get the right tools in place to rebuild the webui.
```
brew install gnu-sed
brew install npm
```

Do I need this with updated Xcode tools available?
```
brew install gcc
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
if [ $(uname -m) == "x86_64" ]; then
    echo "Building for Intel Macs is not supported yet."
    # _BUILD_SUBDIR="$BUILD_DIR/$EXECUTABLE_NATIVE_X86_64$_GPUS_CHOICE"
    # _PACKAGE_FILE="Mmojo-Server-mac-os-x86_64-native$_GPUS_CHOICE.zip"
    # _RPC_PACKAGE_FILE="Mmojo-RPC-Server-aarch64-rpi5.zip"
    # _TOUCH_FILE="build-mac-os-x86_64-$_BUILD_CHOICE$_GPUS_CHOICE"
elif [ $(uname -m) == "aarch64" ] || [ $(uname -m) == "arm64" ]; then
    _BUILD_SUBDIR="$BUILD_DIR/$EXECUTABLE_NATIVE_AARCH64$_GPUS_CHOICE"
    _PACKAGE_FILE="Mmojo-Server-mac-os-arm64-native$_GPUS_CHOICE.zip"
    _RPC_PACKAGE_FILE="Mmojo-RPC-Server-mac-os-arm64-native.zip"
    _TOUCH_FILE="build-mac-os-arm64-$_BUILD_CHOICE$_GPUS_CHOICE"
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

<img width="656" height="118" alt="image" src="https://github.com/user-attachments/assets/fb38bb9a-8285-42f5-a5ca-92301585ba72" />

---
### Proceed
- **Next:** [02. Test Mmojo Server](02-Test-Mmojo-Server.md)
- **Previous:** This is the first step in this guide.
- **Up:** [Build Mmojo Server for mac OS](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
