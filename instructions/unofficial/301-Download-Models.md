## 301. Download Models

**THIS IS GOING TO MOVE TO THE 400 SECTION AND USE THE `$LOCAL_MODELS_DIR` DIRECTORY.**

### About this Step
In this step, we will download some `gguf` files we will need from Hugging Face and copy them to our Mmojo share for later use.

If you already have models downloaded and copied to your Mmojo share, please proceed to: [302. Copy Models](302-Copy-Models.md).

**Where:** Perform this step in both your x86_64 and your aarch64 (arm64) build environments.

**Shortcut:** [Scroll down](#shortcut-download-models).

***Note:** This step will be going away soon. The 400 section is about creating `.gguf` models from Hugging Face models. It will be supplemented with some `mm-` scripts to backup and restore models to/from your Mmojo Share.*

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
### Create Models Directory
This script creates the `$MODELS_DIR` and adds a simple model map to it:
- View the script: <a href="../scripts/301-Create-Models-Directory.sh" target="_blank">301-Create-Models-Directory.sh</a>.
  - *On Github, you may need to right-click and choose "Open link in new tab" to open the "View script" links in a new tab.*
    <br/>
    <br/>
- Run the script. We run with `.` so variables can be defined and exported.
  ```
  $MMOJO_SERVER_SCRIPTS/301-Create-Models-Directory.sh
  ```

<details>
  <summary><b>Optional: Download Model Map.</b></summary>

If you plan to create `mmojo-server-one` Actual Portable Executables (APEs) with embedded models, you should download some models that are tested to work with `mmojo-server`. We'll download a model map from Hugging Face.

This script downloads the model map from Hugging Face:
- View the script: <a href="../scripts/301-Download-Model-Map.sh" target="_blank">301-Download-Model-Map.sh</a>.
- Run the script.
  ```
  $MMOJO_SERVER_SCRIPTS/301-Download-Model-Map.sh
  ```
</details>

<details>
  <summary><b>Optional: Edit the Model Map.</b></summary>

All these models will take a long time to download, so you can edit the model map and remove models you don't want.
```
nano $MODEL_MAP
```
</details>

---
### Download Models
This script downloads the models from Hugging Face:
- View the script: <a href="../scripts/301-Download-Models.sh" target="_blank">301-Download-Models.sh</a>.
- Run the script.
  ```
  $MMOJO_SERVER_SCRIPTS/301-Download-Models.sh
  ```

---
### SHORTCUT: Download Models
I really think you should run through these scripts one at a time the first few times you build, so you can familiarize yourself with the process and know what goes where. But, now that you've run through a few times, you can use the shortcut snippet to download two models I offer on Hugging Face.
```
################################################################################
# SHORTCUT: DON'T DO THIS IF YOU ALREADY RAN SCRIPTS ABOVE!
################################################################################
$MMOJO_SERVER_SCRIPTS/301-Create-Models-Directory.sh
$MMOJO_SERVER_SCRIPTS/301-Download-Models.sh
```

---
### SHORTCUT: Download Tested Models
I really think you should run through these scripts one at a time the first few times you build, so you can familiarize yourself with the process and know what goes where. But, now that you've run through a few times, you can use the shortcut snippet to download all the models I offer on Hugging Face. This will take awhile and use a lot (i.e. 100 GB-ish) of disk space.
```
################################################################################
# SHORTCUT: DON'T DO THIS IF YOU ALREADY RAN SCRIPTS ABOVE!
################################################################################
$MMOJO_SERVER_SCRIPTS/301-Create-Models-Directory.sh
$MMOJO_SERVER_SCRIPTS/301-Download-Model-Map.sh
$MMOJO_SERVER_SCRIPTS/301-Download-Models.sh
```

---
### Proceed
- **Next:** [302. Copy Models](302-Copy-Models.md)
- **Previous:** This is the first step in this section.
- **Up:** [300. Gather Build Pieces](300-Gather-Build-Pieces.md)

---
[MIT License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
