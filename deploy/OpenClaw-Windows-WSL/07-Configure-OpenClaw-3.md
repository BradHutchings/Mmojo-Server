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
openclaw
```

---
### Connect to OpenClaw
```
openclaw dashboard --no-open
```

<img width="696" height="346" alt="image" src="https://github.com/user-attachments/assets/9fb8908c-1d63-4ea4-846a-12494a93ac05" />

Control-click the top link in the output.

<!--
Scroll up to find the `Dashboard ready` section of the configure output. 

<img width="777" height="291" alt="image" src="https://github.com/user-attachments/assets/b0951a76-a2fd-4a10-bf61-b403eb01bcde" />

Control-click the `Dashboard link (with token)`.

<img width="716" height="368" alt="image" src="https://github.com/user-attachments/assets/6800706c-b82a-4978-9e13-c270b955dbf2" />

**Note**: The picture above needs to be updated.
-->

You will see the **OpenClaw Gateway Dashboard**, indicating that OpenClaw is running and you can connect to it from a web browser on your computer.




---
### Proceed
- **Next:** [05. Connect OpenClaw to Mmojo Server](05-Connect-OpenClaw-to-Mmojo-Server.md)
- **Previous:** [03. Prepare WSL - OpenClaw](03-Prepare-WSL-OpenClaw.md)
- **Up:** [Deploy OpenClaw (WSL)](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
