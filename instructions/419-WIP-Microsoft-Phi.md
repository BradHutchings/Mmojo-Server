## 419. Microsoft Phi
### About this Section
Let's download and convert Microsoft's Phi models from Hugging Face.

We will be using this script to clone each repo, convert the model, copy the model your `$LOCAL_MODELS_DIR` directory, and update the model map at `$MODELS_MAP`.
- View the script: <a href="../scripts/410-Convert-HF-to-gguf-Model.sh" target="_blank">410-Convert-HF-to-gguf-Model.sh</a>.
  - *On Github, you may need to right-click and choose "Open link in new tab" to open the "View script" links in a new tab.*
    <br/>

In the future, this script will also copy your converted model to your Mmojo Share if it is mounted.

---
### Microsoft's Phi (Mini) 3.8B Instruct v3.5
**Hugging Face Repo:** https://huggingface.co/microsoft/Phi-3.5-mini-instruct

It may take 10 minutes to clone the Hugging Face repo, even on fast Internet.

```
MODEL_NAME="Microsoft-Phi-3.8B-Instruct-v3.5"
MODEL_MNEMONIC="mic-phi-3.8B-ins-v3.5"
MODEL_TYPE="q8_0"
MODEL_REPO="https://huggingface.co/microsoft/Phi-3.5-mini-instruct"
$MMOJO_SERVER_REPO_SCRIPTS/410-Convert-HF-to-gguf-Model.sh \
    $MODEL_NAME $MODEL_TYPE $MODEL_MNEMONIC $MODEL_REPO
```

<details>
  <summary><b>Optional: Backup models to Mmojo Share</b></summary>

This backs up all new models in the `$LOCAL_MODELS_DIR` directory to your Mmojo Share.
- View the script: <a href="../scripts/mm-models-backup.sh" target="_blank">mm-models-backup.sh</a>.
- Run the script.
  ```
  mm-models-backup.sh
  ```
</details>

---
### Microsoft's Phi 3.8B Vision Instruct v3.5
**THIS MODEL DOESN'T WORK. NOT SUPPORTED BY LLAMA.CPP.**

**Hugging Face Repo:** https://huggingface.co/microsoft/Phi-3.5-vision-instruct

It may take 10 minutes to clone the Hugging Face repo, even on fast Internet.

```
MODEL_NAME="Microsoft-Phi-3.8B-Vision-Instruct-v3.5"
MODEL_MNEMONIC="mic-phi-3.8B-vis-ins-v3.5"
MODEL_TYPE="q8_0"
MODEL_REPO="https://huggingface.co/microsoft/Phi-3.5-vision-instruct"
$MMOJO_SERVER_REPO_SCRIPTS/410-Convert-HF-to-gguf-Model.sh \
    $MODEL_NAME $MODEL_TYPE $MODEL_MNEMONIC $MODEL_REPO
```

<details>
  <summary><b>Optional: Backup models to Mmojo Share</b></summary>

This backs up all new models in the `$LOCAL_MODELS_DIR` directory to your Mmojo Share.
- View the script: <a href="../scripts/mm-models-backup.sh" target="_blank">mm-models-backup.sh</a>.
- Run the script.
  ```
  mm-models-backup.sh
  ```
</details>

---
### Microsoft's Phi (Mini) 3.8B Instruct v4
**Hugging Face Repo:** https://huggingface.co/microsoft/Phi-4-mini-instruct

It may take 10 minutes to clone the Hugging Face repo, even on fast Internet.

```
MODEL_NAME="Microsoft-Phi-3.8B-Instruct-v4"
MODEL_MNEMONIC="mic-phi-3.8B-instruct-v4"
MODEL_TYPE="q8_0"
MODEL_REPO="https://huggingface.co/microsoft/Phi-4-mini-instruct"
$MMOJO_SERVER_REPO_SCRIPTS/410-Convert-HF-to-gguf-Model.sh \
    $MODEL_NAME $MODEL_TYPE $MODEL_MNEMONIC $MODEL_REPO
```

<details>
  <summary><b>Optional: Backup models to Mmojo Share</b></summary>

This backs up all new models in the `$LOCAL_MODELS_DIR` directory to your Mmojo Share.
- View the script: <a href="../scripts/mm-models-backup.sh" target="_blank">mm-models-backup.sh</a>.
- Run the script.
  ```
  mm-models-backup.sh
  ```
</details>

---
### Microsoft's Phi (Mini) 3.8B Flash Reasoning v4
**THIS MODEL DOESN'T WORK. NOT SUPPORTED BY LLAMA.CPP.**

**Hugging Face Repo:** https://huggingface.co/microsoft/Phi-4-mini-flash-reasoning

It may take 10 minutes to clone the Hugging Face repo, even on fast Internet.

