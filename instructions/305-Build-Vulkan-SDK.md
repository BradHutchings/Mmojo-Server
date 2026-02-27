## 305. Build Vulkan SDK
### About this Step
Vulkan is a newer industry standard API to help applications work seamlessly with GPUs from different vendors. GPU vendors provide Vulkan interfaces for their GPUs, which are loaded dynamically by applications which use the Vulkan API. It should be the easiest way to add GPU support to your builds for any particular device you have. However:

- Metal support on Mac M* chips is provided through a third-party open source project.
- Many systems with small GPUs do not support a large enough `maxComputeSharedMemorySize` in Vulkan for llama.cpp to work with it. Such systems include Raspberry Pi 5 and Intel Iris Xe built-in graphics.
- Since Vulkan interfaces with a dynamic library, we can't link to it with cross-platform and cross-architecture Cosmo builds.

**Where:** Perform this step in both your x86_64 and your aarch64 (arm64) build environments.

---
<details>
  <summary><b>Update Local Mmojo Server Repo</b> &mdash; Expand if you haven't today.</summary>
  
Have you updated your local clone of the Mmojo Server Repo today? If not, run this first:
```
mm-repo-update-local.sh
mm-env
```
</details>

---
### Ubuntu / Debian
Building the Vulkan SDK can take a couple of hourse. This quick install on Debian / Ubuntu *should* get a build working for you. Try this first.
```
sudo apt install libvulkan-dev glslc vulkan-tools
```

Run this command to verify that Vulkan is installed and see which GPUs on your system it recognizes.
```
vulkaninfo --summary
```

When you get to the [521. Build Executables Compatible](521-Build-Executables-Compatible.md) step, try building with Vulkan GPU support. If the build gets through creating Vulkan shaders, you have what you need. Otherwise, proceed below.

***Reference:** [llama.cpp commit 16cc3c6](https://github.com/ggml-org/llama.cpp/commit/16cc3c606efe1640a165f666df0e0dc7cc2ad869)*

---
### Fast Builds
If you're working in a build environment that has more than 4 CPU threads available, run this command:
```
export VULKAN_SIMULTANEOUS_COMPILES=8
```

Otherwise, we'll use the default 4.

---
### Download Vulkan, Build Locally
This script downloads the latest tested Vulkan source into a `$BUILD_VULKAN_DIR` directory, then build Vulkan. Build this once, and leave the `$BUILD_VULKAN_DIR` directory between Mmojo Server builds. This takes about an hour on a fast PC (e.g. 12th generation i9) and several hours on a slow PC (e.g. Raspberry Pi 5).
- View the script: <a href="../scripts/305-Download-Build-vulkan.sh" target="_blank">305-Download-Build-vulkan.sh</a>.
  - *On Github, you may need to right-click and choose "Open link in new tab" to open the "View script" links in a new tab.*
    <br/>
    <br/>
- Run the script. We run with `.` so variables can be defined and exported.
  ```
  $MMOJO_SERVER_REPO_SCRIPTS/305-Download-Build-vulkan.sh
  . mm-environment-variables.sh
  ```

***Note:** You may need to confirm installation of packages and wade through a pink outgoing mail configuration screen.*

---
### Verify that Vulkan is Installed
Run this command to verify that Vulkan is installed and see which GPUs on your system it recognizes.
```
vulkaninfo --summary
```

---
### Proceed
- **Next:** This is the last step in this section.
- **Previous:** [304. Install CUDA Toolkit](304-Install-CUDA-Toolkit.md)
- **Up:** [300. Gather Build Pieces](300-Gather-Build-Pieces.md)

---
### Next Section
- **Next Section:** [400. Gather Models](400-Gather-Models.md)

---
[MIT License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
