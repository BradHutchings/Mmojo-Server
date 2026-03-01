## 03. Package APE for All Platforms
### About this Step
In this step, you will package the build you just created and tested.

---
### Review Your Work
Let's list the contents of the `$HOME/Mmojo-Server` directory and review your work:
```
ls -l $DEPLOY_DIR
```

It should look like:

<img width="814" height="159" alt="image" src="https://github.com/user-attachments/assets/7d59ae18-90ff-4137-840e-dbf7e9c10891" />

---
### Add `Mmojo Complete` and `mmojo-server-args` to the APE Files
```
cd "$DEPLOY_DIR"
sed -i -e 's/\/app\//\/zip\//g' "mmojo-server-args"
if [ -f "$PACKAGE_MMOJO_SERVER_APE_PERFORMANT_FILE" ]; then
    mv "$PACKAGE_MMOJO_SERVER_APE_PERFORMANT_FILE" "$PACKAGE_MMOJO_SERVER_APE_PERFORMANT_FILE.zip"
    zip -r "$PACKAGE_MMOJO_SERVER_APE_PERFORMANT_FILE.zip" "Mmojo-Complete" "mmojo-server-args"
    mv "$PACKAGE_MMOJO_SERVER_APE_PERFORMANT_FILE.zip" "$PACKAGE_MMOJO_SERVER_APE_PERFORMANT_FILE"
    cp "$PACKAGE_MMOJO_SERVER_APE_PERFORMANT_FILE" "$PACKAGE_MMOJO_SERVER_APE_PERFORMANT_FILE.exe"
fi
if [ -f "$PACKAGE_MMOJO_SERVER_APE_COMPATIBLE_FILE" ]; then
    mv "$PACKAGE_MMOJO_SERVER_APE_COMPATIBLE_FILE" "$PACKAGE_MMOJO_SERVER_APE_COMPATIBLE_FILE.zip"
    zip -r "$PACKAGE_MMOJO_SERVER_APE_COMPATIBLE_FILE.zip" "Mmojo-Complete" "mmojo-server-args"
    mv "$PACKAGE_MMOJO_SERVER_APE_COMPATIBLE_FILE.zip" "$PACKAGE_MMOJO_SERVER_APE_COMPATIBLE_FILE"
    cp "$PACKAGE_MMOJO_SERVER_APE_COMPATIBLE_FILE" "$PACKAGE_MMOJO_SERVER_APE_COMPATIBLE_FILE.exe"
fi
rm -r "Mmojo-Complete"
cd "$HOME"
```

---
### Make a Package File
Make a .zip pakcage files from your run directory. They are moved to your `$PACKAGES_DIR` directory after zipping for later testing or deployment.

Make a `mmojo-server-ape.zip` package file and move it to your `$PACKAGES_DIR` directory:
```
PACKAGE_FILE="Mmojo-Server-ape.zip"
if test -n "$DEPLOY_DIR"; then
  cd "$DEPLOY_DIR"
  zip "$PACKAGE_FILE" "$PACKAGE_MMOJO_SERVER_APE_FILE"* mmojo-server-args
  mkdir -p "$PACKAGES_DIR"
  mv -f "$PACKAGE_FILE" "$PACKAGES_DIR"
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
- **Previous:** [02. Test APE for All Platforms](02-Test-APE-All-Platforms.md)
- **Up:** [Build Mmojo Server](../README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
