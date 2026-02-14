## 522. APE (Performant)
### About this Step
In this step, we will build Mmojo Server (`mmojo-server-ape`) for x86_64 and aarch64 (arm64). We will then package them in an Actual Portable Executable (APE) file which can run cross platform and cross artchitecture. This build will run on a narrower, more modern range of x86_64 and aarch64 machines.

The APE will run on x86 and ARM CPUs, and Windows, Linux, and macOS operating systems. As a zip file, the APE can also hold configuration files and .gguf models. The APE will perform much better on modern hardware than the APE (compatible) build, especially on x86_64 machines.

**Where:** Perform this step in either or both your x86_64 and your aarch64 (arm64) build environments. The resulting APE file will be copied to your Mmojo SMB share.

**Shortcut:** [Scroll down](#shortcut-build-and-assemble-ape-test-ape).

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
### Build Mmojo Server for x86_64
This script uses cmake CMake to build Mmojo Server with `cosmocc` for x86_64. Note that we make a temporary change to `common/CMakeLists.txt` to statically link with OpenSSL libraries.
- View the script: <a href="../scripts/mm-build-with-cosmo.sh" target="_blank">mm-build-with-cosmo.sh</a>.
  - *On Github, you may need to right-click and choose "Open link in new tab" to open the "View script" links in a new tab.*
    <br/>
    <br/>
- Run the script. We run with `.` so variables can be defined and exported.
  ```
  $MMOJO_SERVER_SCRIPTS/mm-build-with-cosmo.sh X86_64 performant
  ```

<details>
  <summary><b>Optional: Test the x86_64 Build.</b></summary>

If your build environment is x86_64, you can test this build. Requires previously downloaded model to the `$LOCAL_MODELS_DIR` directory.
- View the script: <a href="../scripts/520-Test-Cosmo-Build.sh" target="_blank">520-Test-Cosmo-Build.sh</a>.
- Run the script.
  ```
  $MMOJO_SERVER_SCRIPTS/520-Test-Cosmo-Build.sh X86_64 performant "$TEST_WITH_CHAT_UI"
  ```
</details>

<details>
  <summary><b>Optional: Copy x86_64 Build to Your Mmojo Share.</b></summary>

Copy this build to your Mmojo share for assembly into an APE later. This is particularly useful if you're building the x86_64 and aarch64 binaries in different build environments.
- View the script: <a href="../scripts/520-Copy-Cosmo-Build-to-Mmojo-Share.sh" target="_blank">520-Copy-Cosmo-Build-to-Mmojo-Share.sh</a>.
- Run the script:
  ```
  $MMOJO_SERVER_SCRIPTS/520-Copy-Cosmo-Build-to-Mmojo-Share.sh x86_64 performant

  ```
</details>

---
### Build Mmojo Server for aarch64 (arm64)
This script uses cmake CMake to build Mmojo Server with `cosmocc` for x86_64. Note that we make a temporary change to `common/CMakeLists.txt` to statically link with OpenSSL libraries.
- View the script: <a href="../scripts/mm-build-with-cosmo.sh" target="_blank">mm-build-with-cosmo.sh</a>.
  - *On Github, you may need to right-click and choose "Open link in new tab" to open the "View script" links in a new tab.*
    <br/>
    <br/>
- Run the script. We run with `.` so variables can be defined and exported.
  ```
  $MMOJO_SERVER_SCRIPTS/mm-build-with-cosmo.sh aarch64 performant
  ```

<details>
  <summary><b>Optional: Test the aarch64 Build.</b></summary>

If your build environment is aarch64, you can test this build. Requires previously downloaded model to the `$LOCAL_MODELS_DIR` directory.
- View the script: <a href="../scripts/520-Test-Cosmo-Build.sh" target="_blank">520-Test-Cosmo-Build.sh</a>.
- Run the script.
  ```
  $MMOJO_SERVER_SCRIPTS/520-Test-Cosmo-Build.sh aarch64 performant "$TEST_WITH_CHAT_UI"
  ```
</details>

<details>
  <summary><b>Optional: Copy aarch64 (arm64) Build to Your Mmojo Share.</b></summary>

Copy this build to your Mmojo share for assembly into an APE later. This is particularly useful if you're building the x86_64 and aarch64 binaries in different build environments.
- View the script: <a href="../scripts/520-Copy-Cosmo-Build-to-Mmojo-Share.sh" target="_blank">520-Copy-Cosmo-Build-to-Mmojo-Share.sh</a>.
- Run the script:
  ```
  $MMOJO_SERVER_SCRIPTS/520-Copy-Cosmo-Build-to-Mmojo-Share.sh aarch64 performant
  ```
</details>

---
### Assemble mmojo-server Actual Portable Executable (APE)
Now that we have x86_64 and aarch64 (ARM64) builds, we can assemble them into an Actual Portable Executable (APE) file.
- View the script: <a href="../scripts/520-Assemble-Cosmo-APE.sh" target="_blank">520-Assemble-Cosmo-APE.sh</a>.
- Run the script:
  ```
  $MMOJO_SERVER_SCRIPTS/520-Assemble-Cosmo-APE.sh performant

  ```

#### Test the Assembled APE
If your build environment is x86_64 or aarch64, you can test the assembled APE. Requires previously downloaded model to the `$LOCAL_MODELS_DIR` directory.
- View the script: <a href="../scripts/520-Test-Cosmo-APE.sh" target="_blank">520-Test-Cosmo-APE.sh</a>.
- Run the script:
  ```
  $MMOJO_SERVER_SCRIPTS/520-Test-Cosmo-APE.sh performant command-line "$TEST_WITH_CHAT_UI"
  ```

<details>
  <summary><b>Optional: Test the Assembled APE with `.gguf` Model in APE.</b></summary>

Test the Assembled APE with `.gguf` Model in APE.
- View the script: <a href="../scripts/520-Test-Cosmo-APE.sh" target="_blank">520-Test-Cosmo-APE.sh</a>.
- Run the script:
  ```
  $MMOJO_SERVER_SCRIPTS/520-Test-Cosmo-APE.sh performant find-ape "$TEST_WITH_CHAT_UI"
  ```
</details>

<details>
  <summary><b>Optional: Copy Assembled APE to Your Mmojo Share.</b></summary>

Copy this assembled APE to your Mmojo share.
- View the script: <a href="../scripts/520-Copy-Cosmo-APE-to-Mmojo-Share.sh" target="_blank">520-Copy-Cosmo-APE-to-Mmojo-Share.sh</a>.
- Run the script:
  ```
  $MMOJO_SERVER_SCRIPTS/520-Copy-Cosmo-APE-to-Mmojo-Share.sh performant
  ```
</details>

---
### WSL Note
If you get build errors in the CMake preparation step, you most likely did not turn off interoperability in WSL. Please see instructions in [2021. Prepare WSL](201-Prepare-WSL.md).

You can turn off interoperability temporarily with this command:
```
sudo sh -c 'echo -1 > /proc/sys/fs/binfmt_misc/WSLInterop-late'
```

---
### SHORTCUT: Build and Assemble APE, Test APE
I really think you should run through these scripts one at a time the first few times you build, so you can familiarize yourself with the process and know what goes where. But, now that you've run through a few times, you can use the shortcut snippet:
```
################################################################################
# SHORTCUT: DON'T DO THIS IF YOU ALREADY RAN SCRIPTS ABOVE!
################################################################################
$MMOJO_SERVER_SCRIPTS/mm-build-with-cosmo.sh X86_64 performant
$MMOJO_SERVER_SCRIPTS/mm-build-with-cosmo.sh aarch64 performant
$MMOJO_SERVER_SCRIPTS/520-Assemble-Cosmo-APE.sh performant
$MMOJO_SERVER_SCRIPTS/520-Test-Cosmo-APE.sh performant "$TEST_WITH_CHAT_UI"
```

---
### SHORTCUT: Build and Assemble APE, Copy to Mmojo Share, Test APE
I really think you should run through these scripts one at a time the first few times you build, so you can familiarize yourself with the process and know what goes where. But, now that you've run through a few times, you can use the shortcut snippet:
```
################################################################################
# SHORTCUT: DON'T DO THIS IF YOU ALREADY RAN SCRIPTS ABOVE!
################################################################################
$MMOJO_SERVER_SCRIPTS/mm-build-with-cosmo.sh X86_64 performant
$MMOJO_SERVER_SCRIPTS/520-Copy-Cosmo-Build-to-Mmojo-Share.sh X86_64 performant
$MMOJO_SERVER_SCRIPTS/mm-build-with-cosmo.sh aarch64 performant
$MMOJO_SERVER_SCRIPTS/520-Copy-Cosmo-Build-to-Mmojo-Share.sh aarch64 performant
$MMOJO_SERVER_SCRIPTS/520-Assemble-Cosmo-APE.sh performant
$MMOJO_SERVER_SCRIPTS/520-Copy-Cosmo-APE-to-Mmojo-Share.sh performant
$MMOJO_SERVER_SCRIPTS/520-Test-Cosmo-APE.sh performant "$TEST_WITH_CHAT_UI"
```

---
### Proceed
- **Next:** This is the last step in this section.
- **Previous:** [521. APE (Compatible)](521-APE-Compatible.md)
- **Up:** [500. Build Mmojo Server](500-Build-Mmojo-Server.md)

---
[MIT License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
