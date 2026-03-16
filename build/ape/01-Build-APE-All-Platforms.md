## 01. Build APE for All Platforms
### About this Step
In this step, you will build an Actual Portable Executable (APE) file that will run on x86_64 and aarch64 (arm64) processors with Windows, macOS, Linux, and other less common operating systems. APE builds are statically linked with no dependencies on dynamic libraries. I use the APE build as a first thing for clients to download and get Mmojo Server running quickly on their computers. If they like they can "upgrade" to a more performant platform-specific version later.

These build steps should be performed in a Debian Linux operating system like Ubuntu or Raspberry Pi. Please prepare your Debian environment by working through one these deploy recipes:
- [Deploy Mmojo Server on Windows (WSL)](/deploy/Windows-WSL/README.md) 
- [Deploy Mmojo Server on Debian / Ubuntu](/deploy/Debian-Ubuntu/README.md) 
- [Deploy Raspberry Pi](/deploy/Raspberry-Pi/README.md) 

---
### Install Dependencies
Install dependencies. These may take 20 minutes or so to download and install. Reinstalling nodejs is necessary to get the right tools in place to rebuild the webui.
```
mm-prepare-install-dependencies.sh
mm-prepare-reinstall-nodejs.sh
```

---
### Build Cosmopolitan Library and Tools
The Cosmopolitan library and tools allow you to build and assemble cross-platform, cross-processor binaries that run anywhere. These assembled files are called Actual Portable Executable (APE) files. The applications are statically linked and compressed into a zip archive.
```
mm-build-cosmopolitan.sh
```

---
### Build OpenSSL with Cosmopolitan
Since you can't dynamically link to the runtime computer's OpenSSL shared library, it needs to be linked statically into the APE builds. Build that static library from latest source here.
```
mm-build-openssl-with-cosmopolitan.sh
```

---
### Build Compatible and Performant Mmojo Server APEs
Prepare to build Mmojo Server (llama.cpp with patches and extensions).
```
if [ ! -d "$BUILD_DIR" ]; then
    mm-prepare-clone-llama-cpp.sh
    mm-prepare-patch-llama-cpp.sh
    mm-prepare-customize-webui.sh
fi
```

The customize step occasionally skips setting the build date in the Mmojo Complete user interface. Run this command to make sure it only returns two results. If it returns more than two, delete the `$BUILD_DIR` and run the snippet above again.
```
grep -r "\[\[UPDATED" $BUILD_DIR
```

Copy Cosmo and OpenSSL into the `$BUILD_DIR`:
```
mm-prepare-copy-cosmo.sh
```

Build compatible and performant Mmojo Server APE:
```
mm-build-with-cosmo.sh X86_64 compatible
mm-build-with-cosmo.sh aarch64 compatible
mm-build-cosmo-ape.sh compatible
mm-build-with-cosmo.sh X86_64 performant
mm-build-with-cosmo.sh aarch64 performant
mm-build-cosmo-ape.sh performant
```

---
### Create a Deploy Directory
Create a deploy directory. We need `.exe` variants for Windows. We need the plain variants for macOS. Linux Terminals and desktops see both as executables.
```
if [ "$DEPLOY_DIR" != "" ]; then
    mkdir -p "$DEPLOY_DIR"
    rm -r -f "$DEPLOY_DIR"/*
    PERFORMANT_APE="$BUILD_DIR/$COSMO_PERFORMANT_APE/$_PACKAGE_MMOJO_SERVER_APE_FILE"
    if [ -f "$PERFORMANT_APE" ]; then
        cp "$PERFORMANT_APE" "$DEPLOY_DIR/$_PACKAGE_MMOJO_SERVER_APE_PERFORMANT_FILE"
    fi
    COMPATIBLE_APE="$BUILD_DIR/$COSMO_COMPATIBLE_APE/$_PACKAGE_MMOJO_SERVER_APE_FILE"
    if [ -f "$COMPATIBLE_APE" ]; then
        cp "$COMPATIBLE_APE" "$DEPLOY_DIR/$_PACKAGE_MMOJO_SERVER_APE_COMPATIBLE_FILE"
    fi
    cp -r "$BUILD_DIR/Mmojo-Complete" "$DEPLOY_DIR"
    cp "$REPO_DIR/LICENSE" "$DEPLOY_DIR"
    cp "$REPO_DIR/LICENSE" "$DEPLOY_DIR"
    cp "$REPO_DIR_FILES/package/ape-chat.html" "$DEPLOY_DIR/Mmojo Chat.html"
    cp "$REPO_DIR_FILES/package/ape-connect.html" "$DEPLOY_DIR/Mmojo Complete.html"
fi
```

Create a `mmojo-server-args` file in the `$DEPLOY_DIR` to launch Mmojo Server with the Mmojo Complete UI:
```
# make a $_PACKAGE_MMOJO_SERVER_ARGS_FILE file
cat << EOF > "$DEPLOY_DIR/$_PACKAGE_MMOJO_SERVER_ARGS_FILE"
# Rename this file "mmojo-server-args" (no quotes) and put it
# in the same directory as the mmojo-server executable to
# override these default values.
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
# Rename this file "mmojo-server-args" (no quotes) and put it
# in the same directory as the mmojo-server executable to
# override these default values.
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
Let's list the contents of the `$HOME/mm-deploy` directory and review your work:
```
ls -l $DEPLOY_DIR
```

It should look like:

<img width="694" height="176" alt="image" src="https://github.com/user-attachments/assets/4a53edbc-5b12-4c7e-b217-e01d60691e16" />

---
### Proceed
- **Next:** [02. Test APE for All Platforms](02-Test-APE-All-Platforms.md)
- **Previous:** This is the first step in this section.
- **Up:** [Build Mmojo Server](../README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
