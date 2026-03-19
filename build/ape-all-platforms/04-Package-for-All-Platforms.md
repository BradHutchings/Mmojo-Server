## 04. Package for All Platforms
### About this Step
In this step, you will package the build you just created and tested.

In this alternative, you will package the compatible and performant builds in one `.zip` file.

---
### Review Your Work
Let's list the contents of the `$HOME/mm-deploy` directory and review your work:
```
ls -l $DEPLOY_DIR
```

It should look like:

<img width="778" height="214" alt="image" src="https://github.com/user-attachments/assets/2af0e2b3-0392-4b73-9f68-775ea10c0cd7" />

---
### Make a Package File
Make a .zip pakcage files from teh `$DEPLOY_DIR` directory. They are moved to the `$PACKAGES_DIR` directory after zipping for later testing or deployment.

Make a `Mmojo-Server-ape.zip` package file and move it to your `$PACKAGES_DIR` directory:
```
_PACKAGE_FILE="Mmojo-Server-ape.zip"
if test -n "$DEPLOY_DIR"; then
  cd "$DEPLOY_DIR"
  zip "$_PACKAGE_FILE" "$_PACKAGE_MMOJO_SERVER_APE_FILE"* *"$_PACKAGE_MMOJO_SERVER_ARGS_FILE" LICENSE *.html
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
- **Next:** [05. Package for All Platforms](05-Package-for-All-Platforms.md)
- **Previous:** [03. Prepare to Package](03-Prepare-to-Package.md)
- **Up:** [Build Mmojo Server for All Platforms](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
