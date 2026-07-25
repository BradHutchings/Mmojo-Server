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
brew install npm
brew install gcc
brew install cmake
```

If they're already installed, upodate them.
```
brew update -y npm
brew update -y gcc
brew update -y cmake
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
    mm-prepare-mmojo-complete.sh
fi
```

---
### Build Mmojo Server
Choose the build type (native, performant, compatible):
```
mm-build-choose.sh
_BUILD_CHOICE="$(cat /tmp/mm-build-choose.out)"
rm /tmp/mm-build-choose.out
```

Choose GPUs for your build. **SHOULD WE JUST GO METAL? NO, OK TO BUILD WITHOUT.**
```
mm-gpus-choose.sh
_GPUS_CHOICE=$(cat /tmp/mm-gpus-choose.out)
rm /tmp/mm-gpus-choose.out
```

Enable 8 CPU cores for the build:
```
export CMAKE_BUILD_PARALLEL_LEVEL=8
```

Build native Mmojo Server tuned to the specific CPU of your PC:
```
_BUILD_SUBDIR=""
_PACKAGE_FILE=""
_RPC_PACKAGE_FILE=""
_TOUCH_FILE=""
if [ $(uname -m) = "x86_64" ]; then
    echo "Building for Intel Macs is not supported yet."
    # _BUILD_SUBDIR="$BUILD_SUBDIRECTORY_MACOS_X86_64-$_BUILD_CHOICE$_GPUS_CHOICE"
    # _PACKAGE_FILE="Mmojo-Server-macos-x86_64-native$_GPUS_CHOICE.zip"
    # _RPC_PACKAGE_FILE="Mmojo-RPC-Server-aarch64-rpi5.zip"
    # _TOUCH_FILE="$BUILD_SUBDIRECTORY_MACOS_X86_64$_BUILD_CHOICE$_GPUS_CHOICE"
elif [ $(uname -m) = "aarch64" ] || [ $(uname -m) = "arm64" ]; then
    _BUILD_SUBDIR="$BUILD_SUBDIRECTORY_MACOS_AARCH64-$_BUILD_CHOICE$_GPUS_CHOICE"
    _PACKAGE_FILE="Mmojo-Server-macos-aarch64-$_BUILD_CHOICE$_GPUS_CHOICE.zip"
    _RPC_PACKAGE_FILE="Mmojo-RPC-Server-macos-aarch64-$_BUILD_CHOICE$_GPUS_CHOICE.zip"
    _TOUCH_FILE="macos-aarch64-$_BUILD_CHOICE$_GPUS_CHOICE"
