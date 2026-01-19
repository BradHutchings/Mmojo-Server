## 625. Attired APEs (Compatible)
### About this Step
**IN PROGRESS**

You have packaged a naked APE (compatible). Now you can simply graft a `.gguf` model onto the naked APE to make a self-contained LLM server. You graft it on using the `zip` tool to add the `.gguf` model to the zip archive which is the naked APE. You'll will do this for each of the models in the `$LOCAL_MODELS_DIR` directory.

---
### Manual Process
Let's run through the process manually, using the `Google-Gemma-1B-Instruct-v3-q8_0.gguf` model.

- Create a directory for the Attired APEs.
- Copy the naked APE to the directory and rename it .zip.
  ```
  THIS_ZIP_FILE=""
  ```
- Copy the copy and name it XXX-model-mnemonic.zip.
  - Get the mnemonic from `model-map.txt`.
    ```
    grep "Google-Gemma-1B-Instruct-v3-q8_0.gguf" $MODEL_MAP
    ```
- Attire the APE:
  ```
  cd $LOCAL_MODELS_DIR
  zip -0 -r -q "$THIS_ZIP_FILE" "Google-Gemma-1B-Instruct-v3-q8_0.gguf"
  cd $HOME
  ```

---
### SHORTCUT: Attire APEs with Available Models
```
# Run a script to attire an APE for each available model.
```

---
### Proceed
- **Next:** [626. Attired APEs (Performant)](626-Attired-APE-Performant.md)
- **Previous:** [624. Naked APE (Performant)](624-Naked-APE-Performant.md)
- **Up:** [500. Build Mmojo Server](500-Build-Mmojo-Server.md)

---
[MIT License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
