## Deploy OpenClaw (macOS)
### About this Guide
In this guide, you will deploy the open source OpenClaw agent platform. You will deploy OpenClaw in one account on your Mac and Mmojo Server in a separate account on your Mac. You will configure OpenClaw to use Mmojo Server as its LLM. You'll be ready to rock and roll with OpenClaw.

Your installation will be private and self-contained on the computer on which you are running OpenClaw. Of course, the agents you run can reach out anywhere on the Internet and leak all of your private and sensitive information, so you should proceed cautiously.

**Note:** OpenClaw has only recently worked well enough with small models to work with Mmojo Server. The problem before was due to both the small models available and how OpenClaw drowned them in prompts. I would confidently say that OpenClaw 2026.3.12 can function with Qwen3.5 9B, and might be functionable with Qwen3.5 4B. In other words, with modest hardware, you might not need expensive cloud tokens.

<!-- SPONSOR --> 
I offer paid assistance over Zoom if you need it:
* [Paid Assistance](/docs/Paid-Assistance.md)

-Brad<br/>
\--<br/>
Brad Hutchings<br/>
brad@BradHutchings.com<br/><br/>
<!-- END SPONSOR -->

**Get Started:** [01. Prerequisites](01-Prerequisites.md)

---
### Deploy OpenClaw
Here are the deployment steps:
- [01. Prerequisites](01-Prerequisites.md) - What you need to deploy OpenClaw.
- [02. Deploy Mmojo Server](02-Deploy-Mmojo-Server.md) - You will use another deploy guide to deploy Mmojo Server.  
- [03. Prepare macOS - OpenClaw](03-Prepare-macOS-OpenClaw.md) - You will create a WSL instance for OpenClaw.
- [04. Mount Mmojo Share](04-Mount-Mmojo-Share.md) - Mount the Mmojo Share.
- [05. Install OpenClaw](05-Install-OpenClaw.md) - Install OpenClaw.
- [06. Configure OpenClaw &mdash; Mmojo Server](06-Configure-OpenClaw-1.md) - Configure OpenClaw to use Mmojo Server.
- [07. Configure OpenClaw &mdash; Channels, Skills, and API Keys](07-Configure-OpenClaw-2.md) - Configure channels, skills, and API keys.
- [08. Configure OpenClaw &mdash; Finish Configuration](08-Configure-OpenClaw-3.md) - Finish configuration of OpenClaw.
- [09. Test OpenClaw](09-Test-OpenClaw.md) - Perform simple tests with OpenClaw.
  <br/><br/>

**Get Started:** [01. Prerequisites](01-Prerequisites.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
