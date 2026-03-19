## 05. Package for All Platforms
### About this Step
In this step, you will package the build you just created and tested.

In this alternative, you will package the compatible and performant builds separately, Windows and Linux/macOS separately.

---
### Review Your Work
Let's list the contents of the `$HOME/mm-deploy` directory and review your work:
```
ls -l $DEPLOY_DIR
```

It should look like:

<img width="778" height="214" alt="image" src="https://github.com/user-attachments/assets/2af0e2b3-0392-4b73-9f68-775ea10c0cd7" />

---
### Add `Mmojo-Complete` and `mmojo-server-args` to the APE Files
This script will add the `Mmojo-Complete` folder and `mmojo-server-args` file to the compatible and performant Mmojo Server APE files, as the APE files are structured as `.zip` files, and intended to hold application support data.

After adding this data, the compatible and performant APE files are duplicated with `.exe` extensions to run on Windows PCs.
```
cd "$DEPLOY_DIR"
$MMOJO_SED -i -e 's/\/app\//\/zip\//g' "mmojo-server-args"
if [ -f "$_PACKAGE_MMOJO_SERVER_APE_PERFORMANT_FILE" ]; then
    mv "$_PACKAGE_MMOJO_SERVER_APE_PERFORMANT_FILE" "$_PACKAGE_MMOJO_SERVER_APE_PERFORMANT_FILE.zip"
    zip -r "$_PACKAGE_MMOJO_SERVER_APE_PERFORMANT_FILE.zip" "Mmojo-Complete" "$_PACKAGE_MMOJO_SERVER_ARGS_FILE"
    mv "$_PACKAGE_MMOJO_SERVER_APE_PERFORMANT_FILE.zip" "$_PACKAGE_MMOJO_SERVER_APE_PERFORMANT_FILE"
    cp "$_PACKAGE_MMOJO_SERVER_APE_PERFORMANT_FILE" "$_PACKAGE_MMOJO_SERVER_APE_PERFORMANT_FILE.exe"
fi
if [ -f "$_PACKAGE_MMOJO_SERVER_APE_COMPATIBLE_FILE" ]; then
    mv "$_PACKAGE_MMOJO_SERVER_APE_COMPATIBLE_FILE" "$_PACKAGE_MMOJO_SERVER_APE_COMPATIBLE_FILE.zip"
    zip -r "$_PACKAGE_MMOJO_SERVER_APE_COMPATIBLE_FILE.zip" "Mmojo-Complete" "$_PACKAGE_MMOJO_SERVER_ARGS_FILE"
    mv "$_PACKAGE_MMOJO_SERVER_APE_COMPATIBLE_FILE.zip" "$_PACKAGE_MMOJO_SERVER_APE_COMPATIBLE_FILE"
    cp "$_PACKAGE_MMOJO_SERVER_APE_COMPATIBLE_FILE" "$_PACKAGE_MMOJO_SERVER_APE_COMPATIBLE_FILE.exe"
fi
rm -r "Mmojo-Complete"
mv "$_PACKAGE_MMOJO_SERVER_ARGS_FILE" "EXAMPLE-$_PACKAGE_MMOJO_SERVER_ARGS_FILE"
cd "$HOME"
```

---
### Review Changes
Let's list the contents of the `$HOME/mm-deploy` directory again and review changes:
```
ls -l $DEPLOY_DIR
```

It should look like:

<img width="778" height="229" alt="image" src="https://github.com/user-attachments/assets/883232c1-86b9-47b3-825f-1e05fd936283" />

---
### Make a Compatable Windows Package File
Make a .zip pakcage files from teh `$DEPLOY_DIR` directory. They are moved to the `$PACKAGES_DIR` directory after zipping for later testing or deployment.

Make a `Mmojo-Server-ape-compatible.zip` package file and move it to your `$PACKAGES_DIR` directory:
```
_PACKAGE_FILE="Mmojo-Server-ape-compatible-windows.zip"
if test -n "$DEPLOY_DIR"; then
    cd "$DEPLOY_DIR"
    zip "$_PACKAGE_FILE" "$_PACKAGE_MMOJO_SERVER_APE_COMPATIBLE_FILE.exe"
    zip "$_PACKAGE_FILE" *"$_PACKAGE_MMOJO_SERVER_ARGS_FILE" LICENSE *.html
    cp --update=none "$MODELS_DIR/Google-Gemma-1B-Instruct-v3-q8_0.gguf" "$DEPLOY_DIR"
    zip -0 "$_PACKAGE_FILE" "Google-Gemma-1B-Instruct-v3-q8_0.gguf"
    mkdir -p "$PACKAGES_DIR"
    mv -f "$_PACKAGE_FILE" "$PACKAGES_DIR"
    cd $HOME
    ls -al "$PACKAGES_DIR"
fi
```

