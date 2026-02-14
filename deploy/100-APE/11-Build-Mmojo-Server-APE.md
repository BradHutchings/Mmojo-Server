## 11. Build Mmojo Server APE
### About this Step (Optional)
**THIS DOCUMENT IS IN-PROGRESS CONVERTING LINUX INSTRUCTIONS**

If you would prefer to build your own Mmojo Server Actual Portable Executable (APE), you can build it with the steps on this page. The Mmojo Server you build with the instructions on this page will run on x86_64 and aarch64 (arm64) on a variety of operating systems.

**Jump Back:**
- Deploy Mmojo Server APE: ???
- **(remove)** Deploy Mmojo Server on Debian / Ubuntu / Raspberry Pi: [05. Download Mmojo Server](05-Download-Mmojo-Server.md)
- **(remove)** Deploy Mmojo Server on Windows (WSL): [05. Download Mmojo Server](../200-Windows-WSL/05-Download-Mmojo-Server.md)
 
---
### Install Dependencies
Install dependencies. These may take 20 minutes or so to download and install.
```
mm-install-dependencies.sh
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
$MMOJO_SERVER_SCRIPTS/501-Clone-Repos.sh
$MMOJO_SERVER_SCRIPTS/501-Patch-llama-cpp.sh
$MMOJO_SERVER_SCRIPTS/501-Customize-webui.sh
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
Create a run directory. **NEED TO FIGURE OUT HOW TO CHOOSE COMPATIBLE OR PERFORMANT BUILD. MAYBE BOTH?? EXEs too?**
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

**Future:** This is a good candidate for an mm-script.

<details>
  <summary>Alternatively, create a run directory where Mmojo Server runs in chat mode..</summary>
<br/>
    
Chat user interfaces are an abomination, but have at it if you must! 😆  -Brad
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

**CHOOSE LINUX/MACOS OR WINDOWS - WILL STRIP OUT THE .EXE OR NO EXTENSION - CAN WE JUST KEEP .EXE?**
```
ZIP_FILE="mmojo-server-ape.zip"
if test -n "$RUN_DIR"; then
  cd "$RUN_DIR"
  # TODO: If we're on aarch64, change the $ZIP_FILE from -x86- to -arm-
  zip -r $ZIP_FILE mmojo-server mmojo-server-args Mmojo-Complete
  mv $ZIP_FILE $HOME
  cd $HOME
fi
```

---
### Proceed
- **Next:**
  - Deploy Mmojo Server on Debian / Ubuntu / Raspberry Pi: [06. Control Mmojo Server](06-Control-Mmojo-Server.md)
  - Deploy Mmojo Server on Windows (WSL): [06. Control Mmojo Server](../200-Windows-WSL/06-Control-Mmojo-Server.md)
- **Previous:**
  - Deploy Mmojo Server on Debian / Ubuntu / Raspberry Pi: [05. Download Mmojo Server](05-Download-Mmojo-Server.md)
  - Deploy Mmojo Server on Windows (WSL): [05. Download Mmojo Server](../200-Windows-WSL/05-Download-Mmojo-Server.md)
- **Up:**
  - [Deploy Mmojo Server on Debian / Ubuntu / Raspberry Pi](README.md)
  - [Deploy Mmojo Server on Windows (WSL)](../200-Windows-WSL/README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
