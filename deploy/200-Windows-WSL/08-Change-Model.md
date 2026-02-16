## 08. Change Model
### About this Step
In this short step, we're going to stop Mmojo Server while keeping the WSL session open, choose a new model, then start Mmojo Sever.

---
### Stop Mmojo Server
<img width="301" height="31" alt="image" src="https://github.com/user-attachments/assets/6941f4e7-9f69-4d00-b6fc-ab03ebaeccf3" />

You should still see the `(MmojoServer)` prompt in your Terminal window.

Run this command:
```
mm-mmojo-server-stop.sh
```

---
### Choose a Model
Choose a model. Try **Google-Gemma-270M-Instruct-v3-q8_0.gguf**. It will be soft-linked in your `$HOME/mm-mmojo-server` directory.
```
mm-model-choose.sh
```

---
### Start Mmojo Server

Start `mmojo-server`:
```
mm-mmojo-server-start.sh background
```

Notice that `background` parameter. It can be anything. That tells Mmojo Server to run quietly as a background proess. If you'd like to see its startup and operational output, which can be helpful for tracking down problems, omit the parameter.

---
### Connect and Verify Model Change
Connect to Mmojo Server again in your browser:

- [Mmojo Complete](http://127.0.0.1:8080) &larr; Right-click, open in new tab.

<img width="313" height="64" alt="image" src="https://github.com/user-attachments/assets/f0bf286e-4a10-4bb4-a80b-ad707f2f9311" />

Click the Settings icon &mdash; lefmost icon top right &mdash;  to reveal the Setting panel, which shows the model your Mmojo Server is running.

<img width="422" height="151" alt="image" src="https://github.com/user-attachments/assets/c3b767c8-54a7-4c8d-93f0-7d542ef2f2a6" />

Click the Setting icon again to make the Settings panel disappear.

---
### Power Off Mmojo Server
You've completed all of the necessary setup and learned the important tricks! Let's powrer off the Mmojo Server WSL instance:
```
sudo poweroff
```

You'll be prompted for your `sudo` password:
```
admin123!
```

<img width="434" height="66" alt="image" src="https://github.com/user-attachments/assets/e42b8af8-cafb-45ee-8e00-06aa8e5626f5" />

You will see your PowerShell prompt.


---
### Proceed
- **Next:** [09. Launch from Taskbar](09-Launch-from-Taskbar.md)
- **Previous:** [07. Autostart Mmojo Server](07-Autostart-Mmojo-Server.md)
- **Up:** [Deploy Mmojo Server on Windows (WSL)](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
