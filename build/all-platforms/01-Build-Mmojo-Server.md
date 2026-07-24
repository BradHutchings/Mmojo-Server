## 01. Build Mmojo Server (for All Platforms)
### About this Step
In this step, you will build a local copy of the Cosmopolitan library, build a local OpenSSL static library with Cosmo tools, then built compatible and performant Actual Portable Executable (APE) files with Cosmo tools.

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
    mm-prepare-mmojo-complete.sh
fi
```

<!--
The customize step occasionally skips setting the build date in the Mmojo Complete user interface. Run this command to make sure it only returns two results. If it returns more than two, delete the `$BUILD_DIR` and run the snippet above again.
```
grep -r "\[\[UPDATED" $BUILD_DIR
```
-->

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
    find $DEPLOY_DIR/* \( ! -name "*.gguf" -a ! -name "*-args" \) -delete
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
    if [ ! -f "$DEPLOY_DIR/$_PACKAGE_MMOJO_SERVER_ARGS_FILE" ]; then
        cp "$REPO_DIR/build/support-files/mmojo-server-args" "$DEPLOY_DIR/$_PACKAGE_MMOJO_SERVER_ARGS_FILE"
    fi
    cp "$REPO_DIR/build/support-files/mmojo-chat.html" "$DEPLOY_DIR/Connect-to-Mmojo-Chat.html"
    cp "$REPO_DIR/build/support-files/mmojo-connect.html" "$DEPLOY_DIR/Connect-to-Mmojo-Connect.html"
fi
```

<details>
  <summary><b>Alternatively:</b> Create a <code>mmojo-server-args</code> file in the <code>$DEPLOY_DIR</code> to launch Mmojo Server with chat UI.</summary>
<br/>
    
Chat user interfaces are an abomination, but have at it if you must! 😆  -Brad
```
cp "$REPO_DIR/build/support-files/mmojo-server-args-chat" "$DEPLOY_DIR/$_PACKAGE_MMOJO_SERVER_ARGS_FILE"

```
</details>

---
### Review Your Work
Let's list the contents of the `$HOME/mm-deploy` directory and review your work:
```
ls -l $DEPLOY_DIR
```

It should look like:

<img width="500" alt="image" src="https://github.com/user-attachments/assets/05f5818f-fe16-4b99-9cb4-42b2b637e211" />

---
### Proceed
- **Next:** [02. Test Mmojo Server](02-Test-Mmojo-Server.md)
- **Previous:** This is the first step in this guide.
- **Up:** [Build Mmojo Server for All Platforms](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
