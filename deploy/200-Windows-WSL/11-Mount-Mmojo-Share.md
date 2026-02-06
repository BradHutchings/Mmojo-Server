## 11. Mount Mmojo Share
### About this Step
In this step, you will mount your Mmojo Share, if you have one.

---
### Create Mmojo Share Mount Point and Mount Script
This script creates a mount point for the Mmojo Share and a script for mounting the Mmojo Share:
- View script: <a href="../../scripts/206-Create-Mmojo-Share-Mount-Point.sh" target="_blank">206-Create-Mmojo-Share-Mount-Point.sh</a>.
  - *On Github, you may need to right-click and choose "Open link in new tab" to open the "View script" links in a new tab.*
    <br/>
    <br/>
- Run the script. 
  ```
  $MMOJO_SERVER_SCRIPTS/206-Create-Mmojo-Share-Mount-Point.sh
  ```

---
### Edit the Mmojo Share Mount Script
Edit the script to put your `COMPUTER` and `USER` names in. `Ctrl-X`, then `Y`, then `Enter` to exit and save.
```
nano "$HOME_SCRIPTS/$MOUNT_MMOJO_SHARE_SCRIPT"
```

---
### Mount the Mmojo Share
Mount the Mmojo share and list its contents. You may be prompted for your Mmojo Share password.
```
mm-mount-mmojo-share.sh
ls -al /mnt/mmojo
```

---
### Proceed
- **Next:** [12. Copy Models from Mmojo Share](04-Copy-Models-from-Mmojo-Share.md)
- **Previous:** [02. Prepare WSL - Mmojo Server](02-Prepare-WSL-Mmojo-Server.md)
- **Up:** [Deploy Mmojo Server on Windows (WSL)](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
