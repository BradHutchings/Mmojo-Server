## 01. Build Mach-O Executable for mac OS
**THIS SECTION IS IN PROGRESS.**
### About this Step
**IT'S MIGHT JUST BE PERF WITH METAL.**

In this step, you will build an executable file that runs on Debian Linux operating systems for the CPU family in your computer. The supported CPU families are x86_64 and aarch64 (arm64). You can build with three compatibility options:
- **Compatible:** Runs on most systems that use a CPU from your computer's CPU family. 
- **Performant:** Runs on systems that use a recent CPU from your computer's CPU family.
  - For x86_64, these are x86_64 CPUs that support "level 3" flags, as defined by the gnu cc compiler.
  - For aarch64 (arm64), these are aarch64 CPUs that support ??? flags, as defined by the gnu cc compiler. These include all Apple M-series CPUs.
- **Native:** Runs on systems with a CPU that includes all of the CPU flags your computer's CPU includes. This includes your computer.

These build steps should be performed with mac OS. Please prepare your mac OS environment by working through this deploy recipes:
- [Deploy Mmojo Server on mac OS](/deploy/mac-OS/README.md) 

---
### Install Dependencies and GPU Support
Install dependencies. These may take 20 minutes or so to download and install. Reinstalling nodejs is necessary to get the right tools in place to rebuild the webui.
```
brew install gnu-sed
brew install npm
```

Do I need this with updated Xcode tools available?
``
brew install gcc
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

The customize script &mdash; `mm-prepare-customize-webui.sh` &mdash; occasionally skips setting the build date in the Mmojo Complete user interface. Run this command to make sure it only returns two results. If it returns more than two, delete the `$BUILD_DIR` and run the snippet above again.
```
grep -r "\[\[UPDATED" $BUILD_DIR
```

Choose GPUs for your build. **WE SHOULD JUST GO METAL.**
```
. mm-gpus-choose.sh
$GPUS_CHOICE=""
```

Build native Mmojo Server tuned to the specific CPU of your PC:
**_PACKAGE_FILE and _TOUCH_FILE NAMES ARE NOT RIGHT.**

```
_BUILD_SUBDIR=""
_PACKAGE_FILE=""
_TOUCH_FILE=""
_VARIATION="native"
if [ $(uname -m) == "x86_64" ]; then
    _BUILD_SUBDIR="$BUILD_DIR/$EXECUTABLE_NATIVE_X86_64$GPUS_CHOICE"
    _PACKAGE_FILE="Mmojo-Server-mac-os-x86_64-native$GPUS_CHOICE.zip"
    _TOUCH_FILE="build-mac-os-x86_64-native$GPUS_CHOICE"
    _VARIATION="native"
elif [ ($(uname -m) == "aarch64") || ($(uname -m) == "arm64") ]; then
    _BUILD_SUBDIR="$BUILD_DIR/$EXECUTABLE_NATIVE_AARCH64$GPUS_CHOICE"
    _PACKAGE_FILE="Mmojo-Server-mac-os-arm64-native$GPUS_CHOICE.zip"
    _TOUCH_FILE="build-mac-os-arm64-native$GPUS_CHOICE"
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
    _PACKAGE_FILE="Mmojo-Server-mac-os-x86_64-comp$GPUS_CHOICE.zip"
    _TOUCH_FILE="build-mac-os-x86_64-comp$GPUS_CHOICE"
elif [ ($(uname -m) == "aarch64") || ($(uname -m) == "arm64") ]; then
    _BUILD_SUBDIR="$BUILD_DIR/$EXECUTABLE_COMPATIBLE_AARCH64$GPUS_CHOICE"
    _PACKAGE_FILE="Mmojo-Server-mac-os-arm64-comp$GPUS_CHOICE.zip"
    _TOUCH_FILE="build-mac-os-arm64-comp$GPUS_CHOICE"
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
    _PACKAGE_FILE="Mmojo-Server-mac-os-x86_64-perf$GPUS_CHOICE.zip"
    _TOUCH_FILE="build-mac-os-x86_64-perf$GPUS_CHOICE"
elif [ ($(uname -m) == "aarch64") || ($(uname -m) == "arm64") ]; then
    _BUILD_SUBDIR="$BUILD_DIR/$EXECUTABLE_PERFORMANT_AARCH64$GPUS_CHOICE"
    _PACKAGE_FILE="Mmojo-Server-mac-os-arm64-perf$GPUS_CHOICE.zip"
    _TOUCH_FILE="build-mac-os-arm64-perf$GPUS_CHOICE"
fi
mm-build-for-platform.sh performant "$GPUS_CHOICE"
```
</details>

---
### Create a Deploy Directory
Create a deploy directory:
```
if [ "$DEPLOY_DIR" != "" ]; then
    mkdir -p "$DEPLOY_DIR"
    rm -r -f "$DEPLOY_DIR"/*
    cp "$_BUILD_SUBDIR/bin/$_PACKAGE_MMOJO_SERVER_FILE" "$DEPLOY_DIR"
    cp -r "$BUILD_DIR/Mmojo-Complete" "$DEPLOY_DIR"
    cp "$REPO_DIR/LICENSE" "$DEPLOY_DIR"
    touch "$DEPLOY_DIR/$_TOUCH_FILE"
fi
```

Create a mmojo-server-args file in the $DEPLOY_DIR to launch Mmojo Server with the Mmojo Complete UI:
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
- **Next:** [02. Test Mach-O Executable for mac OS](02-Test-Mach-O-mac-OS.md)
- **Previous:** This is the first step in this section.
- **Up:** [Build Mmojo Server](../README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
