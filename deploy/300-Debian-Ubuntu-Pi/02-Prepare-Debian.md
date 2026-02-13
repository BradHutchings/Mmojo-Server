## 02. Prepare Debian
### About this Step
You will do some basic preparation for Mmojo Server deployment.

Note for developer newbies: Windows cmd shell and PowerShell use a backslash `\` for file system paths. Linux shells use a forward slash `/` for paths and a backslash `\` for escaping characters like `$` in strings. I mostly use the Linux style slashes in these instructions because they're for Linux.

<!--
---
### Create a mmojo Account (Optional)
(You should have a separate server or VM with fresh Debian or Ubuntu installation to run Mmojo Server.)

(Instructions to create a separate account if you're running on a shared server.)
-->
---
### Remove sudo Timeout
You will use the `sudo` command often, so let's make it not expire.
```
sudo visudo
```

Below the first `Defaults` section, paste this:
```
Defaults        env_reset,timestamp_timeout=-1
```
<img width="926" height="134" alt="image" src="https://github.com/user-attachments/assets/7793f414-3f52-4c38-93ee-801584e8b102" />

`Ctrl-X`, then `Y`, then `Enter` to save and exit.

---
### Run apt update and upgrade
Update linux and install `unzip`:
```
sudo apt update
sudo apt upgrade -y
sudo apt install unzip -y
echo "NOTE: apt update, upgrade, and install unzip finished."
```

---
### Create `mm-scripts` Directory
The `mm-scripts` Directory will contain useful scripts we will use to manage Mmojo Server.
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

---
### Clone the Mmojo Server Repository
The Mmojo Server Github repositort has scripts and tools for installing and building Mmojo Server.
```
export MMOJO_SERVER_DIR="$HOME/mm-mmojo-server-repo"
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

<details>
  <summary><b>Optional:</b> If you're Brad working on writing these instructions, switch to the work-in-progress branch.</summary>
  
```
mm-work-in-progress-branch.sh
mm-env
```
</details>

---
### Great  Job!
It's OK to start from scratch and do it often. There is a lot going on to deploy Mmojo Server. There are a lot of moving parts. When you get stuck, save your sanity and start over.

---
### Proceed
- **Next:** [03. Mount Mmojo Share](03-Mount-Mmojo-Share.md)
- **Previous:** [01. Prerequisites](01-Prerequisites.md)
- **Up:** [Deploy Mmojo Server on Debian / Ubuntu / Raspberry Pi](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
