## 16. Run Mmojo Server

### About this Step
Now that you have Mmojo Server installed in the `$HOME/Mmojo-Server` directory, you can run it.

---
### Launch mmojo-server

Launch `mmojo-server`:
```
$RUN_DIR/$PACKAGE_MMOJO_SERVER_FILE 
```

Connect to Mmojo Complete from a browser:

[Mmojo Complete](http://127.0.0.1:8080) &larr; Right-click, open in new tab.

You should see the Mmojo Complete user interface:

<img width="543" height="400" alt="image" src="https://github.com/user-attachments/assets/31055741-4697-441e-a3e3-a191401a7e8c" />

---
### Stop Mmojo Server, Exit WSL Instance
Due to some weirdness with WSL when moving instances to other drives, you should stop Mmojo Server and exit its WSL instance. You will be moving the WSL instance for OpenClaw to your second drive, and WSL won't do that if *any* WSL instance is running.

There are two ways you can do this:
1. **The easy way:**

   Close the WSL window where Mmojo Server is running. WSL will notice you have no sessions open and shut down the instance.
   
2. **The hard but maybe better way**:

   `CTRL-C` (maybe twice) to stop `mmojo-server`. Then leave the connection to the WSL instance:
   ```
   exit
   ```

---
### Proceed
- **Next:** [20. Deploy OpenClaw](20-Deploy-OpenClaw.md)
- **Previous:** [15. Build Mmojo Server](15-Build-Mmojo-Server.md)
- **Up:** [Deploy OpenClaw (WSL)](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
