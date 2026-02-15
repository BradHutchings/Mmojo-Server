## 520. APE Builds
### About Doghouse
**Doghouse** is an example of a branded developer experience. [Read more about Doghouse](400-Build-Doghouse.md).

---
### About this Step
In the following two steps, we will build the Doghouse server (`doghouse`) and other llama.cpp targets as Actual Portable Executable (APEs). These exexcutables run on x86_64 and aarch64 (arm64) across Linux, macOS, Windows, FreeBSD, and some other operating systems. They do not offer GPU support.
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
mm-build-with-cosmo.sh X86_64 compatible doghouse
mm-build-with-cosmo.sh aarch64 compatible doghouse
mm-build-cosmo-ape.sh compatible doghouse
mm-build-with-cosmo.sh X86_64 performant doghouse
mm-build-with-cosmo.sh aarch64 performant doghouse
mm-build-cosmo-ape.sh performant doghouse
```

---
### SHORTCUT: Test Compatible APE Doghouse
After you build all the APEs, you can test the compatible APE:
```
$MMOJO_SERVER_SCRIPTS/520-Test-Cosmo-APE.sh compatible command-line 1 doghouse
```

---
### SHORTCUT: Test Performant APE Doghouse
After you build all the APEs, you can test the performant APE:
```
$MMOJO_SERVER_SCRIPTS/520-Test-Cosmo-APE.sh performant command-line 1 doghouse
```

---
### Proceed
- **Next:** [521. APE (Compatible)](521-APE-Compatible.md)
- **Previous:** [503. Debug Build](503-Debug-Build.md)
- **Up:** [500. Build Doghouse](500-Build-Doghouse.md)

---
[MIT License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
