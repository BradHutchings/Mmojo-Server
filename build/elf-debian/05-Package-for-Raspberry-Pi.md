## 04. Package Mmojo Server for Raspberry Pi
### About this Step
In this step, you will package the build you just created and tested for Raspberry Pi. It will include Google Gemma 1B Instruct v3.

---
### Review Your Work
Let's list the contents of the `$HOME/Mmojo-Server` directory and review your work:
```
ls -l $DEPLOY_DIR
```

It should look like:

<img width="656" height="118" alt="image" src="https://github.com/user-attachments/assets/fb38bb9a-8285-42f5-a5ca-92301585ba72" />

---
### Make a Mmojo Server Package File
Make a .zip package file for Mmojo Server from your run directory. It will be moved to your `$PACKAGES_DIR` directory after zipping for later testing or deployment.

Make a `.zip` package file and move it to your `$PACKAGES_DIR` directory:
```
if [ -d "$DEPLOY_DIR"]; then
  cd "$DEPLOY_DIR"
  zip "$_PACKAGE_FILE" mmojo-server
  zip "$_PACKAGE_FILE" $_PACKAGE_MMOJO_SERVER_ARGS_FILE LICENSE "$_TOUCH_FILE" *.html
  zip -r "$_PACKAGE_FILE" Mmojo-Complete 
  cp --update=none "$MODELS_DIR/Google-Gemma-1B-Instruct-v3-q8_0.gguf" "$DEPLOY_DIR"
  zip -0 "$_PACKAGE_FILE" "Google-Gemma-1B-Instruct-v3-q8_0.gguf"
  mkdir -p "$PACKAGES_DIR"
  mv -f "$_PACKAGE_FILE" "$PACKAGES_DIR"
  cd $HOME
  ls -al "$PACKAGES_DIR"
fi
```

---
### Make a Mmojo RPC Server Package File
Just kidding. This makes no sense for the Raspberry Pi 5.

---
### Backup Mmojo Server Package to Mmojo Share
You can back the Mmojo Server package up to your Mmojo Share.
```
mm-packages-backup.sh
```

---
### Proceed
- **Next:** This is the last step in this guide.
- **Previous:** [04. Package Mmojo Server for Debian](04-Package-for-Debian.md)
- **Up:** [Build Mmojo Server for Debian Linux](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
