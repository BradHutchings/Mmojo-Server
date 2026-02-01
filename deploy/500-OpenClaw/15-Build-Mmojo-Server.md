## 15. Build Mmojo Server

### About this Step
If you didn't install Mmojo Server from Hugging Face downloads or from builds on your Mmojo Share, you can build it quickly with the steps on this page.

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

Choose a model and GPUs:
```
unset CHOSEN_MODEL
unset CHOSEN_MODEL_MNEMONIC
unset CHOSEN_GPUS
. mm-choose-model.sh
. mm-choose-gpus.sh
```

Build native Mmojo Server:
```
$MMOJO_SERVER_SCRIPTS/510-Build-for-Platform.sh native "$CHOSEN_GPUS"
```

Make a run folder. This is a good candidate for an mm-script.
```
mkdir -p $RUN_DIR
rm -r -f "$RUN_DIR"/*
BUILD_SUBDIR="$BUILD_DIR/$BUILD_EXECUTABLE_NATIVE_X86_64$CHOSEN_GPUS"
cp $BUILD_SUBDIR/bin/$PACKAGE_MMOJO_SERVER_FILE $RUN_DIR
cp -r $BUILD_DIR/Mmojo-Complete $RUN_DIR
# make a $PACKAGE_MMOJO_SERVER_ARGS_FILE file
cat << EOF > "$RUN_DIR/$PACKAGE_MMOJO_SERVER_ARGS_FILE"
--path
"$RUN_FOLDER/Mmojo-Complete"
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
if [ -f "$LOCAL_MODELS_DIR/$CHOSEN_MODEL" ]; then cp "$LOCAL_MODELS_DIR/$CHOSEN_MODEL" $RUN_DIR; fi
```

---
### Launch mmojo-server

Launch `mmojo-server`:
```
$RUN_DIR/$PACKAGE_MMOJO_SERVER_FILE 
```

Connect to Mmojo Complete from a browser:

[Mmojo Complete](http://127.0.0.1:8080) &larr; Right-click, open in new tab.

---
### Proceed
- **Next:** [20. Deploy OpenClaw](20-Deploy-OpenClaw.md)
- **Previous:** [14. Copy Mmojo Server from Mmojo Share](14-Copy-Mmojo-Server-from-Mmojo-Share.md)
- **Up:** [Deploy OpenClaw (WSL)](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
