## 08. Make Command Aliases
**THIS GUIDE IS IN PROGRESS.**
### About this Step
In this short step, we're going to create some alias commands in `.zshrc` to make working with Mmojo Server from the command line easier. 

---
### Make Command Aliases
Run this command:
```
if ! grep -q "alias mm-stop=" "$HOME/.bashrc"; then
cat << EOF >> $HOME/.bashrc

alias mm-stop="mm-mmojo-server-stop.sh"
alias mm-go="mm-mmojo-server-start.sh background"
alias mm-debug="mm-mmojo-server-start.sh"
alias mm-running="mm-mmojo-server-status.sh"
alias mm-model="mm-model-choose.sh"
alias mm-which="mm-model-which.sh"
alias mm-args="cat \$DELOY_DIR/\$_PACKAGE_MMOJO_SERVER_ARGS_FILE"
alias mm-args-edit="nano \$DELOY_DIR/\$_PACKAGE_MMOJO_SERVER_ARGS_FILE"

echo "Useful command aliases:"
echo "- mm-stop      --> mm-mmojo-server-stop.sh"
echo "- mm-go        --> mm-mmojo-server-start.sh background  # Runs in background."
echo "- mm-debug     --> mm-mmojo-server-start.sh             # Runs in foreground with output."
echo "- mm-running   --> mm-mmojo-server-status.sh            # Is Mmojo Server running?"
echo "- mm-model     --> mm-model-choose.sh"
echo "- mm-which     --> mm-model-which.sh"
echo "- mm-args      --> cat \$DELOY_DIR/\$_PACKAGE_MMOJO_SERVER_ARGS_FILE"
echo "- mm-args-edit --> nano \$DELOY_DIR/\$_PACKAGE_MMOJO_SERVER_ARGS_FILE"
echo ""
EOF
fi
source .bashrc
```

---
### Proceed
- **Next:** [09. Autostart Mmojo Server](09-Autostart-Mmojo-Server.md)
- **Previous:** [07. Test Mmojo Server](07-Test-Mmojo-Server.md)
- **Up:** [Deploy Mmojo Server on macOS](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
