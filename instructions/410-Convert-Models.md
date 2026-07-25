## 410. Convert Models
### About this Step

In this step, we will download the latest convert script from the llama.cpp repo so we can do model conversion.

**Where:** Perform this step in both your x86_64 and your aarch64 (arm64) build environments.

---
<details>
  <summary><b>Update Local Mmojo Server Repo</b> &mdash; Expand if you haven't today.</summary>
  
Have you updated your local clone of the Mmojo Server Repo today? If not, run this first:
```
mm-repo-update-local.sh
mm-env
```
</details>

---
### Convert Models
Download the conversion tool, then work through popular Hugging Face models, converting them to `.gguf` models for local use. After converting each model, you can backup the Hugging Face source repo and converted `'.gguf` model to your Mmojo Share.
- [411. Prepare to Convert](411-Prepare-to-Convert.md) - Clone the llama.cpp GitHub repo, and leave it uncustomized so we can convert with it.
- [412. Google Gemma](412-Google-Gemma.md) - Clone Google's Gemma Repos on Hugging Face, convert to `.gguf` models.
- [413. Meta Llama](413-Meta-Llama.md) - Clone Meta's Llama Repos on Hugging Face, convert to `.gguf` models.
- [414. Mistral AI Ministral](414-Mistral-AI-Ministral.md) - Clone Mistral AI's Ministral Repos on Hugging Face, convert to `.gguf` models.

---
### Proceed
- **Next:** [411. Prepare to Convert](411-Prepare-to-Convert.md)
- **Previous:** [402. Restore Models](402-Restore-Models.md)
- **Up:** [400. Gather Models](400-Gather-Models.md)

---
[MIT License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@Mmojo.net)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
