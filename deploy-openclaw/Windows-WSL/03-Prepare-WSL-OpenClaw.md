## 03. Prepare WSL - OpenClaw

### About this Step
Windows Subsystem for Linux (WSL) lets you run a full Linux distribution directly on Windows. Let's create and configure a WSL instance for OpenClaw.

Note for developer newbies: Windows cmd shell and PowerShell use a backslash `\` for file system paths. Linux shells use a forward slash `/` for paths and a backslash `\` for escaping characters like `$` in strings. I mostly use the Linux style slashes (`/`) in these instructions because they're for Linux.

---
### Delete your Existing `OpenClaw` WSL Instance
If you have a previous `OpenClaw` WSL instance, let's delete it. We're going to start from scratch with a new one.

<img width="131" height="97" alt="image" src="https://github.com/user-attachments/assets/d9940c1a-8fea-4efa-bc0f-8c4740067537" />

Open a **Terminal** (or **PowerShell**) window. 

<img width="243" height="76" alt="image" src="https://github.com/user-attachments/assets/d86d6c60-1da3-48ad-a76c-b1ad78f30e7e" />

Take note of the PowerShell prompt. Verify that your instance exists and is stopped:
```
wsl --list --verbose
```

Unregister ("delete") the instance:
```
wsl --unregister OpenClaw
```

<img width="158" height="97" alt="image" src="https://github.com/user-attachments/assets/1184dbb5-ff97-41a0-8b25-3a652f05d690" />

If you previously pinned `OpenClaw` to your **Taskbar**, unpin it. The existing pinned shortcut one will not launch the new instance you will create.

---
### Create New `OpenClaw` WSL Instance
Still in the **Terminal**, register a new instance:
```
wsl --install Ubuntu --name OpenClaw
```

A Ubuntu instance will be downloaded and installed. After a couple of minutes, you will be prompted for a user name and password. I like to use `linux` and `admin123!`.
```
linux
```
```
admin123!
```

---
### Disable `[interop]` and `[automount]`
Let's disable interoperability with the host Windows environment so we don't have our WSL `$PATH` polluted and won't have problems launching APE files inside WSL.

**Most important:** Disabling `automount` ensures that OpenClaw will not have access to any of your documents on your computer's disks, outside of the WSL environment. This is a safe approach for experimenting with OpenClaw.

Check that `/etc/wsl.conf` doesn't already have an `[interop]` section:
```
cd $HOME
cat /etc/wsl.conf
```

Append an `[interop]` section and an `[automount]` section to `/etc/wsl.conf`:
```
cp /etc/wsl.conf ./wsl.conf
cat << EOF >> wsl.conf

[interop]
enabled=false
appendWindowsPath=false

