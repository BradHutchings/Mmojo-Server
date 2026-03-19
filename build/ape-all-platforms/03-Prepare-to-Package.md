## 03. Package for All Platforms
### About this Step
In this step, you will prepare the APE files to be packaged by adding supporting files to them.

---
### Review Your Work
Let's list the contents of the `$HOME/mm-deploy` directory and review your work:
```
ls -l $DEPLOY_DIR
```

It should look like:

<img width="500" alt="image" src="https://github.com/user-attachments/assets/fd74467d-c23c-4f0b-bbe6-e06b482ae7ab" />

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

<img width="500" alt="image" src="https://github.com/user-attachments/assets/3233af7d-978c-423a-9f83-94e9afb70782" />

---
### Proceed
- **Next:** [04. Package for All Platforms](04-Package-for-All-Platforms.md)
- **Previous:** [02. Test Mmojo Server](02-Test-Mmojo-Server.md)
- **Up:** [Build Mmojo Server for All Platforms](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
