## Configure llama-server-one in my Environment

Brad Hutchings<br/>
brad@bradhutchings.com

This file contains instructions for configuring the `llama-server-one` executable to make it ready to package for multiple platforms.

---
### Environment Variables

Let's define some environment variables:
```
BUILD_DIR="1-BUILD-llama.cpp"
CONFIGURE_DIR="2-CONFIGURE-llama-server-one"

LLAMA_SERVER="llama-server"
LLAMA_SERVER_ONE="llama-server-one"
LLAMA_SERVER_ONE_ZIP="llama-server-one.zip"
DEFAULT_ARGS="default-args"
printf "\n**********\n*\n* FINISHED: Environment Variables.\n*\n**********\n\n"
```

---
### Create Configure Directory

Next, let's create a directory where we'll configure `llama-server-one`:
```
cd ~
rm -r -f ~/$CONFIGURE_DIR
mkdir -p $CONFIGURE_DIR
cp ~/$BUILD_DIR/$LLAMA_SERVER \
    ~/$CONFIGURE_DIR/$LLAMA_SERVER_ONE_ZIP

cd ~/$CONFIGURE_DIR
printf "\n**********\n*\n* FINISHED: Create Configuration Directory.\n*\n**********\n\n"
```

---
### Examine Contents of Zip Archive

Look at the contents of the `llama-server-one` zip archive:
```
unzip -l $LLAMA_SERVER_ONE_ZIP 
printf "\n**********\n*\n* FINISHED: Examine Contents of Zip Archive.\n*\n**********\n\n"
```

---
### Delete Extraneous Timezone Files

You should notice a bunch of extraneous timezone related files in `/usr/*`. Let's get rid of those:
```
zip -d $LLAMA_SERVER_ONE_ZIP "/usr/*"
printf "\n**********\n*\n* FINISHED: Delete Extraneous Timezone Files.\n*\n**********\n\n"
```

#### Verify Contents of Zip Archive

Verify that these files are no longer in the archive:
```
unzip -l $LLAMA_SERVER_ONE_ZIP 
printf "\n**********\n*\n* FINISHED: Verify Contents of Zip Archive.\n*\n**********\n\n"
```

---
### OPTIONAL: Create website Directory in Archive

`llama.cpp` has a built in chat UI. If you'd like to provide a custom UI, you should add a `website` directory to the `llama-server-one` archive. `llama.cpp`'s chat UI is optimized for serving inside the project's source code. But we can copy the unoptimized source:
```
mkdir -p website
cp -r ~/$BUILD_DIR/examples/server/public_legacy/* website
zip -0 -r $LLAMA_SERVER_ONE_ZIP website/*
printf "\n**********\n*\n* FINISHED: Create website Directory in Archive.\n*\n**********\n\n"
```

#### OPTIONAL: Verify website Directory in Archive

Verify that the archive has your website:
```
unzip -l $LLAMA_SERVER_ONE_ZIP 
printf "\n**********\n*\n* FINISHED: Verify website Directory in Archive.\n*\n**********\n\n"
```

---
### Create default-args File in Archive

A `default-args` file in the archive can specify sane default parameters. The format of the file is parameter name on a line, parameter value on a line, rinse, repeat. End the file with a `...` line to include user specified parameters.

We don't yet support including the model inside the zip archive (yet). That has a 4GB size limitation on Windows anyway, as `.exe` files cannot exceed 4GB. So let's use an adjacent file called `model.gguf`.

We will serve on localhost, port 8080 by default for safety. The `--ctx-size` parameter is the size of the context window. This is kinda screwy to have as a set size rather than a maximum because the `.gguf` files now have the training context size in metadata. We set it to 8192 to be sensible. The `--threads-http` parameter ensures that the browser can ask for all the image files in our default UI at once.
```
cat << EOF > $DEFAULT_ARGS
-m
model.gguf
--host
127.0.0.1
--port
8080
--ctx-size
8192
--threads-http
8
...
EOF
zip -0 -r $LLAMA_SERVER_ONE_ZIP $DEFAULT_ARGS
printf "\n**********\n*\n* FINISHED: Create Default args File in Archive.\n*\n**********\n\n"
```

#### OPTIONAL: Create default-args File in Archive with Website
```
cat << EOF > $DEFAULT_ARGS
-m
model.gguf
--host
127.0.0.1
--port
8080
--ctx-size
8192
--threads-http
8
--path
/zip/website
...
EOF
zip -0 -r $LLAMA_SERVER_ONE_ZIP $DEFAULT_ARGS
printf "\n**********\n*\n* FINISHED: Create Default args File in Archive with Website.\n*\n**********\n\n"
```

#### Verify default-args File in Archive

Verify that the archive contains the `default-args` file:
```
unzip -l $LLAMA_SERVER_ONE_ZIP 
printf "\n**********\n*\n* FINISHED: Verify default-args File in Archive.\n*\n**********\n\n"
```

---
### Remove .zip Extension

Remove the `.zip` from our working file:
```
mv $LLAMA_SERVER_ONE_ZIP $LLAMA_SERVER_ONE
printf "\n**********\n*\n* FINISHED: Remove .zip Extension.\n*\n**********\n\n"
```

---
### Download Model

Let's download a small model. We'll use Google Gemma 1B Instruct v3, a surprisingly capable tiny model.
```
MODEL_FILE="Google-Gemma-1B-Instruct-v3-q8_0.gguf"
# Future: Cache download in ~/$DOWNLOAD_DIR
wget https://huggingface.co/bradhutchings/Brads-LLMs/resolve/main/models/$MODEL_FILE?download=true \
    --show-progress --quiet -O model.gguf
printf "\n**********\n*\n* FINISHED: Download Model.\n*\n**********\n\n"```
```

---
### Test Run

Now we can test run `llama-server-one`, listening on localhost:8080.
```
./$LLAMA_SERVER_ONE
```

After starting up and loading the model, it should display:

**main: server is listening on http://127.0.0.1:8080 - starting the main loop**<br/>
**srv  update_slots: all slots are idle**

Hit `ctrl-C` on your keyboard to stop it.

#### Test Run on Public Interfaces

If you'd like it to listen on all available interfaces, so you can connect from a browser on another computer:
```
./$LLAMA_SERVER_ONE --host 0.0.0.0
```

After starting up and loading the model, it should display:

**main: server is listening on http://0.0.0.0:8080 - starting the main loop**<br/>
**srv  update_slots: all slots are idle**

Hit `ctrl-C` on your keyboard to stop it.

---
### Copy llama-server-one for Deployment
Congratulations! You are ready to copy `llams-server-one` executable to the share for deployment.

```
sudo cp llama-server-one /mnt/hyperv/Mmojo-Raspberry-Pi/Mmojo-LLMs
sudo cp llama-server-one /mnt/hyperv/Mmojo-Raspberry-Pi/Mmojo-LLMs/llama-server-one.exe
printf "\n**********\n*\n* FINISHED: Copy llama-server-one for Deployment.\n*\n**********\n\n"
```

---
### Next Step: Package llama-server-one for Deployment
Congratulations! You are ready to package your llams-server-one executable for deployment. Follow instructions in [Package-ls1.md](Package-ls1.md).

