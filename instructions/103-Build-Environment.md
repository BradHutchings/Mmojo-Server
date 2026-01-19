## 103. Build Environment
### Build Systems
Your Mmojo Server build environment will consist of one or more build systems, depending on what you're trying to build. 

- The Mmojo Server Actual Portable Executable (APE) can be built on one Linux system running on either an x86_64 or an aarch64 (arm64) CPU.
- Other than the APE, cross-platform (OS and/or architecture) builds don't work well with llama.cpp. You should build for the deployment platform on the deployment platform. So...
  - **You will need multiple build environments.**
- You should keep your build environments from polluting and being polluted by your everyday work. You will want to rebuild them from scratch occasionally / often. A build environment dedicated to building Mmojo Server will work best for you. So...
  - **Your build environments, ideally, will be containers, virtual machines (VMs), Windows Subsystem for Linux (WSL) instances, etc. Less than ideally, bootable thumb drives for e.g. Raspberry Pi.**
- GPU SDKs and Toolkits are typically available for hardware and operating systems the GPU drivers run on. You'll want to test GPU performance of your builds. So...
  - **You will usually need to build directly on hardware that has the GPU you want your build to use.**
  - WSL provides a working bridge for CUDA / NVIDIA GPUs.
  - WSL does not provide a working bridge for Vulkan.
  - VMs typically don't provide GPU support. Where they do, they require advanced setup.
 
In short, you can use one build system if you want to build an APE or are targeting a specific OS/CPU/GPU combination. You will probably have several build systems if you want to build out a robust deployment offering.

---
### Mmojo Share
A file share that is accessible to all of your build systems will help you coordinate building and packaging. It's also a place you can store large downloads, such as `.gguf` model files and GPU SDKs, that can survive rebuilding of your individual build systems. I use a CIFS share I host on my main computer and call my Mmojo Share. It's mounted at `/mnt/mmojo` on each of my Linux build systems.

---
### WSL vs Windows
Windows Subsystem for Linux (WSL) lets you run a full Linux distribution directly on Windows. For building and deploying Mmojo Server for Windows computers, it offers a few advantages and disadvantages over the native Windows environment:

1. (Advantage WSL): No executable size limit. Windows itself has a 4 GB `.exe` size limit. For Mmojo Server, this means we cannot run an Actual Portable Executable (APE) file containing an LLM in the 4B parameter range or higher!
2. (Advantage WSL): If you have NVIDIA drivers installed on your Windows host for a GPU that supports CUDA, you can run CUDA software from within WSL.
3. (Advantage WSL): I don't have instructions for building directly on or for Windows (yet).
4. (Advantage Windows): Vulkan demonstration software can be run with experimental, hard to find bridge software installed within WSL. The bridge software does not work well for Mmojo Server.

Hyper-V virtual machines run on Windows 11 Pro do not have access to the host system's GPU. While they may offer a more robust sandbox for CPU inference with Mmojo Server, they tend to be less convenient and more work than WSL.

There is a [201. Prepare WSL](201-Prepare-WSL.md) step in the next section to help you with WSL.

---
### Help is in the Instructions
I'll help you build set up these build systems, set up a Mmojo Share, connect to the share from the build systems, and install required software, projects, SDKs, and toolkits in the [200. Prepare Build Environment](200-Prepare-Build-Environment.md) and [300. Gather Build Pieces](300-Gather-Build-Pieces.md) sections.

---
### Proceed
- **Next:** [104. Build Targets](104-Build-Targets.md)
- **Previous:** [102. Project Features](102-Project-Features.md)
- **Up:** [100. Overview](100-Overview.md)

---
[MIT License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
