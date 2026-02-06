## 02. Cleanup WSL Instances
### About this Step
In this step, you will open the deployment guide for deploying Mmojo Server on Windows (WSL), you will complete the guide. You will return here.

---
### Deploy Mmojo Server

Open this deployment guide in a new tab:

- [Deploy Mmojo Server on Windows (WSL)](../200-Windows-WSL/README.md)

Complete that guide. When you are finished, you will have a Mmojo Server running in its own WSL instance.

---
### Download Models (Hugging Face)
Download models that OpenClaw can work with from Hugging Face. These may take 20 minutes or so to download.

IBM Granite models implement so-called "thinking" and "tool calling". Run this script to add them to the model download queue.
```
cat << EOF >> $LOCAL_DOWNLOAD_MODEL_MAP
IBM-Granite-2B-Instruct-v3.3-q8_0.gguf IBM-Gra-2B-Ins-v3.3
IBM-Granite-8B-Instruct-v3.3-q8_0.gguf IBM-Gra-8B-Ins-v3.3
EOF
```

Now download all the models you added to the queue.
```
mm-download-models.sh
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
