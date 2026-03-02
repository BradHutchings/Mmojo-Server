## 01. Download Mmojo Server and a Model
### About this Step
In this step, you're going to download the `mmojo-server-ape.zip` from Hugging Face, download a model file from Hugging Face, exapnd the `.zip` archive, and move a model into the expanded archive folder.

*When you are finished with this step, proceed to the next step using the **Proceed** links at the bottom of this page.*

---
### Download Mmojo-Server-ape.zip
This `.zip` archive contains the Mmojo Server software.

- [Download Mmojo-Server-ape.zip](https://huggingface.co/bradhutchings/Mmojo-Server/resolve/main/deploy/Mmojo-Server-ape.zip)

---
### Download a Model File
Mmojo Server works with `.gguf` model files. Here are a few to try. Pick one.

- [Google Gemma 1B Instruct v3](https://huggingface.co/bradhutchings/Mmojo-Server/resolve/main/models/Google-Gemma-1B-Instruct-v3-q8_0.gguf)

- [Google Gemma 4B Instruct v3](https://huggingface.co/bradhutchings/Mmojo-Server/resolve/main/models/Google-Gemma-4B-Instruct-v3-q8_0.gguf)

- [Qwen3 8B v3](https://huggingface.co/bradhutchings/Mmojo-Server/resolve/main/models/Qwen3-8B-v3-q8_0.gguf)

Model files wih higher "B" (e.g. "4B" vs. "1B") require more RAM, perform slower. Models with higher "B" generally give better answers.

More models that have been tested with Mmojo Server are available here:

- [Mmojo Server Models](https://huggingface.co/bradhutchings/Mmojo-Server/tree/main/models)

---
### Expand Mmojo-Server-ape.zip
Expand the `Mmojo-Server-ape.zip` archive into a folder on your Desktop. The contents of the folder will look something like this:

<img width="414" height="250" alt="image" src="https://github.com/user-attachments/assets/4b3b0577-ee55-442e-9b2b-598d1381eaa9" />

---
### Copy a Model into the Folder
Copy one model file you downloaded into the folder. The folder will look something like this:

<img width="422" height="283" alt="image" src="https://github.com/user-attachments/assets/ea8c557d-6e34-4c0a-b8d2-668e0aa830c7" />

One model file at a time! Mmojo Server finds the first `.gguf` model file it can in its folder and uses that model file. It may or may not find them alphabetically. So, one model file at a time!

---
### Proceed
- **Next:** [02. Start Mmojo Server](02-Start-Mmojo-Server.md)
- **Previous:** This is the first step in this section.
- **Up:** [Deploy Mmojo Server on All Supported Platforms](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
