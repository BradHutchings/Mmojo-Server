## Build Mmojo Server for Debian Linux
### About this Guide
In this guide, you will build ELF executables of Mmojo Server, Mmojo RPC Server, and llama.cpp targets for your computer's CPU family &mdash; x86_64 or aarch64 (arm64). You will test your Mmojo Server and Mmojo RPC Server builds. You will package your Mmojo Server and Mmojo RPC Server for later use or external deployment.

You can build with three compatibility options:
- **Compatible:** Runs on most systems that use a CPU from your computer's CPU family. 
- **Performant:** Runs on systems that use a recent CPU from your computer's CPU family.
  - For x86_64, these are x86_64 CPUs that support "level 3" flags, as defined by the gnu cc compiler.
  - For aarch64 (arm64), these are aarch64 CPUs that support ??? flags, as defined by the gnu cc compiler. These include all Apple M-series CPUs.
- **Native:** Runs on systems with a CPU that includes all of the CPU flags your computer's CPU includes. This includes your computer.

Windows Subsystem for Linux (WSL) supports NVIDIA GPUs through CUDA libraries. If you're building for WSL, be sure to enable CUDA below.

These build steps should be performed in a Debian Linux operating system like Ubuntu or Raspberry Pi. Please prepare your Debian environment by working through one these deploy recipes:
- [Deploy Mmojo Server on Windows (WSL)](/deploy/Windows-WSL/README.md) 
- [Deploy Mmojo Server on Debian / Ubuntu / Raspberry Pi](/deploy/Debian-Ubuntu-Pi/README.md) 

**Get Started:**
- [01. Build Mmojo Server](01-Build-Mmojo-Server.md) &mdash; Build Mmojo Server, Mmojo RPC Server, and other llama.cpp targets.

---
### Build Steps
- [01. Build Mmojo Server](01-Build-Mmojo-Server.md) &mdash; Build Mmojo Server, Mmojo RPC Server, and other llama.cpp targets.
- [02. Test Mmojo Server](02-Test-Mmojo-Server.md) &mdash; Test Mmojo Server.
- [03. Test Mmojo RPC Server](03-Test-Mmojo-RPC-Server.md) &mdash; Test Mmojo RPC Server.
- [04. Package for Debian Linux](04-Package-for-Debian.md) &mdash; Package your builds for Debian Linux.

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
