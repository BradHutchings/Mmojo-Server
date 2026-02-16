## 621. APE (Compatible)
### About the Build llama-server Track
**llama-server** is the project upon which Mmojo Server builds. [Read more about llama-server](500-Build-llana-server.md).

---
### About this Step

Let's prepare an Actual Portable Executable (APE) for distribution. You will start with the APE file you built, remove extraneous timezone files from it, add certificates, add a `.gguf` model file, and add a configuration file. You will test run it.

**TO-DO**:
- Shortcut after picking gguf.

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
### Choose `.gguf` Model to Add to APE
Choose a model. The models from your `$HOME/300-MODELS` directory are available for you to use. This is its own script in your `$HOME/scripts` directory because it sets an environment variable and is resused in these instructions. We choose the model first so we can include its short name in the package folder name and the APE file name.
- View the script: <a href="../../scripts/mm-model-choose.sh" target="_blank"> mm-model-choose.sh</a>.
  - *On Github, you may need to right-click and choose "Open link in new tab" to open the "View script" links in a new tab.*
    <br/>
    <br/>
- Run the script.
  ```
  unset MODEL_CHOICE
  . mm-model-choose.sh
  ```

---
### Create Package APE
This script creates the package directories, copies the `llama-server-ape` file you previously built and assembled, removes extraneous timezone files from it, and displays the contents for your review.
- View the script: <a href="../../scripts/620-Create-Package-APE.sh" target="_blank">620-Create-Package-APE.sh</a>.
- Run the script.
  ```
  $MMOJO_SERVER_SCRIPTS/620-Create-Package-APE.sh compatible attired llama-server
  # Keep track of what we add below for the Args file.
  unset ADDED_CERTS
  unset ADDED_MMOJO_COMPLETE
  unset ADDED_MODEL
  ```

---
### Add Certificates to APE
This script adds SSL certificates from `$HOME/300-CERTIFICATES` to the APE package.
- View the script: <a href="../../scripts/620-Add-Certificates-to-APE.sh" target="_blank">620-Add-Certificates-to-APE.sh</a>.
- Run the script.
  ```
  $MMOJO_SERVER_SCRIPTS/620-Add-Certificates-to-APE.sh compatible attired llama-server
  # Keep track of what we add for the args file.
  export ADDED_CERTS=1
  ```

<!--
---
### Add Mmojo Complete UI to APE
This script adds the Mmojo Complete user interface to the APE package.
- View the script: <a href="../../scripts/620-Add-UI-to-APE.sh" target="_blank">620-Add-UI-to-APE.sh</a>.
- Run the script.
  ```
  $MMOJO_SERVER_SCRIPTS/620-Add-UI-to-APE.sh compatible attired llama-server
  # Keep track of what we add for the args file.
  export ADDED_MMOJO_COMPLETE=1
  ```
-->

---
### Add `.gguf` Model to APE
This script adds the chosen `.gguf` model to the APE package.
- View the script: <a href="../../scripts/620-Add-gguf-Model-to-APE.sh" target="_blank">620-Add-gguf-Model-to-APE.sh</a>.
- Run the script.
  ```
  if [ -v CHOSEN_MODEL ]; then
    $MMOJO_SERVER_SCRIPTS/620-Add-gguf-Model-to-APE.sh compatible attired llama-server
    # Keep track of what we add for the Args file.
    export ADDED_MODEL=1
  fi
  ```

#### Note: Aligning the .gguf File to Page Boundary
*The original llamafile used a custom tool called `zipalign` to add .gguf files to the APE file &mdash; a zip file &mdash; on a page boundary. This would allow Cosmopolitan libc's `mmap()` function to map the uncompressed .gguf file for llamafile. When llama.cpp is compiled and linked with `cosmocc` to use the `mmap()` function in Cosmopolitan libc, this functionality does not work. You'll get an error like:*

*`llama_model_load: error loading model: mmap failed: Invalid argument`*

*Until I resolve this, the .gguf file will not be aligned, and the Args file will have the `--no-mmap` flag set if a `.gguf` file is included. This can be overridden by the command-line argument `--mmap `, which is an addition to Mmojo Server.*

