## 623. Naked APE (Compatible)
### About the Build llama-server Track
**llama-server** is the project upon which Mmojo Server builds. [Read more about llama-server](500-Build-llana-server.md).

---
### About this Step

Let's prepare an Actual Portable Executable (APE) for distribution. You will start with the APE file you built, remove extraneous timezone files from it, add certificates, and add a configuration file. You will test run it.

**Naked** means there is no gguf file in this APE. You can just deploy a naked APE with a gguf file in the same folder &mdash; maybe even a hard or soft link &mdash; or zip a gguf onto a naked APE to get a fully contained server.

**TO-DO**:
- Shortcut after picking gguf.

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
### Create Package APE
This script creates the package directories, copies the `llama-server-ape` file you previously built and assembled, removes extraneous timezone files from it, and displays the contents for your review.
- View the script: <a href="../../scripts/620-Create-Package-APE.sh" target="_blank">620-Create-Package-APE.sh</a>.
- Run the script.
  ```
  unset CHOSEN_MODEL
  unset CHOSEN_MODEL_MNEMONIC
  $MMOJO_SERVER_SCRIPTS/620-Create-Package-APE.sh compatible naked llama-server
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
  $MMOJO_SERVER_SCRIPTS/620-Add-Certificates-to-APE.sh compatible naked llama-server
  # Keep track of what we add for the args file.
  export ADDED_CERTS=1
  ```

---
### Add Args File to APE
This script adds a Args file to the APE package. We clean up files that were copied into the `package-ape` directory.
- View the script: <a href="../../scripts/620-Add-Args-to-APE.sh" target="_blank">620-Add-Args-to-APE.sh</a>.
- Run the script.
  ```
  $MMOJO_SERVER_SCRIPTS/620-Add-Args-to-APE.sh compatible naked llama-server
  ```

---
### Test Run on localhost

Now we can test run `llama-server`, listening on localhost:8080. This should be a script file.
```
THIS_PACKAGE_DIR="$LLAMA_SERVER_PACKAGE_DIR/$PACKAGE_COMPATIBLE_NAKED_APE"
APP_FILE="$PACKAGE_LLAMA_SERVER_APE_FILE-comp"
cp $LOCAL_MODELS_DIR/Google-Gemma-1B-Instruct-v3-q8_0.gguf $THIS_PACKAGE_DIR
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
THIS_PACKAGE_DIR="$LLAMA_SERVER_PACKAGE_DIR/$PACKAGE_COMPATIBLE_NAKED_APE"
APP_FILE="$PACKAGE_LLAMA_SERVER_APE_FILE-comp"
cp $LOCAL_MODELS_DIR/Google-Gemma-1B-Instruct-v3-q8_0.gguf $THIS_PACKAGE_DIR
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
THIS_PACKAGE_DIR="$LLAMA_SERVER_PACKAGE_DIR/$PACKAGE_COMPATIBLE_NAKED_APE"
echo ""
echo "$THIS_PACKAGE_DIR:"
ls -al $THIS_PACKAGE_DIR
```

---
### Proceed
- **Next:** [624. Naked APE (Performant)](624-Naked-APE-Performant.md)
- **Previous:** [622. APE (Performant)](622-APE-Performant.md)
- **Up:** [600. Package llama-server](600-Package-llama-server.md)

---
[MIT License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
