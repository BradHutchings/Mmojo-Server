## Build APE for All Platforms
**THE BUILD SSECTION IS UNDER CONSTRUCTION. THESE INSTRUCTIONS PROBABLY DON'T WORK.**

---
### About this Step
In this step, you will build an Actual Portable Executable (APE) file that will run on x86_64 and aarch64 (arm64) processors with Windows, macOS, Linux, and other less common operating systems. APE builds are statically linked with no dependencies on dynamic libraries. I use the APE build as a first thing for clients to download and get Mmojo Server running quickly on their computers. If they like they can "upgrade" to a more performant platform-specific version later.

These build steps work well in a Debian Linux operating system like Ubuntu or Raspberry Pi.

<!--
**Jump Back:** (Does this make sense here?)
- Deploy Mmojo Server APE: ???
- **(remove)** Deploy Mmojo Server on Debian / Ubuntu / Raspberry Pi: [05. Download Mmojo Server](05-Download-Mmojo-Server.md)
- **(remove)** Deploy Mmojo Server on Windows (WSL): [05. Download Mmojo Server](../200-Windows-WSL/05-Download-Mmojo-Server.md)
-->

---
### Install Dependencies
Install dependencies. These may take 20 minutes or so to download and install.
```
mm-prepare-install-dependencies.sh
```

---
### Build Cosmopolitan Library and Tools
```
mm-build-cosmopolitan.sh
```

---
### Build OpenSSL with Cosmopolitan
```
mm-build-openssl-with-cosmopolitan.sh
```

---
### Build Compatible and Performant Mmojo Server APEs/
Prepare to build:
```
mm-prepare-clone-repo.sh
mm-prepare-patch-llama-cpp.sh
mm-prepare-customize-webui-sh
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
Create a run directory:
```
mkdir -p $RUN_DIR
rm -r -f "$RUN_DIR"/*
COMPATIBLE_APE="$BUILD_DIR/$BUILD_COSMO_COMPATIBLE_APE/$PACKAGE_MMOJO_SERVER_APE_FILE"
if [ -f "$COMPATIBLE_APE" ]; then
   cp "$COMPATIBLE_APE" "$RUN_DIR/$PACKAGE_MMOJO_SERVER_APE_FILE-compatible"
   cp "$COMPATIBLE_APE" "$RUN_DIR/$PACKAGE_MMOJO_SERVER_APE_FILE-compatible.exe"
fi
PERFORMANT_APE="$BUILD_DIR/$BUILD_COSMO_PERFORMANT_APE/$PACKAGE_MMOJO_SERVER_APE_FILE"
if [ -f "$PERFORMANT_APE" ]; then
   cp "$PERFORMANT_APE" "$RUN_DIR/$PACKAGE_MMOJO_SERVER_APE_FILE-performant"
   cp "$PERFORMANT_APE" "$RUN_DIR/$PACKAGE_MMOJO_SERVER_APE_FILE-performant.exe"
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
```

<details>
  <summary>Alternatively, create a <code>mmojo-server-args</code> file in the <code>$RUN_DIR</code> to launch Mmojo Server with chat UI.</summary>
<br/>
    
Chat user interfaces are an abomination, but have at it if you must! 😆  -Brad
```
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
Brad makes .zip files for the Hugging Face downloads. They are moved to your `$HOME` directory after zipping. You don't need to do this.

Choose a model to include in your `.zip` file. I'd suggest choosing **Google Gemma 270M Instruct v3**.
```
mm-choose-model.sh
```

Make a `mmojo-server-ape.zip` file and move it to your `$HOME` directory:
```
ZIP_FILE="mmojo-server-ape.zip"
if test -n "$RUN_DIR"; then
  cd "$RUN_DIR"
  # TODO: If we're on aarch64, change the $ZIP_FILE from -x86- to -arm-
  zip -r $ZIP_FILE "$PACKAGE_MMOJO_SERVER_APE_FILE"* mmojo-server-args Mmojo-Complete
  zip -0 $ZIP_FILE *.gguf
  mv $ZIP_FILE $HOME
  cd $HOME
fi
```

**Future:** Figure out if we need both files, with `.exe` and withot. WIll macOS run the `.exe`?

---
### Proceed
- **Next:** [02. Build ELF Executable for Debian Linux](02-ELF-Debian.md)
- **Previous:** This is the first step in this section.
- **Up:** [Build Mmojo Server](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
