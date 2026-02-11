## 01. Prerequisites
### About this Step
This step contains prerequisites for deploying Mmojo Server using this recipe. We will install Mmojo Server in its own Windows Subsystem for Linux (WSL) instance.

**Skip Ahead:**
- [02. Prepare WSL - Mmojo Server](02-Prepare-WSL-Mmojo-Server.md)

---
### Requirements
This recipe deploys Mmojo Server on a single, stand-alone Windows 10/11 PC or laptop:
- x86_64 or AARCH64 (ARM64) CPU
  - So-called "AI" laptops and desktops are not helpful. Mmojo Server (llama.cpp) for WSL uses NVIDIA GPUs when available.
- 16 GB RAM
  - Mmojo Server needs plenty of RAM to run an 8B parameter model.
  - 24 GB RAM or more will let you run other tasks comfortably while running an 8B parameter model.
- Windows 10/11 support WSL and have the feature enabled.

**While these steps are similar for general stand-alone Debian / Ubunut Linux and may look workable for macOS, they are not intended for use on such systems.**

---
### Recommendations
The following are recommended for smoothest sailing through this recipe:
- A second (fast) disk for WSL instance storage.
  - 4 TB recommended.
  - It's not a WSL instance exclusive disk. Store other data on it too.
  - This will keep your startup disk from getting full unexpectedly.
- Modern NVIDIA GPU with at least 4 GB VRAM
  - WSL only supports a bridge to NVIDIA GPUs.
- Familiarity with WSL.
  - The WSL specific instructsions can be confusing for new users of WSL. I will be adding video walkthroughs to help you out.
- File share on your network that you can use as a Mmojo Share.
  - This is a good place to store builds and models so you don't have to download them from Hugging Face.
 
---
### Proceed
- **Next:** [02. Prepare WSL - Mmojo Server](02-Prepare-WSL-Mmojo-Server.md)
- **Previous:** This is the first step in this section.
- **Up:** [Deploy Mmojo Server on Windows (WSL)](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
