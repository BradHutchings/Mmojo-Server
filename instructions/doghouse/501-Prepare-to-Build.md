## 501. Prepare to Build
### About Doghouse
**Doghouse** is an example of a branded developer experience. [Read more about Doghouse](500-Build-Doghouse.md).

---
### About this Step
In this step, we will clone the Mmojo-Server repo, fix problems that affect building with Cosmopolitan, and customize things for building Doghouse.

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
Clone llama.cpp repo and repos upon which it depends into a `$DOGHOUSE_BUILD_DIR` directory.

This script clones the llama.cpp repo and repos upon which it depends into the `$DOGHOUSE_BUILD_DIR` directory:
- View the script: <a href="../../scripts/mm-prepare-clone-repo.sh" target="_blank">mm-prepare-clone-repo.sh</a>.
  - *On Github, you may need to right-click and choose "Open link in new tab" to open the "View script" links in a new tab.*
    <br/>
    <br/>
- Run the script. We run with `.` so variables can be defined and exported.
  ```
  mm-prepare-clone-repo.sh doghouse
  ```

---
### Patch llama.cpp Source Code and Build Code, Customize for Doghouse
This looks like lots of fun.
- View the script: <a href="../../scripts/mm-prepare-patch-llama-cpp.sh" target="_blank">mm-prepare-patch-llama-cpp.sh</a>.
- View the script: <a href="../../scripts/doghouse/501-Customize-llama-cpp.sh" target="_blank">501-Customize-llama-cpp.sh</a>.
- Run the scripts.
  ```
  mm-prepare-patch-llama-cpp.sh doghouse
  $DOGHOUSE_SCRIPTS/501-Customize-llama-cpp.sh
  ```

---
### Customize WebUI
Customize the web UI, rebuild all the web files.
- View the script: <a href="../../scripts/501-Customize-webui.sh" target="_blank">501-Customize-webui.sh</a>.
- Run the script.
  ```
  $MMOJO_SERVER_SCRIPTS/501-Customize-webui.sh doghouse
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
mm-prepare-clone-repo.sh doghouse
mm-prepare-patch-llama-cpp.sh doghouse
$DOGHOUSE_SCRIPTS/501-Customize-llama-cpp.sh
$MMOJO_SERVER_SCRIPTS/501-Customize-webui.sh doghouse
```

---
### Proceed
- **Next:** [502. Prepare to Test](502-Prepare-to-Test.md)
- **Previous:** This is the first step in this section.
- **Up:** [500. Build Doghouse](500-Build-Doghouse.md)

---
[MIT License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