*-Brad*

---
### Add Args File to APE
This script adds a Args file to the APE package. We clean up files that were copied into the `package-ape` directory.
- View the script: <a href="../../scripts/620-Add-Args-to-APE.sh" target="_blank">620-Add-Args-to-APE.sh</a>.
- Run the script.
  ```
  $MMOJO_SERVER_SCRIPTS/620-Add-Args-to-APE.sh compatible attired llama-server
  ```

---
### Test Run on localhost

Now we can test run `llama-server`, listening on localhost:8080. This should be a script file.
```
THIS_PACKAGE_DIR="$LLAMA_SERVER_PACKAGE_DIR/$PACKAGE_COMPATIBLE_APE"
APP_FILE="$PACKAGE_LLAMA_SERVER_APE_FILE-comp"
if [ -v CHOSEN_MODEL_MNEMONIC ]; then
    THIS_PACKAGE_DIR+="-$CHOSEN_MODEL_MNEMONIC"
fi
$THIS_PACKAGE_DIR/$APP_FILE
```

After starting up and loading the model, it should display:

**main: server is listening on `http://127.0.0.1:8080` - starting the main loop**<br/>
**srv  update_slots: all slots are idle**

Hit `ctrl-C` on your keyboard to stop it.

If you added SSL certificates, you can connect to the server with `https`:
- [https://localhost:8080](https://127.0.0.1:8080)
- The message about the server listening on `http://127.0.0.1:8080` is incorrect.

If you did not add SSL cxertificates, you can connect to the server with `http`:
- [http://localhost:8080](http://127.0.0.1:8080)

If you're building in WSL, your Windows web browser should be able to connect to llama-server with the localhost links above.

---
### Test Run on Public Interfaces

If you'd like it to listen on all available interfaces, you can connect from a browser on another computer. This should be a script file.
```
THIS_PACKAGE_DIR="$LLAMA_SERVER_PACKAGE_DIR/$PACKAGE_COMPATIBLE_APE"
APP_FILE="$PACKAGE_LLAMA_SERVER_APE_FILE-comp"
if [ -v CHOSEN_MODEL_MNEMONIC ]; then
    THIS_PACKAGE_DIR+="-$CHOSEN_MODEL_MNEMONIC"
fi
$THIS_PACKAGE_DIR/$APP_FILE --host 0.0.0.0
```

After starting up and loading the model, it should display:

**main: server is listening on `https://0.0.0.0:8080` - starting the main loop**<br/>
**srv  update_slots: all slots are idle**

Hit `ctrl-C` on your keyboard to stop it.
If you added SSL certificates, you can connect to the server with `https`:
- https://[host-name-or-ip]:8080
- The message about the server listening on `http://127.0.0.1:8080` is incorrect.

If you did not add SSL cxertificates, you can connect to the server with `http`:
- http://[host-name-or-ip]:8080

<!--
---
### Copy `mmojo-server` APE to Mmojo Share
This script copies the packaged `mmojo-server` to your Mmojo Share.
- View the script: <a href="../scripts/620-Copy-APE-Package-to-Mmojo-Share.sh" target="_blank">620-Copy-APE-Package-to-Mmojo-Share.sh</a>.
- Run the script.
  ```
  $MMOJO_SERVER_SCRIPTS/620-Copy-APE-Package-to-Mmojo-Share.sh compatible
  ```
-->

---
### Review the APE Directory
Let's look at what you packaged:
```
THIS_PACKAGE_DIR="$LLAMA_SERVER_PACKAGE_DIR/$PACKAGE_COMPATIBLE_APE"
if [ -v CHOSEN_MODEL_MNEMONIC ]; then
    THIS_PACKAGE_DIR+="-$CHOSEN_MODEL_MNEMONIC"
fi
echo ""
echo "$THIS_PACKAGE_DIR:"
ls -al $THIS_PACKAGE_DIR
```

---
### Proceed
- **Next:** [622. APE (Performant)](622-APE-Performant.md)
- **Previous:** [620. APE Packages](620-APE-Packages.md)
- **Up:** [600. Package llama-server](600-Package-llama-server.md)

---
[MIT License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
