## 06. Test Mmojo Server
### About this Step
In this step, you will choose a model and test Mmojo Server.

---
### Choose a Model
First, choose a model. I'd suggest choosing **Google Gemma 4B Instruct**. It will be soft-linked in your `$HOME/Mmojo-Server` directory.
```
mm-choose-model.sh
```

---
### Start Mmojo Server

Launch `mmojo-server`:
```
mm-start-mmojo-server.sh
```

This starts Mmojo Server in a debug mode with messages displayed on screen so you can see what it's doing.

If you get a message about an illegal instruction, it's because you installed a performant version of Mmojo Server. Your computer's CPU, sadly, does not support that version. Go back to the download step and try the alternative compatible version.

- [05. Download Mmojo Server](05-Download-Mmojo-Server.md)

---
### Connect to Mmojo Complete
Connect to Mmojo Complete from a browser:

[Mmojo Complete](http://127.0.0.1:8080) &larr; Right-click, open in new tab.

You should see the Mmojo Complete user interface:

<img width="543" height="400" alt="image" src="https://github.com/user-attachments/assets/31055741-4697-441e-a3e3-a191401a7e8c" />

---
### Stop Mmojo Server
Go back to the Terminal window and hit `CTRL-C` on your keyboard to stop Mmojo Server. You may need to hit it twice.

<img width="385" height="98" alt="image" src="https://github.com/user-attachments/assets/6ce39db5-85e7-44fc-ae1e-3b922c5785e5" />

You will see your command prompt.

---
### Proceed
- **Next:** [07. Autostart Mmojo Server](07-Autostart-Mmojo-Server.md)
- **Previous:** [05. Download Mmojo Server](05-Download-Mmojo-Server.md)
- **Up:** [Deploy Mmojo Server on Windows (WSL)](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
