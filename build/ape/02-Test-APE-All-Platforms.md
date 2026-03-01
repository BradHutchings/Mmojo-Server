## 02. Test APE for All Platforms
### About this Step
In this step, you will test your Actual Portable Executable (APE) build. If you zipped up your run directory and saved as a package previously, you can recover that package and test it.

<!--
---
### Retrieve Previously Built Package (Optional)
If you've previously built an APE for all platforms and want to retrieve it for testing, run this script:
```
mm-package-choose.sh
```
-->

---
### Choose a Build
Use one of the four commands below to choose a build from from the `$DEPLOY_DIR` to activate. The command will create a link to the right executable in your `$DEPLOY_DIR`. The link will not be included in your `.zip` archive.

```
ln -sfr "$DEPLOY_DIR/$PACKAGE_MMOJO_SERVER_APE_PERFORMANT_FILE.exe" \
    "$DEPLOY_DIR/$PACKAGE_MMOJO_SERVER_APE_FILE"
```
```
ln -sfr "$DEPLOY_DIR/$PACKAGE_MMOJO_SERVER_APE_PERFORMANT_FILE" \
    "$DEPLOY_DIR/$PACKAGE_MMOJO_SERVER_APE_FILE"
```
```
ln -sfr "$DEPLOY_DIR/$PACKAGE_MMOJO_SERVER_APE_COMPATIBLE_FILE.exe" \
    "$DEPLOY_DIR/$PACKAGE_MMOJO_SERVER_APE_FILE"
```
```
ln -sfr "$DEPLOY_DIR/$PACKAGE_MMOJO_SERVER_APE_COMPATIBLE_FILE" \
    "$DEPLOY_DIR/$PACKAGE_MMOJO_SERVER_APE_FILE"
```

---
### Choose a Model
Choose a model. It will be included in your `.zip` archive. I'd suggest choosing **Google Gemma 270M Instruct v3**.
```
mm-model-choose.sh
```

---
### Test Your Build
Test that the build runs with output in the Terminal.
```
mm-debug
```

Connect to Mmojo Complete from a browser:

[Mmojo Complete](http://127.0.0.1:8080) &larr; Right-click, open in new tab.

Hit `CTRL-C` to stop the debug run when you are finished testing your build.

Since your build is in your `$DEPLOY_DIR`, it's ready to be deployed with `mm-start`.

---
### Proceed
- **Next:** [03. Package APE for All Platforms](03-Package-APE-All-Platforms.md)
- **Previous:** [01. Build APE for All Platforms](01-Build-APE-All-Platforms.md)
- **Up:** [Build Mmojo Server](../README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
