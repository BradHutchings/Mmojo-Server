## 11. Prepare WSL - Mmojo Server

### About this Step
Windows Subsystem for Linux (WSL) lets you run a full Linux distribution directly on Windows. Let's create and configure a WSL instance for Mmojo Server deployment.

Note for developer newbies: Windows cmd shell and PowerShell use a backslash `\` for file system paths. Linux shells use a forward slash `/` for paths and a backslash `\` for escaping characters like `$` in strings. I mostly use the Linux style slashes in these instructions because they're for Linux.

---
### Delete your Existing `MmojoServer` WSL Instance
If you have a previous `MmojoServer` WSL instance, let's delete it. We're going to start from scratch with a new one.

Open a **Terminal** (or **PowerShell**) window. Verify that your instance exists and is stopped:
```
wsl --list --verbose
```

Unregister ("delete") the instance:
```
wsl --unregister MmojoServer
```

If you previously pinned `MmojoServer` to your **Taskbar**, unpin it. The existing pinned shortcut one will not launch the new instance you will create.

---
### Create New `MmojoServer` WSL Instance
Still in the **Terminal**, register a new instance:
```
wsl --install Ubuntu --name MmojoServer
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
Let's diable interoperability with the host Windows environment so we don't have our WSL `$PATH` polluted and won't have problems launching APE files inside WSL.

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
You can prepend `(MmojoServer)-` to the shell prompt so you can easily indentify which WSL instance you're working with.
```
cat << EOF >> .bashrc
PS1="(MmojoServer)-$PS1"
EOF
. .bashrc
```

---
### Run apt update and upgrade
Update linux:
```
sudo apt update
sudo apt upgrade -y
sudo apt install unzip -y
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
### Move the WSL `.vhdx` Virual Disk
In 2025, advanced Windows users like you have a startup drive for Windows stuff and applications and a separate (fast, larger) drive for your data. The virtual disk for your WSL instance will get pretty big, i.e. 50 GB or 100 GB. You should move it to another drive.

The **Terminal** app should show a PowerShell prompt. Create a destination directory on the `D:` drive:
```
mkdir D:\wsl-mmojo-server
```

Wait a couple minutes for WSL to completely shut down the instance you just created. Then move its virtual drive:
```
wsl --manage MmojoServer --move D:\wsl-mmojo-server
```

If you get a `WSL_E_DISTRO_NOT_STOPPED` or an `ERROR_SHARING_VIOLATION`, wait a minute, then try again.

---
### Pin MmojoServer to the Taskbar
Click your **Start** menu. Search for:
```
MmojoServer
```
Add it to the **Taskbar**.

---
### Launch MmojoServer WSL Instance

Launch and log into your new instance by clicking the icon you just added to the **Taskbar**.

Now, let's get a `sudo` password in, so we don't have to enter it again this session.
```
sudo echo "Mmojo Server!"
```

You'll be prompted for your `sudo` password:
```
admin123!
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

<details>
  <summary><b>Optional:</b> If you're Brad working on writing these instructions, switch to the work-in-progress branch.</summary>
  
```
mm-work-in-progress-branch.sh
mm-env
```
</details>

---
### Great  Job!
Leave the `Terminal` window open for installing or building Mmojo Server.

It's OK to start from scratch and do it often. There is a lot going on to deploy Mmojo Server. There are a lot of moving parts. When you get stuck, save your sanity and start over.

---
### Proceed
- **Next:** [12. Mount Mmojo Share](12-Mount-Mmojo-Share.md)
- **Previous:** [10. Deploy Mmojo Server](10-Deploy-Mmojo-Server.md)
- **Up:** [Deploy OpenClaw (WSL)](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
