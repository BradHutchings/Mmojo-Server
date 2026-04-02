## 06. Configure OpenClaw &mdash; Mmojo Server
### About this Step
In this step, you will start working through OpenClaw configuration wizard. You will get through the configuration option of connecting OpenClaw to Mmojo Server.

---
### Initial Configuration
Work through the configuration options in order as they are presented.

---

**I understand this is powerful and inherently risky? Continue?**

<img width="500" alt="image" src="https://github.com/user-attachments/assets/6b1c2fb1-7d48-4d64-87a0-b8dbf687547c" />

Hit the `Y` key.

---

**Onboarding mode**

<img width="500" alt="image" src="https://github.com/user-attachments/assets/de92b7b5-a0f8-4e53-be85-042e38a4d096" />

Hit the `ENTER` key.

---
### Configure for Use with Mmojo Server
**Model/auth provider**

<img width="500" alt="image" src="https://github.com/user-attachments/assets/b388b5da-096a-4448-8afd-e21ebf7e2b3d" />

Use the <code>&darr;</code> key to choose `Custom Provider`, then hit the `ENTER` key.

---

**API Base URL**

<img width="271" height="55" alt="image" src="https://github.com/user-attachments/assets/a801f45f-62de-46c1-b4c0-299f1c0eb44b" />

This is the API URL for Mmojo Server. Paste this value in:
```
http://127.0.0.1:8080/v1
```

---

**API Key (leave blank if not required)**

Don't leave this blank! Paste in this fake key:
```
mmojo-server-api-key
```

---

**Endpoint compatibility**

<img width="438" height="92" alt="image" src="https://github.com/user-attachments/assets/8a7669ac-9ba1-4e7d-960b-7ed4646ee004" />

`OpenAI-compatible` is the default selection.

Hit the `ENTER` key.

---

**Model ID**

<img width="154" height="56" alt="image" src="https://github.com/user-attachments/assets/ba25ad11-f790-4f0d-8d63-6abe3d9f02e8" />

The model is chosen on the Mmojo Server. Paste in this Model ID:
```
mmojo-model
```

You'll see the configuration wizard verifying that it can make a connection, followed by:

<img width="258" height="32" alt="image" src="https://github.com/user-attachments/assets/66ae4afb-00f5-43c8-b7b6-fc443abc3bc2" />

---

**Endpoint ID**

<img width="248" height="57" alt="image" src="https://github.com/user-attachments/assets/d5372b1d-9b08-460c-a8a9-fda5af982a4c" />

Paste in this value:
```
mmojo-server-127-0-0-1
```

---

**Model Alias (optional)**

<img width="245" height="58" alt="image" src="https://github.com/user-attachments/assets/0e2282f5-c545-437c-be2f-586d2af9059d" />

Paste in this value:
```
mmojo-server
```

You will see this message about configuration:

<img width="500" alt="image" src="https://github.com/user-attachments/assets/410e689e-e85e-4fa3-916c-39a983f2702e" />

---
### Continue Next Page
There is more configuration left to complete. Continue on the next page.


---
### Proceed
- **Next:** [07. Configure OpenClaw — Channels, Skills, and API Keys](07-Configure-OpenClaw-2.md)
- **Previous:** [05. Install OpenClaw](05-Install-OpenClaw.md)
- **Up:** [Deploy OpenClaw (WSL)](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
