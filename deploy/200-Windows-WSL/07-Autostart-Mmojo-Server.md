## 07. Autostart Mmojo Server
### About this Step
In this short step, we're going to modify the Mmojo Server WSL instance so that it automatically starts Mmojo Server and has some useful command aliases for managing it. This will enable a workflow where you click the Mmojo Server icon in the Taskbar to launch it and close the window to stop it. 

---
### Autostart Mmojo Server
Run this command:
```
if ! grep -q "mm-start-mmojo-server.sh" "$HOME/.bashrc"; then
cat << EOF >> $HOME/.bashrc

alias mm-stop="mm-stop-mmojo-server.sh"
alias mm-model="mm-model-choose.sh"
alias mm-start="mm-start-mmojo-server.sh background"
alias mm-debug="mm-start-mmojo-server.sh"

echo "Starting Mmojo Server."
mm-start
echo ""
echo "Close all MmojoServer WSL windows to stop Mmojo Server."
echo "Or, type the alias: << mm-stop >>."
echo ""
echo "Useful command aliases:"
echo "- mm-stop  --> mm-stop-mmojo-server.sh"
echo "- mm-model --> mm-model-choose.sh"
echo "- mm-start --> mm-start-mmojo-server.sh background  # Runs in background."
echo "- mm-debug --> mm-start-mmojo-server.sh             # Runs in foreground with output."
echo ""
EOF
fi
```

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

The MmojoServer WSL instance should show stopped. If it is not, wait a few more moments and run that command again.

Now, let's start your MmojoServer WSL instance and connect to it again:

```
wsl -d "MmojoServer"
```

<img width="787" height="258" alt="image" src="https://github.com/user-attachments/assets/d6bb2336-b5aa-4666-b864-7f0263daae4d" />

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
