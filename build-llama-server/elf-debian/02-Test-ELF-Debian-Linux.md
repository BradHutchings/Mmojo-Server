## 02. llama-server &mdash; Test ELF Executable for Debian Linux
**THIS GUIDE IS IN PROGRESS**
### About this Step
In this step, you will build an Actual Portable Executable (APE) file that will run on x86_64 and aarch64 (arm64) processors with Windows, macOS, Linux, and other less common operating systems. APE builds are statically linked with no dependencies on dynamic libraries. I use the APE build as a first thing for clients to download and get Mmojo Server running quickly on their computers. If they like they can "upgrade" to a more performant platform-specific version later.

These build steps work well in a Debian Linux operating system like Ubuntu or Raspberry Pi.

---
### Retrieve Previously Built Package (Optional)
If you've previously built an APE for all platforms and want to retrieve it for testing, run this script:
```
mm-package-choose.sh
```

**Note:** this will unzip your package in the `$RUN_DIR`, not the `$RUN_LLAMA_SERVER_DIR`. I'll fix that soon. -Brad

---
### Choose a Model
Choose a model. It will be included in your `.zip` archive. I'd suggest choosing **Google Gemma 270M Instruct v3**.
```
mm-model-choose.sh "llama-server"
```

---
### Test Your Build
Test that the build runs with output in the Terminal.
```
cd $RUN_LLAMA_SERVER_DIR
./$PACKAGE_LLAMA_SERVER_FILE --host 127.0.0.1 --port 8080 --model *.gguf
cd $HOME 
```

Connect to llama.cpp Chat from a browser:

[llama.cpp Chat](http://127.0.0.1:8080) &larr; Right-click, open in new tab.

Hit `CTRL-C` to stop the debug run when you are finished testing your build.

---
### Proceed
- **Next:** This is the last step in this section.
- **Previous:** [01. Build ELF Executable for Debian Linux](01-Build-ELF-Debian-Linux.md)
- **Up:** [Build llama-server](../README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
