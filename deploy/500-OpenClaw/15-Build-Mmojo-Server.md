## 15. Build Mmojo Server

### About this Step
If you didn't download Mmojo Server from Hugging Face, or copy Mmojo Server from your Mmojo Share, you can build it quickly with the steps on this page.

---
### Install Dependencies and GPU Support
Install dependencies. These may take 20 minutes or so to download and install.
```
$MMOJO_SERVER_SCRIPTS/207-Install-Dependencies.sh
```

Install CUDA and Vulkan support. These may take 10 minutes or so to download and install.
```
sudo apt install -y nvidia-cuda-toolkit
sudo apt install -y libvulkan-dev glslc vulkan-tools
```

---
### Download Models
Download models. These may take 20 minutes or so to download.

Might be good to get these from Mmojo Share? Mount Mmojo Share should be step 12.
```
$MMOJO_SERVER_SCRIPTS/401-Create-Models-Directory.sh
cat << EOF > $LOCAL_DOWNLOAD_MODEL_MAP
# This is our map between actual model filenames and filenames for mmojo-server with the model embedded.
Google-Gemma-270M-Instruct-v3-q8_0.gguf Goo-Gem-270M-Ins-v3
Google-Gemma-1B-Instruct-v3-q8_0.gguf Goo-Gem-1B-Ins-v3
IBM-Granite-2B-Instruct-v3.3-q8_0.gguf IBM-Gra-2B-Ins-v3.3
IBM-Granite-8B-Instruct-v3.3-q8_0.gguf IBM-Gra-8B-Ins-v3.3
EOF
mm-download-models.sh 4
```

---
### Build Native Mmojo Server
Prepare to build:
```
$MMOJO_SERVER_SCRIPTS/501-Clone-Repos.sh
$MMOJO_SERVER_SCRIPTS/501-Patch-llama-cpp.sh
$MMOJO_SERVER_SCRIPTS/501-Customize-webui.sh
```

Choose a model and GPUs. I'd suggest **CUDA**.
```
unset CHOSEN_GPUS
. mm-choose-gpus.sh
```

Build native Mmojo Server tuned to the CPU of your PC:
```
$MMOJO_SERVER_SCRIPTS/510-Build-for-Platform.sh native "$CHOSEN_GPUS"
BUILD_SUBDIR="$BUILD_DIR/$BUILD_EXECUTABLE_NATIVE_X86_64$CHOSEN_GPUS"
```

<details>
  <summary>Alternatively, build a more compatible Mmojo Server:</summary>
  
```
$MMOJO_SERVER_SCRIPTS/510-Build-for-Platform.sh compatible "$CHOSEN_GPUS"
BUILD_SUBDIR="$BUILD_DIR/$BUILD_EXECUTABLE_COMPATIBLE_X86_64$CHOSEN_GPUS"
```
</details>

---
### Create a Run Directory
Make a run directory. This is a good candidate for an mm-script.
```
mkdir -p $RUN_DIR
rm -r -f "$RUN_DIR"/*
# BUILD_SUBDIR="$BUILD_DIR/$BUILD_EXECUTABLE_NATIVE_X86_64$CHOSEN_GPUS"
cp $BUILD_SUBDIR/bin/$PACKAGE_MMOJO_SERVER_FILE $RUN_DIR
cp -r $BUILD_DIR/Mmojo-Complete $RUN_DIR
# make a $PACKAGE_MMOJO_SERVER_ARGS_FILE file
cat << EOF > "$RUN_DIR/$PACKAGE_MMOJO_SERVER_ARGS_FILE"
--path
"$RUN_DIR/Mmojo-Complete"
--host
0.0.0.0
--port
8080
--batch-size
1924
--threads-http
8
--ctx-size
32768 
EOF
```

---
### Choose a Model
Choose a model. I'd suggest choosing **IBM Granite 8B Instruct**. It will be copied to your `$HOME/Mmojo-Server` directory.
```
unset CHOSEN_MODEL
unset CHOSEN_MODEL_MNEMONIC
. mm-choose-model.sh
if [ -f "$LOCAL_MODELS_DIR/$CHOSEN_MODEL" ]; then cp "$LOCAL_MODELS_DIR/$CHOSEN_MODEL" $RUN_DIR; fi
```

---
### Review Your Work
Let's list the contents of the `$HOME/Mmojo-Server` directory and review your work:
```
ls -al $RUN_DIR
```

It should look like:

<img width="814" height="159" alt="image" src="https://github.com/user-attachments/assets/7d59ae18-90ff-4137-840e-dbf7e9c10891" />

---
### Proceed
- **Next:** [16. Run Mmojo Server](16-Run-Mmojo-Server.md)
- **Previous:** [14. Copy Mmojo Server from Mmojo Share](14-Copy-Mmojo-Server-from-Mmojo-Share.md)
- **Up:** [Deploy OpenClaw (WSL)](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
