## 02. Prepare mmojo Account
**THIS SECTION IS IN PROGRESS.**
### About this Step
You will create a `mmojo` user account on your Mac to deploy Mmojo Server. It will be useful for building Mmojo Server as well, if you decide to do that. This provides a little bit of sandboxing to both Mmojo Server and your Mac, as well as isolation of development tools.

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
### Delete your Existing mmojo User Account
If you have a previous `mmojo` user account on your Mac, let's delete it and start over.

- Log in as an admin user.
- Settings > Users and Groups.
- Delete the `mmojo` or `Mmojo Server` account.

---
### Create a new mmojo User Account
- Log in as an admin user.
- Settings > Users and Groups.
- New account
  - mmojo
  - Mmojo Server
  - admin123!
- More details here.

---
### Optional: Hide mmojo Account from Login Screen
You won't need to log into your `mmojo` user account from the Desktop. You will log into from a Terminal via `su mmojo` or via SSH.

Open a Terminal and paste this command:
```
sudo dscl . create /Users/mmojo IsHidden 1
```

Keep the Terminal open.

---
### Login as mmojo
Note: I think this would be better as ssh. Gotta try that.
```
ssh mmojo@localhost
```

Let's su to the new mmojo user.
```
su mmojo
```

Your password:
```
admin123!
```

(picture su'd here.)

---
### Install homebrew
- **CAN THIS MOVE TO BUILD??**

Homebrew is the prefered package mamager for mac OS.

In the Terminal, signed in as the new mmojo user:
```
mkdir -p $HOME/homebrew
curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C $HOME/homebrew
echo 'eval "$($HOME/homebrew/bin/brew shellenv)"' >> ~/.zshrc
eval "$($HOME/homebrew/bin/brew shellenv)"
brew update
brew list
```

---
### Proceed
- **Next:** [03. Mount Mmojo Share](03-Mount-Mmojo-Share.md)
- **Previous:** [01. Prerequisites](01-Prerequisites.md)
- **Up:** [Deploy Mmojo Server on mac OS](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)




