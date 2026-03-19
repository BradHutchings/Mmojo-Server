## Build Mmojo Server for All Platforms
### About this Guide
In this guide, you will build Actual Portable Executable (APE) files that will run on x86_64 and aarch64 (arm64) processors with Windows, macOS, Linux, and other less common operating systems. APE builds are statically linked with no dependencies on dynamic libraries. I use the APE build as a first thing for clients to download and get Mmojo Server running quickly on their computers. If they like, they can "upgrade" to a more performant platform-specific version later.

These build steps should be performed in a Debian Linux operating system like Ubuntu or Raspberry Pi. Please prepare your Debian environment by working through one these deploy recipes:
- [Deploy Mmojo Server on Windows (WSL)](/deploy/Windows-WSL/README.md) 
- [Deploy Mmojo Server on Debian / Ubuntu](/deploy/Debian-Ubuntu/README.md) 
- [Deploy Raspberry Pi](/deploy/Raspberry-Pi/README.md) 

**Get Started:**
- [01. Build Mmojo Server](01-Build-Mmojo-Server.md) &mdash; Build Mmojo Server, Mmojo RPC Server, and other llama.cpp targets.

---
### Build Steps
- [01. Build Mmojo Server](01-Build-Mmojo-Server.md) &mdash; Build Mmojo Server, Mmojo RPC Server, and other llama.cpp targets.
- [02. Test Mmojo Server](02-Test-Mmojo-Server.md) &mdash; Test Mmojo Server.
- [03. Package for All Platforms](03-Package-for-All-Platforms.md) &mdash; Package your builds for all platforms.
- [04. Package for All Platforms](04-Package-for-All-Platforms.md) &mdash; Package your builds for all platforms.
- [05. Package for All Platforms](05-Package-for-All-Platforms.md) &mdash; Package your builds for all platforms.

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
