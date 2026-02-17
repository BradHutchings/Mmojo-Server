## 08. Autostart Mmojo Server
### About this Step
**NEEDS TO BE UPDATED TO USE CRON, START AT STARTUP, STRIP OUT WSL STUFF.**

In this short step, we're going to modify the Mmojo Server WSL instance so that it automatically starts Mmojo Server. This will enable a workflow where you click the Mmojo Server icon in the Taskbar to launch it, and close to window to stop it. This is easier than digging for the `mm-mmojo-server-start.sh` command and typing or pasting it in every time you want Mmojo Server running.

---
### Autostart Mmojo Server
Run this command:
```
if ! grep -q "Starting Mmojo Server." "$HOME/.bashrc"; then
cat << EOF >> $HOME/.bashrc

echo "Starting Mmojo Server."
mm-start
echo ""
echo "To stop Mmojo Server, type the alias: << mm-stop >>."
echo ""
EOF
fi
```

Now, close your Mmojo Server WSL window, wait a few moments, then click the Mmojo Server icon in your Taskbar to see autostart in action.

---
### Bookmark Mmojo Complete
While you're setting things up, bookmark Mmojo Complete in your web browser.

[Mmojo Complete](http://127.0.0.1:8080) &larr; Right-click, open in new tab.

I told you this was a short step!

---
### Proceed
- **Next:** [09. Change Model](09-Change-Model.md)
- **Previous:** [07. Make Command Aliases](07-Make-Command-Aliases.md)
- **Up:** [Deploy Mmojo Server on Debian / Ubuntu / Raspberry Pi](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
