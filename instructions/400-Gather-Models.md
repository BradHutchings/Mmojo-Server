## 400. Gather Models
### About this Section
Let's gather pre-built models from the Mmojo Share and use llama.cpp and Hugging Face to build some .gguf models we can use with Mmojo Server.

If you have already prepared your build environment, skip ahead to: 
- [500. Build Mmojo Server](500-Build-Mmojo-Server.md)

*Cloning even the smaller repos from Hugging Face takes a lot of time, even on fast broadband with fast WiFi. I'm working to create a workflow where users of the system clone and convert a couple models at a time to build up a collection on their Mmojo Shares, which can be copied back to build environments when needed. -Brad*

---
### Convert Models
Here are the things you need to do:

- [401. Download Models](401-Download-Models.md) - Download popular `.gguf` models from Hugging Face.
- [402. Restore Models](402-Restore-Models.md) - Restore models previously backed up to your Mmojo Share.<br/><br/>
- [410. Convert Models](410-Convert-Models.md) - Convert Hugging Face models to `.gguf` models, the model format for llama.cpp.
  - [411. Prepare to Convert](411-Prepare-to-Convert.md) - Clone the llama.cpp GitHub repo, and leave it uncustomized so we can convert with it.
  - [412. Google Gemma](412-Google-Gemma.md) - Clone Google's Gemma Repos on Hugging Face, convert to `.gguf` models.
  - [413. Meta Llama](413-Meta-Llama.md) - Clone Meta's Llama Repos on Hugging Face, convert to `.gguf` models.
  - [414. Mistral AI Ministral](414-Mistral-AI-Ministral.md) - Clone Mistral AI's Ministral Repos on Hugging Face, convert to `.gguf` models.<br/><br/>

**Get Started:** [401. Download Models](401-Download-Models.md)



---
[MIT License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
