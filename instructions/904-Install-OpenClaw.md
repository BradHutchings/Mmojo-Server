## 904. Install OpenClaw
### About this Step
You will install OpenClaw in the `OpenClaw` WSL instance.

---
### Install OpenClaw
Switch to the `Terminal` window with the `(OpenClaw)` prompt.

<img width="356" height="125" alt="image" src="https://github.com/user-attachments/assets/c37cc113-8b61-4957-a08a-a17cb043fb2e" />

Now, run this command from the [OpenClaw website](https://openclaw.ai) to download and install OpenClaw.
```
curl -fsSL https://openclaw.ai/install.sh | bash
```

---
### Complete OpenClaw Onboarding
You will complete OpenClaw onboarding right now to get it running quickly. You will connect it to Mmojo Server and set up services later.

<img width="607" height="60" alt="image" src="https://github.com/user-attachments/assets/6b1c2fb1-7d48-4d64-87a0-b8dbf687547c" />

Hit the `Y` key.

<img width="608" height="77" alt="image" src="https://github.com/user-attachments/assets/de92b7b5-a0f8-4e53-be85-042e38a4d096" />

Hit the `ENTER` key.

<img width="238" height="302" alt="image" src="https://github.com/user-attachments/assets/76102749-6c0a-48e8-8a21-531d587c637a" />

Use the <code>&darr;</code> key to choose `Skip for now`, then hit the `ENTER` key.

<img width="290" height="152" alt="image" src="https://github.com/user-attachments/assets/6cb2cf56-f950-4a13-8c77-7608b1fbb5cc" />

Hit the `ENTER` key.

<img width="502" height="88" alt="image" src="https://github.com/user-attachments/assets/ea4f5cef-fedc-4a9a-aba2-efb28fbc2175" />

Use the <code>&darr;</code> key to choose `Enter model manually`, then hit the `ENTER` key.

<img width="283" height="61" alt="image" src="https://github.com/user-attachments/assets/a066c210-cd76-48d0-b313-c078dbc69181" />

Hit the `ENTER` key. You will fix the default model later.

<img width="688" height="386" alt="image" src="https://github.com/user-attachments/assets/79ec0122-0d4c-4697-bc55-116901f2920f" />

Use the <code>&darr;</code> key to choose `Skip for now`, then hit the `ENTER` key.

<img width="363" height="68" alt="image" src="https://github.com/user-attachments/assets/9645fd0d-54d8-48d4-bcc9-6d2a1a7109fc" />

Hit the `N` key.

<img width="235" height="117" alt="image" src="https://github.com/user-attachments/assets/2b8fafc0-9774-453e-8a45-161be4ec86b1" />

Hit the spacebar to choose `Skip for now`. Hit the `ENTER` key.

<img width="764" height="80" alt="image" src="https://github.com/user-attachments/assets/7d8780e5-e6a8-4234-b0e3-76c71d952f1e" />

Congratulations! Onboarding is complete.

---
### Additional Configuration
Source the `.bashrc` file. Run `openclaw` to make sure it is available.
```
. $HOME/.bashrc
openclaw
```

---
### Connect to OpenClaw
Scroll up to find the `Dashboard ready` section of the configure output. 

<img width="777" height="291" alt="image" src="https://github.com/user-attachments/assets/b0951a76-a2fd-4a10-bf61-b403eb01bcde" />

Control-click the `Dashboard link (with token)`.

<img width="716" height="368" alt="image" src="https://github.com/user-attachments/assets/6800706c-b82a-4978-9e13-c270b955dbf2" />

You will see what is still labeled as the **Clawdbot Gateway Dashboard**, indicating that OpenClaw is running and you can connect to it from a web browser on your computer.

---
### Proceed
- **Next:** Whatever is next.
- **Previous:** [903. Build Mmojo Server](903-Build-Mmojo-Server.md)
- **Up:** [900. Deploy OpenClaw](900-Deploy-OpenClaw.md)

---
[MIT License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
