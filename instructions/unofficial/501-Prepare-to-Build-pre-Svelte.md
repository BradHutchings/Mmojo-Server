## 501. Prepare to Build (pre-Svelte)
### About this Step

**THIS IS HERE TO KEEP THE ROLLBACK TO PRE-SVELTE-UI STEP AVAILABLE. IT LOOKS LIKE NON-ROOT-PATH HOSTING OF THE CHAT-UI HAS BEEN FIXED AT SOME POINT. THIS IS HERE IN CASE THAT STOPS WORKING. -BRAD 2025-12-23**

In this step, we will clone this Mmojo-Server repo, fix problems that affect building with Cosmopolitan, and add some features for Mmojo Server.

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
Clone llama.cpp repo and repos upon which it depends into a `$BUILD_LLAMA_CPP_DIR` directory.

This script clones the llama.cpp repo and repos upon which it depends into the `$BUILD_LLAMA_CPP_DIR` directory:
- View the script: <a href="../scripts/501-Clone-Repos.sh" target="_blank">501-Clone-Repos.sh</a>.
  - *On Github, you may need to right-click and choose "Open link in new tab" to open the "View script" links in a new tab.*
    <br/>
    <br/>
- Run the script. We run with `.` so variables can be defined and exported.
  ```
  $MMOJO_SERVER_SCRIPTS/501-Clone-Repos.sh
  ```

---
### Patch llama.cpp Source Code and Build Code
This looks like lots of fun.
- View the script: <a href="../scripts/501-Patch-llama-cpp.sh" target="_blank">501-Patch-llama-cpp.sh</a>.
- Run the script.
  ```
  $MMOJO_SERVER_SCRIPTS/501-Patch-llama-cpp.sh
  ```

---
### Customize WebUI
#### Suggested
Rollback the `tools/server/webui` to the pre-Svelte version. The new Svelte UI doesn't like running on non-root web server path. We'll remove this step when the new UI is fixed upstream in llama.cpp.
- View the script: <a href="../scripts/501-Rollback-webui.sh" target="_blank">501-Rollback-webui.sh</a>.
- Run the script.
  ```
  $MMOJO_SERVER_SCRIPTS/501-Rollback-webui.sh
  ```

#### Required
Customize the web UI, rebuild all the web files. If you did the **Suggested** step above, you will see 2 `sed` errors.
- View the script: <a href="../scripts/501-Customize-webui.sh" target="_blank">501-Customize-webui.sh</a>.
- Run the script.
  ```
  $MMOJO_SERVER_SCRIPTS/501-Customize-webui.sh
  ```

<!--
#### Uh. Oh. npm Spit Out Errors

You may have an earlier version of `npm` and `nodejs` installed on your build machine than are required for that customization step. If you're running Linux or macOS, these steps should clean that up. This reinstall is already in this step: [207. Install Dependencies](207-Install-Dependencies.md). I'm leaving this workaround here until I'm sure it's not needed.

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
$MMOJO_SERVER_SCRIPTS/501-Clone-Repos.sh
$MMOJO_SERVER_SCRIPTS/501-Patch-llama-cpp.sh
$MMOJO_SERVER_SCRIPTS/501-Rollback-webui.sh
$MMOJO_SERVER_SCRIPTS/501-Customize-webui.sh
```

---
### Proceed
- **Next:** [502. Prepare to Test](502-Prepare-to-Test.md)
- **Previous:** This is the first step in this section.
- **Up:** [500. Build Mmojo Server](500-Build-Mmojo-Server.md)

---
[MIT License](/LICENSE)<br/>
Copyright (c) 2025 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
