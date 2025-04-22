## Package llama-server-one for Deployment

Brad Hutchings<br/>
brad@bradhutchings.com

This file contains instructions for packaging the `llama-server-one` executable for deployment. I'm using Ubuntu 24.04.

---
### Package Directory
Assuming you configured as instructed in the [Configure-ls1.md](Configure-ls1.md) instructions file, let's create a directory with everything you need to package for deployment. You can zip this folder to distribute your `llama-server-one`, model, and arguments file for use on any platform. 

---
### Environment Variables
Let's define some environment variables:
```
BUILD_DIR="1-BUILD-llama.cpp"
CONFIGURE_DIR="2-CONFIGURE-llama-server-one"
PACKAGE_DIR="3-PACKAGE-llama-server-one-deploy"
DEPLOY_ZIP="llama-server-one-deploy.zip"

LLAMA_SERVER="llama-server"
LLAMA_SERVER_ONE="llama-server-one"
LLAMA_SERVER_ONE_EXE="llama-server-one.exe"
LLAMA_SERVER_ONE_ARGS="llama-server-one-args"
printf "\n**********\n*\n* FINISHED: Environment Variables.\n*\n**********\n\n"
```

---
### Create Package Directory
Create a folder and copy `llama-server-one` into the new folder.
```
# This should use variables for paths and filenames. So should the packaging instructions.
cd ~
rm -r -f ~/$PACKAGE_DIR ~/$DEPLOY_ZIP
mkdir -p ~/$PACKAGE_DIR
cd ~/$PACKAGE_DIR
cp ~/$CONFIGURE_DIR/$LLAMA_SERVER_ONE .
printf "\n**********\n*\n* FINISHED: Create Package Directory.\n*\n**********\n\n"
```

---
### Copy llama-server-one as .exe

On Windows, this executable will need to be renamed to a `.exe` file. Since our executable is small, let's just make a copy of `llama-server-one` with the `.exe` extension.

```
cp $LLAMA_SERVER_ONE $LLAMA_SERVER_ONE_EXE
printf "\n**********\n*\n* FINISHED: Copy llama-server-one as .exe.\n*\n**********\n\n"
```

---
### Download Model

Let's download a small model. We'll use Google Gemma 1B Instruct v3, a surprisingly capable tiny model.
```
MODEL_FILE="Google-Gemma-1B-Instruct-v3-q8_0.gguf"
cd ~/$DOWNLOAD_DIR
URL="https://huggingface.co/bradhutchings/Brads-LLMs/resolve/main/models/$MODEL_FILE?download=true"
if [ ! -f model.gguf ]; then wget $URL --show-progress --quiet -O model.gguf ; fi
cd ~/$PACKAGE_DIR
cp ~/$DOWNLOAD_DIR/model.gguf .
printf "\n**********\n*\n* FINISHED: Download Model.\n*\n**********\n\n"
```

---
### Create llama-server-one-args File

Let's create a `llama-server-one-args` file. These parameters can override or augment the parameters you previously embedded in you `llama-server-one` archive. This file could be edited by the end user to configure llama-file-one without having to construct and type a long command line. Notice that we've overridden the `-m`, `--host`, and `--port` parameters.
```
cat << EOF > $LLAMA_SERVER_ONE_ARGS
-m
model.gguf
--host
0.0.0.0
--port
8888
...
EOF
printf "\n**********\n*\n* FINISHED: Create llama-server-one-args File.\n*\n**********\n\n"
```

---
### Test Run

Now we can test run `llama-server-one`, listening on all network interfaces, port 8888. Note that these are different from the default args you built into `llama-server-one`. You can connect to it from another web browser.
```
./$LLAMA_SERVER_ONE
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
Finally, let's review what you created in building, packaging, and deploying `llama-server-one`:
```
ls -aldh *llama*
printf "\n**********\n*\n* FINISHED: Review What You Created.\n*\n**********\n\n"
```

You should see three directories and a `.zip` file. The `llama-server-one-deploy.zip` file is ready to upload and share.

---
### Congratulations!

Congratulations! You did it. You built a `llama-server-one` executable that runs on two different CPU architectures and several popular operating systems. If you had any trouble in this process, please post a question in the [Discussions section](https://github.com/BradHutchings/llama-server-one/discussions). I'm happy to help!

-Brad

