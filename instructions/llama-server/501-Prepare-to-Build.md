## 501. Prepare to Build
### About the Build llama-server Track
**llama-server** is the project upon which Mmojo Server builds. [Read more about llama-server](500-Build-llana-server.md).

---
### About this Step
In this step, we will clone the Mmojo-Server repo, then optionally fix problems that affect building with Cosmopolitan and packaging for distribution. While additional code from Mmojo Server are kept, no additional branding is applied. Your builds will be mostly indistinguishable from building llama.cpp from scratch.

**Where:** Perform this step in both your x86_64 and your aarch64 (arm64) build environments.

**Shortcut:** [Scroll down](#shortcut-run-all-the-above-scripts).

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
### Clone Repos
Clone llama.cpp repo and repos upon which it depends into a `$LLAMA_SERVER_BUILD_DIR` directory.

This script clones the llama.cpp repo and repos upon which it depends into the `$LLAMA_SERVER_BUILD_DIR` directory:
- View the script: <a href="../../scripts/mm-prepare-clone-repo.sh" target="_blank">mm-prepare-clone-repo.sh</a>.
  - *On Github, you may need to right-click and choose "Open link in new tab" to open the "View script" links in a new tab.*
    <br/>
    <br/>
- Run the script. We run with `.` so variables can be defined and exported.
  ```
  mm-prepare-clone-repo.sh llama-server
  ```
---
### Customize, or Nah?
If you'd like additional source code enhancements from Mmojo Server, you should patch and customize with the two scripts below. If not, you should stop here and start building.

---
### Patch llama.cpp Source Code and Build Code, Customize for Doghouse
This looks like lots of fun.
- View the script: <a href="../../scripts/501-Patch-llama-cpp.sh" target="_blank">501-Patch-llama-cpp.sh</a>.
- View the script: <a href="../../scripts/llama-server/501-Customize-llama-cpp.sh" target="_blank">501-Customize-llama-cpp.sh</a>.
- Run the scripts.
  ```
  $MMOJO_SERVER_SCRIPTS/501-Patch-llama-cpp.sh llama-server
  $LLAMA_SERVER_SCRIPTS/501-Customize-llama-cpp.sh
  ```

<!--
---
### Optional: Patch llama.cpp Source Code and Build Code
If you want to build Actual Portable Executable (APE) files with Cosmopolitan or package conveniently for distribution, you need to patch some of the llama.cpp code with this script.
- View the script: <a href="../../scripts/501-Patch-llama-cpp.sh" target="_blank">501-Patch-llama-cpp.sh</a>.
- Run the scripts.
  ```
  $MMOJO_SERVER_SCRIPTS/501-Patch-llama-cpp.sh llama-server
  ```
-->

---
### Optional: Customize WebUI
If you want to customize the WebUI to use **llama-server** as the title, run this script.
- View the script: <a href="../../scripts/501-Customize-webui.sh" target="_blank">501-Customize-webui.sh</a>.
- Run the script.
  ```
  $MMOJO_SERVER_SCRIPTS/501-Customize-webui.sh llama-server
  ```

<!--
#### Uh. Oh. npm Spit Out Errors

You may have an earlier version of `npm` and `nodejs` installed on your build machine than are required for that customization step. If you're running Linux or macOS, these steps should clean that up. This reinstall is already in this step: [207. Install Dependencies](../207-Install-Dependencies.md). I'm leaving this workaround here until I'm sure it's not needed.

**ONLY RUN THESE IF YOU HAD PROBLEMS IN THE PREVIOUS STEP!!** Then rerun the previous step.
```
sudo apt remove nodejs npm -y
sudo apt install nodejs npm -y
sudo npm install -g node@latest
sudo npm install -g npm@latest
```
-->

---
### SHORTCUT: Run All the Above Scripts 
I really think you should run through these scripts one at a time the first few times you build, so you can familiarize yourself with the process and know what goes where. But, now that you've run through a few times, you can use the shortcut snippet:
```
################################################################################
# SHORTCUT: DON'T DO THIS IF YOU ALREADY RAN SCRIPTS ABOVE!
################################################################################
mm-prepare-clone-repo.sh llama-server
$MMOJO_SERVER_SCRIPTS/501-Patch-llama-cpp.sh llama-server
$LLAMA_SERVER_SCRIPTS/501-Customize-llama-cpp.sh
$MMOJO_SERVER_SCRIPTS/501-Customize-webui.sh llama-server
```

---
### Proceed
- **Next:** [502. Prepare to Test](502-Prepare-to-Test.md)
- **Previous:** This is the first step in this section.
- **Up:** [500. Build llama-server](500-Build-llama-server.md)

---
[MIT License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
