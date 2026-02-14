## 520. APE Builds
### About the Build llama-server Track
**llama-server** is the project upon which Mmojo Server builds. [Read more about llama-server](500-Build-llana-server.md).

---
### About this Step
In the following two steps, we will build `llama-server` and other llama.cpp targets as Actual Portable Executable (APEs). These exexcutables run on x86_64 and aarch64 (arm64) across Linux, macOS, Windows, FreeBSD, and some other operating systems. They do not offer GPU support.
- **Compatible** builds run on a wide range of x86_64 and aarch64 processors.
- **Performant** builds run on newer x86_64 processors and Apple M* aarch64 processors.

**Where:** Perform this step in either or both your x86_64 and your aarch64 (arm64) build environments.

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
### SHORTCUT: Build Compatible and Performant APEs
Before using this shortcut, please work through the steps of building the compatible and performant APEs a few times so that you can become familiar with what they do.
```
$MMOJO_SERVER_SCRIPTS/mm-build-with-cosmo.sh X86_64 compatible llama-server
$MMOJO_SERVER_SCRIPTS/mm-build-with-cosmo.sh aarch64 compatible llama-server
$MMOJO_SERVER_SCRIPTS/520-Assemble-Cosmo-APE.sh compatible llama-server
$MMOJO_SERVER_SCRIPTS/mm-build-with-cosmo.sh X86_64 performant llama-server
$MMOJO_SERVER_SCRIPTS/mm-build-with-cosmo.sh aarch64 performant llama-server
$MMOJO_SERVER_SCRIPTS/520-Assemble-Cosmo-APE.sh performant llama-server
```

---
### SHORTCUT: Test Compatible APE llama-server
After you build all the APEs, you can test the compatible APE:
```
$MMOJO_SERVER_SCRIPTS/520-Test-Cosmo-APE.sh compatible command-line 1 llama-server
```

---
### SHORTCUT: Test Performant APE llama-server
After you build all the APEs, you can test the performant APE:
```
$MMOJO_SERVER_SCRIPTS/520-Test-Cosmo-APE.sh performant command-line 1 llama-server
```

---
### Proceed
- **Next:** [521. APE (Compatible)](521-APE-Compatible.md)
- **Previous:** [513. Platform (Native)](513-Platform-Native.md)
- **Up:** [500. Build llama-server](500-Build-llama-server.md)

---
[MIT License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
