## 414. Mistral AI Ministral
### About this Section
Let's download and convert Mistral AI's Ministral models from Hugging Face.

We will be using this script to clone each repo, convert the model, copy the model your `$LOCAL_MODELS_DIR` directory, and update the model map at `$MODELS_MAP`.
- View the script: <a href="../scripts/410-Convert-HF-to-gguf-Model.sh" target="_blank">410-Convert-HF-to-gguf-Model.sh</a>.
  - *On Github, you may need to right-click and choose "Open link in new tab" to open the "View script" links in a new tab.*
    <br/>

In the future, this script will also copy your converted model to your Mmojo Share if it is mounted.

---
### Mistral AI's Ministral 3B Reasoning v3-2512
**Hugging Face Repo:** https://huggingface.co/mistralai/Ministral-3-3B-Reasoning-2512

It may take 20 or 30 minutes to clone the Hugging Face repo, even on fast Internet.

```
MODEL_NAME="Mistral-Ministral-3B-Reasoning-v3-2512"
MODEL_MNEMONIC="mis-min-3B-rea-v3-2512"
MODEL_TYPE="q8_0"
MODEL_REPO="https://huggingface.co/mistralai/Ministral-3-3B-Reasoning-2512"
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
### Mistral AI's Ministral 8B Reasoning v3-2512
**Hugging Face Repo:** https://huggingface.co/mistralai/Ministral-3-8B-Reasoning-2512

It may take 20 or 30 minutes to clone the Hugging Face repo, even on fast Internet.

```
MODEL_NAME="Mistral-Ministral-8B-Reasoning-v3-2512"
MODEL_MNEMONIC="mis-min-8B-rea-v3-2512"
MODEL_TYPE="q8_0"
MODEL_REPO="https://huggingface.co/mistralai/Ministral-3-8B-Reasoning-2512"
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
### Mistral AI's Ministral 14B Reasoning v3-2512
**Hugging Face Repo:** https://huggingface.co/mistralai/Ministral-3-14B-Reasoning-2512

It may take 20 or 30 minutes to clone the Hugging Face repo, even on fast Internet.

```
MODEL_NAME="Mistral-Ministral-14B-Reasoning-v3-2512"
MODEL_MNEMONIC="mis-min-14B-rea-v3-2512"
MODEL_TYPE="q8_0"
MODEL_REPO="https://huggingface.co/mistralai/Ministral-3-14B-Reasoning-2512"
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
- **Next:** This is the last step in this section.
- **Previous:** [413. Meta Llama](413-Meta-Llama.md)
- **Up:** [400. Gather Models](400-Gather-Models.md)

---
[MIT License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
