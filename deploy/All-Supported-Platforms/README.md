## Deploy Mmojo Server on All Supported Platforms
### About this Section
In this section, you will get Mmojo Server running on your PC or laptop, regardless of operating system or CPU. You will download the `mmojo-server-ape.zip` archive, download a model, expand the acrhive on your desktop, then run Mmojo Server.

The Mmojo Server Actual Portable Executable (APE) is a starting point. Connect to my Mmojo Complete UI or a traditional chat UI in your web browser. Connect your OpenAI API compatible application to Mmojo Server. Make sure it works for you. If you decide you'd like a more robust installation, perhaps with GPU support, you can deploy or build Mmojo Server, tuned to your platform.

**Supported CPUs:** x86_64 (Intel/AMD) and aarch64 (ARM).

**Supported operating systems:** Windows 10/11, macOS, Linux (Debian, RHEL, Arch, etc.), FreeBSD, and a few others.

**Suggested RAM:** 16 GB.

---
### 1. Download mmojo-server-ape.zip
This archive has the Mmojo Server software.

- [Download mmojo-server-ape.zip](https://huggingface.co/bradhutchings/Mmojo-Server/resolve/main/deploy/Mmojo-Server-ape.zip)

---
### 2. Download a Model
Here are a few to try. Pick one. More B's require more RAM, perform slower. More B's generally give better answers.

- [Google Gemma 1B Instruct v3](https://huggingface.co/bradhutchings/Mmojo-Server/resolve/main/models/Google-Gemma-1B-Instruct-v3-q8_0.gguf)

- [Google Gemma 4B Instruct v3](https://huggingface.co/bradhutchings/Mmojo-Server/resolve/main/models/Google-Gemma-4B-Instruct-v3-q8_0.gguf)

- [Qwen3 8B v3](https://huggingface.co/bradhutchings/Mmojo-Server/resolve/main/models/Qwen3-8B-v3-q8_0.gguf)

More models that have been tested with Mmojo Server are available here:

- [Mmojo Server Models](https://huggingface.co/bradhutchings/Mmojo-Server/tree/main/models)

---
### 3. Expand mmojo-server-ape.zip
Expand the `mmojo-server-ape.zip` archive into a folder on your Desktop. The contents of the folder will look something like this:

<img width="408" height="189" alt="image" src="https://github.com/user-attachments/assets/bdd76941-a6ae-4ea5-b790-262ab9db923d" />

---
### 4. Copy a Model into the Folder
Copy one model you downloaded into the folder. The folder will look something like this:

<img width="404" height="219" alt="image" src="https://github.com/user-attachments/assets/53b67556-b53d-4e21-99d2-c055fba2e024" />

One model at a time! Mmojo Server finds the first model it can in its folder and uses that one. It may or may not find the alphabetically. So, one model at a time!

---
### 5. Start Mmojo Server
There are four Mmojo Servers.
- `mmojo-server-ape-performant` - maxOS and Linux.
- `mmojo-server-ape-performant.exe` - Windows.
- `mmojo-server-ape-compatible` - macOS and Linux.
- `mmojo-server-ape-compatible.exe` - Windows.

If you're using a macOS or Linux computer, move the `.exe` builds to the Trash.

If you're using a Windows computer, move the builds without the `.exe` extension to the trash.

Now, you're left with a "performant" build and a "compatible" build. The performant build runs faster, but only on new enough computers. The compatible runs on most computers, but not as fast.

**Note:** Raspberry Pi users, you will use the compatible build.

Double-click the performant build. A terminal window will open and show what Mmojo Server is doing:

<img width="803" height="640" alt="image" src="https://github.com/user-attachments/assets/ed2347fa-3700-43da-bbd7-8857fe0133e6" />

**Note:** macOS users may be asked to install "Developer Tools" before the terminal window appears. Do that.

**Note:** Linux users with GNOME Files as their desktop should open a Terminal for the directory and run Mmojo Server from the command line. Otherwise, it will launch as a background process.

---
### 6. Connect to Mmojo Server
Open your web browser on the computer on which you are running Mmojo Server. Go to this link:

- [http://127.0.0.1](http://127.0.0.1)

You will see the Mmojo Complete user interface for Mmojo Server. Type a question or a sentence and the `RETURN` or `ENTER` key.

<img width="707" height="762" alt="image" src="https://github.com/user-attachments/assets/615adf94-d488-4253-9eef-d7d1910857aa" />

If you'd prefer to go directly to the chat user interface, use this link instead:

- [http://127.0.0.1/chat](http://127.0.0.1/chat)

You will see the Mmojo Chat user interface for Mmojo Server.  


<img width="704" height="759" alt="image" src="https://github.com/user-attachments/assets/42ba9528-c9ae-40b0-9204-71ef693410b7" />

---
### 7. Stop Mmojo Server
When you're done using Mmojo Server, you should stop it. Just close the Terminal window.

You can also keep it running, but note that it consumes enough RAM to load the model file and little bit more.

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
