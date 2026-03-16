## 03. Package ELF Executable for Raspberry Pi
### About this Step
In this step, you will package the build you just created and tested for Raspberry Pi. It will include Google Gemma 1B Instruct v3.

Run this step after you've built on Mmojo Server on a Raspberry Pi device. It will have been built with native CPU features and no GPU support.

---
### Copy Links into Deploy Directory
The Raspberry Pi package needs links.
```
if [ "$DEPLOY_DIR" != "" ]; then
    cp "$REPO_DIR_FILES/package/ape-chat.html" "$DEPLOY_DIR/Mmojo Chat.html"
    cp "$REPO_DIR_FILES/package/ape-connect.html" "$DEPLOY_DIR/Mmojo Complete.html"
fi
```

---
### Review Your Work
Let's list the contents of the `$HOME/mm-deploy` directory and review your work:
```
ls -l $DEPLOY_DIR
```

It should look like:

<img width="656" height="118" alt="image" src="https://github.com/user-attachments/assets/fb38bb9a-8285-42f5-a5ca-92301585ba72" />

---
### Make a Package File
Make a .zip pakcage files from your run directory. They are moved to your `$PACKAGES_DIR` directory after zipping for later testing or deployment.

Make a `.zip` package file and move it to your `$PACKAGES_DIR` directory:
```
_PACKAGE_FILE="Mmojo-Server-raspberry-pi-5.zip"
if test -n "$DEPLOY_DIR"; then
  cd "$DEPLOY_DIR"
  zip "$_PACKAGE_FILE" mmojo-server
  zip -r "$_PACKAGE_FILE" $_PACKAGE_MMOJO_SERVER_ARGS_FILE Mmojo-Complete LICENSE *.html
  cp --update=none "$MODELS_DIR/Google-Gemma-1B-Instruct-v3-q8_0.gguf" "$DEPLOY_DIR"
  zip -0 "$_PACKAGE_FILE" "Google-Gemma-1B-Instruct-v3-q8_0.gguf"
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
- **Previous:** [03. Package ELF Executable for Debian Linux](03-Package-ELF-Debian-Linux.md)
- **Up:** [Build Mmojo Server](../README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
