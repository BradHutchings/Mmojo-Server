## Build APE for All Platforms
### About this Step
In this step, you will build an Actual Portable Executable (APE) file that will run on x86_64 and aarch64 (arm64) processors with Windows, macOS, Linux, and other less common operating systems. APE builds are statically linked with no dependencies on dynamic libraries. I use the APE build as a first thing for clients to download and get Mmojo Server running quickly on their computers. If they like they can "upgrade" to a more performant platform-specific version later.

These build steps work well in a Debian Linux operating system like Ubuntu or Raspberry Pi.

---
### Retrieve Previously Built Package (Optional)
If you've previously built an APE for all platforms and want to retrieve it for testing, run this script:
```
mm-package-choose.sh
```

---
### Choose a Build and a Model
Use one of the four commands below to choose a build from from the `$RUN_DIR` to activate. The command will create a link to the right executable in your `$RUN_DIR`. The link will not be included in your `.zip` archive.

```
ln -sfr "$RUN_DIR/$PACKAGE_MMOJO_SERVER_APE_PERFORMANT_FILE.exe" \
    "$RUN_DIR/$PACKAGE_MMOJO_SERVER_APE_FILE"
```
```
ln -sfr "$RUN_DIR/$PACKAGE_MMOJO_SERVER_APE_PERFORMANT_FILE" \
    "$RUN_DIR/$PACKAGE_MMOJO_SERVER_APE_FILE"
```
```
ln -sfr "$RUN_DIR/$PACKAGE_MMOJO_SERVER_APE_COMPATIBLE_FILE.exe" \
    "$RUN_DIR/$PACKAGE_MMOJO_SERVER_APE_FILE"
```
```
ln -sfr "$RUN_DIR/$PACKAGE_MMOJO_SERVER_APE_COMPATIBLE_FILE" \
    "$RUN_DIR/$PACKAGE_MMOJO_SERVER_APE_FILE"
```

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

Hit `CTRL-C` to stop the debug run.

---
### Proceed
- **Next:** [02. Build ELF Executable for Debian Linux](02-ELF-Debian.md)
- **Previous:** This is the first step in this section.
- **Up:** [Build Mmojo Server](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
