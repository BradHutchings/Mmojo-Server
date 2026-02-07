## 204. Clone Mmojo Server Repo
### About this Step
Let's get started by cloning the Mmojo Server repository from Github, so we have scripts available to do all the documented steps.

As we work, we will update our local copy of the repo at the start of each section.

**Where:** Perform this step in both your x86_64 and your aarch64 (arm64) build environments.

---
### Clone the Mmojo Server Repo

Clone the Mmojo Server repo:
```
export MMOJO_SERVER_DIR="$HOME/mm-mmojo-server"
export MMOJO_SERVER_SCRIPTS="$MMOJO_SERVER_DIR/scripts"
cd $HOME
if [ "$MMOJO_SERVER_DIR" ]; then
  rm -r -f $MMOJO_SERVER_DIR
fi
mkdir -p $MMOJO_SERVER_DIR
git clone https://github.com/BradHutchings/mmojo-server.git $MMOJO_SERVER_DIR

# mm-update-local-mmojo-server-repo.sh uses these variables, so set them first.
. $MMOJO_SERVER_SCRIPTS/mm-environment-variables.sh

# mm-update-local-mmojo-server-repo.sh copies mm- scripts to $HOME/mm-scripts
. $MMOJO_SERVER_SCRIPTS/mm-update-local-mmojo-server-repo.sh

if ! grep -q "mm-env=" "$HOME/.bashrc"; then
cat << EOF1 >> $HOME/.bashrc
alias mm-env=". mm-environment-variables.sh"
mm-env
EOF1
source $HOME/.bashrc
fi
```

---
### Proceed
- **Next:** [205. Set Timezone](205-Set-Timezone.md)
- **Previous:** [203. Create Scripts Directory](203-Create-Scripts-Directory.md)
- **Up:** [200. Prepare Build Environment](200-Prepare-Build-Environment.md)

---
[MIT License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
