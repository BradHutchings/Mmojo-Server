## 07. Make Command Aliases
### About this Step
In this short step, we're going to create some alias commands in `.bashrc` to make working with Mmojo Server from the command line easier. 

---
### Make Command Aliases
Run this command:
```
if ! grep -q "alias mm-stop=" "$HOME/.bashrc"; then
cat << EOF >> $HOME/.bashrc

alias mm-stop="mm-mmojo-server-stop.sh"
alias mm-model="mm-model-choose.sh"
alias mm-start="mm-mmojo-server-start.sh background"
alias mm-debug="mm-mmojo-server-start.sh"
alias mm-status="mm-mmojo-server-status.sh"

echo "Useful command aliases:"
echo "- mm-stop   --> mm-mmojo-server-stop.sh"
echo "- mm-model  --> mm-model-choose.sh"
echo "- mm-start  --> mm-mmojo-server-start.sh background  # Runs in background."
echo "- mm-debug  --> mm-mmojo-server-start.sh             # Runs in foreground with output."
echo "- mm-status --> mm-mmojo-server-status.sh            # Is Mmojo Server running?"
echo ""
EOF
source $HOME/.bashrc
fi
```

---
### Proceed
- **Next:** [08. Change Model](08-Change-Model.md)
- **Previous:** [06. Test Mmojo Server](06-Test-Mmojo-Server.md)
- **Up:** [Deploy Mmojo Server on Windows (WSL)](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
