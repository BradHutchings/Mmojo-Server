## 11. Build Mmojo Server
### About this Step (Optional)
If you would prefer to build Mmojo Server optimized for the CPU on your computer, you can build it with the steps on this page. The Mmojo Server you build with the instructions on this page will take advantage of all available features of your computer's CPU. It can also work with your computer's NVIDIA GPU if it has one.

**Jump Back:**
- [05. Download Mmojo Server](05-Download-Mmojo-Server.md)

---
### Install Dependencies and GPU Support
Install dependencies. These may take 20 minutes or so to download and install.
```
$MMOJO_SERVER_SCRIPTS/207-Install-Dependencies.sh
```

Install CUDA and Vulkan support. These may take 10 minutes or so to download and install.
```
sudo apt install -y nvidia-cuda-toolkit
sudo apt install -y libvulkan-dev glslc vulkan-tools
```

---
### Build Native Mmojo Server
Prepare to build:
```
$MMOJO_SERVER_SCRIPTS/501-Clone-Repos.sh
$MMOJO_SERVER_SCRIPTS/501-Patch-llama-cpp.sh
$MMOJO_SERVER_SCRIPTS/501-Customize-webui.sh
```

Choose GPUs for your build. I suggest **CUDA**.
```
. mm-choose-gpus.sh
```

Build native Mmojo Server tuned to the specific CPU of your PC:
```
$MMOJO_SERVER_SCRIPTS/510-Build-for-Platform.sh native "$CHOSEN_GPUS"
BUILD_SUBDIR=""
ZIP_FILE=""
TOUCH_FILE=""
if [ $(uname -m) == "x86_64" ]; then
    BUILD_SUBDIR="$BUILD_DIR/$BUILD_EXECUTABLE_NATIVE_X86_64$CHOSEN_GPUS"
    ZIP_FILE="Mmojo-Server-x86_64-native$CHOSEN_GPUS.zip"
    TOUCH_FILE="build-x86_64-native$CHOSEN_GPUS"
elif [ $(uname -m) == "aarch64" ]; then
    BUILD_SUBDIR="$BUILD_DIR/$BUILD_EXECUTABLE_NATIVE_AARCH64$CHOSEN_GPUS"
    ZIP_FILE="Mmojo-Server-aarch64-native$CHOSEN_GPUS.zip"
    TOUCH_FILE="build-aarch64-native$CHOSEN_GPUS"
fi
```

<details>
  <summary>Alternatively, build a more compatible Mmojo Server. It will run on most CPUs in your CPU family (x86_64 or aarch64).</summary>
  
```
$MMOJO_SERVER_SCRIPTS/510-Build-for-Platform.sh compatible "$CHOSEN_GPUS"
BUILD_SUBDIR=""
ZIP_FILE=""
if [ $(uname -m) == "x86_64" ]; then
    BUILD_SUBDIR="$BUILD_DIR/$BUILD_EXECUTABLE_COMPATIBLE_X86_64$CHOSEN_GPUS"
    ZIP_FILE="Mmojo-Server-x86_64-comp$CHOSEN_GPUS.zip"
    TOUCH_FILE="build-x86_64-comp$CHOSEN_GPUS"
elif [ $(uname -m) == "aarch64" ]; then
    BUILD_SUBDIR="$BUILD_DIR/$BUILD_EXECUTABLE_COMPATIBLE_AARCH64$CHOSEN_GPUS"
    ZIP_FILE="Mmojo-Server-aarch64-comp$CHOSEN_GPUS.zip"
    TOUCH_FILE="build-aarch64-comp$CHOSEN_GPUS"
fi
```
</details>

<details>
  <summary>Alternatively, build a performant Mmojo Server. It will run on recent CPUs in your CPU family (x86_64 or aarch64).</summary>
  
```
$MMOJO_SERVER_SCRIPTS/510-Build-for-Platform.sh performant "$CHOSEN_GPUS"
BUILD_SUBDIR=""
ZIP_FILE=""
if [ $(uname -m) == "x86_64" ]; then
    BUILD_SUBDIR="$BUILD_DIR/$BUILD_EXECUTABLE_PERFORMANT_X86_64$CHOSEN_GPUS"
    ZIP_FILE="Mmojo-Server-x86_64-perf$CHOSEN_GPUS.zip"
    TOUCH_FILE="build-x86_64-perf$CHOSEN_GPUS"
elif [ $(uname -m) == "aarch64" ]; then
    BUILD_SUBDIR="$BUILD_DIR/$BUILD_EXECUTABLE_PERFORMANT_AARCH64$CHOSEN_GPUS"
    ZIP_FILE="Mmojo-Server-aarch64-perf$CHOSEN_GPUS.zip"
    TOUCH_FILE="build-aarch64-perf$CHOSEN_GPUS"
fi
```
</details>

---
### Create a Run Directory
Make a run directory. This is a good candidate for an mm-script.
```
mkdir -p $RUN_DIR
rm -r -f "$RUN_DIR"/*
cp $BUILD_SUBDIR/bin/$PACKAGE_MMOJO_SERVER_FILE $RUN_DIR
cp -r $BUILD_DIR/Mmojo-Complete $RUN_DIR
# make a $PACKAGE_MMOJO_SERVER_ARGS_FILE file
cat << EOF > "$RUN_DIR/$PACKAGE_MMOJO_SERVER_ARGS_FILE"
--path
/app/Mmojo-Complete
--default-ui-endpoint
chat
--host
0.0.0.0
--port
8080
--batch-size
2048
--threads-http
8
--ctx-size
32768 
EOF
touch "$RUN_DIR/$TOUCH_FILE"
```

---
### Review Your Work
Let's list the contents of the `$HOME/Mmojo-Server` directory and review your work:
```
ls -al $RUN_DIR
```

It should look like:

<img width="814" height="159" alt="image" src="https://github.com/user-attachments/assets/7d59ae18-90ff-4137-840e-dbf7e9c10891" />

---
### (Optional) Make a .zip File
Brad makes .zip files for the Hugging Face downloads. They are moved to your `$HOME` directory after zipping. You don't need to do this.
```
if test -n "$RUN_DIR"; then
  cd "$RUN_DIR"
  # TODO: If we're on aarch64, change the $ZIP_FILE from -x86- to -arm-
  zip -r $ZIP_FILE mmojo-server mmojo-server-args Mmojo-Complete
  mv $ZIP_FILE $HOME
  cd $HOME
fi
```

---
### Proceed
- **Next:** [06. Control Mmojo Server](06-Control-Mmojo-Server.md)
- **Previous:** [05. Download Mmojo Server](05-Download-Mmojo-Server.md)
- **Up:** [Deploy Mmojo Server on Windows (WSL)](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
