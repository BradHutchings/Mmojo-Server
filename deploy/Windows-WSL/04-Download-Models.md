## 04. Download Models
### About this Step
In this step, we will download models for use with Mmojo Server from Hugging Face. If you have setup a Mmojo Share and the models are already available there, the models will be copied from your Mmojo Share instead.

---
### Download Models
Download models. These may take 20 minutes or so to download.

The default set of models contains Google Gemma 270M, 1B, and 4B. Run this command to create the model download queue.
```
mm-models-create-directory.sh
```

**Optional:** There are more recent Gemma E2B and E4B models. Run this script to add them to the model download queue.
```
cat << EOF >> $MODEL_QUEUE
Google-Gemma-E2B-Instruct-v3n-q8_0.gguf
Google-Gemma-E4B-Instruct-v3n-q8_0.gguf
EOF
```

**Optional:** IBM Granite models implement so-called "thinking" and "tool calling". Run this script to add them to the model download queue.
```
cat << EOF >> $MODEL_QUEUE
IBM-Granite-2B-Instruct-v3.3-q8_0.gguf
IBM-Granite-8B-Instruct-v3.3-q8_0.gguf
EOF
```

**Optional:** Qwen3 models also implement so-called "thinking" and "tool calling". Run this script to add them to the model download queue.
```
cat << EOF >> $MODEL_QUEUE
Qwen3-4B-Thinking-2507-FP8-q8_0.gguf
Qwen3-8B-v3-q8_0.gguf
Qwen3-14B-v3-q8_0.gguf
EOF
```

Now download all the models you added to the queue. If any of the models are available on your Mmojo Share, they will be copied from there.
```
mm-models-download.sh
```

---
### Proceed
- **Next:** [05. Download Mmojo Server](05-Download-Mmojo-Server.md)
- **Previous:** [03. Mount Mmojo Share](03-Mount-Mmojo-Share.md)
- **Up:** [Deploy Mmojo Server on Windows (WSL)](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