[automount]
enabled = false
EOF
sudo mv ./wsl.conf /etc/wsl.conf
```

You'll be prompted for your `sudo` password:
```
admin123!
```

Check that `/etc/wsl.conf` now has an `[interop]` section:
```
cat /etc/wsl.conf
```

Note: The drive directories will remain under `/mnt`, but the drives will not be mounted on those directories.

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
### Customize Shell Prompt
You can prepend `(OpenClaw)-` to the shell prompt so you can easily indentify which WSL instance you're working with.
```
cat << EOF >> .bashrc
PS1="(OpenClaw)-$PS1"
EOF
. .bashrc
```

---
### Run apt update and upgrade
Update linux and install `unzip`:
```
sudo apt update
sudo apt upgrade -y
sudo apt install zip unzip jq -y
echo "NOTE: apt update, upgrade, and install unzip finished."
```

---
### Power Off the WSL Instance
Now, poweroff the WSL instance:
```
sudo poweroff
```

**IMPORTANT:** Wait for the **Terminal** app will revert back to a PowerShell prompt.

*Note: This would be a good place to set up hostname and networking for the instance if we wanted to do that.*

---
### Move the WSL `.vhdx` Virual Disk (Optional)
In 2026, advanced Windows users like you have a startup drive for Windows stuff and applications and a separate (fast, larger) drive for your data. The virtual disk for your WSL instance will get pretty big, i.e. 50 GB or 100 GB. You should move it to another drive. That said, this sub-step is optional.

<img width="404" height="63" alt="image" src="https://github.com/user-attachments/assets/7ee2a1eb-7ddb-4f0f-8378-75b45077aea3" />

The **Terminal** app should show a PowerShell prompt. Create a destination directory on the `D:` drive:
```
mkdir D:\wsl-openclaw
```

Wait a couple minutes for WSL to completely shut down the instance you just created. Then move its virtual drive:
```
wsl --manage OpenClaw --move D:\wsl-openclaw
```

If you get a `WSL_E_DISTRO_NOT_STOPPED` or an `ERROR_SHARING_VIOLATION`, wait a minute, then try again.

---
### Reconnect to OpenClaw WSL Instance
<img width="574" height="64" alt="image" src="https://github.com/user-attachments/assets/91681471-562c-43fe-9e21-40d7bd13d755" />

Let's reconnect to the OpenClaw WSL instance in the Terminal window.
```
wsl -d "OpenClaw"
```

<img width="335" height="44" alt="image" src="https://github.com/user-attachments/assets/84adb52e-74f0-4299-b8af-627322448f30" />

You will see your `(OpenClaw)-` prompt again. Now, let's get a `sudo` password in, so we don't have to enter it again this session.
```
sudo echo "OpenClaw!"
```

You'll be prompted for your `sudo` password:
```
admin123!
```

---
### Create `oc-scripts` Directory
The `oc-scripts` Directory will contain useful scripts you will use to manage OpenClaw.
```
export HOME_OC_SCRIPTS="$HOME/oc-scripts"
export TILDE_OC_SCRIPTS="~/oc-scripts"
mkdir -p $HOME_OC_SCRIPTS

if [[ "${PATH}" != *"${HOME_OC_SCRIPTS}"* ]] && [[ "${PATH}" != *"${TILDE_OC_SCRIPTS}"* ]]; then
cat << EOF >> $HOME/.bashrc

export PATH="$HOME_OC_SCRIPTS:\$PATH"
EOF
fi

source $HOME/.bashrc
echo $PATH
```

---
### Clone the Mmojo Server Repository
The Mmojo Server Github repository has scripts and tools for managing OpenClaw.
```
export REPO_DIR="$HOME/mm-repo"
export REPO_DIR_SCRIPTS="$REPO_DIR/scripts"
cd $HOME
if [ "$REPO_DIR" ]; then
  rm -r -f $REPO_DIR
fi
mkdir -p $REPO_DIR
git clone https://github.com/BradHutchings/mmojo-server.git $REPO_DIR
. $REPO_DIR_SCRIPTS/mm-environment-variables.sh
. $REPO_DIR_SCRIPTS/mm-repo-update-local.sh
if ! grep -q "mm-env=" "$HOME/.bashrc"; then
cat << EOF1 >> $HOME/.bashrc

alias mm-env=". mm-environment-variables.sh"
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

<!--
---
### Install node to Avoid Problems Later
The OpenClaw installer is still a little flakey. Installing node first helps.
```
sudo apt remove nodejs npm -y
sudo apt install nodejs npm -y
sudo npm install -g node@latest
sudo npm install -g npm@latest
sudo npm install -g pnpm

if ! grep -q "\.npm-global\/bin" "$HOME/.bashrc"; then
cat << EOF1 >> $HOME/.bashrc

export PATH="$HOME/.npm-global/bin:\$PATH"
EOF1
source $HOME/.bashrc
fi
```
-->

---
### Pin OpenClaw to the Taskbar
Click your **Start** menu. Search for:
```
OpenClaw
```
Add it to the **Taskbar**.

---
### Great  Job!
Leave the Terminal window open for installing OpenClaw.

It's OK to start from scratch and do it often. There is a lot going on to build and configure OpenClaw. There are a lot of moving parts. When you get stuck, save your sanity and start over.

---
### Proceed
- **Next:** [04. Mount Mmojo Share](04-Mount-Mmojo-Share.md)
- **Previous:** [02. Deploy Mmojo Server](02-Deploy-Mmojo-Server.md)
- **Up:** [Deploy OpenClaw (WSL)](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
