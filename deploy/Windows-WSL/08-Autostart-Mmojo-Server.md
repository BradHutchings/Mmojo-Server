## 08. Autostart Mmojo Server
### About this Step
In this short step, we're going to modify the Mmojo Server WSL instance so that it automatically starts Mmojo Server and has some useful command aliases for managing it. This will enable a workflow where you click the Mmojo Server icon in the Taskbar to launch it and close the window to stop it. 

---
### Autostart Mmojo Server
Run this command:
```
if ! grep -q "Starting Mmojo Server." "$HOME/.bashrc"; then
cat << EOF >> $HOME/.bashrc

echo "Starting Mmojo Server."
mm-go
echo ""
echo "Close all MmojoServer WSL windows to stop Mmojo Server."
echo "Or, type the alias: << mm-stop >>."
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
<img width="788" height="273" alt="image" src="https://github.com/user-attachments/assets/c1b2d850-d736-40bf-93c1-8a6220f2441e" />

You will see a message about Mmojo Server being started or already running. It's fine if it says it's already running. WSL made a previous connection to your instance before the one displayed in the Terminal window.

Connect to Mmojo Server again in your browser to verify that Mmojo Server is running and available:

- [Mmojo Complete](http://127.0.0.1:8080) &larr; Right-click, open in new tab.

Leave the WSL window open for as long as you want to run Mmojo Server. When you close it, Mmojo Server will stop automatically within a minute, probably sooner.

---
### Proceed
- **Next:** [09. Change Model](09-Change-Model.md)
- **Previous:** [07. Make Command Aliases](07-Make-Command-Aliases.md)
- **Up:** [Deploy Mmojo Server on Windows (WSL)](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@Mmojo.net)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
