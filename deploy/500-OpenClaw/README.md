## Deploy OpenClaw (WSL)
### About this Section (500-OpenClaw)
In this section, you will deploy the open source OpenClaw agent platform. You will deploy OpenClaw in one Windows Subsystem for Linux (WSL) instance and Mmojo Server in a separate WSL instance. You will configure OpenClaw to use Mmojo Server as its LLM. You'll be ready to rock and roll with OpenClaw.

Your installation will be private and self-contained on the computer on which you are running OpenClaw. Of course, the agents you run can reach out anywhere on the Internet and leak all of your private and sensitive information, so you should proceed cautiously.

**THIS IS A DRAFT OF THIS RECIPE.** Some pieces aren't implemented yet. If you're careful, you should end up with a "working" installation and at the very least, be able to use the OpenClaw web control page to chat with your Mmojo Server. -Brad 2026-02-01

**Get Started:** [01. Prerequisites](01-Prerequisites.md)

---
### Deploy OpenClaw
Here are the deployment steps:
- [01. Prerequisites](01-Prerequisites.md) - What you need to deploy OpenClaw.
- [02. Cleanup WSL Instances](02-Cleanup-WSL-Instances.md) - You will delete existing instances so you have a fresh canvas to work with.

- [10. Deploy Mmojo Server](10-Deploy-Mmojo-Server.md) - In this subsection, you will install or build Mmojo Server for use with OpenClaw.
  
  - [11. Prepare WSL - Mmojo Server](11-Prepare-WSL-Mmojo-Server.md) - You will create a WSL instance for Mmojo Server.
  - [12. Mount Mmojo Share](12-Mount-Mmojo-Share.md) - If you have a Mmojo Share, mount it.
  - [13. Download Mmojo Server from Hugging Face](13-Download-Mmojo-Server-from-Hugging-Face.md) - In this subsection, you will download Mmojo Server from Hugging Face and install it for use with OpenClaw.
  - [14. Copy Mmojo Server from Mmojo Share](14-Copy-Mmojo-Server-from-Mmojo-Share.md) - In this subsection, you will copy a previously built Mmojo Server from your Mmojo Share and install it for use with OpenClaw.
  - [15. Build Mmojo Server](15-Build-Mmojo-Server.md) - You will build a Mmojo Server for testing with OpenClaw quickly.
  - [16. Run Mmojo Server](16-Run-Mmojo-Server.md) - Run and quickly test Mmojo Server.

- [20. Deploy OpenClaw](20-Deploy-OpenClaw.md) - You will install, configure, and test OpenClaw.
  
  - [21. Prepare WSL - OpenClaw](21-Prepare-WSL-OpenClaw.md) - You will create a WSL instance for OpenClaw.
  - [22. Install OpenClaw](22-Install-OpenClaw.md) - Install OpenClaw and perform Quick Configuration.
  - [23. Connect OpenClaw to Mmojo Server](23-Connect-OpenClaw-to-Mmojo-Server.md) - Connect OpenClaw to Mmojo Server.
  - [24. Test OpenClaw](24-Test-OpenClaw.md) - Perform simple tests with OpenClaw.
    <br/><br/>

**Get Started:** [01. Prerequisites](01-Prerequisites.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
