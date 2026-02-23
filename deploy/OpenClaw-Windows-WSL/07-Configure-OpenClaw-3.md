## 07. Configure OpenClaw &mdash; Finish Configuration
### About this Step
In this step, you will configure channels and skills.

---
### Configure OpenClaw (continued)
**Enable Hooks?**

<img width="326" height="123" alt="image" src="https://github.com/user-attachments/assets/8fead834-6497-4361-88ee-d90de8fc9126" />

Hit the spacebar to choose `Skip for now`. Hit the `ENTER` key.

---

**How do you want to hatch your bot?**

<img width="361" height="107" alt="image" src="https://github.com/user-attachments/assets/dc6a95b5-8bdc-44ee-8e0b-f09f52c3a75e" />

Use the <code>&darr;</code> key to choose `Open the Web UI`, then hit the `ENTER` key.

---

**Onboarding complete.**

<img width="682" height="147" alt="image" src="https://github.com/user-attachments/assets/fdc95d95-5247-4b38-ac60-3f398f8d4939" />

You're not quite done yet. At this point it looks like the installer is stuck. You will not see your familiar `(OpenClaw-` shell prompt.

Hit `CTRL-C`.

<img width="671" height="70" alt="image" src="https://github.com/user-attachments/assets/782a4b07-f15c-49a4-a15f-9225736832fe" />

Your shell prompt appears.

---
### Additional Configuration
Source the `.bashrc` file. Run `openclaw` to make sure it is available.
```
. $HOME/.bashrc
openclaw config set agents.defaults.timeoutSeconds 1200
openclaw config set models.providers.mmojo-server-127-0-0-1-8080.models[0].reasoning true
openclaw config set models.providers.mmojo-server-127-0-0-1-8080.models[0].contextWindow 32768
openclaw config set models.providers.mmojo-server-127-0-0-1-8080.models[0].maxTokens 32768
openclaw config set models.providers.mmojo-server-127-0-0-1-8080.models[0].compat.supportsDeveloperRole false
openclaw gateway restart
```

<!--
supportsDeveloperRole from this comment:
https://github.com/openclaw/openclaw/issues/5704#issuecomment-3938731743
-->

---
### Connect to OpenClaw
```
openclaw dashboard --no-open
```

<img width="696" height="346" alt="image" src="https://github.com/user-attachments/assets/9fb8908c-1d63-4ea4-846a-12494a93ac05" />

Control-click the top link in the output.

You will see the **OpenClaw Gateway Dashboard** in your web browser, indicating that OpenClaw is running and ready for use.

---
### Proceed
- **Next:** [08. Test OpenClaw](08-Test-OpenClaw.md)
- **Previous:** [06. Configure OpenClaw — Channels, Skills, and API Keys](06-Configure-OpenClaw-2.md)
- **Up:** [Deploy OpenClaw (WSL)](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
