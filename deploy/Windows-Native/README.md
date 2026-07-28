## Deploy Mmojo Server on Windows (Native)
### About this Guide
In this guide, you will setup a WSL environment on Windows and deploy Mmojo Server in it. This is the prefered way to run Mmojo Server on a Windows PC.

<!-- SPONSOR --> 
I offer paid assistance over Zoom if you need it:
* [Paid Assistance](/docs/Paid-Assistance.md)

-Brad<br/>
\--<br/>
Brad Hutchings<br/>
brad@Mmojo.net<br/><br/>
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
- [06. Test Mmojo Server](06-Test-Mmojo-Server.md) - Choose model, start Mmojo Server, stop Mmojo Server.
- [07. Make Command Aliases](07-Make-Command-Aliases.md) - Add useful command aliases to `.bashrc`.
- [08. Autostart Mmojo Server](08-Autostart-Mmojo-Server.md) - Choose model, start Mmojo Server, stop Mmojo Server.
- [09. Change Model](09-Change-Model.md) - Stop Mmojo Server, choose a new model, start Mmojo Server.
- [10. Launch from Taskbar](10-Launch-from-Taskbar.md) - Make sure Mmojo Server works for day to day use.
  <br/><br/>

**Get Started:** [01. Prerequisites](01-Prerequisites.md)

---
### Port Forward to Mmojo Server
If you want Mmojo Server to accept connections from other computers on your network, you can set that up:
- [11. Port Forward to Mmojo Server](11-Port-Forward-to-Mmojo-Server.md) - **Optional:** Set up port forwarding with nginx.

---
### Build Mmojo Server
You can also build Mmojo Server using my new instructions in the [Build section](/buildREADME.md).

Use this recipe:
- [01. Build Mmojo Server for Debian Linux](/build/debian/README.md)

Before building, please work through all of the deploy steps above.

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@Mmojo.net)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
