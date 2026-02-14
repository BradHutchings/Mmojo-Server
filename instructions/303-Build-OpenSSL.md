## 303. Build OpenSSL
### About this Step
We need to build our own `libssl.a` and `libcrypto.a` becuase:
1. Actual Portable Executable (APE) does not support dynamic loading of libraries.
2. The `libssl.a` and `libcrypto.a` we get by installing `libssl-dev` is built with `_FORTIFY_SOURCE` and will not link against Cosmo's `libc.a`.

This is how I understand the problem. My understanding might be incorrect, but it bears out in trying to find workarounds.

**Where:** Perform this step in both your x86_64 and your aarch64 (arm64) build environments.

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
### Clone openssl Repo, Build Locally with cosmocc
Clone openssl repo into a `$BUILD_OPENSSSL_DIR` directory, then build openssl with cosmo. Build this once, and leave the `$BUILD_OPENSSSL_DIR` directory between builds.

This script clones the openssl repo to `$BUILD_OPENSSSL_DIR`, then builds it:
- View the script: <a href="../scripts/mm-build-openssl-with-cosmopolitan.sh" target="_blank">mm-build-openssl-with-cosmopolitan.sh</a>.
  - *On Github, you may need to right-click and choose "Open link in new tab" to open the "View script" links in a new tab.*
    <br/>
    <br/>
- Run the script.
  ```
  mm-build-openssl-with-cosmopolitan.sh
  ```

---
### Proceed
- **Next:** [304. Install CUDA Toolkit](304-Install-CUDA-Toolkit.md)
- **Previous:** [302. Build Cosmopolitan](302-Build-Cosmopolitan.md)
- **Up:** [300. Gather Build Pieces](300-Gather-Build-Pieces.md)

---
[MIT License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
