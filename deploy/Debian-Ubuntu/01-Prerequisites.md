## 01. Prerequisites
### About this Step
This step contains prerequisites for deploying Mmojo Server using this recipe. We will install Mmojo Server in a home directory of a dedicated Linux account on your device.

**Skip Ahead:**
- [02. Prepare Debian](02-Prepare-Debian.md)

*When you are finished with this step, proceed to the next step using the **Proceed** links at the bottom of this page.*

---
### Requirements
This recipe deploys Mmojo Server on a single, stand-alone PC or laptop running a Debian based Linux operating system:
- x86_64 or AARCH64 (ARM64) CPU.
  - So-called "AI" laptops and desktops are not helpful. Mmojo Server (llama.cpp) for Debian that I offer for download can use NVIDIA GPUs.
  - You can build a custom Mmojo Server for your PC that supports GPUs which have Vulkan interfaces, e.g. AMD.
- 16 GB RAM.
  - Mmojo Server needs plenty of RAM to run an 8B parameter model.
  - 24 GB RAM or more will let you run other tasks comfortably while running an 8B parameter model.

**While these steps may look workable for macOS, they are not intended for use on such systems.**

---
### Recommendations
The following are recommended for smoothest sailing through this recipe:
- Modern NVIDIA GPU with at least 4 GB VRAM.
  - WSL only supports a bridge to NVIDIA GPUs.
- Familiarity with Linux and command-line.
  - I will be adding video walkthroughs to help you out.
- File share on your network that you can use as a Mmojo Share.
  - This is a good place to store builds and models so you don't have to download them from Hugging Face.
 
---
### Proceed
- **Next:** [02. Prepare Debian](02-Prepare-Debian.md)
- **Previous:** This is the first step in this section.
- **Up:** [Deploy Mmojo Server on Debian / Ubuntu](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
