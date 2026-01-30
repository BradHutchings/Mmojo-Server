## 903. Build Mmojo Server

### About this Step
This will be replaced with downloading the right Mmojo Server binary and .gguf model from Hugging Face. But since I don't know what it is as I write this guide, I'm offering a roadmap to quickly getting a Mmojo Server running from code.

---
### Scripts, Repo, Dependencies

Create the `mm-scripts` directory:
```
export HOME_SCRIPTS="$HOME/mm-scripts"
TILDE_SCRIPTS="~/mm-scripts"
mkdir -p $HOME_SCRIPTS

if [[ "${PATH}" != *"${HOME_SCRIPTS}"* ]] && [[ "${PATH}" != *"${TILDE_SCRIPTS}"* ]]; then
cat << EOF >> $HOME/.bashrc
export PATH="\$PATH:$HOME_SCRIPTS"
EOF
fi

source $HOME/.bashrc
echo $PATH
```

Clone Mmojo Server Repo:
```
export MMOJO_SERVER_DIR="$HOME/200-mmojo-server"
export MMOJO_SERVER_SCRIPTS="$MMOJO_SERVER_DIR/scripts"
cd $HOME
if [ "$MMOJO_SERVER_DIR" ]; then
  rm -r -f $MMOJO_SERVER_DIR
fi
mkdir -p $MMOJO_SERVER_DIR
git clone https://github.com/BradHutchings/mmojo-server.git $MMOJO_SERVER_DIR
. $MMOJO_SERVER_SCRIPTS/mm-environment-variables.sh
. $MMOJO_SERVER_SCRIPTS/mm-update-local-mmojo-server-repo.sh
if ! grep -q "mm-env=" "$HOME/.bashrc"; then
cat << EOF1 >> $HOME/.bashrc
alias mm-env=". mm-environment-variables.sh"
mm-env
EOF1
source $HOME/.bashrc
fi
```

Install dependencies:
```
$MMOJO_SERVER_SCRIPTS/207-Install-Dependencies.sh
```

---
### Open These Steps in New Tabs
Right-click each of these steps in order, and open in new tabs:
- [401. Download Models](401-Download-Models.md) - Download popular `.gguf` models from Hugging Face.
- [501. Prepare to Build](501-Prepare-to-Build.md) - Clone llama.cpp repo, fix some things, and copy some things.
- [502. Prepare to Test](502-Prepare-to-Test.md) - Set some environment variables to customize test runs.
- [513. Platform (Native)](513-Platform-Native.md) - Build `mmojo-server` highly optimized for the CPU of the build environment platform.<br/><br/>

---
### Run Steps in Order
Go to your `MmojoServer` WSL terminal.

Proceed from left to right and run the steps in each tab. This will get you a native platform build running in the `MmojoServer` WSL instance. You can connect to it from a browser:

[Mmojo Complete](http://127.0.0.1:8080) &larr; Right-click, open in new tab.

---
### Proceed
- **Next:** [904. Install Moltbot](904-Install-Moltbot.md)
- **Previous:** [902. Prepare WSL - Moltbot](902-Prepare-WSL-Moltbot.md)
- **Up:** [900. Deploy Moltbot](900-Deploy-Moltbot.md)

---
[MIT License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
