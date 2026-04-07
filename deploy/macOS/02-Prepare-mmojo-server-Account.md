## 02. Prepare mmojo-server Account
**THIS GUIDE IS IN PROGRESS.**
### About this Step
You will create a `mmojo-server` user account on your Mac to deploy Mmojo Server. It will be useful for building Mmojo Server as well, if you decide to do that. This provides a little bit of sandboxing to both Mmojo Server and your Mac, as well as isolation of development tools.

---
### Install Latest Xcode
- **CAN THIS MOVE TO BUILD??**
- Use the App Store to install the latest Xcode.
- This will ensure that you have the latest compilers and headers.

--- 
### Uninstall Global Homebrew Installation
- **CAN THIS MOVE TO BUILD??**

If you have a global homebrew installation, you need to uninstall it and rethink your life choices. That was mean, but seriously, who does that?

Open a Terminal. Paste this command:
```
if [ -d "/opt/homebrew" ]; then
    echo "Rethinking life choices, then uninstalling homebrew."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
fi
```

---
### Delete your Existing mmojo-server User Account
If you have a previous `mmojo-server` user account on your Mac, let's delete it and start over.

- Log in as an admin user.
- Settings > Users and Groups.
- Delete the `mmojo-server` or `Mmojo Server` account.

---
### Create a new mmojo-server User Account
- Log in as an admin user.
- Settings > Users and Groups.
- New account
  - Administrator
  - mmojo-server
  - Mmojo Server
  - admin123!
- More details here.

---
### Enable SSH
Settings > General > Sharing > Advanced

<img width="400" alt="image" src="https://github.com/user-attachments/assets/423e3b66-f4f3-4eb6-bf00-0d0fcd96c603" />


---
### Login as mmojo-server
Note: I think this would be better as ssh. Gotta try that.
```
ssh mmojo-server@localhost
```

Are you sure you want to continue connecting?
```
yes
```

Your password:
```
admin123!
```

(picture su'd here.)

---
### Customize the Shell Prompt
You can prepend `(MmojoServer)-` to the shell prompt so you can easily indentify which WSL instance you're working with.
```
cat << EOF >> .zshrc
PS1="(MmojoServer)-$PS1"
EOF
source .zshrc
```

<img width="331" height="32" alt="image" src="https://github.com/user-attachments/assets/0610c9f1-e5b3-4a1d-b5f8-73a056d2fa1f" />

Notice your new prompt.



---
### Install homebrew
Homebrew is the prefered package mamager for macOS.

In the Terminal, install homebrew:
```
mkdir -p $HOME/homebrew
curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C $HOME/homebrew
echo 'eval "$($HOME/homebrew/bin/brew shellenv)"' >> ~/.zshrc
eval "$($HOME/homebrew/bin/brew shellenv)"
brew update
brew list

brew install bash
sudo cp $HOME/homebrew/bin/bash /usr/local
```

---
### Install bash and gsed with homebrew
In the Terminal, install bash and gsed with homebrew:
```
brew install bash gsed
sudo cp $HOME/homebrew/bin/bash /usr/local
```

---
### Create `mm-scripts` Directory
The `mm-scripts` Directory will contain useful scripts we will use to manage Mmojo Server.
```
export HOME_SCRIPTS="$HOME/mm-scripts"
TILDE_SCRIPTS="~/mm-scripts"
mkdir -p $HOME_SCRIPTS

if [[ "${PATH}" != *"${HOME_SCRIPTS}"* ]] && [[ "${PATH}" != *"${TILDE_SCRIPTS}"* ]]; then
cat << EOF >> $HOME/.zshrc
export PATH="\$PATH:$HOME_SCRIPTS"
EOF
fi

source $HOME/.zshrc
echo $PATH
```

---
### Clone the Mmojo Server Repository
The Mmojo Server Github repositort has scripts and tools for installing and building Mmojo Server.
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
if ! grep -q "mm-env=" "$HOME/.zshrc"; then
cat << EOF1 >> $HOME/.zshrc
alias mm-env="source mm-environment-variables.sh"
mm-env
EOF1
source $HOME/.zshrc
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
- **Next:** [03. Mount Mmojo Share](03-Mount-Mmojo-Share.md)
- **Previous:** [01. Prerequisites](01-Prerequisites.md)
- **Up:** [Deploy Mmojo Server on macOS](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)




