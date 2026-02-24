## 208. Set up Cross Compile x86_64 on aarch64

**THIS PAGE NEEDS TO HAVE A WORKING SCRIPT INCLUDED FOR CROSS COMPILING X86_64 ON AARCH64/ARM<64. -Brad 2025-11-02**
**NOT IN THE TOC OR NEXT ARTICLE FLOW UNTIL WE NEED IT. -Brad**

---
### About this Step
Cross-compiling llama.cpp does not work very well right now. The llama.cpp CMake build system is meant to discover the capabilities of the host machine and build for that. In particular, I run into problems with OpenSSL that need to be patched for cosmocc builds to link in compatible static libraries.

I have not had success yet cross-compiling x86_64 builds on aarch64/arm64.

**Where:** Perform this step in both your aarch64 (arm64) build environment.

---
### Set up Cross Compile x86_64 on aarch64 (arm64)
Do this if you're running on aarch64/arm64.

- View the script in a new tab: <a href="../scripts/208-Set-up-Cross-Compile-x86_64-on-aarch64.sh" target="_blank">208-Set-up-Cross-Compile-x86_64-on-aarch64.sh</a>
  - *On Github, you may need to right-click and choose "Open link in new tab" to open the "View script" links in a new tab.*
    <br/>
    <br/>
- Run the script. We run with `.` so variables can be defined and exported.
  ```
  . mm-environment-variables.sh
  . $MMOJO_SERVER_REPO_SCRIPTS/208-Set-up-Cross-Compile-x86_64-on-aarch64.sh.sh
  ```

---
### Proceed
- **Next:** This is the last article in this section.
- **Previous:** [207. Set up Cross Compile - aarch64 on x86_64](207-Set-up-Cross-Compile-aarch64-on-x86_64.md)
- **Up:** [200. Prepare Build Environment](200-Prepare-Build-Environment.md)

---
### Next Section
- **Next Section:** [300. Gather Build Pieces](300-Gather-Build-Pieces.md)

---
[MIT License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
