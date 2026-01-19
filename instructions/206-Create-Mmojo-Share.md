## 206. Create Mmojo Share

---
### About the Step
The Mmojo Share is a file share where I keep files for local access and completed builds. It lets me build different items on different build platforms. I use a Ubuntu 24.04 virtual machine to build and test x86_64 and cosmo builds. I use a Raspberry Pi for building and testing ARM64 and Pi specific builds. The Mmojo Share lets me keep .gguf models to test with locally and is where I copy completed and packaged builds. Your Mmojo Share will help you organize your builds as well.

In this step, we will create a Mmojo Share on a device running Linuz. We will install the necessary SMB software, configure `smb.conf`, restart the SMB server, and set it to start automatically at system startup. You can perform this step on another computer on your network if you like.

If you have a Mmojo Share already set up, skip ahead to the next step: [206. Mount Mmojo Share](206-Mount-Mmojo-Share.md).

**Where:** Perform this step on a computer on your network reachable by other build environments on your network.

---
### Enable File Sharing and Create Mmojo Share &mdash; Windows 10/11
If you plan to build in a WSL enivoronment, setting up your Mmojo Share on the host computer is a good approach.

Here is a good video that shows how to enable file sharing and create an SMB share on Windows 10 and 11.

https://www.youtube.com/watch?v=c_ZlwFktayQ

The video's recommendation to turn password protected sharing off may be workable for a private home network. If you do this, you won't have to manage users for the SMB share.

---
### Install Samba and Create Mmojo Share &mdash; Ubuntu and other Debian Linux
Here is the official Ubunutu tutorial for installing Samba and creating a share.

https://ubuntu.com/tutorials/install-and-configure-samba#1-overview

If you're building in your WSL environment, that is not a good place to set up a file share because you will likely rebuild that encvironment from scratch often. You want a place that can hold the files you keep permanently.

---
### Create Directories on Mmojo Share
Make the directories we'll use.

---
### Proceed
- **Next:** [207. Mount Mmojo Share](207-Mount-Mmojo-Share.md)
- **Previous:** [205. Set Timezone](205-Set-Timezone.md)
- **Up:** [200. Prepare Build Environment](200-Prepare-Build-Environment.md)

---
[MIT License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
