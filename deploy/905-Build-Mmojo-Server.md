## 905. Build Mmojo Server

### About this Step
If you didn't install Mmojo Server from Hugging Face downloads or from builds on your Mmojo Share, you can build it quickly with the steps on this page.

---
### Scripts, Repo, Dependencies

Create the `mm-scripts` directory:
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

Clone Mmojo Server Repo:
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

Install dependencies:
```
$MMOJO_SERVER_SCRIPTS/207-Install-Dependencies.sh
```

Install CUDA and Vulkan support:
```
sudo apt install -y nvidia-cuda-toolkit
sudo apt install -y libvulkan-dev glslc vulkan-tools
```

Download models:
```
$MMOJO_SERVER_SCRIPTS/401-Create-Models-Directory.sh
$MMOJO_SERVER_SCRIPTS/401-Download-Model-Map.sh
mm-download-models.sh 4
```

---
### Build Native Mmojo Server
Prepare to build:
```
$MMOJO_SERVER_SCRIPTS/501-Clone-Repos.sh
$MMOJO_SERVER_SCRIPTS/501-Patch-llama-cpp.sh
$MMOJO_SERVER_SCRIPTS/501-Customize-webui.sh
```

Choose a model and GPUs:
```
unset CHOSEN_MODEL
unset CHOSEN_MODEL_MNEMONIC
unset CHOSEN_GPUS
. mm-choose-model.sh
. mm-choose-gpus.sh
```

Build native Mmojo Server:
```
$MMOJO_SERVER_SCRIPTS/510-Build-for-Platform.sh native "$CHOSEN_GPUS"
```

Make a run folder:
```
RUN_FOLDER="$HOME/Mmojo-Server"
mkdir -p $RUN_FOLDER
rm -r -f "$RUN_FOLDER"/*
BUILD_SUBDIR="$BUILD_DIR/$BUILD_EXECUTABLE_NATIVE_X86_64$CHOSEN_GPUS"
cp $BUILD_SUBDIR/bin/$PACKAGE_MMOJO_SERVER_FILE $RUN_FOLDER
cp -r $BUILD_DIR/Mmojo-Complete $RUN_FOLDER
# make a $PACKAGE_MMOJO_SERVER_ARGS_FILE file
if [ -f "$LOCAL_MODELS_DIR/$CHOSEN_MODEL" ]; then cp "$LOCAL_MODELS_DIR/$CHOSEN_MODEL" $RUN_FOLDER; fi
```

---
### Launch mmojo-server

Launch `mmojo-server`:
```
RUN_FOLDER="$HOME/Mmojo-Server"
$RUN_FOLDER/$PACKAGE_MMOJO_SERVER_FILE --path "$RUN_FOLDER/Mmojo-Complete" --host 0.0.0.0 --port 8080 \
    --batch-size 128 --threads-http 8 --ctx-size 32768 
```

Connect to Mmojo Complete from a browser:

[Mmojo Complete](http://127.0.0.1:8080) &larr; Right-click, open in new tab.

---
### Proceed
- **Next:** [906. Install OpenClaw](906-Install-OpenClaw.md)
- **Previous:** [904. Install Mmojo Server](904-Install-Mmojo-Server.md)
- **Up:** [900. Deploy OpenClaw](900-Deploy-OpenClaw.md)

---
[MIT License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
