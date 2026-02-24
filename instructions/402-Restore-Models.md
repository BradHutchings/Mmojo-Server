## 402. Restore Models
### About this Step
In this step, you will copy `.gguf` models previously backed up to your Mmojo Share to this build environment.

If you would like to convert some Hugging Face models, please proceed to [410. Convert Models](402-Convert-Models.md).

**Where:** Perform this step in both your x86_64 and your aarch64 (arm64) build environments.

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
### Restore Models
This script mounts your Mmojo Share, looks for the `/models` subdirectory, and looks the `/models/restore-model-map.txt` file. If that file does not exist, it copies the `/models/model-map.txt` file. You can edit that file to pick which models get restored and the order they get restored. The `2` command-line paramter tells the script to restore the first two available models than are not available locally.
- View the script: <a href="../scripts/mm-restore-models.sh" target="_blank">mm-restore-models.sh</a>.
  - *On Github, you may need to right-click and choose "Open link in new tab" to open the "View script" links in a new tab.*
    <br/>
    <br/>
- Run the script to restore the first two available models than are not available locally.
  ```
  mm-restore-models.sh 2
  ```

<details>
  <summary><b>Optional: Edit the Restore Model Map File</b></summary>
  
You can edit the `restore-model-map.txt` file with this command:
```
sudo nano $MMOJO_SHARE_RESTORE_MODEL_MAP
```
</details>

<details>
  <summary><b>Optional: Delete the Restore Model Map File</b></summary>
  
Deleting the restore model map file will force the `mm-restore-models.sh` script to recreate it. You can delete the `restore-model-map.txt` file with this command:
```
if [ "$MMOJO_SHARE_RESTORE_MODEL_MAP != "" ]; then
    sudo rm $MMOJO_SHARE_RESTORE_MODEL_MAP
fi
```
</details>



---
### Proceed
- **Next:** [410. Convert Models](410-Convert-Models.md)
- **Previous:** [401. Download Models](401-Download-Models.md)
- **Up:** [400. Gather Models](400-Gather-Models.md)

---
[MIT License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