---
### Make a Compatable Linux/macOS Package File
Make a .zip pakcage files from teh `$DEPLOY_DIR` directory. They are moved to the `$PACKAGES_DIR` directory after zipping for later testing or deployment.

Make a `Mmojo-Server-ape-compatible-linux-macos.zip` package file and move it to your `$PACKAGES_DIR` directory:
```
_PACKAGE_FILE="Mmojo-Server-ape-compatible-linux-macos.zip"
if test -n "$DEPLOY_DIR"; then
  cd "$DEPLOY_DIR"
    zip "$_PACKAGE_FILE" "$_PACKAGE_MMOJO_SERVER_APE_COMPATIBLE_FILE"
    zip "$_PACKAGE_FILE" *"$_PACKAGE_MMOJO_SERVER_ARGS_FILE" LICENSE *.html
    cp --update=none "$MODELS_DIR/Google-Gemma-1B-Instruct-v3-q8_0.gguf" "$DEPLOY_DIR"
    zip -0 "$_PACKAGE_FILE" "Google-Gemma-1B-Instruct-v3-q8_0.gguf"
  mkdir -p "$PACKAGES_DIR"
  mv -f "$_PACKAGE_FILE" "$PACKAGES_DIR"
  cd $HOME
  ls -al "$PACKAGES_DIR"
fi
```

---
### Make a Performant Windows Package File
Make a .zip pakcage files from teh `$DEPLOY_DIR` directory. They are moved to the `$PACKAGES_DIR` directory after zipping for later testing or deployment.

Make a `Mmojo-Server-ape-performant-windows.zip` package file and move it to your `$PACKAGES_DIR` directory:
```
_PACKAGE_FILE="Mmojo-Server-ape-performant-windows.zip"
if test -n "$DEPLOY_DIR"; then
  cd "$DEPLOY_DIR"
    zip "$_PACKAGE_FILE" "$_PACKAGE_MMOJO_SERVER_APE_PERFORMANT_FILE.exe"
    zip "$_PACKAGE_FILE" *"$_PACKAGE_MMOJO_SERVER_ARGS_FILE" LICENSE *.html
    cp --update=none "$MODELS_DIR/Google-Gemma-4B-Instruct-v3-q8_0.gguf" "$DEPLOY_DIR"
    zip -0 "$_PACKAGE_FILE" "Google-Gemma-4B-Instruct-v3-q8_0.gguf"
  mkdir -p "$PACKAGES_DIR"
  mv -f "$_PACKAGE_FILE" "$PACKAGES_DIR"
  cd $HOME
  ls -al "$PACKAGES_DIR"
fi
```

---
### Make a Performant Linux/macOS Package File
Make a .zip pakcage files from teh `$DEPLOY_DIR` directory. They are moved to the `$PACKAGES_DIR` directory after zipping for later testing or deployment.

Make a `Mmojo-Server-ape-performant-linux-macos.zip` package file and move it to your `$PACKAGES_DIR` directory:
```
_PACKAGE_FILE="Mmojo-Server-ape-performant-linux-macos.zip"
if test -n "$DEPLOY_DIR"; then
  cd "$DEPLOY_DIR"
    zip "$_PACKAGE_FILE" "$_PACKAGE_MMOJO_SERVER_APE_PERFORMANT_FILE"
    zip "$_PACKAGE_FILE" *"$_PACKAGE_MMOJO_SERVER_ARGS_FILE" LICENSE *.html
    cp --update=none "$MODELS_DIR/Google-Gemma-4B-Instruct-v3-q8_0.gguf" "$DEPLOY_DIR"
    zip -0 "$_PACKAGE_FILE" "Google-Gemma-4B-Instruct-v3-q8_0.gguf"
  mkdir -p "$PACKAGES_DIR"
  mv -f "$_PACKAGE_FILE" "$PACKAGES_DIR"
  cd $HOME
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
- **Next:** This is the last step in this section.
- **Previous:** [04. Package for All Platforms](04-Package-for-All-Platforms.md)
- **Up:** [Build Mmojo Server for All Platforms](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
