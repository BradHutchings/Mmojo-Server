## 99. Vision Proxy
**THIS STEP IS UNDER CONSTRUCTION.**
### About this Step
You can deploy a vision proxy in order to watch requests to and responses from Mmojo Server. The proxy is a modified version of [openai-proxy](https://github.com/fangwentong/openai-proxy).

---
### Clone openai-proxy Repo
```
sudo apt install -y python3 python3-pip python3-tk uvicorn
if [ "$PROXY_DIR" != "" ] && [ -d "$PROXY_DIR" ]; then
    rm -r -f $PROXY_DIR
fi
git clone https://github.com/fangwentong/openai-proxy $PROXY_DIR
cd $PROXY_DIR
pip install -r requirements.txt --quiet --break-system-packages
cd $HOME

if [ -d "$REPO_DIR_FILES" ]; then
    cp -r -f "$REPO_DIR_FILES/proxy/"* $PROXY_DIR
fi
```

---
### Start Proxy
Click the MmojoServer icon in the Taskbar to open a new terminal connection to your MmojoServer WSL instance. Start the proxy.
```
cd $PROXY_DIR
uvicorn main:app --host 127.0.0.1 --port 8081
```

Click the MmojoServer icon in the Taskbar to open another new terminal connection to your MmojoServer WSL instance. Start the watcher.

```
cd $PROXY_DIR
python3 proxy-watcher.py
```

---
### Proceed
- **Next:** This is the last step in this section.
- **Previous:** Not sure what  the previous step is going to be.
- **Up:** [Deploy Mmojo Server on Windows (WSL)](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