```
MODEL_NAME="Microsoft-Phi-3.8B-Flash-Reasoning-v4"
MODEL_MNEMONIC="mic-phi-3.8B-fla-rea-v4"
MODEL_TYPE="q8_0"
MODEL_REPO="https://huggingface.co/microsoft/Phi-4-mini-flash-reasoning"
$MMOJO_SERVER_REPO_SCRIPTS/410-Convert-HF-to-gguf-Model.sh \
    $MODEL_NAME $MODEL_TYPE $MODEL_MNEMONIC $MODEL_REPO
```

<details>
  <summary><b>Optional: Backup models to Mmojo Share</b></summary>

This backs up all new models in the `$LOCAL_MODELS_DIR` directory to your Mmojo Share.
- View the script: <a href="../scripts/mm-models-backup.sh" target="_blank">mm-models-backup.sh</a>.
- Run the script.
  ```
  mm-models-backup.sh
  ```
</details>

---
### Microsoft's Phi (Mini) 3.8B Reasoning v4
**Hugging Face Repo:** https://huggingface.co/microsoft/Phi-4-mini-reasoning

It may take 10 minutes to clone the Hugging Face repo, even on fast Internet.

```
MODEL_NAME="Microsoft-Phi-3.8B-Reasoning-v4"
MODEL_MNEMONIC="mic-phi-3.8B-rea-v4"
MODEL_TYPE="q8_0"
MODEL_REPO="https://huggingface.co/microsoft/Phi-4-mini-reasoning"
$MMOJO_SERVER_REPO_SCRIPTS/410-Convert-HF-to-gguf-Model.sh \
    $MODEL_NAME $MODEL_TYPE $MODEL_MNEMONIC $MODEL_REPO
```

<details>
  <summary><b>Optional: Backup models to Mmojo Share</b></summary>

This backs up all new models in the `$LOCAL_MODELS_DIR` directory to your Mmojo Share.
- View the script: <a href="../scripts/mm-models-backup.sh" target="_blank">mm-models-backup.sh</a>.
- Run the script.
  ```
  mm-models-backup.sh
  ```
</details>

---
### Microsoft's Phi 16B Reasoning v4
**Hugging Face Repo:** https://huggingface.co/microsoft/Phi-4-reasoning

It may take 10 minutes to clone the Hugging Face repo, even on fast Internet.

```
MODEL_NAME="Microsoft-Phi-16B-Reasoning-v4"
MODEL_MNEMONIC="mic-phi-16B-rea-v4"
MODEL_TYPE="q8_0"
MODEL_REPO="https://huggingface.co/microsoft/Phi-4-reasoning"
$MMOJO_SERVER_REPO_SCRIPTS/410-Convert-HF-to-gguf-Model.sh \
    $MODEL_NAME $MODEL_TYPE $MODEL_MNEMONIC $MODEL_REPO
```

<details>
  <summary><b>Optional: Backup models to Mmojo Share</b></summary>

This backs up all new models in the `$LOCAL_MODELS_DIR` directory to your Mmojo Share.
- View the script: <a href="../scripts/mm-models-backup.sh" target="_blank">mm-models-backup.sh</a>.
- Run the script.
  ```
  mm-models-backup.sh
  ```
</details>

---
### Microsoft's Phi 16B Reasoning Plus v4
**Hugging Face Repo:** https://huggingface.co/microsoft/Phi-4-reasoning-plus

It may take 10 minutes to clone the Hugging Face repo, even on fast Internet.

```
MODEL_NAME="Microsoft-Phi-16B-Reasoning-Plus-v4"
MODEL_MNEMONIC="mic-phi-16B-rea-plu-v4"
MODEL_TYPE="q8_0"
MODEL_REPO="https://huggingface.co/microsoft/Phi-4-reasoning-plus"
$MMOJO_SERVER_REPO_SCRIPTS/410-Convert-HF-to-gguf-Model.sh \
    $MODEL_NAME $MODEL_TYPE $MODEL_MNEMONIC $MODEL_REPO
```

<details>
  <summary><b>Optional: Backup models to Mmojo Share</b></summary>

This backs up all new models in the `$LOCAL_MODELS_DIR` directory to your Mmojo Share.
- View the script: <a href="../scripts/mm-models-backup.sh" target="_blank">mm-models-backup.sh</a>.
- Run the script.
  ```
  mm-models-backup.sh
  ```
</details>

---
### Proceed
- **Next:** [415. Mistral AI Ministral](415-Mistral-AI-Ministral.md)
- **Previous:** [413. Meta Llama](413-Meta-Llama.md)
- **Up:** [400. Gather Models](400-Gather-Models.md)

---
[MIT License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@Mmojo.net)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
