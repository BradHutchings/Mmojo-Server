## 610. Platform Packages

**THIS IS A WORK IN PROGRESS, NOT WORKING YET. -BRAD**

### About this Step
Let's prepare a `.zip` file containing a `doghouse` executable and a `doghouse-support` directory for distribution. You will start with one of the `doghouse` apps you built, add certificates, add a add a `.gguf` model file, and add a configuration file. You will test run it, zip it up, then copy it to your Mmojo Share. 

**TO-DO**:
- Incorporate .gguf short name into directory name, zip name.
- Shortcut after picking build and gguf.
- Choosing the build doesn't find GPU-enabled builds.
- Test localhost and public interfaces before copying to Mmojo Server.

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
### Choose a `doghouse` Build to Package
This script has you choose one of the `doghouse` apps you've built.
- View the script: <a href="../scripts/mm-use-build.sh" target="_blank">mm-use-build.sh</a>.
  - *On Github, you may need to right-click and choose "Open link in new tab" to open the "View script" links in a new tab.*
    <br/>
    <br/>
- Run the script.
  ```
  unset CHOSEN_BUILD
  unset CHOSEN_BUILD_PATH
  unset CHOSEN_BUILD_INFO
  . mm-use-build.sh
  ```

---
### Choose `.gguf` Model to Add to Package
Choose a model. The models from your `$HOME/300-MODELS` directory are available for you to use. This is its own script in your `$HOME/scripts` directory because it sets an environment variable and is resused in these instructions.
- View the script: <a href="../scripts/mm-choose-model.sh" target="_blank">mm-choose-model.sh</a>.
- Run the script.
  ```
  unset CHOSEN_MODEL
  unset CHOSEN_MODEL_MNEMONIC
  . mm-choose-model.sh
  ```

---
### Create Package Directories
This script creates the package directories.
- View the script: <a href="../scripts/610-Create-Package-Directories.sh" target="_blank">610-Create-Package-Directories.sh</a>.
- Run the script.
  ```
  $MMOJO_SERVER_SCRIPTS/610-Create-Package-Directories.sh doghouse
  # Keep track of what we add below for the `default-args` file.
  unset ADDED_CERTS
  unset ADDED_MMOJO_COMPLETE
  unset ADDED_MODEL
  ```

---
### Add Certs to Package
This script adds SSL certificates from `$HOME/300-CERTIFICATES` to the package.
- View the script: <a href="../scripts/610-Add-Certs-to-Package.sh" target="_blank">610-Add-Certs-to-Package.sh</a>.
- Run the script.
  ```
  $MMOJO_SERVER_SCRIPTS/610-Add-Certs-to-Package.sh doghouse
  # Keep track of what we add for the `default-args` file.
  export ADDED_CERTS=1
  ```

*Note: I use these certificates in my Mmojo Knowledge Appliance. I will document why and how to create these certificates soon.*

<!--
---
### Add Mmojo Complete UI to Package
This script adds the Mmojo Complete user interface to the package.
- View the script: <a href="../scripts/610-Add-UI-to-Package.sh" target="_blank">610-Add-UI-to-Package.sh</a>.
- Run the script.
  ```
  $MMOJO_SERVER_SCRIPTS/610-Add-UI-to-Package.sh doghouse
  # Keep track of what we add for the `default-args` file.
  export ADDED_MMOJO_COMPLETE=1
  ```
-->

---
### Add `.gguf` Model to Package
This script adds the chosen `.gguf` model to the package.
- View the script: <a href="../scripts/610-Add-gguf-Model-to-Package.sh" target="_blank">610-Add-gguf-Model-to-Package.sh</a>.
- Run the script.
  ```
  if [ -v CHOSEN_MODEL ]; then
    $MMOJO_SERVER_SCRIPTS/610-Add-gguf-Model-to-Package.sh doghouse
    # Keep track of what we add for the `default-args` file.
    export ADDED_MODEL=1
  fi
  ```

---
### Add Args File to Package
This script adds a `default-args` file to the package. If you added certs and/or the Mmojo Complete UI above, the `default-args` file will reflect that. We clean up files that were copied into the `package-ape` directory.
- View the script: <a href="../scripts/610-Add-Args-to-Package.sh" target="_blank">610-Add-Args-to-Package.sh</a>.
- Run the script.
  ```
  $MMOJO_SERVER_SCRIPTS/610-Add-Args-to-Package.sh doghouse
  ```

---
### Zip the Package
This script zips the package into a `.zip` file and moves the file to `$HOME/500-PACKAGE`.
- View the script: <a href="../scripts/610-Zip-Package.sh" target="_blank">610-Zip-Package.sh</a>.
- Run the script.
  ```
  $MMOJO_SERVER_SCRIPTS/610-Zip-Package.sh doghouse
  ```

<details>
  <summary><b>Optional: Copy Zip Package to Your Mmojo Share.</b></summary>

Copy this zip package to your Mmojo share.
- View the script: <a href="../scripts/610-Copy-Zip-Package-to-Mmojo-Share.sh" target="_blank">610-Copy-Zip-Package-to-Mmojo-Share.sh</a>.
- Run the script:
  ```
  $MMOJO_SERVER_SCRIPTS/610-Copy-Zip-Package-to-Mmojo-Share.sh
  ```
</details>

---
### Proceed
- **Next:** [620. APE Packages](620-APE-Packages.md)
- **Previous:** This is the first step in this section.
- **Up:** [600. Package Doghouse](600-Package-Doghouse.md)

---
[MIT License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
