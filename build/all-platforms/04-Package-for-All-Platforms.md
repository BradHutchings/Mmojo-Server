## 06. Package for All Platforms
### About this Step
In this step, you will package the build you just created and tested.

In this alternative, you will package the compatible and performant builds separately, Windows and Linux/macOS separately.

**NOTE: PLEASE REVIEW THE [LICENSE FILE](/LICENSE) BEFORE DISTRIUBUTING ANY BUILDS YOU PACKAGE. YOU MAY NOT CALL WHAT YOU DISTRIBUITE "Mmojo Server".**

---
### Review Your Work
Let's list the contents of the `$HOME/mm-deploy` directory and review your work:
```
ls -l $DEPLOY_DIR
```

It should look like:

<img width="500" alt="image" src="https://github.com/user-attachments/assets/3233af7d-978c-423a-9f83-94e9afb70782" />

If you have a model to be included in the package, it will show up as a link. It is light blue in my listing.

---
### Choose a Model for Compatible Packages
Choose a model to include in the compatible packages. If you don't want one, choose "None".

Suggested: Google Gemma 1B Instruct v3.
```
mm-model
```

---
### Make a Compatable Windows Package File
Make a .zip pakcage files from teh `$DEPLOY_DIR` directory. They are moved to the `$PACKAGES_DIR` directory after zipping for later testing or deployment.

Make a `Mmojo-Server-ape-compatible-windows.zip` package file and move it to your `$PACKAGES_DIR` directory:
```
_PACKAGE_FILE="Mmojo-Server-ape-compatible-windows.zip"
if test -n "$DEPLOY_DIR"; then
    cd "$DEPLOY_DIR"
    zip "$_PACKAGE_FILE" "$_PACKAGE_MMOJO_SERVER_APE_COMPATIBLE_FILE.exe"
    zip "$_PACKAGE_FILE" *"$_PACKAGE_MMOJO_SERVER_ARGS_FILE"
    zip "$_PACKAGE_FILE" LICENSE *.html
    if find . -maxdepth 1 -type f,l -iname "*.gguf" -print -quit | grep -q .; then
        zip -0 "$_PACKAGE_FILE" *.gguf 
    fi
    mkdir -p "$PACKAGES_DIR"
    mv -f "$_PACKAGE_FILE" "$PACKAGES_DIR"
    cd $HOME
    ls -al "$PACKAGES_DIR"
fi
```

---
### Make a Compatable Linux / macOS Package File
Make a .zip pakcage files from teh `$DEPLOY_DIR` directory. They are moved to the `$PACKAGES_DIR` directory after zipping for later testing or deployment.

Make a `Mmojo-Server-ape-compatible-linux-macos.zip` package file and move it to your `$PACKAGES_DIR` directory:
```
_PACKAGE_FILE="Mmojo-Server-ape-compatible-linux-macos.zip"
if test -n "$DEPLOY_DIR"; then
    cd "$DEPLOY_DIR"
    zip "$_PACKAGE_FILE" "$_PACKAGE_MMOJO_SERVER_APE_COMPATIBLE_FILE"
    zip "$_PACKAGE_FILE" *"$_PACKAGE_MMOJO_SERVER_ARGS_FILE"
    zip "$_PACKAGE_FILE" LICENSE *.html
    if find . -maxdepth 1 -type f,l -iname "*.gguf" -print -quit | grep -q .; then
        zip -0 "$_PACKAGE_FILE" *.gguf 
    fi
    mkdir -p "$PACKAGES_DIR"
    mv -f "$_PACKAGE_FILE" "$PACKAGES_DIR"
    cd $HOME
    ls -al "$PACKAGES_DIR"
fi
```

---
### Choose a Model for Performant Packages
Choose a model to include in the performant packages. If you don't want one, choose "None".

Suggested: Google Gemma 4B Instruct v3.
```
mm-model
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
    zip "$_PACKAGE_FILE" *"$_PACKAGE_MMOJO_SERVER_ARGS_FILE"
    zip "$_PACKAGE_FILE" LICENSE *.html
    if find . -maxdepth 1 -type f,l -iname "*.gguf" -print -quit | grep -q .; then
        zip -0 "$_PACKAGE_FILE" *.gguf 
    fi
    mkdir -p "$PACKAGES_DIR"
    mv -f "$_PACKAGE_FILE" "$PACKAGES_DIR"
    cd $HOME
    ls -al "$PACKAGES_DIR"
fi
```

---
### Make a Performant Linux / macOS Package File
Make a .zip pakcage files from teh `$DEPLOY_DIR` directory. They are moved to the `$PACKAGES_DIR` directory after zipping for later testing or deployment.

Make a `Mmojo-Server-ape-performant-linux-macos.zip` package file and move it to your `$PACKAGES_DIR` directory:
```
_PACKAGE_FILE="Mmojo-Server-ape-performant-linux-macos.zip"
if test -n "$DEPLOY_DIR"; then
    cd "$DEPLOY_DIR"
    zip "$_PACKAGE_FILE" "$_PACKAGE_MMOJO_SERVER_APE_PERFORMANT_FILE"
    zip "$_PACKAGE_FILE" *"$_PACKAGE_MMOJO_SERVER_ARGS_FILE"
    zip "$_PACKAGE_FILE" LICENSE *.html
    if find . -maxdepth 1 -type f,l -iname "*.gguf" -print -quit | grep -q .; then
        zip -0 "$_PACKAGE_FILE" *.gguf 
    fi
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
- **Next:** This is the last step in this guide.
- **Previous:** [03. Prepare to Package](03-Prepare-to-Package.md)
- **Up:** [Build Mmojo Server for All Platforms](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@Mmojo.net)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
