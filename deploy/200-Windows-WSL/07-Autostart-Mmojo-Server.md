## 07. Autostart Mmojo Server
### About this Step
In this short step, we're going to modify the Mmojo Server WSL instance so that it automatically starts Mmojo Server. This will enable a workflow where you click the Mmojo Server icon in the Taskbar to launch it and close to window to stop it. 

---
### Autostart Mmojo Server
Run this command:
```
if ! grep -q "mm-start-mmojo-server.sh" "$HOME/.bashrc"; then
cat << EOF >> $HOME/.bashrc

alias mm-stop="mm-stop-mmojo-server.sh"
alias mm-choose="mm-choose-model.sh"
alias mm-start="mm-start-mmojo-server.sh background"
alias mm-debug="mm-start-mmojo-server.sh"

echo "Starting Mmojo Server."
mm-start-mmojo-server.sh background
echo "Close all MmojoServer WSL windows to stop Mmojo Server."
echo "Or, type the command: << mm-stop-mmojo-server.sh >>. (No << >>.)"
echo ""
echo "Useful command aliases:"
echo "- mm-stop   --> mm-stop-mmojo-server.sh"
echo "- mm-choose --> mm-choose-model.sh"
echo "- mm-start  --> mm-start-mmojo-server.sh background  # Runs in background."
echo "- mm-debug  --> mm-start-mmojo-server.sh             # Runs in foreground with output."
echo ""
EOF
fi
```

Now, close your Mmojo Server WSL window, wait a few moments, then click the Mmojo Server icon in your Taskbar to see autostart in action.

---
### Bookmark Mmojo Complete
While you're setting things up, bookmark Mmojo Complete in your web browser.

- [Mmojo Complete](http://127.0.0.1:8080) &larr; Right-click, open in new tab.

I told you this was a short step!

---
### Test Autostart
Poweroff the WSL instance:
```
sudo poweroff
```

<img width="434" height="66" alt="image" src="https://github.com/user-attachments/assets/e42b8af8-cafb-45ee-8e00-06aa8e5626f5" />

You will see your PowerShell prompt. Wait a few moments, then check that your WSL instance is not running.

```
wsl --list --verbose
```

<img width="422" height="122" alt="image" src="https://github.com/user-attachments/assets/13c55d36-ef9d-4882-9429-42e35c9dea07" />

MmojoServer WSL instance should show stopped. If it is not, wait a few more moments and run that command again.

Now, let's start your MmojoServer WSL instance and connect to it again:

```
wsl -d "MmojoServer"
```

<img width="597" height="121" alt="image" src="https://github.com/user-attachments/assets/294b776b-2dc7-4ae7-a60c-4c47d7daa101" />

You will see a message about Mmojo Server being started or already running. It's fine if it says it's already running. WSL made a previous connection to your instance before the one displayed in the Terminal window.

Connect to Mmojo Server again in your browser to verify that Mmojo Server is running and available:

- [Mmojo Complete](http://127.0.0.1:8080) &larr; Right-click, open in new tab.

Leave the WSL window open for as long as you want to run Mmojo Server. When you close it, Mmojo Server will stop automatically within a minute, probably sooner.

---
### Proceed
- **Next:** [08. Change Model](08-Change-Model.md)
- **Previous:** [06. Test Mmojo Server](06-Test-Mmojo-Server.md)
- **Up:** [Deploy Mmojo Server on Windows (WSL)](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