fi
mm-build-for-platform.sh "$_BUILD_SUBDIR" "$_BUILD_CHOICE" "$_GPUS_CHOICE"
```

---
### Create a Deploy Directory
Create a deploy directory:
```
if [ "$DEPLOY_DIR" != "" ]; then
    mkdir -p "$DEPLOY_DIR"
    find $DEPLOY_DIR/* \( ! -name "*.gguf" -a ! -name "*-args" \) -delete
    cp "$BUILD_DIR/$_BUILD_SUBDIR/bin/$_PACKAGE_MMOJO_SERVER_FILE" "$DEPLOY_DIR"
    cp -r "$BUILD_DIR/Mmojo-Complete" "$DEPLOY_DIR"
    if [ ! -f "$DEPLOY_DIR/$_PACKAGE_MMOJO_SERVER_ARGS_FILE" ]; then
        cp "$REPO_DIR/build/support-files/mmojo-server-args-complete" "$DEPLOY_DIR/$_PACKAGE_MMOJO_SERVER_ARGS_FILE"
        $MMOJO_SED -i -e 's/# -ngl/-ngl/g' "$DEPLOY_DIR/$_PACKAGE_MMOJO_SERVER_ARGS_FILE"
        $MMOJO_SED -i -e 's/# all/all/g' "$DEPLOY_DIR/$_PACKAGE_MMOJO_SERVER_ARGS_FILE"
    fi
    cp "$REPO_DIR/build/support-files/mmojo-chat.html" "$DEPLOY_DIR/Connect-to-Mmojo-Chat.html"
    cp "$REPO_DIR/build/support-files/mmojo-connect.html" "$DEPLOY_DIR/Connect-to-Mmojo-Connect.html"
    cp "$REPO_DIR/build/support-files/mmojo-read-me.html" "$DEPLOY_DIR/Read-Me.html"
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
Let's list the contents of the `$HOME/Mmojo-Server` directory and review your work:
```
ls -l $DEPLOY_DIR
```

It should look like:

<img width="500" height="191" alt="image" src="https://github.com/user-attachments/assets/b1d61521-6d05-4d3e-9cc7-d0de55f29c91" />

---
### Make a Stock Mmojo Server Package File
Make a .zip pakcage files from your run directory. They are moved to your `$PACKAGES_DIR` directory after zipping for later testing or deployment. This package will have stock args and no `.gguf` file.

Make a `.zip` package file and move it to your `$PACKAGES_DIR` directory:
```
if test -n "$DEPLOY_DIR"; then
    cd "$DEPLOY_DIR"
    mv "$_PACKAGE_MMOJO_SERVER_ARGS_FILE" "$_PACKAGE_MMOJO_SERVER_ARGS_FILE-save"
    cp "$REPO_DIR/build/support-files/mmojo-server-args-complete" "$DEPLOY_DIR/$_PACKAGE_MMOJO_SERVER_ARGS_FILE"

    zip "$_PACKAGE_FILE" $_PACKAGE_MMOJO_SERVER_FILE
    zip "$_PACKAGE_FILE" $_PACKAGE_MMOJO_SERVER_ARGS_FILE
    zip "$_PACKAGE_FILE" LICENSE "$_TOUCH_FILE" *.html
    zip -r "$_PACKAGE_FILE" Mmojo-Complete

    rm "$_PACKAGE_MMOJO_SERVER_ARGS_FILE"
    mv "$_PACKAGE_MMOJO_SERVER_ARGS_FILE-save" "$_PACKAGE_MMOJO_SERVER_ARGS_FILE"

    mkdir -p "$PACKAGES_DIR"
    mv -f "$_PACKAGE_FILE" "$PACKAGES_DIR"
    cd $HOME
    echo
    echo "Packages:"
    ls -al "$PACKAGES_DIR"
fi
```

---
### Make a Stock Mmojo RPC Server Package File
Make a .zip package file for RPC Mmojo Server from your run directory. It will be moved to your `$PACKAGES_DIR` directory after zipping for later testing or deployment. This package will have stock args.

Make a `.zip` package file and move it to your `$PACKAGES_DIR` directory:
```
if [ -d "$DEPLOY_DIR" ]; then
    cd "$DEPLOY_DIR"
    mv "$_PACKAGE_MMOJO_RPC_SERVER_ARGS_FILE" "$_PACKAGE_MMOJO_RPC_SERVER_ARGS_FILE-save"
    cp "$REPO_DIR/build/support-files/mmojo-rpc-server-args" "$DEPLOY_DIR/$_PACKAGE_MMOJO_RPC_SERVER_ARGS_FILE"

    zip "$_RPC_PACKAGE_FILE" $_PACKAGE_MMOJO_RPC_SERVER_FILE
    zip "$_RPC_PACKAGE_FILE" $_PACKAGE_MMOJO_RPC_SERVER_ARGS_FILE
    zip "$_RPC_PACKAGE_FILE" LICENSE "$_TOUCH_FILE"

    rm "$_PACKAGE_MMOJO_RPC_SERVER_ARGS_FILE"
    mv "$_PACKAGE_MMOJO_RPC_SERVER_ARGS_FILE-save" "$_PACKAGE_MMOJO_RPC_SERVER_ARGS_FILE"

    mkdir -p "$PACKAGES_DIR"
    mv -f "$_RPC_PACKAGE_FILE" "$PACKAGES_DIR"
    cd $HOME
    echo
    echo "Packages:"
    ls -al "$PACKAGES_DIR"
fi
```

---
### Backup Package to Mmojo Share
You can back the package up to your Mmojo Share.
```
mm-packages-backup.sh
```

---
### Proceed
- **Next:** [02. Test Mmojo Server](02-Test-Mmojo-Server.md)
- **Previous:** This is the first step in this guide.
- **Up:** [Build Mmojo Server for macOS](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
