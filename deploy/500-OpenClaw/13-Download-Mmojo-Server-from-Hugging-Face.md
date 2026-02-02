## 13. Download Mmojo Server from Hugging Face

### THIS STEP IS NOT FULLY IMPLEMENTED YET.
Please proceed to the next step.

---
### About this Step
In this step, we will install Mmojo Server from Hugging Face. If you would prefer to install Mmojo Server from your Mmojo Share or build it from scratch, skip ahread to one of these steps:
- Install from Mmojo Share.
- Build from scratch.

---
### Install GPU Support
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
### Download Mmojo Server from Hugging Face

Set the URL for the Mmojo Server package that runs on recent x86_64 CPUs:
```
URL="https://huggingface.co/bradhutchings/Mmojo-Server/resolve/main/deploy/Mmojo-Server-x86-perf-cud.zip"
```

Alternatively, set the URL for the Mmojo Server package that runs on all x86_64 CPUs:
```
URL="https://huggingface.co/bradhutchings/Mmojo-Server/resolve/main/deploy/Mmojo-Server-x86-comp-cud.zip"
```

Download Mmojo Server from Hugging Face and unzip it in the `$HOME/Mmojo-Server` directory:
```
mkdir -p $RUN_DIR
cd $RUN_DIR
rm -r -f "$RUN_DIR"/*
wget $URL -O "mmojo-server.zip"
unzip "mmojo-server.zip"
rm "mmojo-server.zip"
cd $HOME
ls -al $RUN_DIR
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

**Future:** The `choose-model.sh` script will copy the chosen model to `$RUN_DIR` if `$RUN_DIR` exists.

---
### Proceed
- **Next:** [14. Copy Mmojo Server from Mmojo Share](14-Copy-Mmojo-Server-from-Mmojo-Share.md)
- **Previous:** [12. Mount Mmojo Share](12-Mount-Mmojo-Share.md)
- **Up:** [Deploy OpenClaw (WSL)](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
