## 23. Connect OpenClaw to Mmojo Server
### About this Step
You will edit the configuration of OpenClaw so that it uses your Mmojo Server instance as its large language model (LLM).

---
### Connect OpenClaw to Mmojo Server
Go to your browser tab that shows the **OpenClaw Control** page.

(picture here)

Click **Config** in the left panel.

(picture of panel with Raw button circled)

Click the **Raw** button at the bottom-left of the **Config** panel.

(picture of json cofig)

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

Copy this block, and replace the `"agents" > "default" > "models"` block:
```
      "model": {
        "primary": "lmstudio/default"
      },
```

---
### Proceed
- **Next:** [24. Test OpenClaw](24-Test-OpenClaw.md)
- **Previous:** [22. Install OpenClaw](22-Install-OpenClaw.md)
- **Up:** [Deploy OpenClaw (WSL)](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
