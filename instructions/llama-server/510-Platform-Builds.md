## 510. Platform Builds
### About the Build llama-server Track
**llama-server** is the project upon which Mmojo Server builds. [Read more about llama-server](500-Build-llana-server.md).

---
### About this Step
In the following three steps, we will build `llama-server` and other llama.cpp targets to run on the CPU of your build environment, with optional GPU support.
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
mm-update-local-mmojo-server-repo.sh
mm-env
```
</details>

---
### SHORTCUT: Build Compatible, Performant, and Native Executables with Optional GPU Support
Before using this shortcut, please work through the steps of building the compatible, performant, and native executables a few times so that you can become familiar with what they do.
```
. mm-gpus-choose.sh
$MMOJO_SERVER_SCRIPTS/510-Build-for-Platform.sh compatible "$GPUS_CHOICE" llama-server
$MMOJO_SERVER_SCRIPTS/510-Build-for-Platform.sh performant "$GPUS_CHOICE" llama-server
$MMOJO_SERVER_SCRIPTS/510-Build-for-Platform.sh native "$GPUS_CHOICE" llama-server
```

---
### SHORTCUT: Test Compatible Executable llama-server
After you build all the APEs, you can test the compatible executable:
```
$MMOJO_SERVER_SCRIPTS/510-Test-Server.sh compatible "$GPUS_CHOICE" 1 llama-server
```

---
### SHORTCUT: Test Performant Executable llama-server
After you build all the APEs, you can test the performant executable:
```
$MMOJO_SERVER_SCRIPTS/510-Test-Server.sh performant "$GPUS_CHOICE" 1 llama-server
```

---
### SHORTCUT: Test Native Executable llama-server
After you build all the APEs, you can test the native executable:
```
$MMOJO_SERVER_SCRIPTS/510-Test-Server.sh native "$GPUS_CHOICE" 1 llama-server
```

---
### Proceed
- **Next:** [511. Platform (Compatible)](511-Platform-Compatible.md)
- **Previous:** [503. Debug Build](503-Debug-Build.md)
- **Up:** [500. Build llama-server](500-Build-llama-server.md)

---
[MIT License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
