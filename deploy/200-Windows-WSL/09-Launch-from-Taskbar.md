## 09. Launch from Taskbar
### About this Step
Let's test the workflow we enabled in the Autostart step. You will click the Mmojo Server icon in the Taskbar to launch it and close the window to stop it.

---
### Start Mmojo Server
<img width="142" height="111" alt="image" src="https://github.com/user-attachments/assets/a48ad2a3-bc64-460e-b3d7-a78507ecb83e" />

Click the MmojoServer WSL icon that you previously added to the Taskbar.

<img width="789" height="257" alt="image" src="https://github.com/user-attachments/assets/eee93dcc-44e1-4644-8b72-8335eb701af0" />

A Terminal window will open, connected to your Mmojo Server WSL instance. You'll see a message about the Mmojo Server process being started or already running, followed by some useful command aliases for managing things.

---
### Tricks for Everyday Use
You're probably wondering how you're going to remember the commands so you can change your model. Here's how.

All three commands start with `mm-`. In fact, many commands you used in this setup start with `mm-`. These commands live in the `$HOME/mm-scripts` directory, and that directory is in your `$PATH`.

You can use these aliases you added to your `.bashrc` in the Autostart step:
- `mm-stop`   --> `mm-stop-mmojo-server.sh`
- `mm-choose` --> `mm-choose-model.sh`
- `mm-start`  --> `mm-start-mmojo-server.sh background`  # Runs in background.
- `mm-debug`  --> `mm-start-mmojo-server.sh`             # Runs in foreground with output.

Notice that you are reminded of these when you start a session with your MmojoServer WSL instance.

---
### Proceed
- **Next:** [10. Port Forward to Mmojo Server](10-Port-Forward-to-Mmojo-Server.md) (Optional)
- **Previous:** [08. Change Model](08-Change-Model.md)
- **Up:** [Deploy Mmojo Server on Windows (WSL)](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
