## 06. Download Mmojo Server
**THIS GUIDE IS IN PROGRESS.**
### About this Step
In this step, we will download Mmojo Server from Hugging Face.

---
### Set Mmojo Server Download URL
Set the URL for the Mmojo Server package that runs on recent x86_64 CPUs. It is currently unkown if this build runs on any aarch64 (arm64) Windows computers.
```
URL=""
if [ $(uname -m) = "x86_64" ]; then
    URL="https://huggingface.co/bradhutchings/Mmojo-Server/resolve/main/deploy/Mmojo-Server-macos-x86_64-performant-met.zip"
elif [ $(uname -m) = "arm64" ]; then
    URL="https://huggingface.co/bradhutchings/Mmojo-Server/resolve/main/deploy/Mmojo-Server-macos-aarch64-performant-met.zip"
fi
```

<details>
  <summary><b>Alternatively:</b> set the URL for the Mmojo Server package that runs on all x86_64 and aarch64 (arm64) CPUs. Use this if the Mmojo Server you download with the URL setting above gives you an illegal instruction error when you run it.</summary>
  <br/>
  
```
URL=""
if [ $(uname -m) = "x86_64" ]; then
    URL="https://huggingface.co/bradhutchings/Mmojo-Server/resolve/main/deploy/Mmojo-Server-macos-x86_64-performant-met.zip"
elif [ $(uname -m) = "aarch64" ] || [ $(uname -m) = "arm64" ]; then
    URL="https://huggingface.co/bradhutchings/Mmojo-Server/resolve/main/deploy/Mmojo-Server-macos-aarch64-performant-met.zip"
fi
```
</details>

**Future:** Might just download the "compatible" version for aarch64 (arm64) by default. It's tough to figure out what processors are out there. -Brad 2025-02-11

---
### Download Mmojo Server from Hugging Face
Download Mmojo Server from Hugging Face and unzip it in the `$HOME/mm-deploy` directory:
```
if [ "$DEPLOY_DIR" != "" ] && [ "$URL" != "" ]; then
    mkdir -p $DEPLOY_DIR
    cd $DEPLOY_DIR
    rm -r -f "$DEPLOY_DIR"/*
    wget -O "mmojo-server.zip" --no-check-certificate $URL
    unzip "mmojo-server.zip"
    $MMOJO_SED -i -e 's/# -ngl/-ngl/g' "$DEPLOY_DIR/$_PACKAGE_MMOJO_SERVER_ARGS_FILE"
    $MMOJO_SED -i -e 's/# all/all/g' "$DEPLOY_DIR/$_PACKAGE_MMOJO_SERVER_ARGS_FILE"
    rm "mmojo-server.zip"
    cd $HOME
    ls -al $DEPLOY_DIR
fi
```

Mmojo Server is installed. You are ready to test it!

---
### Optional: Open Server to Outside Connections
For default safety, the server only listens to localhost connections, i.e. apps on your computer. Run this snippet to edit the `mmojo-server-args` file and open Mmojo Server up to accept connections from other computers on your network:
```
if [ "$DEPLOY_DIR" != "" ]; then
    $MMOJO_SED -i -e 's/127.0.0.1/0.0.0.0/g' "$DEPLOY_DIR/$_PACKAGE_MMOJO_SERVER_ARGS_FILE"
fi
```

---
### Proceed
- **Next:**  [07. Test Mmojo Server](07-Test-Mmojo-Server.md)
- **Previous:** [05. Download Models](05-Download-Models.md)
- **Up:** [Deploy Mmojo Server on macOS](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
