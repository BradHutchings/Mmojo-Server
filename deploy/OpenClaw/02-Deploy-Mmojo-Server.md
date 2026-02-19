## 02. Cleanup WSL Instances
### About this Step
In this step, you will open the deployment guide for deploying Mmojo Server on Windows (WSL), you will complete the guide. You will return here.

---
### Deploy Mmojo Server

Open this deployment guide in a new tab:

- [Deploy Mmojo Server on Windows (WSL)](../200-Windows-WSL/README.md)

Complete that guide. When you are finished, you will have a Mmojo Server running in its own WSL instance.

If you have an NVIDIA GPU, build a native Mmojo Server with CUDA support in your WSL instance:

- [Build ELF Executable for Debian Linux](/build/20-ELF-Debian.md)

---
### Download Models
Download models that OpenClaw can work with from Hugging Face. These may take 20 minutes or so to download.

IBM Granite models implement so-called "thinking" and "tool calling". Run this script to add them to the model download queue.
```
cat << EOF >> $LOCAL_MODEL_QUEUE
IBM-Granite-2B-Instruct-v3.3-q8_0.gguf
IBM-Granite-8B-Instruct-v3.3-q8_0.gguf
EOF
```

Here are some newer Granite models:
```
cat << EOF >> $LOCAL_MODEL_QUEUE
IBM-Granite-350M-v4.0-q8_0.gguf
IBM-Granite-1B-v4.0-q8_0.gguf
IBM-Granite-Micro-3B-v4.0-q8_0.gguf
IBM-Granite-Tiny-Preview-7B-v4.0-q8_0.gguf
EOF
```

Here are some Microsoft Phi4 models:
```
cat << EOF >> $LOCAL_MODEL_QUEUE
Microsoft-Phi-3.8B-Reasoning-v4-q8_0.gguf
Microsoft-Phi-16B-Reasoning-v4-q8_0.gguf
Microsoft-Phi-16B-Reasoning-Plus-v4-q8_0.gguf
EOF
```

Now download all the models you added to the queue.
```
mm-models-download.sh
```

---
### Stop Mmojo Server, Exit WSL Instance
Due to some weirdness with WSL when moving instances to other drives, you should stop Mmojo Server and exit its WSL instance. You will be moving the WSL instance for OpenClaw to your second drive, and WSL won't do that if *any* WSL instance is running.

There are two ways you can do this:
1. **The easy way:**

   Close the WSL window where Mmojo Server is running. WSL will notice you have no sessions open and shut down the instance.
   
2. **The hard but maybe better way**:

   `CTRL-C` (maybe twice) to stop `mmojo-server`. Then leave the connection to the WSL instance:
   ```
   exit
   ```

---
### Proceed
- **Next:** [03. Prepare WSL - OpenClaw](03-Prepare-WSL-OpenClaw.md)
- **Previous:** [01. Prerequisites](01-Prerequisites.md)
- **Up:** [Deploy OpenClaw (WSL)](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
