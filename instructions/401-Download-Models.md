## 401. Download Models

### About this Step
In this step, we will download some `gguf` files we will need from Hugging Face and copy them to our Mmojo share for later use.

If you would like to convert some Hugging Face models, please proceed to [410. Convert Models](410-Convert-Models.md).

**Where:** Perform this step in both your x86_64 and your aarch64 (arm64) build environments.

**Shortcut:** [Scroll down](#shortcut-download-models).

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
- View the script: <a href="../scripts/mm-create-models-directory.sh" target="_blank">mm-create-models-directory.sh</a>.
  - *On Github, you may need to right-click and choose "Open link in new tab" to open the "View script" links in a new tab.*
    <br/>
    <br/>
- Run the script. We run with `.` so variables can be defined and exported.
  ```
  $MMOJO_SERVER_SCRIPTS/mm-create-models-directory.sh
  ```

<!--
<details>
  <summary><b>Optional: Download Model Map.</b></summary>

If you plan to create `mmojo-server-one` Actual Portable Executables (APEs) with embedded models, you should download some models that are tested to work with `mmojo-server`. We'll download a model map from Hugging Face.

This script downloads the model map from Hugging Face:
- View the script: <a href="../scripts/401-Download-Model-Map.sh" target="_blank">401-Download-Model-Map.sh</a>.
- Run the script.
  ```
  $MMOJO_SERVER_SCRIPTS/401-Download-Model-Map.sh
  ```
</details>
-->

<details>
  <summary><b>Optional: Edit the Model Queue</b></summary>

All these models will take a long time to download, so you can edit the model queue and remove models you don't want to download now.
```
nano $LOCAL_MODEL_QUEUE
```
</details>

---
### Download Models
This script downloads two models from Hugging Face:
- View the script: <a href="../scripts/mm-download-models.sh" target="_blank">mm-download-models.sh</a>.
- Run the script.
  ```
  mm-download-models.sh 2
  ```

<details>
  <summary><b>Optional: Backup models to Mmojo Share</b></summary>

This backs up all new models in the `$LOCAL_MODELS_DIR` directory to your Mmojo Share.
- View the script: <a href="../scripts/mm-backup-models.sh" target="_blank">mm-backup-models.sh</a>.
- Run the script.
  ```
  mm-backup-models.sh
  ```
</details>

---
### SHORTCUT: Download Models
I really think you should run through these scripts one at a time the first few times you build, so you can familiarize yourself with the process and know what goes where. But, now that you've run through a few times, you can use the shortcut snippet to download two models I offer on Hugging Face.
```
################################################################################
# SHORTCUT: DON'T DO THIS IF YOU ALREADY RAN SCRIPTS ABOVE!
################################################################################
$MMOJO_SERVER_SCRIPTS/mm-create-models-directory.sh
mm-download-models.sh 2
```

<details>
  <summary><b>Optional: Backup models to Mmojo Share</b></summary>

This backs up all new models in the `$LOCAL_MODELS_DIR` directory to your Mmojo Share.
- View the script: <a href="../scripts/mm-backup-models.sh" target="_blank">mm-backup-models.sh</a>.
- Run the script.
  ```
  mm-backup-models.sh
  ```
</details>

---
### SHORTCUT: Download Tested Models
I really think you should run through these scripts one at a time the first few times you build, so you can familiarize yourself with the process and know what goes where. But, now that you've run through a few times, you can use the shortcut snippet to download all the models I offer on Hugging Face. This will take awhile and use a lot (i.e. 100 GB-ish) of disk space.
```
################################################################################
# SHORTCUT: DON'T DO THIS IF YOU ALREADY RAN SCRIPTS ABOVE!
################################################################################
$MMOJO_SERVER_SCRIPTS/mm-create-models-directory.sh
$MMOJO_SERVER_SCRIPTS/401-Download-Model-Map.sh
mm-download-models.sh 2
```

<details>
  <summary><b>Optional: Backup models to Mmojo Share</b></summary>

This backs up all new models in the `$LOCAL_MODELS_DIR` directory to your Mmojo Share.
- View the script: <a href="../scripts/mm-backup-models.sh" target="_blank">mm-backup-models.sh</a>.
- Run the script.
  ```
  mm-backup-models.sh
  ```
</details>

---
### Proceed
- **Next:** [402. Restore Models](402-Restore-Models.md)
- **Previous:** This is the first step in this section.
- **Up:** [400. Gather Models](400-Gather-Models.md)

---
[MIT License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
