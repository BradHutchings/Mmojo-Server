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

`i` to insert, paste, `esc` after you paste, `:wq` to save and quit.

---
### Install Homebrew, bash, gsed on appliance Account
Homebrew is the prefered package mamager for macOS.

In the Terminal, install homebrew:
```
mkdir -p $HOME/homebrew
curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C $HOME/homebrew
echo 'eval "$($HOME/homebrew/bin/brew shellenv)"' >> ~/.zshrc
eval "$($HOME/homebrew/bin/brew shellenv)"
brew update
brew install bash gsed wget
brew list
echo "Copying bash and gsed to /ur/local/bin."
sudo mkdir -p /usr/local/bin
sudo cp $HOME/homebrew/bin/bash /usr/local/bin
sudo cp $HOME/homebrew/bin/gsed /usr/local/bin
echo "/usr/local/bin:"
ls -l /usr/local/bin
```

---
### Set bash as Shell for Mmojo Server Account
(instructions here.)

---
### Customize the Shell Prompt
You can prepend `(MmojoServer)-` to the shell prompt so you can easily indentify which WSL instance you're working with.
```
cat << EOF >> .bashrc
PS1="(MmojoServer)-$PS1"
EOF
source .bashrc
```

<img width="331" height="32" alt="image" src="https://github.com/user-attachments/assets/0610c9f1-e5b3-4a1d-b5f8-73a056d2fa1f" />

Notice your new prompt.


---
### Proceed
- **Next:** [03. Clone Mmojo Server Repo](03-Clone-Mmojo-Server-Repo.md)
- **Previous:** [01. Prerequisites](01-Prerequisites.md)
- **Up:** [Deploy Mmojo Server on macOS](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)




