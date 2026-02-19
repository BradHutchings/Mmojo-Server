## 05. Download Mmojo Server
### About this Step
In this step, we will download Mmojo Server from Hugging Face.

---
### Install GPU Support
Install CUDA and Vulkan support. These may take 10 minutes or so to download and install.
```
sudo apt install -y nvidia-cuda-toolkit
sudo apt install -y libvulkan-dev glslc vulkan-tools
echo "NOTE: Install CUDA and Vulkan tools finished."
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
### Set Mmojo Server Download URL
Set the URL for the Mmojo Server package that runs on recent x86_64 CPUs. It is currently unkown if this build runs on any aarch64 (arm64) Windows computers.
```
URL=""
if [ $(uname -m) == "x86_64" ]; then
    URL="https://huggingface.co/bradhutchings/Mmojo-Server/resolve/main/deploy/Mmojo-Server-x86_64-perf-cud.zip"
elif [ $(uname -m) == "aarch64" ]; then
    URL="https://huggingface.co/bradhutchings/Mmojo-Server/resolve/main/deploy/Mmojo-Server-aarch64-perf-cud.zip"
fi
```

<details>
  <summary><b>Alternatively:</b>, set the URL for the Mmojo Server package that runs on all x86_64 and aarch64 (arm64) CPUs. Use this if the Mmojo Server you download with the URL setting above gives you an illegal instruction error when you run it.</summary>
  <br/>
  
```
URL=""
if [ $(uname -m) == "x86_64" ]; then
    URL="https://huggingface.co/bradhutchings/Mmojo-Server/resolve/main/deploy/Mmojo-Server-x86_64-comp-cud.zip"
elif [ $(uname -m) == "aarch64" ]; then
    URL="https://huggingface.co/bradhutchings/Mmojo-Server/resolve/main/deploy/Mmojo-Server-aarch64-comp-cud.zip"
fi
```
</details>

Future: Might just download the "compatible" version for aarch64 (arm64) by default. It's tough to figure out what processors are out there. -Brad 2025-02-11

---
### Download Mmojo Server from Hugging Face
Download Mmojo Server from Hugging Face and unzip it in the `$HOME/Mmojo-Server` directory:
```
if (test -n "$RUN_DIR") && [ "$URL" != "" ]; then
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

Mmojo Server is installed. You are ready to test it!

---
### Proceed
- **Next:**  [06. Test Mmojo Server](06-Test-Mmojo-Server.md)
- **Previous:** [04. Download Models](04-Download-Models.md)
- **Up:** [Deploy Mmojo Server on Windows (WSL)](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
