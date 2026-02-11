## 511. Platform (Compatible)
### About the Build llama-server Track
**llama-server** is the project upon which Mmojo Server builds. [Read more about llama-server](500-Build-llana-server.md).

---
### About this Step
In this step, we will build `llama-server` and other llama.cpp targets to run on the widest variety of x86_64 and aarch64 machines, with optional GPU support.

**Where:** Perform this step in both your x86_64 and your aarch64 (arm64) build environments.

**Shortcut:** [Scroll down](#shortcut-build-llama-server-test).

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
### Choose GPUs to Include in Build
This script has you choose GPU support to include in the build. If you've already chosen GPUs, you do not have to choose them again.

- View the script: <a href="../scripts/mm-use-gpus.sh" target="_blank">mm-use-gpus.sh</a>.
  - *On Github, you may need to right-click and choose "Open link in new tab" to open the "View script" links in a new tab.*
    <br/>
    <br/>
- Run the script.
  ```
  . mm-use-gpus.sh
  ```

*I will make this easier to navigate soon! -Brad*

---
### Build llama-server and other llama.cpp Apps
This script uses cmake to build `llama-server`:
- View the script: <a href="../../scripts/510-Build-for-Platform.sh" target="_blank">510-Build-for-Platform.sh</a>.
- Run the script.
  ```
  $MMOJO_SERVER_SCRIPTS/510-Build-for-Platform.sh compatible "$CHOSEN_GPUS" llama-server
  ```

---
### Test llama-server
Requires previously downloaded model to the `$LOCAL_MODELS_DIR` directory. We test with command-line arguments.
- View the script: <a href="../../scripts/510-Test-Server.sh" target="_blank">510-Test-Server.sh</a>.
- Run the script.
  ```
  $MMOJO_SERVER_SCRIPTS/510-Test-Server.sh compatible "$CHOSEN_GPUS" 1 llama-server
  ```

---
<details>
  <summary><b>Optional: Copy Executables to Mmojo Share.</b></summary>

Copy these builds to your Mmojo Share for packaging later. 
- View the script: <a href="../../scripts/510-Copy-Executables-to-Share.sh" target="_blank">510-Copy-Executables-to-Share.sh</a>.
- Run the script:
  ```
  $MMOJO_SERVER_SCRIPTS/510-Copy-Executables-to-Share.sh compatible $CHOSEN_GPUS
  ```
</details>

---
### SHORTCUT: Build llama-server, Test
I really think you should run through these scripts one at a time the first few times you build, so you can familiarize yourself with the process and know what goes where. But, now that you've run through a few times, you can use the shortcut snippet:
```
################################################################################
# SHORTCUT: DON'T DO THIS IF YOU ALREADY RAN SCRIPTS ABOVE!
################################################################################
. mm-use-gpus.sh
$MMOJO_SERVER_SCRIPTS/510-Build-for-Platform.sh compatible "$CHOSEN_GPUS" llama-server
$MMOJO_SERVER_SCRIPTS/510-Test-Server.sh compatible "$CHOSEN_GPUS" 1 llama-server
```

---
### SHORTCUT: Build llama-server, Copy to Mmojo Share, Test
I really think you should run through these scripts one at a time the first few times you build, so you can familiarize yourself with the process and know what goes where. But, now that you've run through a few times, you can use the shortcut snippet:
```
################################################################################
# SHORTCUT: DON'T DO THIS IF YOU ALREADY RAN SCRIPTS ABOVE!
################################################################################
. mm-use-gpus.sh
$MMOJO_SERVER_SCRIPTS/510-Build-for-Platform.sh compatible "$CHOSEN_GPUS" llama-server
$MMOJO_SERVER_SCRIPTS/510-Copy-Executables-to-Share.sh compatible "$CHOSEN_GPUS" llama-server
$MMOJO_SERVER_SCRIPTS/510-Test-Server.sh compatible "$CHOSEN_GPUS" 1 llama-server
```

---
### Proceed
- **Next:** [512. Platform (Performant)](512-Platform-Performant.md)
- **Previous:** [510. Platform Builds](510-Platform-Builds.md)
- **Up:** [500. Build llama-server](500-Build-llama-server.md)

---
[MIT License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
