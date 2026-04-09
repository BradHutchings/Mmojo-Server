## Deploy Mmojo Server on macOS
**THIS GUIDE IS IN PROGRESS.**
### About this Guide
In this guide, you will deploy Mmojo Server on macOS. Your Mmojo Server will take advantage of the GPU cores inside your Mac's M-series CPU.

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
### Deploy Mmojo Server
Here are the deployment steps:
- [01. Prerequisites](01-Prerequisites.md) &mdash; What you need to deploy Mmojo Server on macOS.  
- [02. Prepare mmojo-server Account](02-Prepare-mmojo-server-Account.md) &mdash; Create a `mmojo-server` user account for Mmojo Server.
- [03. Clone Mmojo Server Repo](03-Clone-Mmojo-Server-Repo.md) &mdash; Clone the Mmojo Server Repo, get scripts working.
- [04. Mount Mmojo Share](04-Mount-Mmojo-Share.md) &mdash; If you have a Mmojo Share, mount it.
- [05. Download Models](05-Download-Models.md) &mdash; Download models for use with Mmojo Server from Hugging Face, or copy from your Mmojo Share.
- [06. Download Mmojo Server](06-Download-Mmojo-Server.md) &mdash; Download Mmojo Server from Hugging Face and install it.
- [07. Test Mmojo Server](07-Test-Mmojo-Server.md) &mdash; Choose model, start Mmojo Server, stop Mmojo Server.
- [08. Make Command Aliases](08-Make-Command-Aliases.md) &mdash; Add useful command aliases to `.bashrc`.
- [09. Autostart Mmojo Server](09-Autostart-Mmojo-Server.md) &mdash; Choose model, start Mmojo Server, stop Mmojo Server.
- [10. Change Model](10-Change-Model.md) &mdash; Stop Mmojo Server, choose a new model, start Mmojo Server.
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
- [01. Build Mmojo Server for macOS](/build/macos/README.md)

Before building, please work through all of the deploy steps above.

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
