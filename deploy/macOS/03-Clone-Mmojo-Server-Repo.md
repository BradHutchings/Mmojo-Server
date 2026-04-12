## 03. Clone Mmojo Server Repo
**THIS GUIDE IS IN PROGRESS.**
### About this Step
You will create an `mm-scripts` directory, clone the Mmojo Server repo to the `mm-repo` directory, and start setting up your bash environment for deploying Mmojo Server.

---
### Create `mm-scripts` Directory
The `mm-scripts` Directory will contain useful scripts we will use to manage Mmojo Server.
```
export HOME_SCRIPTS="$HOME/mm-scripts"
TILDE_SCRIPTS="~/mm-scripts"
mkdir -p $HOME_SCRIPTS

if [[ "${PATH}" != *"${HOME_SCRIPTS}"* ]] && [[ "${PATH}" != *"${TILDE_SCRIPTS}"* ]]; then
cat << EOF >> $HOME/.bashrc
export PATH="$HOME_SCRIPTS:\$PATH"
EOF
fi

source $HOME/.bashrc
echo $PATH
```

---
### Clone the Mmojo Server Repository
The Mmojo Server Github repositort has scripts and tools for installing and building Mmojo Server.
```
export REPO_DIR="$HOME/mm-repo"
export REPO_DIR_SCRIPTS="$REPO_DIR/scripts"
export MMOJO_SED="/usr/local/gsed"
cd $HOME
if [ "$REPO_DIR" ]; then
  rm -r -f $REPO_DIR
fi
mkdir -p $REPO_DIR
git clone https://github.com/BradHutchings/mmojo-server.git $REPO_DIR
source $REPO_DIR_SCRIPTS/mm-environment-variables.sh
/usr/local/bin/bash $REPO_DIR_SCRIPTS/mm-repo-update-local.sh
/usr/local/bin/bash $REPO_DIR_SCRIPTS/mm-repo-copy-scripts.sh
if ! grep -q "mm-env=" "$HOME/.bashrc"; then
cat << EOF1 >> $HOME/.bashrc
alias mm-env="source mm-environment-variables.sh"
mm-env
EOF1
source $HOME/.bashrc
fi
```

<details>
  <summary><b>Optional:</b> If you're Brad working on writing these instructions, switch to the work-in-progress branch.</summary>
  
```
mm-repo-branch-work-in-progress.sh
mm-env
```
</details>


---
### Proceed
- **Next:** [04. Mount Mmojo Share](04-Mount-Mmojo-Share.md)
- **Previous:** [02. Prepare mmojo-server Account](02-Prepare-mmojo-server-Account.md)
- **Up:** [Deploy Mmojo Server on macOS](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
