## 02. Cleanup WSL Instances

### About this Step
Windows Subsystem for Linux (WSL) lets you run a full Linux distribution directly on Windows. Let's cleanup your WSL environment to prepare for a fresh installation of Mmojo Server. Skip this step if you're not starting from scratch.

Note for developer newbies: Windows cmd shell and PowerShell use a backslash `\` for file system paths. Linux shells use a forward slash `/` for paths and a backslash `\` for escaping characters like `$` in strings. I mostly use the Linux style slashes (`/`) in these instructions because they're for Linux.

---
### Delete your Existing `MmojoServer` WSL Instances
If you have previous `MmojoServer` WSL instances, let's delete them. We're going to start from scratch with new instances.

Open a **Terminal** (or **PowerShell**) window. Verify that your instances exist and are stopped:

```
wsl --list --verbose
```

Unregister ("delete") the instance:

```
wsl --unregister MmojoServer

```

If you previously pinned `MmojoServer` to your **Taskbar**, unpin it. The existing pinned shortcut will not launch the new instance you will create.


---
### Proceed
- **Next:** [10. Deploy Mmojo Server](10-Deploy-Mmojo-Server.md)
- **Previous:** [01. Prerequisites](01-Prerequisites.md)
- **Up:** [Deploy Mmojo Server on Windows (WSL)](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
