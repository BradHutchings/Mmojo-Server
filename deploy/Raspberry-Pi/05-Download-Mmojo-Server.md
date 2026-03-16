## 05. Download Mmojo Server
### About this Step
In this step, we will download Mmojo Server from Hugging Face.

---
### Set Mmojo Server Download URL
Set the URL for the Mmojo Server package that runs on Raspberry Pi. This build was compiled on a Raspberry Pi with native CPU features enabled.
```
DEPLOY_URL="https://huggingface.co/bradhutchings/Mmojo-Server/resolve/main/deploy"
URL="$DEPLOY_URL/Mmojo-Server-raspberry-pi-5.zip"
```

---
### Download Mmojo Server from Hugging Face
Download Mmojo Server from Hugging Face and unzip it in the `$HOME/Mmojo-Server` directory:
```
if [ "$DEPLOY_DIR" != "" ] && [ "$URL" != "" ]; then
    mkdir -p $DEPLOY_DIR
    cd $DEPLOY_DIR
    rm -r -f "$DEPLOY_DIR"/*
    wget $URL -O "mmojo-server.zip"
    unzip "mmojo-server.zip"
    rm "mmojo-server.zip"
    cd $HOME
    ls -al $DEPLOY_DIR
fi
```

Mmojo Server is installed and you are ready to run it!

---
### Proceed
- **Next:**  [06. Test Mmojo Server](06-Test-Mmojo-Server.md)
- **Previous:** [04. Download Models](04-Download-Models.md)
- **Up:** [Deploy Mmojo Server on Debian / Ubuntu / Raspberry Pi](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
