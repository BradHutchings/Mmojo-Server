## 03. Test Mmojo RPC Server
**THIS GUIDE IS A WORK IN PROGRESS.**
### About this Step
The Mmojo RPC Server lets you offload inference to another computer. You would use it to operate a cluser of Mmojo Server nodes acting as a single Mmojo Server. Mmojo RPC Server is the software the "slave hosts" in the cluster run. The "master host" runs Mmojo Server, and is configured to offload work to the "slave hosts".

You can read more about llama.cpp's RPC Server here:
- [llama.cpp RPC Server](https://github.com/ggml-org/llama.cpp/blob/master/tools/rpc/README.md)

Mmojo RPC Server puts the parameters in a `mmojo-rpc-server-args` file for easier deployments.

---
### Set up Mmojo Server on Another Host
Add this to the "master host's" `mmojo-server-args` file:
```
--rpc
["slave" hostname]:[port]
```

Be sure to substitute the actual hostname and port of the computer on which you're testing Mmojo RPC Server.

---
### Start Mmojo RPC Server
Run this command:
```
mm-rpc-server-start.sh
```

Hit `CTRL-C` to stop the debug run when you are finished testing your build.

Since your build is in your `$DEPLOY_DIR`, it's ready to be deployed with `rpc-go`. See next sub-step.

---
### Make Command Aliases
Run this command:
```
if ! grep -q "alias rpc-stop=" "$HOME/.zshrc"; then
cat << EOF >> $HOME/.zshrc

alias rpc-stop="mm-rpc-server-stop.sh"
alias rpc-go="mm-rpc-server-start.sh background"
alias rpc-debug="mm-rpc-server-start.sh"
alias rpc-running="mm-rpc-server-status.sh"

echo ""
echo "Useful Mmojo RPC Servercommand aliases:"
echo "- rpc-stop    --> mm-rpc-server-stop.sh"
echo "- rpc-go      --> mm-rpc-server-start.sh background  # Runs in background."
echo "- rpc-debug   --> mm-rpc-server-start.sh             # Runs in foreground with output."
echo "- rpc-running --> mm-rpc-server-status.sh            # Is Mmojo RPC Server running?"
echo ""
EOF
source $HOME/.bashrc
fi
```

---
### Proceed
- **Next:** [04. Package for Windows](04-Package-for-Windows.md)
- **Previous:** [02. Test Mmojo Server](02-Test-Mmojo-Server.md)
- **Up:** [Build Mmojo Server for Windows](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
