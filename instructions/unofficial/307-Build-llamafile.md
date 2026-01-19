## 307. Build llamafile

**THIS IS NO LONGER NEEDED. -Brad 2025-11-08**

---
### About this Step - DO THIS ONCE
In this step, we will clone the llamafile repo and build it. This will give us access to llamafile's `zipalign` tool for packaging `mmojo-server-one`. You don't need to do this every time you build Mmojo Server.

This will be renamed "Build Tools" or "Build zipalign" or some such. `zipalign` is the only thing we need from this, built with `cosmocc`.

**Where:** Perform this step in both your x86_64 and your aarch64 (arm64) build environments.

---
### Clone llamafile Repo, Build Locally
Clone llamafile repo into a `$BUILD_LLAMAFILE_DIR` directory, then build llamfile. Build this once, and leave the `$BUILD_LLAMAFILE_DIR` directory between builds.

This script clones the llamafile repo to `$BUILD_LLAMAFILE_DIR`, then builds it:
- View the script: <a href="../../scripts/unofficial/307-Clone-Build-llamafile.sh" target="_blank">307-Clone-Build-llamafile.sh</a>.
  - *On Github, you may need to right-click and choose "Open link in new tab" to open the "View script" links in a new tab.*
    <br/>
    <br/>
- Run the script. We run with `.` so variables can be defined and exported.
  ```
  . mm-environment-variables.sh
  . $MMOJO_SERVER_SCRIPTS/unofficial/307-Clone-Build-llamafile.sh
  ```

Now, `zipalign` exists at `$BUILD_LLAMAFILE_DIR/bin/zipalign`.

---
### Proceed
<!--
- **Next:** [306. Build OpenSSL](306-Build-OpenSSL.md)
- **Previous:** [304. Build Cosmopolitan](304-Build-Cosmopolitan.md)
- **Up:** [300. Gather Build Pieces](300-Gather-Build-Pieces.md)
-->

---
[MIT License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
