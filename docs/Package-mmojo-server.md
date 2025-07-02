## Package mmojo-server for Deployment

Brad Hutchings<br/>
brad@bradhutchings.com

This file contains instructions for packaging the `mmojo-server` executable for deployment. I'm using Ubuntu 24.04.

---
### Package Directory
Assuming you configured as instructed in the [Configure-ls1.md](Configure-ls1.md) instructions file, let's create a directory with everything you need to package for deployment. You can zip this folder to distribute your `mmoojo-server`, model, and arguments file for use on any platform. 

---
### Environment Variables
Let's define some environment variables:
```
DOWNLOAD_DIR="0-DOWNLOAD"
BUILD_DIR="1-BUILD-mmojo-server"
CONFIGURE_DIR="2-CONFIGURE-mmojo-server"
PACKAGE_DIR="3-PACKAGE-mmojo-server"
DEPLOY_ZIP="mmojo-server-deploy.zip"

MMOJO_SERVER="mmojo-server"
MMOJO_SERVER_EXE ="mmojo-server.exe"
MMOJO_SERVER_ARGS="mmojo-server-args"
printf "\n**********\n*\n* FINISHED: Environment Variables.\n*\n**********\n\n"
```

---
### Create Package Directory
Create a folder and copy `mmojo-server` into the new folder.
```
# This should use variables for paths and filenames. So should the packaging instructions.
cd ~
rm -r -f ~/$PACKAGE_DIR ~/$DEPLOY_ZIP
mkdir -p ~/$PACKAGE_DIR
cd ~/$PACKAGE_DIR
cp ~/$CONFIGURE_DIR/$MMOJO_SERVER .
printf "\n**********\n*\n* FINISHED: Create Package Directory.\n*\n**********\n\n"
```

---
### Copy mmojo-server as .exe

On Windows, this executable will need to be renamed to a `.exe` file. Since our executable is small, let's just make a copy of `mmojo-server` with the `.exe` extension.

```
cp $MMOJO_SERVER $MMOJO_SERVER_EXE
printf "\n**********\n*\n* FINISHED: Copy mmojo-server as .exe.\n*\n**********\n\n"
```

---
### Download Model

Let's download a small model. We'll use Google Gemma 1B Instruct v3, a surprisingly capable tiny model.
```
MODEL_FILE="Google-Gemma-1B-Instruct-v3-q8_0.gguf"
mkdir -p ~/$DOWNLOAD_DIR
cd ~/$DOWNLOAD_DIR
URL="https://huggingface.co/bradhutchings/Mmojo-Server/resolve/main/models/$MODEL_FILE?download=true"
if [ ! -f $MODEL_FILE ]; then wget $URL --show-progress --quiet -O $MODEL_FILE ; fi
cd ~/$PACKAGE_DIR
cp ~/$DOWNLOAD_DIR/$MODEL_FILE model.gguf
printf "\n**********\n*\n* FINISHED: Download Model.\n*\n**********\n\n"
```

---
### Create mmojo-server-args File

Let's create a `mmojo-server-args` file. These parameters can override or augment the parameters you previously embedded in you `mmojo-server` archive. This file could be edited by the end user to configure `mmojo-server` without having to construct and type a long command line. Notice that we've overridden the `-m`, `--host`, and `--port` parameters.
```
cat << EOF > $MMOJO_SERVER_ARGS
-m
model.gguf
--host
0.0.0.0
--port
8888
...
EOF
printf "\n**********\n*\n* FINISHED: Create mmojo-server-one-args File.\n*\n**********\n\n"
```

---
### Test Run

Now we can test run `mmojo-server`, listening on all network interfaces, port 8888. Note that these are different from the default args you built into `mmojo-server`. You can connect to it from another web browser.
```
./$MMOJO_SERVER
```

After starting up and loading the model, it should display:

**main: server is listening on http://0.0.0.0:8888 - starting the main loop**<br/>
**srv  update_slots: all slots are idle**

Hit `ctrl-C` on your keyboard to stop it.

---
### Make .zip Acrhive

Let's zip up the files into a `.zip` file you can share and move it to your home directory. The model won't compress much, so we're turning compression off with the `-0` parameter.

```
zip -0 $DEPLOY_ZIP *
mv $DEPLOY_ZIP ~
cd ~
printf "\n**********\n*\n* FINISHED: Make .zip Acrhive.\n*\n**********\n\n"
```

---
### Review What You Created
Finally, let's review what you created in building, packaging, and deploying `mmojo-server`:
```
ls -aldh *mmojo*
printf "\n**********\n*\n* FINISHED: Review What You Created.\n*\n**********\n\n"
```

You should see three directories and a `.zip` file. The `mmojo-server-deploy.zip` file is ready to upload and share.

---
### Congratulations!

Congratulations! You did it. You built a `mmojo-server` executable that runs on two different CPU architectures and several popular operating systems. If you had any trouble in this process, please post a question in the [Discussions section](https://github.com/BradHutchings/llama-server-one/discussions). I'm happy to help!

-Brad

