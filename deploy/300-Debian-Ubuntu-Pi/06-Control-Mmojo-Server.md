## 06. Control Mmojo Server
### About this Step
This step has controls for choosing a model, starting Mmojo Server, and stopping Mmojo Server.

---
### Choose a Model
First, choose a model. I'd suggest choosing **Google Gemma 4B Instruct**. It will be soft-linked in your `$HOME/mm-mmojo-server` directory.
```
mm-choose-model.sh
```

---
### Start Mmojo Server

Launch `mmojo-server`:
```
mm-start-mmojo-server.sh
```

Connect to Mmojo Complete from a browser:

[Mmojo Complete](http://127.0.0.1:8080) &larr; Right-click, open in new tab.

You should see the Mmojo Complete user interface:

<img width="543" height="400" alt="image" src="https://github.com/user-attachments/assets/31055741-4697-441e-a3e3-a191401a7e8c" />

---
### Stop Mmojo Server
`CTRL-C` (maybe twice) to stop `mmojo-server`.

---
### Proceed
- **Next:** [07. Autostart Mmojo Server](07-Autostart-Mmojo-Server.md)
- **Previous:** [05. Download Mmojo Server](05-Download-Mmojo-Server.md)
- **Up:** [Deploy Mmojo Server on Debian / Ubuntu / Raspberry Pi](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
