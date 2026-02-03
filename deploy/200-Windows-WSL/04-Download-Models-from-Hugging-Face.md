## 04. Download Models from Hugging Face
### About this Step (OPTIONAL)
In this step, we will download models for use with Mmojo Server from Hugging Face. If you would prefer to copy models from your Mmojo Share, you can skip ahead.

**Skip Ahead:**
- [05. Copy Models from Mmojo Share](05-Copy-Models-from-Mmojo-Share.md)

---
### Download Models
Download models. These may take 20 minutes or so to download.

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

**Future:** It would be better to offer a collection of generic models, download a couple at a time. These are geared toward OpenClaw.

---
### Proceed
- **Next:** [05. Copy Models from Mmojo Share](05-Copy-Models-from-Mmojo-Share.md)
- **Previous:** [03. Mount Mmojo Share](03-Mount-Mmojo-Share.md)
- **Up:** [Deploy Mmojo Server on Windows (WSL)](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
