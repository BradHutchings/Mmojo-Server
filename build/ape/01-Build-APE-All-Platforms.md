## 01. Build APE for All Platforms
### About this Step
In this step, you will build an Actual Portable Executable (APE) file that will run on x86_64 and aarch64 (arm64) processors with Windows, macOS, Linux, and other less common operating systems. APE builds are statically linked with no dependencies on dynamic libraries. I use the APE build as a first thing for clients to download and get Mmojo Server running quickly on their computers. If they like they can "upgrade" to a more performant platform-specific version later.

These build steps work well in a Debian Linux operating system like Ubuntu or Raspberry Pi. Please prepare your Debian environment by working through one these deploy recipes:
- [Deploy Mmojo Server on Windows (WSL)](/deploy/200-Windows-WSL/README.md) 
- [Deploy Mmojo Server on Debian / Ubuntu / Raspberry Pi](/deploy/300-Debian-Ubuntu-Pi/README.md) 

---
### Install Dependencies
Install dependencies. These may take 20 minutes or so to download and install.
```
mm-prepare-install-dependencies.sh
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
Prepare to build Mmojo Server (llama.cpp with patches and extensions):
```
mm-prepare-clone-llama-cpp.sh
mm-prepare-patch-llama-cpp.sh
mm-prepare-customize-webui.sh
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
### Create a Run Directory
Create a run directory. We need `.exe` variants for Windows. We need the plain variants for macOS. Linux Terminals and desktops see both as executables.
```
mkdir -p $RUN_DIR
rm -r -f "$RUN_DIR"/*
PERFORMANT_APE="$BUILD_DIR/$BUILD_COSMO_PERFORMANT_APE/$PACKAGE_MMOJO_SERVER_APE_FILE"
if [ -f "$PERFORMANT_APE" ]; then
   cp "$PERFORMANT_APE" "$RUN_DIR/$PACKAGE_MMOJO_SERVER_APE_PERFORMANT_FILE.exe"
   cp "$PERFORMANT_APE" "$RUN_DIR/$PACKAGE_MMOJO_SERVER_APE_PERFORMANT_FILE"
fi
COMPATIBLE_APE="$BUILD_DIR/$BUILD_COSMO_COMPATIBLE_APE/$PACKAGE_MMOJO_SERVER_APE_FILE"
if [ -f "$COMPATIBLE_APE" ]; then
   cp "$COMPATIBLE_APE" "$RUN_DIR/$PACKAGE_MMOJO_SERVER_APE_COMPATIBLE_FILE.exe"
   cp "$COMPATIBLE_APE" "$RUN_DIR/$PACKAGE_MMOJO_SERVER_APE_COMPATIBLE_FILE"
fi
```

Create a `mmojo-server-args` file in the `$RUN_DIR` to launch Mmojo Server with the Mmojo Complete UI:
```
cp -r $BUILD_DIR/Mmojo-Complete $RUN_DIR
# make a $PACKAGE_MMOJO_SERVER_ARGS_FILE file
cat << EOF > "$RUN_DIR/$PACKAGE_MMOJO_SERVER_ARGS_FILE"
--path
/app/Mmojo-Complete
--default-ui-endpoint
chat
--host
127.0.0.1
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
127.0.0.1
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
ls -l $RUN_DIR
```

It should look like:

<img width="814" height="159" alt="image" src="https://github.com/user-attachments/assets/7d59ae18-90ff-4137-840e-dbf7e9c10891" />

---
### (Optional) Make a .zip File
Brad makes .zip files for the Hugging Face downloads. They are moved to your `$PACKAGES_DIR` directory after zipping. You don't need to do this.

Make a `mmojo-server-ape.zip` file and move it to your `$PACKAGES_DIR` directory:
```
ZIP_FILE="Mmojo-Server-ape.zip"
if test -n "$RUN_DIR"; then
  cd "$RUN_DIR"
  zip -r "$ZIP_FILE" "$PACKAGE_MMOJO_SERVER_APE_FILE"* mmojo-server-args Mmojo-Complete
  mkdir -p "$PACKAGES_DIR"
  mv -f "$ZIP_FILE" "$PACKAGES_DIR"
  cd $HOME
  ls -al "$PACKAGES_DIR"
fi
```

---
### Proceed
- **Next:** [02. Test APE for All Platforms](02-Test-APE-All-Platforms.md)
- **Previous:** This is the first step in this section.
- **Up:** [Build Mmojo Server](../README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
