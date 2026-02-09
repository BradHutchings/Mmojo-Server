## 05. Connect OpenClaw to Mmojo Server
### About this Step
You will edit the configuration of OpenClaw so that it uses your Mmojo Server instance as its large language model (LLM).

---
### Start Mmojo Server

<img width="158" height="97" alt="image" src="https://github.com/user-attachments/assets/9770555c-7f9c-408d-ab99-e209c0ad2db1" />

Click the MmojoServer WSL Shortcut that you added to your Taskbar. This will launch the WSL instance and open a Terminal window.

Choose a model. I'd suggest choosing **IBM Granite 8B Instruct**. It will be copied to your `$HOME/Mmojo-Server` directory.
```
mm-choose-model.sh
```

Launch `mmojo-server`:
```
mm-start-mmojo-server.sh
```

Leave the WSL instance Terminal window open and visible on your screen.

---
### Connect OpenClaw to Mmojo Server
Go to your browser tab that shows the **OpenClaw Control** page.

<img width="165" height="97" alt="image" src="https://github.com/user-attachments/assets/b3c9ec48-cbb5-418e-aaeb-0406dec1f55b" />

Click **Config** in the left panel.

<img width="302" height="84" alt="image" src="https://github.com/user-attachments/assets/5b133cf6-8e5a-4d30-9148-e3a76ce50c33" />

Click the **Raw** button at the bottom-left of the **Config** panel.

<img width="780" height="329" alt="image" src="https://github.com/user-attachments/assets/87ba53a1-7915-420f-bf26-987366f8c668" />

Copy this block and paste it after the `"messages"` block:
```
  "models": {
    "providers": {
      "mmojo": {
        "baseUrl": "http://127.0.0.1:8080/v1",
        "apiKey": "mmojo",
        "api": "openai-completions",
        "models": [
          {
            "id": "default",
            "name": "Default",
            "reasoning": true,
            "input": ["text"],
            "cost": { input: 0, output: 0, cacheRead: 0, cacheWrite: 0 },
            "contextWindow": 32768,
            "maxTokens": 32768
          }
        ]
      }
    }
  },

```

Copy this block, and replace the `"agents" > "defaults" > "model"` block:
```
      "model": {
        "primary": "mmojo/default"
      },

```

<img width="338" height="67" alt="image" src="https://github.com/user-attachments/assets/711345a1-0691-4afd-bd0b-b658e7656c9c" />

Click the **Save** button at the top right. Wait for saving to complete.

Click the **Update** button at the top right. Wait for updating to complete.

---
### Proceed
- **Next:** [06. Test OpenClaw](06-Test-OpenClaw.md)
- **Previous:** [04. Install OpenClaw](04-Install-OpenClaw.md)
- **Up:** [Deploy OpenClaw (WSL)](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
