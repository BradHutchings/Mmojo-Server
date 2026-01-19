## 304. Install CUDA Toolkit
### About this Step
CUDA is... NVIDIA

**Where:** Perform this step in both your x86_64 and your aarch64 (arm64) build environments.

---
<details>
  <summary><b>Update Local Mmojo Server Repo</b> &mdash; Expand if you haven't today.</summary>
  
Have you updated your local clone of the Mmojo Server Repo today? If not, run this first:
```
mm-update-local-mmojo-server-repo.sh
mm-env
```
</details>

---
### Install with `apt`
This works as we need it to with WSL and Ubuntu 24.04 in a virtual machine:
```
sudo apt install -y nvidia-cuda-toolkit
```

It installs `nvcc` in `/usr/bin`. CMake should be able to see it.

---
### Find Download and Install Script
If installing with `apt` did not work, go here, find your toolkit, run the install script. This link will get you the right stuff for WSL:

[CUDA Toolkit for WSL](https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&Distribution=WSL-Ubuntu&target_version=2.0&target_type=deb_local)

---
### Proceed
- **Next:** [305. Build Vulkan SDK](305-Build-Vulkan-SDK.md)
- **Previous:** [303. Build OpenSSL](303-Build-OpenSSL.md)
- **Up:** [300. Gather Build Pieces](300-Gather-Build-Pieces.md)

---
[MIT License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
