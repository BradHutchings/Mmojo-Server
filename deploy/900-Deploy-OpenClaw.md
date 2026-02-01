## 900. Deploy OpenClaw
### About this Section
In this section, you will deploy the open source OpenClaw agent platform. You will deploy OpenClaw in one WIndows Subsystem for Linux (WSL) instance and Mmojo Server in a separate WSL instance. You will configure OpenClaw to use Mmojo Server as its LLM. You'll be ready to rock and roll with Moltbot.

Your installation will be private and self-contained on the computer on which you are running OpenClaw. Of course, the agents you run can reach out anywhere on the Internet and leak all of your private and sensitive information, so you should proceed cautiously.

---
### Deploy OpenClaw
Here are the deployment steps:
- [901. Cleanup WSL Instances](901-Cleanup-WSL-Instances.md) - You will delete existing instances so you have a fresh canvas to work with.
- [910. Deploy Mmojo Server](910-Deploy-Mmojo-Server.md) - In this subsection, you will install or build Mmojo Server for use with OpenClaw.
  - [911. Prepare WSL - Mmojo Server](911-Prepare-WSL-Mmojo-Server.md) - You will create a WSL instance for Mmojo Server.
  - [912. Install Mmojo Server - Hugging Face](912-Install-Mmojo-Server-Hugging-Face.md) - In this subsection, you will download Mmojo Server from Hugging Face and install it for use with OpenClaw.
  - [913. Install Mmojo Server - Mmojo Share](913-Install-Mmojo-Server-Mmojo-Share.md) - In this subsection, you will copy a previously built Mmojo Server from your Mmojo Share and install it for use with OpenClaw.
  - [914. Build Mmojo Server](914-Build-Mmojo-Server.md) - You will build a Mmojo Server for testing with OpenClaw quickly.
- [920. Deploy OpenClaw](920-Deploy-OpenClaw.md) - You will install, configure, and test OpenClaw.
  - [921. Prepare WSL - OpenClaw](921-Prepare-WSL-OpenClaw.md) - You will create a WSL instance for OpenClaw.
  - [922. Install OpenClaw](922-Install-OpenClaw.md) - Install OpenClaw and perform Quick Configuration.
  - [923. Connect to Mmojo Server](923-Connect-to-Mmojo-Server.md) - Connect OpenClaw to Mmojo Server.
  - [924. Test OpenClaw](924-Test-OpenClaw.md) - Perform simple tests with OpenClaw.

**Get Started:** [901. Cleanup WSL Instances](901-Cleanup-WSL-Instances.md)

---
[MIT License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
