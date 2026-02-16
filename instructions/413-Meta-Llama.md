## 413. Meta Llama
### About this Section
Let's download and convert Meta's Llama models from Hugging Face.

We will be using this script to clone each repo, convert the model, copy the model your `$LOCAL_MODELS_DIR` directory, and update the model map at `$MODELS_MAP`.
- View the script: <a href="../scripts/410-Convert-HF-to-gguf-Model.sh" target="_blank">410-Convert-HF-to-gguf-Model.sh</a>.
  - *On Github, you may need to right-click and choose "Open link in new tab" to open the "View script" links in a new tab.*
    <br/>

In the future, this script will also copy your converted model to your Mmojo Share if it is mounted.

---
### Hugging Face Account
Meta requires that you have a Hugging Face account and that your account has permission to download their gated models. Please:
- Create an account on Hugging Face.
- Create an API key with read access.
- Request permission through one of the Meta models.

You will need your account id and your API key handy each time you clone a model repo. In fact, you will be asked for them twice each time you clone.

---
### Meta's Llama Scout 17B Instruct v4
**Hugging Face Repo:** https://huggingface.co/meta-llama/Llama-4-Scout-17B-16E-Instruct

It may take 20 or 30 minutes to clone the Hugging Face repo, even on fast Internet.

```
MODEL_NAME="Meta-Llama-Scout-17B-Instruct-v4"
MODEL_MNEMONIC="met-lla-sco-17B-ins-v4"
MODEL_TYPE="q8_0"
MODEL_REPO="https://huggingface.co/meta-llama/Llama-4-Scout-17B-16E-Instruct"
$MMOJO_SERVER_SCRIPTS/410-Convert-HF-to-gguf-Model.sh \
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
### Meta's Llama Maverick 17B Instruct v4
**Hugging Face Repo:** https://huggingface.co/meta-llama/Llama-4-Maverick-17B-128E-Instruct

It may take 20 or 30 minutes to clone the Hugging Face repo, even on fast Internet.

```
MODEL_NAME="Meta-Llama-Maverick-17B-Instruct-v4"
MODEL_MNEMONIC="met-lla-mav-17B-ins-v4"
MODEL_TYPE="q8_0"
MODEL_REPO="https://huggingface.co/meta-llama/Llama-4-Maverick-17B-128E-Instruct"
$MMOJO_SERVER_SCRIPTS/410-Convert-HF-to-gguf-Model.sh \
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
### Meta's Llama 1B Instruct v3.2
**Hugging Face Repo:** https://huggingface.co/meta-llama/Llama-3.2-1B-Instruct

It may take 20 or 30 minutes to clone the Hugging Face repo, even on fast Internet.

```
MODEL_NAME="Meta-Llama-1B-Instruct-v3.2"
MODEL_MNEMONIC="met-lla-1B-ins-v3.2"
MODEL_TYPE="q8_0"
MODEL_REPO="https://huggingface.co/meta-llama/Llama-3.2-1B-Instruct"
$MMOJO_SERVER_SCRIPTS/410-Convert-HF-to-gguf-Model.sh \
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
### Meta's Llama 3B Instruct v3.2
**Hugging Face Repo:** https://huggingface.co/meta-llama/Llama-3.2-3B-Instruct

It may take 20 or 30 minutes to clone the Hugging Face repo, even on fast Internet.

```
MODEL_NAME="Meta-Llama-3B-Instruct-v3.2"
MODEL_MNEMONIC="met-lla-3B-ins-v3.2"
MODEL_TYPE="q8_0"
MODEL_REPO="https://huggingface.co/meta-llama/Llama-3.2-3B-Instruct"
$MMOJO_SERVER_SCRIPTS/410-Convert-HF-to-gguf-Model.sh \
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
### Meta's Llama 11B Vision Instruct v3.2
**Hugging Face Repo:** https://huggingface.co/meta-llama/Llama-3.2-11B-Vision-Instruct

It may take 20 or 30 minutes to clone the Hugging Face repo, even on fast Internet.

```
MODEL_NAME="Meta-Llama-11B-Vision-Instruct-v3.2"
MODEL_MNEMONIC="met-lla-11B-vis-ins-v3.2"
MODEL_TYPE="q8_0"
MODEL_REPO="https://huggingface.co/meta-llama/Llama-3.2-11B-Vision-Instruct"
$MMOJO_SERVER_SCRIPTS/410-Convert-HF-to-gguf-Model.sh \
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
- **Next:** [414. Mistral AI Ministral](414-Mistral-AI-Ministral.md)
- **Previous:** [412. Google Gemma](412-Google-Gemma.md)
- **Up:** [400. Gather Models](400-Gather-Models.md)

---
[MIT License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
