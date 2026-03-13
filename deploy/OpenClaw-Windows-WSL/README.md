## Deploy OpenClaw (Windows WSL)
### About this Section
In this section, you will deploy the open source OpenClaw agent platform. You will deploy OpenClaw in one Windows Subsystem for Linux (WSL) instance and Mmojo Server in a separate WSL instance. You will configure OpenClaw to use Mmojo Server as its LLM. You'll be ready to rock and roll with OpenClaw.

Your installation will be private and self-contained on the computer on which you are running OpenClaw. Of course, the agents you run can reach out anywhere on the Internet and leak all of your private and sensitive information, so you should proceed cautiously.

**Note:** OpenClaw has only recently worked well enough with small models. The problem before was due to both the small models available and how OpenClaw drowned them in prompts. I would confidently say that OpenClaw 2026.3.12 can function with Qwen3.5 9B, and might be functionable with Qwen3.5 4B. In other words, with modest hardware, you might not need expensive cloud tokens.

<!-- SPONSOR --> 
If you need assistance via Zoom call and screen sharing, I offer a one-hour hands-on session, for (US) $100. It can be scheduled during extended west coast business hours. You will be working with me, the guy who made this thing work. [Email me if interested](mailto:brad@BradHutchings.com?subject=OpenClaw%20Install%20Help).

-Brad<br/>
\--<br/>
Brad Hutchings<br/>
brad@BradHutchings.com<br/><br/>
<!-- END SPONSOR -->

<!--
**OPENCLAW TEAM KEEPS BREAKING THINGS.** I'm testing new builds soon after they are released and patching up instructions as I can figure them out. -Brad 2025-02-09

**THIS IS A DRAFT OF THIS RECIPE.** Some pieces aren't implemented yet. If you're careful, you should end up with a "working" installation and at the very least, be able to use the OpenClaw web control page to chat with your Mmojo Server. -Brad 2026-02-01
-->

**Get Started:** [01. Prerequisites](01-Prerequisites.md)

---
### Deploy OpenClaw
Here are the deployment steps:
- [01. Prerequisites](01-Prerequisites.md) - What you need to deploy OpenClaw.
- [02. Deploy Mmojo Server](02-Deploy-Mmojo-Server.md) - You will use another deploy guide to deploy Mmojo Server.  
- [03. Prepare WSL - OpenClaw](03-Prepare-WSL-OpenClaw.md) - You will create a WSL instance for OpenClaw.
- [04. Install OpenClaw](04-Install-OpenClaw.md) - Install OpenClaw and perform Quick Configuration.
- [05. Connect OpenClaw to Mmojo Server](05-Connect-OpenClaw-to-Mmojo-Server.md) - Connect OpenClaw to Mmojo Server.
- [06. Test OpenClaw](06-Test-OpenClaw.md) - Perform simple tests with OpenClaw.
  <br/><br/>

**Get Started:** [01. Prerequisites](01-Prerequisites.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
