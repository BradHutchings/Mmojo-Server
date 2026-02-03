## 02. Cleanup WSL Instances

### About this Step
Windows Subsystem for Linux (WSL) lets you run a full Linux distribution directly on Windows. Let's cleanup your WSL environment to prepare for a fresh installation of Mmojo Server and OpenClaw. Skip this step if you're not starting from scratch.

Note for developer newbies: Windows cmd shell and PowerShell use a backslash `\` for file system paths. Linux shells use a forward slash `/` for paths and a backslash `\` for escaping characters like `$` in strings. I mostly use the Linux style slashes (`/`) in these instructions because they're for Linux.

---
### Delete your Existing `MmojoServer` and `OpenClaw` WSL Instances
If you have previous `MmojoServer` and/or `OpenClaw` WSL instances, let's delete them. We're going to start from scratch with new instances.

Open a **Terminal** (or **PowerShell**) window. Verify that your instances exist and are stopped:

```
wsl --list --verbose
```

Unregister ("delete") the instance:

```
wsl --unregister MmojoServer
wsl --unregister OpenClaw

```

If you previously pinned `MmojoServer` and/or `OpenClaw` to your **Taskbar**, unpin them. The existing pinned shortcuts will not launch the new instances you will create.


---
### Proceed
- **Next:** [10. Deploy Mmojo Server](10-Deploy-Mmojo-Server.md)
- **Previous:** [01. Prerequisites](01-Prerequisites.md)
- **Up:** [Deploy OpenClaw (WSL)](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
