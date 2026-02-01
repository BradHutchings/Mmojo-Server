## 01. Prerequisites
### About this Step
This step contains prerequisites for deploying OpenClaw and Mmojo Server using this recipe. We will install each in its own Windows Subsystem for Linux (WSL) instance.

---
### Requirements
This recipe deploys OpenClaw and Mmojo Server on a single, stand-alone Windows 10/11 PC or laptop:
- x86_64 CPU
  - There are portions of this recipe that will not work on ARM CPUs without adjustment.
- 32 GB RAM
  - Mmojo Server needs plenty of RAM to run an 8B paramter model.
- Modern NVIDIA GPU with at least 4 GB VRAM
  - OpenClaw doesn't tolerate CPU inference pace, times out.
  - WSL only supports a bridge to NVIDIA GPUs.
- Windows 10/11 support WSL and have the feature enabled.

---
### Recommendations
The following are recommended for smoothest sailing through this recipe:
- Mmojo Share configured and accessible on your network.
  - This is a good place to store builds and models so you don't have to download them from Hugging Face.
- Familiarity with WSL.
  - The WSL specific instructsions can be confusing for new users of WSL. I will be adding video walkthroughs to help you out.
- Familiarity with Mmojo Server build process.
  - If you're managed to build one, deploying with OpenClaw will be easy.

---
### Proceed
- **Next:** [02. Cleanup WSL Instances](02-Cleanup-WSL-Instances.md)
- **Previous:** This is the first step in this section.
- **Up:** [Deploy OpenClaw (WSL)](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
