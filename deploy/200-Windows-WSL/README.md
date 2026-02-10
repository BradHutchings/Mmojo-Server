## Deploy Mmojo Server on Windows (WSL)
### About this Section (200-Windows-WSL)
In this section, you will setup a WSL environment on Windows and deploy Mmojo Server in it. This is the prefered way to run Mmojo Server on a Windows PC.

<!-- SPONSOR --> 
If you need assistance via Zoom call and screen sharing, I offer a one-hour hands-on session, for (US) $100. It can be scheduled during extended west coast business hours. You will be working with me, the guy who made this thing work. [Email me if interested](mailto:brad@BradHutchings.com?subject=Mmojo%20Server%20Install%20Help).

-Brad<br/>
\--<br/>
Brad Hutchings<br/>
brad@BradHutchings.com<br/><br/>
<!-- END SPONSOR -->

**Get Started:** [01. Prerequisites](01-Prerequisites.md)

---
### Deploy Mmojo Server
Here are the deployment steps:
- [01. Prerequisites](01-Prerequisites.md) - What you need to deploy Mmojo Server in a WSL instance.  
- [02. Prepare WSL - Mmojo Server](02-Prepare-WSL-Mmojo-Server.md) - Create a WSL instance for Mmojo Server.
- [03. Mount Mmojo Share](03-Mount-Mmojo-Share.md) - If you have a Mmojo Share, mount it.
- [04. Download Models](04-Download-Models.md) - Download models for use with Mmojo Server from Hugging Face, or copy from your Mmojo Share.
- [05. Download Mmojo Server](05-Download-Mmojo-Server.md) - Download Mmojo Server from Hugging Face and install it.
- [06. Control Mmojo Server](06-Control-Mmojo-Server.md) - Choose model, start Mmojo Server, stop Mmojo Server.
- [07. Autostart Mmojo Server](07-Autostart-Mmojo-Server.md) - Choose model, start Mmojo Server, stop Mmojo Server.
  <br/><br/>

**Get Started:** [01. Prerequisites](01-Prerequisites.md)

---
### Port Forward to Mmojo Server
If you want Mmojo Server to accept connections from other computers on your network, you can set that up:
- [08. Port Forward to Mmojo Server](08-Port-Forward-to-Mmojo-Server.md) - **Optional:** Set up port forwarding with nginx.


---
### Build Mmojo Server
You can also build Mmojo Server using abbreviated instructions. Do this after you have downloaded models.
- [11. Build Mmojo Server](11-Build-Mmojo-Server.md) - **Optional:** Build a Mmojo Server quickly.
  <br/><br/>

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
