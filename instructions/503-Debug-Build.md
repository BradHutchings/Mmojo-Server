## 503. Debug Build
### About this Step

In this step, we will build Mmojo Server (`mmojo-server`) for the CPU of your build environment platform without any GPU support. Even if you're more interested in APE builds or GPU-enabled builds, you can and should use this build to test and debug features of Mmojo Server that are not specific to any particular build. CPU optimizations are turned off.

**Where:** Perform this step in both your x86_64 and your aarch64 (arm64) build environments.

**Shortcut:** [Scroll down](#shortcut-build-debug-test).

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
### Build Debug Mmojo Server for Build Environment Platform
This script uses cmake to build Mmojo Server:
- View the script: <a href="../scripts/503-Build-Debug.sh" target="_blank">503-Build-Debug.sh</a>.
  - *On Github, you may need to right-click and choose "Open link in new tab" to open the "View script" links in a new tab.*
    <br/>
    <br/>
- Run the script. We run with `.` so variables can be defined and exported.
  ```
  $MMOJO_SERVER_SCRIPTS/503-Build-Debug.sh
  ```

---
### Test the Build - Command-Line Arguments
Requires previously downloaded model to the `$LOCAL_MODELS_DIR` directory.
- View the script: <a href="../scripts/503-Test-Debug.sh" target="_blank">503-Test-Debug.sh</a>.
- Run the script.
  ```
  $MMOJO_SERVER_SCRIPTS/503-Test-Debug.sh command-line $TEST_WITH_CHAT_UI
  ```

<details>
  <summary><b>Optional: Test the Build &mdash; mmojo-server-args File.</b></summary>

Requires previously downloaded model to the `$LOCAL_MODELS_DIR` directory.
- View the script: <a href="../scripts/503-Test-Debug.sh" target="_blank">503-Test-Debug.sh</a>.
- Run the script.
  ```
  $MMOJO_SERVER_SCRIPTS/503-Test-Debug.sh args-file $TEST_WITH_CHAT_UI
  ```
</details>

<details>
  <summary><b>Optional: Test the Build &mdash; mmojo-server-support Directory.</b></summary>

Requires previously downloaded model to the `$LOCAL_MODELS_DIR` directory.
- View the script: <a href="../scripts/503-Test-Debug.sh" target="_blank">503-Test-Debug.sh</a>.
- Run the script.
  ```
  $MMOJO_SERVER_SCRIPTS/503-Test-Debug.sh support-directory $TEST_WITH_CHAT_UI
  ```
</details>

<details>
  <summary><b>Optional: Test the Build &mdash; find .gguf model in executable directory.</b></summary>

Requires previously downloaded model to the `$LOCAL_MODELS_DIR` directory.
- View the script: <a href="../scripts/503-Test-Debug.sh" target="_blank">503-Test-Debug.sh</a>.
- Run the script.
  ```
  $MMOJO_SERVER_SCRIPTS/503-Test-Debug.sh find-executable-dir $TEST_WITH_CHAT_UI
  ```
</details>

<details>
  <summary><b>Optional: Test the Build &mdash; find .gguf model in working directory.</b></summary>

Requires previously downloaded model to the `$LOCAL_MODELS_DIR` directory.
- View the script: <a href="../scripts/503-Test-Debug.sh" target="_blank">503-Test-Debug.sh</a>.
- Run the script.
  ```
  $MMOJO_SERVER_SCRIPTS/503-Test-Debug.sh find-working-dir $TEST_WITH_CHAT_UI
  ```
</details>

<details>
  <summary><b>Optional: Test the Build &mdash; find .gguf model in support directory.</b></summary>

Requires previously downloaded model to the `$LOCAL_MODELS_DIR` directory.
- View the script: <a href="../scripts/503-Test-Debug.sh" target="_blank">503-Test-Debug.sh</a>.
- Run the script.
  ```
  $MMOJO_SERVER_SCRIPTS/503-Test-Debug.sh find-support-dir $TEST_WITH_CHAT_UI
  ```
</details>

---
### SHORTCUT: Build Debug, Test
I really think you should run through these scripts one at a time the first few times you build, so you can familiarize yourself with the process and know what goes where. But, now that you've run through a few times, you can use the shortcut snippet to build and test a debug build:
```
################################################################################
# SHORTCUT: DON'T DO THIS IF YOU ALREADY RAN SCRIPTS ABOVE!
################################################################################
$MMOJO_SERVER_SCRIPTS/503-Build-Debug.sh
$MMOJO_SERVER_SCRIPTS/503-Test-Debug.sh command-line $TEST_WITH_CHAT_UI
```

---
### Proceed
- **Next:** [510. Platform Builds](510-Platform-Builds.md)
- **Previous:** [502. Prepare to Test](502-Prepare-to-Test.md)
- **Up:** [500. Build Mmojo Server](500-Build-Mmojo-Server.md)

---
[MIT License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
