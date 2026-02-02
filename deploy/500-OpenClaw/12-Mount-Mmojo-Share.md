## 12. Mount Mmojo Share
### About this Step (OPTIONAL)
In this step, you will mount your Mmojo Share, if you have one. You can skip this step if you don't have a Mmojo Share.

---
### Create Mmojo Share Mount Point and Mount Script
This script creates a mount point for the Mmojo Share and a script for mounting the Mmojo Share:
- View script: <a href="../scripts/206-Create-Mmojo-Share-Mount-Point.sh" target="_blank">206-Create-Mmojo-Share-Mount-Point.sh</a>.
  - *On Github, you may need to right-click and choose "Open link in new tab" to open the "View script" links in a new tab.*
    <br/>
    <br/>
- Run the script. We run with `.` so variables can be defined and exported.
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
Mount the Mmojo share and list its contents.
```
mm-mount-mmojo-share.sh
ls -al /mnt/mmojo
```

---
### Proceed
- **Next:** [13. Download Mmojo Server from Hugging Face](13-Download-Mmojo-Server-from-Hugging-Face.md)
- **Previous:** [11. Prepare WSL - Mmojo Server](11-Prepare-WSL-Mmojo-Server.md)
- **Up:** [Deploy OpenClaw (WSL)](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
