## 10. Launch from Taskbar
### About this Step
Let's test the workflow we enabled in the Autostart step. You will click the Mmojo Server icon in the Taskbar to launch it and close the window to stop it.

---
### Start Mmojo Server
<img width="142" height="111" alt="image" src="https://github.com/user-attachments/assets/a48ad2a3-bc64-460e-b3d7-a78507ecb83e" />

Click the MmojoServer WSL icon that you previously added to the Taskbar.

<img width="788" height="273" alt="image" src="https://github.com/user-attachments/assets/ed1fd90d-0093-4678-bb65-b762d94059b4" />

A Terminal window will open, connected to your Mmojo Server WSL instance. You'll see some useful command aliases for managing things, followed by a message about the Mmojo Server process being started or already running.

---
### Connect to Mmojo Server
Connect to Mmojo Server again in your browser:

- [Mmojo Complete](http://127.0.0.1:8080) &larr; Right-click, open in new tab.

---
### Tricks for Everyday Use
You're probably wondering how you're going to remember the commands so you can change your model. Here's how.

All three commands start with `mm-`. In fact, many commands you used in this setup start with `mm-`. These commands live in the `$HOME/mm-scripts` directory, and that directory is in your `$PATH`.

You can use these aliases you added to your `.bashrc` in the [07. Make Command Aliases](07-Make-Command-Aliases.md) step:
- `mm-stop`   --> `mm-mmojo-server-stop.sh`
- `mm-model`  --> `mm-model-choose.sh`
- `mm-go`     --> `mm-mmojo-server-start.sh background`  # Runs in background.
- `mm-debug`  --> `mm-mmojo-server-start.sh`             # Runs in foreground with output.
- `mm-status` --> `mm-mmojo-server-status.sh`            # Is Mmojo Server running?

Notice that you are reminded of these when you start a session with your MmojoServer WSL instance.

---
### Stop Mmojo Server
Stop Mmojo Server by closing all Terminal windows connected to it. Typically, that will be one window. WSL will shut it down soon after all sessions are closed.

You can verify that your MmojoServer instance is not running by opening a Terminal and listing available instances. Paste this into a PowerShell prompt:

```
wsl --list --verbose
```

<img width="422" height="122" alt="image" src="https://github.com/user-attachments/assets/13c55d36-ef9d-4882-9429-42e35c9dea07" />

The MmojoServer WSL instance should show stopped. If it is not, wait a few more moments and run that command again.

---
### Congratulations!
You did it. You installed Mmojo Server on your Windows PC or laptop, made it work, learned how to manage it, and practiced starting and stopping it!

<img width="300" height="300" alt="image" src="https://github.com/user-attachments/assets/0f9de046-7ae2-4000-82f6-e14490297c4e" />

Enjoy Mmojo Server for regular use! Also, enjoy a nice latte. You earned it!

---
### Proceed
- **Next:** [11. Port Forward to Mmojo Server](11-Port-Forward-to-Mmojo-Server.md) (Optional)
- **Previous:** [09. Change Model](09-Change-Model.md)
- **Up:** [Deploy Mmojo Server on Windows (WSL)](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
