## 03. llama-server &mdash; Package ELF Executable for Debian Linux
### About this Step
In this step, you will package the build you just created and tested.
 
---
### Review Your Work
Let's list the contents of the `$HOME/mm-llama-server` directory and review your work:
```
ls -l $RUN_LLAMA_SERVER_DIR
```

It should look like:

<img width="615" height="79" alt="image" src="https://github.com/user-attachments/assets/d3914894-c66d-4012-be1b-0511c023e3b0" />

---
### Make a Package File
Make a .zip pakcage files from your run directory. They are moved to your `$PACKAGES_DIR` directory after zipping for later testing or deployment.

Make a `.zip` package file and move it to your `$PACKAGES_DIR` directory:
```
if test -n "$RUN_LLAMA_SERVER_DIR"; then
  cd "$RUN_LLAMA_SERVER_DIR"
  zip -r "$_PACKAGE_FILE" $_PACKAGE_LLAMA_SERVER_FILE "$TOUCH_FILE"
  mkdir -p "$PACKAGES_DIR"
  mv -f "$_PACKAGE_FILE" "$PACKAGES_DIR"
  cd $HOME
  ls -al "$PACKAGES_DIR"
fi
```

---
### Backup Package to Mmojo Share
You can back the package up to your Mmojo Share.
```
mm-packages-backup.sh
```

---
### Proceed
- **Next:** This is the last step in this section.
- **Previous:** [02. Test ELF Executable for Debian Linux](02-Test-ELF-Debian-Linux.md)
- **Up:** [Build llama-server](../README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
