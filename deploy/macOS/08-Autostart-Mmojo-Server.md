## 08. Autostart Mmojo Server
**THIS GUIDE IS IN PROGRESS.**
### About this Step
In this short step, we're going to modify the mmojo user account so that it automatically starts Mmojo Server and has some useful command aliases for managing it. This will enable a workflow where you open a Terminal session with the mmojo account to launch it and close the Terminal window to stop it. 

---
### Autostart Mmojo Server
Run this command:
```
if ! grep -q "Starting Mmojo Server." "$HOME/.zshrc"; then
cat << EOF >> $HOME/.zshrc

echo "Starting Mmojo Server."
mm-go
echo ""
echo "To stop Mmojo Server, type the alias: << mm-stop >>."
echo ""
EOF
fi
```

---
### Test Autostart
???



Connect to Mmojo Server again in your browser to verify that Mmojo Server is running and available:

- [Mmojo Complete](http://127.0.0.1:8080) &larr; Right-click, open in new tab.

Leave the Terminal window open for as long as you want to run Mmojo Server. When you close it, Mmojo Server will stop automatically within a minute, probably sooner.

---
### Proceed
- **Next:** [09. Change Model](09-Change-Model.md)
- **Previous:** [07. Make Command Aliases](07-Make-Command-Aliases.md)
- **Up:** [Deploy Mmojo Server on macOS](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
