## 01. Prerequisites
### About this Step
This step contains prerequisites for deploying OpenClaw and Mmojo Server using this recipe. We will install each in its own Windows Subsystem for Linux (WSL) instance.

**Skip Ahead:** [02. Deploy Mmojo Server](02-Deploy-Mmojo-Server.md)

*When you are finished with this step, proceed to the next step using the **Proceed** links at the bottom of this page.*

---
### Requirements
This recipe deploys OpenClaw and Mmojo Server on a single, stand-alone Windows 10/11 PC or laptop:
- x86_64 CPU
  - There are portions of this recipe that will not work on ARM CPUs without adjustment.
  - I will add side notes in the future for use on ARM CPUs.
  - So-called "AI" laptops and desktops are not helpful. Mmojo Server (llama.cpp) needs GPUs.
- 32 GB RAM
  - Mmojo Server needs plenty of RAM to run an 8B paramter model.
- Modern NVIDIA GPU with at least 4 GB VRAM
  - OpenClaw doesn't tolerate CPU inference pace, times out.
  - WSL only supports a bridge to NVIDIA GPUs.
- Windows 10/11 support WSL and have the feature enabled.

**While these steps are similar for general stand-alone Debian / Ubuntu Linux and may look workable for macOS, they are not intended for use on such systems.**


---
### Recommendations
The following are recommended for smoothest sailing through this recipe:
- A second (fast) disk for WSL instance storage.
  - 4 TB recommended.
  - It's not a WSL instance exclusive disk. Store other data on it too.
  - This will keep your startup disk from getting full unexpectedly.
- An NVIDIA GPU with more VRAM will allow you to run bigger models.
  - OpenClaw doesn't seem to run very well yet with 3B and 8B models.
  - Bigger models seem to more reliable.
- Familiarity with WSL.
  - The WSL specific instructsions can be confusing for new users of WSL. I will be adding video walkthroughs to help you out.

---
### Proceed
- **Next:** [02. Deploy Mmojo Server](02-Deploy-Mmojo-Server.md)
- **Previous:** This is the first step in this section.
- **Up:** [Deploy OpenClaw (WSL)](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
