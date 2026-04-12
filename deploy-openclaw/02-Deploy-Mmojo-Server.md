## 02. Deploy Mmojo Server
### About this Step
In this step, you will open the deployment guide for deploying Mmojo Server on macOS, you will complete the guide. You will return here.

---
### Deploy Mmojo Server

Open this deployment guide in a new tab:

- [Deploy Mmojo Server on macOS](/deploy/macOS/README.md)

Complete that guide. When you are finished, you will have a Mmojo Server running in its own account on your Mac.

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
### Proceed
- **Next:** [03. Prepare macOS - OpenClaw](03-Prepare-macOS-OpenClaw.md)
- **Previous:** [01. Prerequisites](01-Prerequisites.md)
- **Up:** [Deploy OpenClaw (macOS)](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
