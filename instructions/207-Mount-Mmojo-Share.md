## 207. Mount Mmojo Share
### About the Step
The Mmojo Share is a file share where I keep files for local access and completed builds. It lets me build different items on different build platforms. I use a Ubuntu 24.04 virtual machine to build and test x86_64 and cosmo builds. I use a Raspberry Pi for building and testing ARM64 and Pi specific builds. The Mmojo Share lets me keep .gguf models to test with locally and is where I copy completed and packaged builds. Your Mmojo Share will help you organize your builds as well.

**Where:** Perform this step in both your x86_64 and your aarch64 (arm64) build environments.

---
### Create Mmojo Share Mount Point and Mount Script
This script creates a mount point for the Mmojo Share and a script for mounting the Mmojo Share:
- View script: <a href="../scripts/mm-share-create-mount-point.sh" target="_blank">mm-share-create-mount-point.sh</a>.
  - *On Github, you may need to right-click and choose "Open link in new tab" to open the "View script" links in a new tab.*
    <br/>
    <br/>
- Run the script. We run with `.` so variables can be defined and exported.
  ```
  mm-share-create-mount-point.sh
  ```

---
### Edit the Mmojo Share Mount Script
Edit the script to put your `COMPUTER` and `USER` names in. `Ctrl-X`, then `Y`, then `Enter` to exit and save.
```
nano "$HOME_SCRIPTS/$MMOJO_SHARE_MOUNT_SCRIPT"
```

---
### Mount the Mmojo Share
Mount the Mmojo share and list its contents.
```
mm-share-mount.sh
ls -al /mnt/mmojo
```

---
### Proceed
- **Next:** [208. Install Dependencies](208-Install-Dependencies.md)
- **Previous:** [206. Create Mmojo Share](206-Create-Mmojo-Share.md)
- **Up:** [200. Prepare Build Environment](200-Prepare-Build-Environment.md)

---
[MIT License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
