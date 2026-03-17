## 09. Change Model
### About this Step
In this short step, we're going to stop Mmojo Server while keeping the WSL session open, choose a new model, then start Mmojo Sever.

---
### Check Which Model is Active
You can see which model is active with this command:
```
mm-model-which.sh
```

---
### Stop Mmojo Server
Run this command:
```
mm-stop
```

---
### Choose a Model
Choose a model. Try **Google-Gemma-270M-Instruct-v3-q8_0.gguf**. It will be soft-linked in your `$HOME/mm-mmojo-server` directory.
```
mm-model
```

---
### Start Mmojo Server

Start `mmojo-server`:
```
mm-start
```

Notice that `background` parameter. It can be anything. That tells Mmojo Server to run quietly as a background proess. If you'd like to see its startup and operational output, which can be helpful for tracking down problems, omit the parameter.

---
### Verify Model Change
You can see which model is active with this command:
```
mm-model-which.sh
```

---
### Connect and Verify Model Change in Mmojo Complete
Connect to Mmojo Server again in your browser:

- [Mmojo Complete](http://127.0.0.1:8080) &larr; Right-click, open in new tab.

<img width="313" height="64" alt="image" src="https://github.com/user-attachments/assets/f0bf286e-4a10-4bb4-a80b-ad707f2f9311" />

Click the Settings icon &mdash; lefmost icon top right &mdash;  to reveal the Setting panel, which shows the model your Mmojo Server is running.

<img width="422" height="151" alt="image" src="https://github.com/user-attachments/assets/c3b767c8-54a7-4c8d-93f0-7d542ef2f2a6" />

Click the Settings icon again to make the Settings panel disappear.

---
### Proceed
- **Next:** This is the last step in this section.
- **Previous:** [08. Autostart Mmojo Server](08-Autostart-Mmojo-Server.md)
- **Up:** [Deploy Mmojo Server on Debian / Ubuntu](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
