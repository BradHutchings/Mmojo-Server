## 08. Change Model
### About this Step
In this short step, we're going to stop Mmojo Server while keeping the WSL session open, choose a new model, then start Mmojo Sever.

---
### Stop Mmojo Server
Run this command:
```
mm-stop-mmojo-server.sh
```

---
### Choose a Model
Choose a model. It will be soft-linked in your `$HOME/mm-mmojo-server` directory.
```
mm-choose-model.sh
```

---
### Start Mmojo Server

Start `mmojo-server`:
```
mm-start-mmojo-server.sh background
```

---
### Proceed
- **Next:** [09. Port Forward to Mmojo Server](09-Port-Forward-to-Mmojo-Server.md) (Optional)
- **Previous:** [07. Autostart Mmojo Server](07-Autostart-Mmojo-Server.md)
- **Up:** [Deploy Mmojo Server on Windows (WSL)](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
