## 03. Download Models
### About this Step
In this step, we will download models for use with Mmojo Server from Hugging Face.

---
### Download Models
Download models. These may take 20 minutes or so to download.

The default set of models contains Google Gemma 270M, 1B, and 4B. This is a great set to get started with!
```
$MMOJO_SERVER_SCRIPTS/401-Create-Models-Directory.sh
mm-download-models.sh 4
```

Additional, more recent Google Gemma models.
```
$MMOJO_SERVER_SCRIPTS/401-Create-Models-Directory.sh
cat << EOF >> $LOCAL_DOWNLOAD_MODEL_MAP
# This is our map between actual model filenames and filenames for mmojo-server with the model embedded.
Google-Gemma-E2B-Instruct-v3n-q8_0.gguf Goo-Gem-E2B-Ins-v3n
Google-Gemma-E4B-Instruct-v3n-q8_0.gguf Goo-Gem-E4B-Ins-v3n
EOF
mm-download-models.sh 5
```

IBM Granite models implement so-called "thinking" and "tool calling".
```
$MMOJO_SERVER_SCRIPTS/401-Create-Models-Directory.sh
cat << EOF >> $LOCAL_DOWNLOAD_MODEL_MAP
# This is our map between actual model filenames and filenames for mmojo-server with the model embedded.
IBM-Granite-2B-Instruct-v3.3-q8_0.gguf IBM-Gra-2B-Ins-v3.3
IBM-Granite-8B-Instruct-v3.3-q8_0.gguf IBM-Gra-8B-Ins-v3.3
EOF
mm-download-models.sh 5
```

---
### Proceed
- **Next:** [04. Download Mmojo Server](04-Download-Mmojo-Server.md)
- **Previous:** [02. Prepare WSL - Mmojo Server](02-Prepare-WSL-Mmojo-Server.md)
- **Up:** [Deploy Mmojo Server on Windows (WSL)](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
