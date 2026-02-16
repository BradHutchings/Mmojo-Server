## 209. `mm-` Scripts
### About this Step
This isn't so much a step, as it is a reference to the scripts that were copied to your `$HOME/mm-scripts` directory.
- They all have the prefix `mm-`.
- They are available on the command line without specifying their path because we added `$HOME/mm-scripts` to your `$PATH` in your `.bashrc` file.
- They are utility scripts.
- They are freshly copied when you clone the Mmojo Server GitHub repo, when you update it with the `mm-repo-update-local.sh` script, or when you switch branched with the `mm-work-in-progress-branch.sh` or `mm-repo-branch-main.sh` scripts.
- `mm` are the first two letters in **Mmojo**.

---
### Reference
- `mm-model-choose.sh` &mdash; User chooses a model from the `$HOME/$LOCAL_MODELS_DIR` directory for use by a test or package script.
  - Sets shell variables `$CHOSEN_MODEL` and `$CHOSEN_MODEL_MNEMONIC`.
  - Call with a `. ` preceeding because you need to set variables in the shell instance you are running.
    ```
    . mm-model-choose.sh
    ```
    <br/>
- `mm-use-build.sh` &mdash; User chooses an available build for use by a package script.
  - Sets shell variables `$CHOSEN_BUILD`, `$CHOSEN_BUILD_PATH`, and `$CHOSEN_BUILD_INFO`.
  - Call with a `. ` preceeding because you need to set variables in the shell instance you are running.
    ```
    . mm-use-build.sh
    ```
- `mm-gpus-choose.sh` &mdash; User chooses a subset of available installed GPU developer libraries for use by a build script.
  - Sets shell variables `$CHOSEN_GPUS` and `$CHOSEN_GPUS_NAMES`.
  - Call with a `. ` preceeding because you need to set variables in the shell instance you are running.
    ```
    . mm-gpus-choose.sh
    ```
   <br/><br/>

- `mm-environment-variables.sh` &mdash; Sets up shell variables, paths, subdirectories used by scripts to organize building and packaging.
  - Call with a `. ` preceeding because you need to set variables in the shell instance you are running.
    ```
    . mm-environment-variables.sh
    ```
  - The convenient `mm-env` alias set in your `.bashrc` file calls the script with a `. ` preceeding it.
     <br/><br/>

- `mm-share-mount.sh` &mdash; Mounts your Mmojo Share at `/mnt/mmojo`. You customized this script previously. It is not overwritten when updating the local Mmojo Server repo or switching branches on it.
  <br/><br/>
  
- `mm-repo-update-local.sh` &mdash; Updates the local Mmojo Server repo, copies `mm-` scripts to `$HOME/mm-scripts`.
- `mm-repo-branch-main.sh` &mdash; Switches to the `main` branch of the local Mmojo Server repo, copies `mm-` scripts to `$HOME/mm-scripts`.
- `mm-work-in-progress-branch.sh` &mdash; Switches to the `eork-in-progress` branch of the local Mmojo Server repo, copies `mm-` scripts to `$HOME/mm-scripts`.
   - You probably do not want to be on this branch unless you're working with Brad on whatever he is working on.
   - Danger: The actual `work-in-progress` branch is deleted and re-created ever time that branch is merged into the `main` branch. You may need to re-clone the repo and switch to the `work-in-progress` branch to continue using it.

---
### Proceed
- **Next:** This is the last step in this section.
- **Previous:** [208. Install Dependencies](208-Install-Dependencies.md)
- **Up:** [200. Prepare Build Environment](200-Prepare-Build-Environment.md)

---
### Next Section
- **Next Section:** [300. Gather Build Pieces](300-Gather-Build-Pieces.md)

---
[MIT License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
