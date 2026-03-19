## 02. llama-server &mdash; Test ELF Executable for Debian Linux
### About this Step
In this step, you will build an Actual Portable Executable (APE) file that will run on x86_64 and aarch64 (arm64) processors with Windows, macOS, Linux, and other less common operating systems. APE builds are statically linked with no dependencies on dynamic libraries. I use the APE build as a first thing for clients to download and get Mmojo Server running quickly on their computers. If they like they can "upgrade" to a more performant platform-specific version later.

These build steps work well in a Debian Linux operating system like Ubuntu or Raspberry Pi.

<!--
---
### Retrieve Previously Built Package (Optional)
If you've previously built an APE for all platforms and want to retrieve it for testing, run this script:
```
mm-package-choose.sh
```
-->

---
### Choose a Model
Choose a model. I'd suggest choosing **Google-Gemma-4B-Instruct-v3-q8_0.gguf**. It will be soft linked in your $DEPLOY_DIR` directory.
```
mm-model-choose.sh
```

---
### Test Your Build
Test that the build runs with output in the Terminal.
```
mm-debug
```

Connect to llama.cpp Chat from a browser:

[llama.cpp Chat](http://127.0.0.1:8080) &larr; Right-click, open in new tab.

Hit `CTRL-C` to stop the debug run when you are finished testing your build.

---
### Proceed
- **Next:** [03. Package ELF Executable for Debian Linux](03-Package-ELF-Debian-Linux.md)
- **Previous:** [01. Build ELF Executable for Debian Linux](01-Build-ELF-Debian-Linux.md)
- **Up:** [Build llama-server](../README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
