## Deploy Mmojo Server on Debian / Ubuntu
### About this Guide
In this guide, you will deploy Mmojo Server on Debian / Ubuntu Linux. I have a separate guide for deploying on Raspberry Pi:
- [Deploy Mmojo Server on Raspberry Pi](../Raspberry-Pi/README.md)

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
- [01. Prerequisites](01-Prerequisites.md) - What you need to deploy Mmojo Server in a WSL instance.  
- [02. Prepare Debian](02-Prepare-Debian.md) - Prepare your Debian host for Mmojo Server.
- [03. Mount Mmojo Share](03-Mount-Mmojo-Share.md) - If you have a Mmojo Share, mount it.
- [04. Download Models](04-Download-Models.md) - Download models for use with Mmojo Server from Hugging Face, or copy from your Mmojo Share.
- [05. Download Mmojo Server](05-Download-Mmojo-Server.md) - Download Mmojo Server from Hugging Face and install it.
- [06. Test Mmojo Server](06-Test-Mmojo-Server.md) - Choose model, start Mmojo Server, stop Mmojo Server.
- [07. Make Command Aliases](07-Make-Command-Aliases.md) - Add useful command aliases to `.bashrc`.
- [08. Autostart Mmojo Server](08-Autostart-Mmojo-Server.md) - Choose model, start Mmojo Server, stop Mmojo Server.
- [09. Change Model](09-Change-Model.md) - Stop Mmojo Server, choose a new model, start Mmojo Server.

**Get Started:** [01. Prerequisites](01-Prerequisites.md)

---
### Build Mmojo Server
You can also build Mmojo Server using my new instructions in the [Build section](/buildREADME.md).

Use this recipe:
- [Build Mmojo Server for Debian Linux](/build/debian/README.md)

Before building, please work through all of the deploy steps above.

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
