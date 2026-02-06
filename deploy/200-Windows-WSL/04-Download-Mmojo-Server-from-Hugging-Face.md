## 04. Download Mmojo Server from Hugging Face
### About this Step (OPTIONAL)
In this step, we will download Mmojo Server from Hugging Face. If you would prefer to build it from source code, you can skip ahead.

**Skip Ahead:**
- [05. Build Mmojo Server](05-Build-Mmojo-Server.md)

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

  These did not work:
```
# open kernel modules
sudo apt install nvidia-open -y
# proprietary kernel modules
sudo apt install cuda-drivers -y
```
</details>

---
### Download Mmojo Server from Hugging Face

Set the URL for the Mmojo Server package that runs on recent x86_64 CPUs:
```
URL="https://huggingface.co/bradhutchings/Mmojo-Server/resolve/main/deploy/Mmojo-Server-x86-perf-cud.zip"
```

<details>
  <summary>Alternatively, set the URL for the Mmojo Server package that runs on all x86_64 CPUs. Use this if the Mmojo Server you download with the URL setting above gives you errors when you run it.</summary>
  <br/>
  
```
URL="https://huggingface.co/bradhutchings/Mmojo-Server/resolve/main/deploy/Mmojo-Server-x86-comp-cud.zip"
```
</details>

Download Mmojo Server from Hugging Face and unzip it in the `$HOME/Mmojo-Server` directory:
```
if test -n "$RUN_DIR"; then
  mkdir -p $RUN_DIR
  cd $RUN_DIR
  rm -r -f "$RUN_DIR"/*
  wget $URL -O "mmojo-server.zip"
  unzip "mmojo-server.zip"
  rm "mmojo-server.zip"
  cd $HOME
  ls -al $RUN_DIR
fi
```

Mmojo Server is installed and you are ready to run it!

**Skip to:** [06. Start, Stop, Choose Model](09-Start-Stop-Choose-Model.md)

---
### Proceed
- **Next:**  [05. Build Mmojo Server](05-Build-Mmojo-Server.md)
- **Previous:** [03. Download Models from Hugging Face](03-Download-Models-from-Hugging-Face.md)
- **Up:** [Deploy Mmojo Server on Windows (WSL)](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
