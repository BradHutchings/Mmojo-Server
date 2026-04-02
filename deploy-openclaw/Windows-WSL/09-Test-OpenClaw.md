## 09. Test OpenClaw
### About this Step
You perform a few tests to demonstrate that OpenClaw is using your Mmojo Server for it's large language model (LLM) server.

*As of this writing, the OpenClaw user interface feels flakey, especially when used with a small local LLM. There are a lot of things wrong with this project. I like to think they will eventually sort some out. -Brad 2026-02-23*

---
### Test OpenClaw
<img width="1271" height="660" alt="image" src="https://github.com/user-attachments/assets/7d17f1a9-7371-4d33-bb35-632ef57309d2" />

The chat panel should be visible.

<img width="294" height="94" alt="image" src="https://github.com/user-attachments/assets/8945ad17-1a1e-45e2-8778-2089ab381738" />

Click the **New session** button at the bottom right of the chat panel.

<img width="813" height="385" alt="image" src="https://github.com/user-attachments/assets/8a98cbb2-95a6-4aa1-bc37-070fad232f6a" />

You should see some activity in the MmojoServer window.

<img width="228" height="101" alt="image" src="https://github.com/user-attachments/assets/73e9577b-d7da-4571-8f6b-42de0719ef3b" />

Ask it to tell you a joke.
```
Tell me a joke.
```

This will take a few minutes, as it first does some work on memory compaction when you issue the above prompt. But eventually, it will tell you joke.

<img width="552" height="244" alt="image" src="https://github.com/user-attachments/assets/c54ce5ef-64a0-41aa-a91c-bf2ed765c2ef" />

Note the timestamps.

Skills are a mixed bag. This seems to work about half the time, making a tool call to query the wttr.in service.
```
/skill weather San Diego, CA
```

---
### Future
A future version of these instructions will show you how to configure Mmojo Server so that you can watch what OpenClaw is asking for. It's eye opening.

**Note:** *The problem with OpenClaw and small LLMs as of February 23, 2026 is OpenClaw's giant, poorly organized, and largely ineffective system prompt. OpenClaw enthisiasts have been happy so far to pay huge cloud token bills, or set up Mac Minis and Mac Studio clusters to run larger models. Having dug deep into the prompt, I know that's just the wrong approach. It may take time, but that system prompt situation should get better or fixable. It's good that you can get OpenClaw installed and running now. -Brad 2026-02-23*

---
### Proceed
- **Next:** This is the last step in this guide.
- **Previous:** [08. Configure OpenClaw — Finish Configuration](08-Configure-OpenClaw-3.md)
- **Up:** [Deploy OpenClaw (WSL)](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
