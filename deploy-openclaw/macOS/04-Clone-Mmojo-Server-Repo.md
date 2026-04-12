## 04. Clone Mmojo Server Repo
**THIS GUIDE IS IN PROGRESS.**
### About this Step
You will create an `oc-scripts` directory, clone the Mmojo Server repo to the `mm-repo` directory, and start setting up your bash environment for deploying Mmojo Server.

---
### Create `oc-scripts` Directory
The `oc-scripts` Directory will contain useful scripts we will use to manage Mmojo Server.
```
export HOME_OC_SCRIPTS="$HOME/oc-scripts"
TILDE_OC_SCRIPTS="~/oc-scripts"
mkdir -p $HOME_OC_SCRIPTS

if [[ "${PATH}" != *"${HOME_OC_SCRIPTS}"* ]] && [[ "${PATH}" != *"${TILDE_OC_SCRIPTS}"* ]]; then
cat << EOF >> $HOME/.bashrc
export PATH="\$PATH:$HOME_OC_SCRIPTS"
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
- **Next:** [05. Mount Mmojo Share](05-Mount-Mmojo-Share.md)
- **Previous:** [03. Prepare macOS OpenClaw](03-Prepare-macOS-OpenClaw.md)
- **Up:** [Deploy OpenClaw on macOS](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
