## 302. Build Cosmopolitan
### About this Step
In this step, we will clone the Cosmopolitan repo, fix known problems, and build it. You don't need to do this every time you build Mmojo Server.

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
### Clone Cosmopolitan Repo, Build Locally
Clone Cosmopolitan repo into a `$BUILD_COSMOPOLITAN_DIR` directory, fix bugs, then build Cosmopolitan. Build this once, and leave the `$BUILD_COSMOPOLITAN_DIR` directory between builds.

This script clones the Cosmopolitan repo to `$BUILD_COSMOPOLITAN_DIR`:
- View the script: <a href="../scripts/mm-build-cosmopolitan.sh" target="_blank">mm-build-cosmopolitan.sh</a>.
  - *On Github, you may need to right-click and choose "Open link in new tab" to open the "View script" links in a new tab.*
    <br/>
    <br/>
- Run the script.
  ```
  mm-build-cosmopolitan.sh
  ```

---
### WSL Note
If you get build errors in the CMake preparation step, you most likely did not turn off interoperability in WSL. Please see instructions in [201. Prepare WSL](201-Prepare-WSL.md).

You can turn off interoperability temporarily with this command:
```
sudo sh -c 'echo -1 > /proc/sys/fs/binfmt_misc/WSLInterop-late'
```

---
### Proceed
- **Next:** [303. Build OpenSSL](303-Build-OpenSSL.md)
- **Previous:** [301. Copy Certificates](301-Copy-Certificates.md)
- **Up:** [300. Gather Build Pieces](300-Gather-Build-Pieces.md)

---
[MIT License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
