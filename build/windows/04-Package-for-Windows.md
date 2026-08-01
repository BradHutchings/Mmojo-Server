## 04. Package for Windows
**THIS GUIDE IS A WORK IN PROGRESS.**
### About this Step
In this step, you will package the build you just created and tested.

**NOTE: PLEASE REVIEW THE [LICENSE FILE](/LICENSE) BEFORE DISTRIUBUTING ANY BUILDS YOU PACKAGE. YOU MAY NOT CALL WHAT YOU DISTRIBUITE "Mmojo Server".**

---
### Choose a Model
Choose a model to include in the package. If you don't want one, choose "None".
```
mm-model
```

---
### Review Your Work
Let's list the contents of the `$HOME/Mmojo-Server` directory and review your work:
```
ls -l $DEPLOY_DIR
```

It should look like:

<img width="500" alt="image" src="https://github.com/user-attachments/assets/73e64e25-a017-4dd7-9f5d-84ad48666c8e" />

If you chose "None" for the model above, you will not have a .gguf file (light blue in my window).

---
### Make a Package File
Make a .zip pakcage files from your run directory. They are moved to your `$PACKAGES_DIR` directory after zipping for later testing or deployment.

Make a `.zip` package file and move it to your `$PACKAGES_DIR` directory:
```
if test -n "$DEPLOY_DIR"; then
    cd "$DEPLOY_DIR"
    zip "$_PACKAGE_FILE" $_PACKAGE_MMOJO_SERVER_FILE
    zip "$_PACKAGE_FILE" $_PACKAGE_MMOJO_SERVER_ARGS_FILE
    zip "$_PACKAGE_FILE" LICENSE "$_TOUCH_FILE" *.html
    zip -r "$_PACKAGE_FILE" Mmojo-Complete 
    if find . -maxdepth 1 -type f,l -iname "*.gguf" -print -quit | grep -q .; then
        zip -0 "$_PACKAGE_FILE" *.gguf 
    fi
    mkdir -p "$PACKAGES_DIR"
    mv -f "$_PACKAGE_FILE" "$PACKAGES_DIR"
    cd $HOME
    echo
    echo "Packages:"
    ls -al "$PACKAGES_DIR"
fi
```

---
### Make a Mmojo RPC Server Package File
Make a .zip package file for RPC Mmojo Server from your run directory. It will be moved to your `$PACKAGES_DIR` directory after zipping for later testing or deployment.

Make a `.zip` package file and move it to your `$PACKAGES_DIR` directory:
```
if [ -d "$DEPLOY_DIR" ]; then
    cd "$DEPLOY_DIR"
    zip "$_RPC_PACKAGE_FILE" $_PACKAGE_MMOJO_RPC_SERVER_FILE
    zip "$_RPC_PACKAGE_FILE" $_PACKAGE_MMOJO_RPC_SERVER_ARGS_FILE
    zip "$_RPC_PACKAGE_FILE" LICENSE "$_TOUCH_FILE"
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
- **Next:** This is the last step in this guide.
- **Previous:** [03. Test Mmojo RPC Server](03-Test-Mmojo-RPC-Server.md)
- **Up:** [Build Mmojo Server for Windows](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
