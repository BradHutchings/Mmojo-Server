## 08. Configure OpenClaw &mdash; Finish Configuration
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

<img width="500" alt="image" src="https://github.com/user-attachments/assets/1ce63803-fe12-4a44-b53d-e1224117ac8d" />

Your shell prompt appears.

---
### Additional Configuration
Source the `.bashrc` file. Create useful directories. Change some things in the OpenClaw configuration. These changes specifically enable the recommended `Qwen3.5 9B v3.5` model.
```
. $HOME/.bashrc
mkdir -p "$HOME/.openclaw/workspace/actions"
mkdir -p "$HOME/.openclaw/workspace/reports"
openclaw config set agents.defaults.timeoutSeconds 1200
openclaw config set agents.defaults.llm.idleTimeoutSeconds 600
openclaw config set models.providers.mmojo-server-127-0-0-1.models[0].reasoning true
openclaw config set models.providers.mmojo-server-127-0-0-1.models[0].contextWindow 72000
openclaw config set models.providers.mmojo-server-127-0-0-1.models[0].maxTokens 72000
openclaw config set models.providers.mmojo-server-127-0-0-1.models[0].compat.supportsDeveloperRole false
openclaw gateway restart
```

<!--
supportsDeveloperRole from this comment:
https://github.com/openclaw/openclaw/issues/5704#issuecomment-3938731743
-->

<details>
  <summary><b>Optional:</b> Turn of Heartbeat. It's a mess.</summary>
<br/>
    
```
openclaw config set agents.defaults.heartbeat.every 0m
openclaw gateway restart
```
</details>

---
### Connect to OpenClaw
You'll use one of the custom commands from `$HOME/oc-scripts` to get the URL to connect to OpenClaw.
```
oc-dashboard.sh
```

<img width="500" alt="image" src="https://github.com/user-attachments/assets/6bbaa473-895a-46f2-a91b-bddb45d07855" />

Control-click the top link in the output.

You will see the **OpenClaw Gateway Dashboard** in your web browser, indicating that OpenClaw is running and ready for use.

---
### Backup the Configuration
Your `mm-scripts` directory scripts for backing up and restoring the OpenClaw environment. These are really useful as you get started automating things with OpenClaw.
```
oc-environment-backup.sh
```

Enter "Fresh Install" for the backup name.

---
### Updating OpenClaw
When you see a notice that there is an update available for OpenClaw, **DO NOT** update it in the web browser user interface. Instead, open a terminal connection to your OpenClaw instance and run this command:

```
# Update the oc-repo.
oc-update.sh
```

This will stop the OpenClaw gateway, update OpenClaw, patch a few important things in the compiled JavaScript, and then restart the OpenClaw gateway.

---
### Proceed
- **Next:** [09. Test OpenClaw](09-Test-OpenClaw.md)
- **Previous:** [07. Configure OpenClaw — Channels, Skills, and API Keys](07-Configure-OpenClaw-2.md)
- **Up:** [Deploy OpenClaw (WSL)](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
