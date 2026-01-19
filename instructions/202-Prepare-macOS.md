## 202. Prepare macOS
### About this Step
Here are steps to prepare a macOS build system. You should have a macOS system and do these steps if you want to build Mmojo Server for macOS or you want to build and test APE builds on macOS.

**THIS IS A DRAFT. I DON'T HAVE FULL TIME ACCESS TO A MAC TO VERIFY THAT BUILDS WORK WELL, BUT I AM TESTING SOME PORTIONS WEEKLY. -BRAD**

**Where:** Perform this step in an aarch64 (arm64) build environment on a Mac.

---
### Rough Outline
This needs end-to-end testing with all the steps in these instructions, but it should get most things working.
1. Create a dedicated account of the machine for building Mmojo Server, e.g. `mmojo` with password `admin123!`, no App Store account needed.
2. Install Homebrew. https://docs.brew.sh/Installation
   ```
   git clone https://github.com/Homebrew/brew homebrew
   eval "$(homebrew/bin/brew shellenv)"
   brew update --force --quiet
   chmod -R go-w "$(brew --prefix)/share/zsh"
   ```
4. Install and enable bash.
   ```
   brew install bash
   # Add the new Bash path to your allowed shells by running:
   echo $(brew --prefix bash) | sudo tee -a /etc/shells
   # Set bash as default shell for this account:
   chsh -s $(brew --prefix bash)
   ```
5. Use Homebrew to install cmake.
   ```
   brew install cmake
   ```

---
### Proceed
- **Next:** [203. Create Scripts Directory](203-Create-Scripts-Directory.md)
- **Previous:** [201. Prepare WSL](201-Prepare-WSL.md)
- **Up:** [200. Prepare Build Environment](200-Prepare-Build-Environment.md)

---
[MIT License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)

