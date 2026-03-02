## 02. Start Mmojo Server
### About this Step
In this step, you're going to identify the builds, sort through which one you should run, and start Mmojo Server.

---
### Identify the Builds
There are four Mmojo Servers.
- `mmojo-server-ape-performant` - macOS and Linux.
- `mmojo-server-ape-performant.exe` - Windows.
- `mmojo-server-ape-compatible` - macOS and Linux.
- `mmojo-server-ape-compatible.exe` - Windows.

If you're using a macOS or Linux computer, move the `.exe` builds to the Trash.  You don't need them for your computer.

If you're using a Windows computer, move the builds without the `.exe` extension to the Recycle Bin. You don't need them for your computer.

Now, you're left with a "performant" build and a "compatible" build. The performant build runs faster, but only on new enough computers. The compatible build runs on most computers, but not as fast.

**Note:** Raspberry Pi users, you will use the compatible build.

---
### Start Mmojo Server
Double-click the performant build. 

- **Windows Users:** You may see a security window. Click "More info", then scroll right and click 

  <img width="300" xxheight="496" alt="image" src="https://github.com/user-attachments/assets/967bda70-b843-47d5-b65a-ccad09ace910" />
  <img width="300" xxheight="309" alt="image" src="https://github.com/user-attachments/assets/40d00756-f3bf-4948-b8a0-243a8a9cdf4c" />

- **Mac Users:** You may be asked to install "Developer Tools" before the terminal window appears. Do that.

  <img width="400" xxheight="291" alt="image" src="https://github.com/user-attachments/assets/23cffe50-ef0d-4dff-9b49-21e2768c8cf4" />

- **Linux users:** If you are running GNOME Files as your desktop, you should open a Terminal for the directory and run Mmojo Server from the command line. Otherwise, it will launch as a background process.

A terminal window will open and show what Mmojo Server is doing:

<img width="803" height="640" alt="image" src="https://github.com/user-attachments/assets/ed2347fa-3700-43da-bbd7-8857fe0133e6" />

If the performant build won't run, runs and quits immediately, or complains in the Terminal window about an "illegal instruction", you need to run the compatible build. Double-click the compatible build.

---
### Throw the Unneeded Build Away
You're running either the performant build or the compatible build. Throw the other one away. You won't need it on your computer.

---
### Proceed
- **Next:** [03. Connect to Mmojo Server](03-Connect-to-Mmojo-Server.md)
- **Previous:** [01. Download Mmojo Server and Model](01-Download-Mmojo-Server.md)
- **Up:** [Deploy Mmojo Server on All Supported Platforms](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
