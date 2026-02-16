## 03. Mount Mmojo Share
### About this Step
In this step, you will mount your Mmojo Share, if you have one. Your Mmojo Share can be any SMB file share on your computer or your network. You will need it's host address, share name, username, and password.

Your Mmojo Share will be used to automatcally store models that you download from Hugging Face so that you only have to download them once. That will save you a lot of time.

If you don't have an SMB file share available to use on your computer or network, you can skip this step.

**Skip Ahead:**
- [04. Download Models](04-Download-Models.md)

---
### Create Mmojo Share Mount Point and Mount Script
This script creates a mount point for the Mmojo Share and a script for mounting the Mmojo Share:
```
mm-share-create-mount-point.sh
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
- **Next:** [04. Download Models](04-Download-Models.md)
- **Previous:** [02. Prepare WSL - Mmojo Server](02-Prepare-WSL-Mmojo-Server.md)
- **Up:** [Deploy Mmojo Server on Windows (WSL)](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
