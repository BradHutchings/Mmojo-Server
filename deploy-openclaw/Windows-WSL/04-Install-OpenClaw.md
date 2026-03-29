## 04. Install OpenClaw
### About this Step
You will install OpenClaw in the `OpenClaw` WSL instance.

---
### Start Mmojo Server
The OpenClaw onboarding sequence will connect with Mmojo Server. It needs to be running.

Start Mmojo Server by launching it from the Taskbar.

Once launched, I recommend stopping Mmojo Server, switching the model to `Qwen3.5-9B-v3-q8_0.gguf` and starting it in "debug" mode.

---
### Install OpenClaw
Switch to the `Terminal` window with the `(OpenClaw)` prompt.

<img width="356" height="125" alt="image" src="https://github.com/user-attachments/assets/c37cc113-8b61-4957-a08a-a17cb043fb2e" />

Now, run this command from the [OpenClaw website](https://openclaw.ai) to download and install OpenClaw.
```
curl -fsSL https://openclaw.ai/install.sh | bash
```
<!--
```
export OPENCLAW_USE_GUM=0
```
**Note:** Turning off GUM is a workaround for the 2026-2-21 release.
-->

<!--
This gets added to .bashrc. We will source .bashrc when we're done. -Brad 2026-02-23
export PATH="/home/linux/.npm-global/bin:$PATH"
-->

---
### Proceed
- **Next:** [05. Configure OpenClaw — Mmojo Server](05-Configure-OpenClaw-1.md)
- **Previous:** [03. Prepare WSL - OpenClaw](03-Prepare-WSL-OpenClaw.md)
- **Up:** [Deploy OpenClaw (WSL)](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
