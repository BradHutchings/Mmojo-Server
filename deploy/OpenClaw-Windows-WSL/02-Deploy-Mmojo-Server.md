## 02. Deploy Mmojo Server
### About this Step
In this step, you will open the deployment guide for deploying Mmojo Server on Windows (WSL), you will complete the guide. You will return here.

---
### Deploy Mmojo Server

Open this deployment guide in a new tab:

- [Deploy Mmojo Server on Windows (WSL)](../Windows-WSL/README.md)

Complete that guide. When you are finished, you will have a Mmojo Server running in its own WSL instance.

If you have an NVIDIA GPU, build a native Mmojo Server with CUDA support in your WSL instance:

- [01. Build Mmojo Server for Debian Linux](/build/debian/README.md)

---
### Download Models
Download models that OpenClaw can work with from Hugging Face. These may take 20 minutes or so to download.

Qwen3.5 models implement so-called "thinking" and "tool calling". 9B integrates well with OpenClaw 2026.3.12 and later. 4B might integrate well enough. Run this script to add them to the model download queue.
```
cat << EOF >> $_MODEL_QUEUE
Qwen3.5-4B-v3.5-q8_0.gguf
Qwen3.5-9B-v3.5-q8_0.gguf
EOF
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
