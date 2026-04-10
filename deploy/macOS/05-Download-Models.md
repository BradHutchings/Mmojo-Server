## 05. Download Models
**THIS GUIDE IS IN PROGRESS.**
### About this Step
In this step, we will download models for use with Mmojo Server from Hugging Face. If you have setup a Mmojo Share and the models are already available there, the models will be copied from your Mmojo Share instead.

---
### Download Models
Download models. These may take 20 minutes or so to download.

The default set of models contains Google Gemma 270M, 1B, and 4B. Run this command to create the model download queue and download some Google models. If any of the models are available on your Mmojo Share, they will be copied from there.

```
mm-models-create-directory.sh
mm-models-download.sh
```

**Optional:** Here are essential Gemma 4 and Qwen3.5 quantizations for OpenClaw. Run this script to download them.
```
Google-Gemma-E4B-Instruct-v4-q4_K_M.gguf
Google-Gemma-E4B-Instruct-v4-q5_K_M.gguf
Qwen3.5-9B-v3.5-q4-K-M.gguf
Qwen3.5-9B-v3.5-q5-K-M.gguf
mm-models-download.sh
```


**Optional:** There are more recent Gemma E2B and E4B models. Here is the complete collection. Run this script to download them.
```
cat << EOF >> $_MODEL_QUEUE
Google-Gemma-E2B-Instruct-v4-q4_K_M.gguf
Google-Gemma-E2B-Instruct-v4-q5_K_M.gguf
Google-Gemma-E2B-Instruct-v4-q6_K.gguf
Google-Gemma-E4B-Instruct-v4-q8_0.gguf
Google-Gemma-E4B-Instruct-v4-q4_K_M.gguf
Google-Gemma-E4B-Instruct-v4-q5_K_M.gguf
Google-Gemma-E4B-Instruct-v4-q6_K.gguf
Google-Gemma-E4B-Instruct-v4-q8_0.gguf
EOF
mm-models-download.sh
```

**Optional:** Qwen3.5 models implement so-called "thinking" and "tool calling". Qwen3.5 models, particularly 9B, seem to be the best for use with OpenClaw. Run this script to download them.
```
cat << EOF >> $_MODEL_QUEUE
Qwen3.5-2B-v3.5-q8_0.gguf
Qwen3.5-4B-v3.5-q8_0.gguf
Qwen3.5-9B-v3.5-q4-K-M.gguf
Qwen3.5-9B-v3.5-q5-K-M.gguf
Qwen3.5-9B-v3.5-q6-K.gguf
Qwen3.5-9B-v3.5-q8_0.gguf
EOF
mm-models-download.sh
```

**Optional:** IBM Granite models also implement so-called "thinking" and "tool calling". Run this script to download them.
```
cat << EOF >> $_MODEL_QUEUE
IBM-Granite-2B-Instruct-v3.3-q8_0.gguf
IBM-Granite-8B-Instruct-v3.3-q8_0.gguf
IBM-Granite-350M-v4.0-q8_0.gguf
IBM-Granite-1B-v4.0-q8_0.gguf
IBM-Granite-Micro-3B-v4.0-q8_0.gguf
IBM-Granite-Tiny-Preview-7B-v4.0-q8_0.gguf
EOF
mm-models-download.sh
```

**Optional:** Microsoft Phi 4 models also implement so-called "thinking" and "tool calling". Run this script to download them.
```
cat << EOF >> $_MODEL_QUEUE
Microsoft-Phi-3.8B-Reasoning-v4-q8_0.gguf
Microsoft-Phi-16B-Reasoning-Plus-v4-q8_0.gguf
Microsoft-Phi-16B-Reasoning-v4-q8_0.gguf
EOF
mm-models-download.sh
```

---
### Proceed
- **Next:** [06. Download Mmojo Server](06-Download-Mmojo-Server.md)
- **Previous:** [04. Mount Mmojo Share](04-Mount-Mmojo-Share.md)
- **Up:** [Deploy Mmojo Server on macOS](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
