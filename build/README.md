## Build Mmojo Server - Table of Contents
Mmojo Server build instructions are here. I use these to build Mmojo Server for the [Deploy](/deploy/README.md) offerings and my own products.

<!-- SPONSOR -->
I offer paid assistance over Zoom if you need it:
* [Paid Assistance](/docs/Paid-Assistance.md)

-Brad<br/>
\--<br/>
Brad Hutchings<br/>
brad@BradHutchings.com<br/><br/>
<!-- END SPONSOR -->

---
### APE Multi-platform, Multi-CPU
You can build an Actual Portable Executable (APE) file that runs on x86_64 and aarch64 (arm64), across Windows, macOS, Linux, and other platforms:
- [Build APE for All Platforms](ape/01-Build-APE-All-Platforms.md)
- [Test APE for All Platforms](ape/02-Test-APE-All-Platforms.md)
- [Package APE for All Platforms](ape/03-Package-APE-All-Platforms.md)

---
### ELF for Debian Linux, x86_64 or aarch64 (arm64)
You can build ELF binaries for Debian Linux (e.g. Ubuntu) in native CPU, performant CPU, and compatible CPU builds. They can support GPUs with CUDA and Vulkan support. This is the build recipe to use for Windows WSL.
- [Build ELF Executable for Debian Linux](elf-debian/01-Build-ELF-Debian-Linux.md)
- [Test ELF Executable for Debian Linux](elf-debian/02-Test-ELF-Debian-Linux.md)
- [Package ELF Executable for Debian Linux](elf-debian/03-Package-ELF-Debian-Linux.md)

---
### Future Build Guides
Here is a tentative list of planned build guides:
- Mach-O Executable for macOS.
- ELF Executable for RHEL (Linux)
- ELF Executable for Arch Linux

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
