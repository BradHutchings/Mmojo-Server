## 200. Prepare Build Environment
### About this Section
**THESE ARE OLD INSTRUCTIONS FROM MMOJO SERVER V1 AND V2. SOME PORTIONS REMAIN HERE FOR REFERENCE.**

Before you can build Mmojo Server, you need to set up a build environment. I use three build environments regularly:
- Ubuntu 24.04 for x86_64 in a Windows Subsystem for Linux (WSL) instance.
- Ubuntu 24.04 Server (Debian 13 Trixie) for x86_64 in a virtual machine.
- Raspberry Pi OS (Debian 13 Trixie) for Raspberry Pi 5 (aarch64/arm64).

If you want your platform native builds to support Debian 12 Bookworm, use Ubuntu 23.04 Server for x86_64 and Bookworm version of Raspberry Pi OS. The compatibility issue is that you need to link against the earliest glibc that you support. This only affects platform native builds. Actual Portable Executable (APE) builds statically link against the Cosmo glibc.

I plan to add into my regular mix and provide custom build instructions in the future:
- macOS on Mac Mini M4.
- RHEL, CentOS Stream, Oracle Linux, etc. for x86_64 in a virtual machine.

You only need to prepare each build environment once. You can update your local clone of the Mmojo Server Repo with a command we install: `mm-repo-update-local.sh`. You still may want to rebuild your build environments from scratch occasionally.

If you have already prepared your build environments, skip ahead to: 
- [300. Gather Build Pieces](300-Gather-Build-Pieces.md)

---
### Preparing Your Build Environment
Here are the things you need to do:
- [201. Prepare WSL](201-Prepare-WSL.md) - Prepare your Windows Subsystem for Linux (WSL) environment if you're using one.
- [202. Prepare macOS](202-Prepare-macOS.md) - Prepare your macOS environment if you're using one.
- [203. Create Scripts Directory](203-Create-Scripts-Directory.md) - Create `$HOME/mmscripts` directory, then add it to your `$PATH`.
- [204. Clone Mmojo Server Repo](204-Clone-Mmojo-Server-Repo.md) - Clone Mmojo Server Repo for setup and build scripts.
- [205. Set Timezone](205-Set-Timezone.md) - Set your build system's time zone so Completion UI reflects correct build date.
- [206. Create Mmojo Share](206-Create-Mmojo-Share.md) - Create a file share to support multiple build environments.
- [207. Mount Mmojo Share](207-Mount-Mmojo-Share.md) - Mount a file share to support multiple build environments.
- [208. Install Dependencies](208-Install-Dependencies.md) - Install packages needed for your build system.
- [209. mm- Scripts](209-mm-Scripts.md) - All about those `mm-` scripts in your `$HOME/mm-scripts` directory.

**Get Started:** [201. Prepare WSL](201-Prepare-WSL.md)

---
### Video Walkthrough
This video walks through preparing WSL, creating the `mm-scripts` directory, cloning the Mmojo Server repo, setting the timezone, mounting the Mmojo Share, and installing dependencies.

https://www.youtube.com/watch?v=gX4XR1H9WI8

---
[MIT License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
