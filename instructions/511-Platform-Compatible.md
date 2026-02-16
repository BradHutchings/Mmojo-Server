## 511. Platform (Compatible)
### About this Step
In this step, we will build Mmojo Server (`mmojo-server`) and other llama.cpp targets to run on the widest variety of x86_64 and aarch64 machines, with optional GPU support.

**Where:** Perform this step in both your x86_64 and your aarch64 (arm64) build environments.

**Shortcut:** [Scroll down](#shortcut-build-cpu-test).

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

- View the script: <a href="../scripts/mm-gpus-choose.sh" target="_blank">mm-gpus-choose.sh</a>.
  - *On Github, you may need to right-click and choose "Open link in new tab" to open the "View script" links in a new tab.*
    <br/>
    <br/>
- Run the script.
  ```
  . mm-gpus-choose.sh
  ```

*I will make this easier to navigate soon! -Brad*

---
### Build Mmojo Server and other llama.cpp Apps
This script uses cmake to build Mmojo Server:
- View the script: <a href="../scripts/510-Build-for-Platform.sh" target="_blank">510-Build-for-Platform.sh</a>.
- Run the script.
  ```
  $MMOJO_SERVER_SCRIPTS/510-Build-for-Platform.sh compatible "$GPUS_CHOICE"
  ```

---
### Test Mmojo Server
Requires previously downloaded model to the `$LOCAL_MODELS_DIR` directory. We test with command-line arguments.
- View the script: <a href="../scripts/510-Test-Server.sh" target="_blank">510-Test-Server.sh</a>.
- Run the script.
  ```
  $MMOJO_SERVER_SCRIPTS/510-Test-Server.sh compatible "$GPUS_CHOICE" "$TEST_WITH_CHAT_UI"
  ```

---
<details>
  <summary><b>Optional: Copy Executables to Mmojo Share.</b></summary>

Copy these builds to your Mmojo Share for packaging later. 
- View the script: <a href="../scripts/510-Copy-Executables-to-Share.sh" target="_blank">510-Copy-Executables-to-Share.sh</a>.
- Run the script:
  ```
  $MMOJO_SERVER_SCRIPTS/510-Copy-Executables-to-Share.sh compatible "$GPUS_CHOICE"
  ```
</details>

---
### SHORTCUT: Build Mmojo Server, Test
I really think you should run through these scripts one at a time the first few times you build, so you can familiarize yourself with the process and know what goes where. But, now that you've run through a few times, you can use the shortcut snippet:
```
################################################################################
# SHORTCUT: DON'T DO THIS IF YOU ALREADY RAN SCRIPTS ABOVE!
################################################################################
. mm-gpus-choose.sh
$MMOJO_SERVER_SCRIPTS/510-Build-for-Platform.sh compatible "$GPUS_CHOICE"
$MMOJO_SERVER_SCRIPTS/510-Test-Server.sh compatible "$GPUS_CHOICE" "$TEST_WITH_CHAT_UI"
```

---
### SHORTCUT: Build Mmojo Server, Copy to Mmojo Share, Test
I really think you should run through these scripts one at a time the first few times you build, so you can familiarize yourself with the process and know what goes where. But, now that you've run through a few times, you can use the shortcut snippet:
```
################################################################################
# SHORTCUT: DON'T DO THIS IF YOU ALREADY RAN SCRIPTS ABOVE!
################################################################################
. mm-gpus-choose.sh
$MMOJO_SERVER_SCRIPTS/510-Build-for-Platform.sh compatible "$GPUS_CHOICE"
$MMOJO_SERVER_SCRIPTS/510-Copy-Executables-to-Share.sh compatible "$GPUS_CHOICE"
$MMOJO_SERVER_SCRIPTS/510-Test-Server.sh compatible "$GPUS_CHOICE" "$TEST_WITH_CHAT_UI"
```

---
### Proceed
- **Next:** [512. Platform (Performant)](512-Platform-Performant.md)
- **Previous:** [510. Platform Builds](510-Platform-Builds.md)
- **Up:** [500. Build Mmojo Server](500-Build-Mmojo-Server.md)

---
[MIT License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
