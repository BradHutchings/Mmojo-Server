## 03. Test Mmojo RPC Server
### About this Step
The Mmojo RPC Server lets you offload inference to another computer. You would use it to operate a cluser of Mmojo Server nodes acting as a single Mmojo Server. Mmojo RPC Server is the software the "slave hosts" in the cluster run. The "master host" runs Mmojo Server, and is configured to offload work to the "slave hosts".

---
### Set up Mmojo Server on Another Host
Add this to the "master host's" `mmojo-server-args file:
```
--rpc
["slave" hostname]:[port]
```

Be sure to substitute the actual hostname and port of the computer on which you're testing Mmojo RPC Server.

---
### WSL Needs a TCP Proxy in Windows
(about that here)

---
### Start Mmojo RPC Server
Run this command:
```
mm-mmojo-rpc-server-start.sh
```

(Need to implement that command / shortcut. mm-mmojo-rpc-server-start.sh.)

Hit `CTRL-C` to stop the debug run when you are finished testing your build.

Since your build is in your `$DEPLOY_DIR`, it's ready to be deployed with `mm-start-rpc`.

---
### Proceed
- **Next:** [04. Package Mmojo Server for Debian Linux](04-Package-for-Debian.md)
- **Previous:** [02. Test Mmojo Server](02-Test-Mmojo-Server.md)
- **Up:** [Build Mmojo Server for Debian Linux](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
