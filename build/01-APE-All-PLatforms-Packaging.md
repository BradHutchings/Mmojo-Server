## Build APE for All Platforms - Packaging
### About this Step
This is a separate packaging step for APE builds. It's how I package the **Mmojo Server - Start Local** zip file and disk.

---
### Create a Run Directory
Create a run directory:
```
mkdir -p $RUN_DIR
rm -r -f "$RUN_DIR"/*
PERFORMANT_APE="$BUILD_DIR/$BUILD_COSMO_PERFORMANT_APE/$PACKAGE_MMOJO_SERVER_APE_FILE"
if [ -f "$PERFORMANT_APE" ]; then
   cp "$PERFORMANT_APE" "$RUN_DIR/1-$PACKAGE_MMOJO_SERVER_APE_PERFORMANT_FILE.exe"
   cp "$PERFORMANT_APE" "$RUN_DIR/2-$PACKAGE_MMOJO_SERVER_APE_PERFORMANT_FILE"
fi
COMPATIBLE_APE="$BUILD_DIR/$BUILD_COSMO_COMPATIBLE_APE/$PACKAGE_MMOJO_SERVER_APE_FILE"
if [ -f "$COMPATIBLE_APE" ]; then
   cp "$COMPATIBLE_APE" "$RUN_DIR/3-$PACKAGE_MMOJO_SERVER_APE_COMPATIBLE_FILE.exe"
   cp "$COMPATIBLE_APE" "$RUN_DIR/4-$PACKAGE_MMOJO_SERVER_APE_COMPATIBLE_FILE"
fi
cp $PACKAGE_FILES_APE_CONNECT "$RUN_DIR/Connect-to-Mmojo.html"
cp $PACKAGE_FILES_APE_READ_ME "$RUN_DIR/Read-Me.html"
touch "$RUN_DIR/0-TRY-THESE-IN-ORDER"
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
ZIP_FILE="Mmojo-Server-All-Platforms.zip"
if test -n "$RUN_DIR"; then
  cd "$RUN_DIR"
  zip -r $ZIP_FILE *"$PACKAGE_MMOJO_SERVER_APE_FILE"* mmojo-server-args Mmojo-Complete *".html" 0-*
  zip -0 $ZIP_FILE *.gguf
  mv $ZIP_FILE $HOME
  cd $HOME
fi
```

---
### Proceed
- **Next:** [02. Build ELF Executable for Debian Linux](02-ELF-Debian.md)
- **Previous:** This is the first step in this section.
- **Up:** [Build Mmojo Server](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
