## 13. Download Mmojo Server from Hugging Face
### About this Step (OPTIONAL)
In this step, we will download Mmojo Server from Hugging Face. If you would prefer to copy Mmojo Server from your Mmojo Share or build it from source code, you can skip ahead.

**Skip Ahead:**
- [14. Copy Mmojo Server from Mmojo Share](14-Copy-Mmojo-Server-from-Mmojo-Share.md)
- [15. Build Mmojo Server](15-Build-Mmojo-Server.md)

---
### Install GPU Support
Install CUDA and Vulkan support. These may take 10 minutes or so to download and install.
```
sudo apt install -y nvidia-cuda-toolkit
sudo apt install -y libvulkan-dev glslc vulkan-tools
```

<details>
  <summary><b>Future:</b> Find client libraries to install rather than developer tools.</summary>
  <br/>
  <b>Source:</b> https://docs.nvidia.com/datacenter/tesla/driver-installation-guide/ubuntu.html
  <br/><br/>

```
# open kernel modules
apt install nvidia-open -y
```

Or:

```
# proprietary kernel modules
apt install cuda-drivers -y
```
</details>


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

<details>
  <summary>Alternatively, set the URL for the Mmojo Server package that runs on all x86_64 CPUs. Use this if the Mmojo Server you download with the URL setting above gives you errors when you run it.</summary>
  
```
URL="https://huggingface.co/bradhutchings/Mmojo-Server/resolve/main/deploy/Mmojo-Server-x86-comp-cud.zip"
```
</details>

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
. mm-choose-model.sh
```

Mmojo Server is installed and you are ready to run it!

Skip to: [16. Run Mmojo Server](16-Run-Mmojo-Server.md)

---
### Proceed
- **Next:** [14. Copy Mmojo Server from Mmojo Share](14-Copy-Mmojo-Server-from-Mmojo-Share.md)
- **Previous:** [12. Mount Mmojo Share](12-Mount-Mmojo-Share.md)
- **Up:** [Deploy OpenClaw (WSL)](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
