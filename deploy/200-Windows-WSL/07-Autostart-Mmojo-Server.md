## 07. Autostart Mmojo Server
### About this Step
In this short step, we're going to modify the Mmojo Server WSL instance so that it automatically starts Mmojo Server. This will enable a workflow where you click the Mmojo Server icon in the Taskbar to launch it, and close to window to stop it. This is easier than digging for the `mm-start-mmojo-server.sh` command and typing or pasting it in every time you want Mmojo Server running.

---
### Autostart Mmojo Server
Run this command:
```
if ! grep -q "mm-start-mmojo-server.sh" "$HOME/.bashrc"; then
cat << EOF >> $HOME/.bashrc

echo "Starting Mmojo Server."
mm-start-mmojo-server.sh background
echo "Close all MmojoServer WSL windows to stop Mmojo Server."
echo "Or, type the command: << mm-stop-mmojo-server.sh >>. (No << >>.)"
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
### Test Autostart
Poweroff the WSL instance:
```
sudo poweroff
```

<img width="158" height="97" alt="image" src="https://github.com/user-attachments/assets/9770555c-7f9c-408d-ab99-e209c0ad2db1" />

Wait a minute or so. Then launch the MmojoServer WSL instance from your Taskbar.

(picture of Mmojo Server startup message.)

You will see a message about Mmojo Server being started or already running.

Leave the WSL window open for as long as you want to run Mmojo Server. When you close it, Mmojo Server will stop automatically within a minute, probably sooner.

---
### Proceed
- **Next:** This is the last step in this section.
- **Previous:** [06. Test Mmojo Server](06-Test-Mmojo-Server.md)
- **Up:** [Deploy Mmojo Server on Windows (WSL)](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
