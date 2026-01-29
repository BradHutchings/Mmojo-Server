## 600. Package llama-server
### About the Build llama-server Track
**llama-server** is the project upon which Mmojo Server builds. [Read more about llama-server](500-Build-llana-server.md).

---
### About this Section
Now that you have llama-server built as an Actual Portable Executable (APE) file, you can package it for deployment.

---
### Package llama-server
Here are some packaging options:
- [620. APE Packages](620-APE-Packages.md) - Package llama-server as Actual Portable Executable (APE) files, which can run on several operating systems spanning x86_64 and aarch64 (ARM64) arcitectures.
  - [621. APE (Compatible)](621-APE-Compatible.md) - The "compatible" APE runs (slowly) on a wide variery of x86_64 and aarch64 (arm64) machines.
  - [622. APE (Performant)](622-APE-Performant.md) - The "performant" APE runs faster, but only on later model x86_64 machines and high end aarch64 (arm64) machines like Apple's M*-based Macs.
  - [623. Naked APE (Compatible)](623-Naked-APE-Compatible.md) - This is a compatible APE with no `.gguf` file. You can `zip` a `.gguf` file onto it or copy one into the working directory, and it will just find it. No need to update the `mmojo-server-args` file!
  - [624. Naked APE (Performant)](624-Naked-APE-Performant.md) - This is a performant APE with no `.gguf` file. You can `zip` a `.gguf` file onto it or copy one into the working directory, and it will just find it. No need to update the `mmojo-server-args` file!<br/><br/>

**Get Started:** [620. APE Packages](620-APE-Packages.md)

---
[MIT License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
