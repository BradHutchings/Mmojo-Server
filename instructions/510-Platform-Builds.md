## 510. Platform Builds
### About this Step
In the following three steps, we will build Mmojo Server (`mmojo-server`) and other llama.cpp targets to run on the CPU of your build environment, with optional GPU support.
- **Compatible** builds run on a wide range of x86_64 and aarch64 processors.
- **Performant** builds run on newer x86_64 processors and Apple M* aarch64 processors.
- **Native** builds run on the processor in your build environment.

**Where:** Perform these steps in both your x86_64 and your aarch64 (arm64) build environments.

**Shortcut:** [Scroll down](#shortcut-build-cpu-test).

---
<details>
  <summary><b>Update Local Mmojo Server Repo</b> &mdash; Expand if you haven't today.</summary>
  
Have you updated your local clone of the Mmojo Server Repo today? If not, run this first:
```
mm-repo-update-local.sh
mm-env
```
</details>

---
### SHORTCUT: Build Compatible, Performant, and Native Executables with Optional GPU Support
Before using this shortcut, please work through the steps of building the compatible, performant, and native executables a few times so that you can become familiar with what they do.
```
. mm-use-gpus.sh
$MMOJO_SERVER_SCRIPTS/510-Build-for-Platform.sh compatible "$CHOSEN_GPUS"
$MMOJO_SERVER_SCRIPTS/510-Build-for-Platform.sh performant "$CHOSEN_GPUS"
$MMOJO_SERVER_SCRIPTS/510-Build-for-Platform.sh native "$CHOSEN_GPUS"
```

---
### SHORTCUT: Test Compatible Executable Mmojo Server
After you build all the APEs, you can test the compatible executable:
```
$MMOJO_SERVER_SCRIPTS/510-Test-Server.sh compatible "$CHOSEN_GPUS" "$TEST_WITH_CHAT_UI"
```

---
### SHORTCUT: Test Performant Executable Mmojo Server
After you build all the APEs, you can test the performant executable:
```
$MMOJO_SERVER_SCRIPTS/510-Test-Server.sh performant "$CHOSEN_GPUS" "$TEST_WITH_CHAT_UI"
```

---
### SHORTCUT: Test Native Executable Mmojo Server
After you build all the APEs, you can test the native executable:
```
$MMOJO_SERVER_SCRIPTS/510-Test-Server.sh native "$CHOSEN_GPUS" "$TEST_WITH_CHAT_UI"
```

---
### Proceed
- **Next:** [511. Platform (Compatible)](511-Platform-Compatible.md)
- **Previous:** [503. Debug Build](503-Debug-Build.md)
- **Up:** [500. Build Mmojo Server](500-Build-Mmojo-Server.md)

---
[MIT License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
