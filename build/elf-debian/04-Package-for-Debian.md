## 04. Package Mmojo Server for Debian Linux
### About this Step
In this step, you will package the build you just created and tested.

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
if test -n "$DEPLOY_DIR"; then
  cd "$DEPLOY_DIR"
  zip -r "$_PACKAGE_FILE" mmojo-server $_PACKAGE_MMOJO_SERVER_ARGS_FILE Mmojo-Complete LICENSE "$_TOUCH_FILE"
  mkdir -p "$PACKAGES_DIR"
  mv -f "$_PACKAGE_FILE" "$PACKAGES_DIR"
  cd $HOME
  ls -al "$PACKAGES_DIR"
fi
```

---
### Make a Mmojo RPC Server Package File
Make a .zip package file for RPC Mmojo Server from your run directory. It will be moved to your `$PACKAGES_DIR` directory after zipping for later testing or deployment.

Make a `.zip` package file and move it to your `$PACKAGES_DIR` directory:
```
# do whatever here
```

---
### Backup Mmojo Server Package to Mmojo Share
You can back the package up to your Mmojo Share.
```
mm-packages-backup.sh
```

---
### Proceed
- **Next:** [05. Package Mmojo Server for Raspberry Pi](05-Package-for-Raspberry-Pi.md)
- **Previous:** [03. Test Mmojo RPC Server](04-Test-Mmojo-RPC-Server.md)
- **Up:** [Build Mmojo Server](../README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
