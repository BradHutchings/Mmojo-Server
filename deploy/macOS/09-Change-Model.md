## 09. Change Model
**THIS GUIDE IS IN PROGRESS.**
### About this Step
In this short step, we're going to stop Mmojo Server while keeping the Terminal session open, choose a new model, then start Mmojo Sever.

---
### Check Which Model is Active
You can see which model is active with this command:
```
mm-model-which.sh
```

---
### Stop Mmojo Server
<img width="301" height="31" alt="image" src="https://github.com/user-attachments/assets/6941f4e7-9f69-4d00-b6fc-ab03ebaeccf3" />

You should still see the `(MmojoServer)` prompt in your Terminal window.

**NOTE: NEED TO SET UP THAT PROMPT AND CURRENT DIRECTORY in 02-PREPARE.**

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

Start `mmojo-server` in the background:
```
mm-go
```

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
### Sign Out of mmojo User Account
???

```
exit
```

<img width="434" height="66" alt="image" src="https://github.com/user-attachments/assets/e42b8af8-cafb-45ee-8e00-06aa8e5626f5" />

You will see your admin account prompt.


---
### Proceed
- **Next:** [10. Port Forward to Mmojo Server](10-Port-Forward-to-Mmojo-Server.md) (Optional)
- **Previous:** [08. Autostart Mmojo Server](08-Autostart-Mmojo-Server.md)
- **Up:** [Deploy Mmojo Server on macOS](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
