## 203. Create Scripts Directory
### About this Step
Let's get started by creating a `$HOME/scripts` directory and a `$HOME/tools` directory, then adding them to your `$PATH` environment variable.

**Where:** Perform this step in both your x86_64 and your aarch64 (arm64) build environments.

---
### Create `$HOME/mm-scripts` Directory Add to `$PATH`
Create `$HOME/mm-scripts` directory, then add it to your `$PATH` in `.bashrc`.
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
### Proceed
- **Next:** [204. Clone Mmojo Server Repo](204-Clone-Mmojo-Server-Repo.md)
- **Previous:** [202. Prepare macOS](202-Prepare-macOS.md)
- **Up:** [200. Prepare Build Environment](200-Prepare-Build-Environment.md)

---
[MIT License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)

