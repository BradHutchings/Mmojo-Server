## 411. Prepare to Convert
### About this Step

In this step, we will download the latest convert script from the llama.cpp repo so we can do model conversion.

**Where:** Perform this step in both your x86_64 and your aarch64 (arm64) build environments.

---
<details>
  <summary><b>Update Local Mmojo Server Repo</b> &mdash; Expand if you haven't today.</summary>
  
Have you updated your local clone of the Mmojo Server Repo today? If not, run this first:
```
mm-repo-update-local.sh
mm-env
```
</details>

---
### Clone llama.cpp
This script clones the llama.cpp repo into `$LOCAL_MODELS_DIR` directory. We use a vanilla copy for converting Hugging Face models to `.gguf` files.
- View the script: <a href="../scripts/410-Clone-llama-cpp.sh" target="_blank">410-Clone-llama-cpp.sh</a>.
  - *On Github, you may need to right-click and choose "Open link in new tab" to open the "View script" links in a new tab.*
    <br/>
    <br/>
- Run the script.
  ```
  $MMOJO_SERVER_SCRIPTS/410-Clone-llama-cpp.sh
  ```

---
### Set up a Credential Store for git
Many of the Hugging Face repos are gated and require you to enter your account name and an API key to access them. You can save a lot of repeated copy/paste effort by setting up a git credential store. **NOTE: THIS IS NOT VERY SECURE!!**

```
# THIS IS NOT A SECURE WAY TO HANDLE YOUR HUGGING FACE CREDENTIALS!!
git config --global credential.helper store
```


---
### Proceed
- **Next:** [412. Google Gemma](412-Google-Gemma.md)
- **Previous:** [410. Convert Models](410-Convert-Models.md)
- **Up:** [400. Gather Models](400-Gather-Models.md)

---
[MIT License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
