## Build mmojo-server

Brad Hutchings<br/>
brad@bradhutchings.com

This file contains instructions for building `llama.cpp` with `cosmocc` to yield a `mmojo-server` executable that will run on multiple platforms.

### Environment Variables

Let's define some environment variables, resetting those that affect the Makefile:
```
DOWNLOAD_DIR="0-DOWNLOAD"
BUILD_DIR="1-BUILD-mmojo-server"
printf "\n**********\n*\n* FINISHED: Environment Variables.\n*\n**********\n\n"
```

_Note that if you copy each code block from the guide and paste it into your terminal, each block ends with a message so you won't lose your place in this guide._

---
### Build Dependencies
I build with a freshly installed Ubuntu 24.04 VM. Here are some packages that are helpful in creating a working build system. You may need to install more.
```
sudo apt install -y git python3-pip build-essential zlib1g-dev \
    libffi-dev libssl-dev libbz2-dev libreadline-dev libsqlite3-dev \
    liblzma-dev tk-dev python3-tk cmake zip npm
printf "\n**********\n*\n* FINISHED: Build Dependencies.\n*\n**********\n\n"
```

---
### Clone this Repo Locally
Clone this repo into a `~\1-BUILD-mmojo-server` directory.
```
cd ~
git clone https://github.com/BradHutchings/llama-server-one.git $BUILD_DIR
printf "\n**********\n*\n* FINISHED: Clone this Repo Locally.\n*\n**********\n\n"
```

Install repos this repo depends upon locally.
```
git clone https://github.com/nlohmann/json.git ~/$BUILD_DIR/nlohmann-json
git clone https://github.com/google/minja.git ~/$BUILD_DIR/google-minja
git clone https://github.com/yhirose/cpp-httplib.git ~/$BUILD_DIR/cpp-httplib
git clone https://github.com/mackron/miniaudio.git ~/$BUILD_DIR/miniaudio
git clone https://github.com/nothings/stb.git ~/$BUILD_DIR/stb
sed -i -e 's/#if defined(_WIN32) || defined(__COSMOPOLITAN__)/#if defined(_WIN32)/g' ~/$BUILD_DIR/miniaudio/miniaudio.h
printf "\n**********\n*\n* FINISHED: Install Additional Repos Locally.\n*\n**********\n\n"
```

**Optional:** Use the `work-in-progress` branch where I implement and test my own changes and where I test upstream changes from `llama.cpp`.
```
cd ~/$BUILD_DIR
git checkout work-in-progress
printf "\n**********\n*\n* FINISHED: Checkout work-in-progress.\n*\n**********\n\n"
```

Patch `ggml-cpu/cosmo` with latest generic ggml-cpu code.
```
mkdir -p ggml/src/ggml-cpu/arch/cosmo
cp ggml/src/ggml-cpu/repack.cpp ggml/src/ggml-cpu/arch/cosmo/
cp ggml/src/ggml-cpu/quants.c ggml/src/ggml-cpu/arch/cosmo/
sed -i -e "s/_generic//g" ggml/src/ggml-cpu/arch/cosmo/repack.cpp 
sed -i -e "s/_generic//g" ggml/src/ggml-cpu/arch/cosmo/quants.c 
printf "\n**********\n*\n* FINISHED: Patch ggml-cpu/cosmo.\n*\n**********\n\n"
```

<!--
**Optional:** Patch `tools/server/server-ls1.cpp` for building `mmojo-server`. In the future, we'll move the Mmojo Completion UI into this repo and rename the repo, target, etc.
```
sed -i -e "s/\"llama-server-one\"/\"mmojo-server\"/g" tools/server/server-ls1.cpp 
sed -i -e "s/\"llama-server-one-args\"/\"mmojo-server-args\"/g" tools/server/server-ls1.cpp 
printf "\n**********\n*\n* FINISHED: Patch tools/server/server-ls1.cpp.\n*\n**********\n\n"
```
-->

---
### Customize WebUI
```
APP_NAME='Mmojo Chat'
sed -i -e "s/<title>.*<\/title>/<title>$APP_NAME<\/title>/g" tools/server/webui/index.html
sed -i -e "s/>llama.cpp<\/div>/>$APP_NAME<\/div>/g" tools/server/webui/src/components/Header.tsx
cd tools/server/webui
npm i
npm run build
cd ~/$BUILD_DIR
printf "\n**********\n*\n* FINISHED: Customize WebUI.\n*\n**********\n\n"
```

---
### OPTIONAL: Build llama.cpp
We won't use what we build here, but it will validate that the source code for llama.cpp compiles. It takes a few minutes. We use the old `Makefile` rather than CMake. We've updated the `Makefile` in this repo to build llama.cpp correctly.
```
cd ~/$BUILD_DIR
export LLAMA_MAKEFILE=1
export LLAMA_SERVER_SSL=ON
make clean
make
printf "\n**********\n*\n* FINISHED: Build llama.cpp.\n*\n**********\n\n"
```

If the build is successful, it will end with this message:

&nbsp;&nbsp;&nbsp;&nbsp;**NOTICE: The 'server' binary is deprecated. Please use 'llama-server' instead.**

If the build fails and you've checked out the `work-in-progress` branch, well, it's in progess, so switch back to the `master` branch and build that.

If the build fails on the `master` branch, please post a note in the [Discussions](https://github.com/BradHutchings/llama-server-one/discussions) area.

#### List Directory

At this point, you should see `llama-server` and other built binaries in the directory listing.
```
ls -al llama-* mmojo-*
printf "\n**********\n*\n* FINISHED: List Directory.\n*\n**********\n\n"
```

---
### Install Cosmo
If we haven't previously downloaded `cosmocc.zip`, download it to `~/$DOWNLOAD_DIR`. Then copy the `.zip` file to the build directory and unzip it.

```
mkdir -p ~/$DOWNLOAD_DIR
mkdir -p ~/$BUILD_DIR/cosmocc
cd ~/$DOWNLOAD_DIR
if [ ! -f cosmocc.zip ]; then wget https://cosmo.zip/pub/cosmocc/cosmocc.zip; fi
cd ~/$BUILD_DIR/cosmocc
cp ~/$DOWNLOAD_DIR/cosmocc.zip .
unzip cosmocc.zip
rm cosmocc.zip
cd ~/$BUILD_DIR
printf "\n**********\n*\n* FINISHED: Install Cosmo.\n*\n**********\n\n"
```

---
### Prepare to Build llama.cpp with Cosmo
```
export PATH="$(pwd)/cosmocc/bin:$PATH"
export CC="cosmocc -I$(pwd)/cosmocc/include -L$(pwd)/cosmocc/lib"
export CXX="cosmocc -I$(pwd)/cosmocc/include \
    -I$(pwd)/cosmocc/include/third_party/libcxx \
    -L$(pwd)/cosmocc/lib -L$(pwd)/openssl"
export AR="cosmoar"
export UNAME_S="cosmocc"
export UNAME_P="cosmocc"
export UNAME_M="cosmocc"
printf "\n**********\n*\n* FINISHED: Prepare to Build llama.cpp with Cosmo.\n*\n**********\n\n"
```

---
### Build openssl with Cosmo
We need cross-architectire `libssl` and `libcrypto` static libraries to support SSL in `llama-server-one`.
```
cd ~/$BUILD_DIR
cp -r /usr/include/openssl/ ./cosmocc/include/
cp -r /usr/include/x86_64-linux-gnu/openssl/* ./cosmocc/include/openssl
git clone https://github.com/openssl/openssl.git
cd ~/$BUILD_DIR/openssl
./Configure no-asm no-dso no-afalgeng no-shared no-pinshared no-apps
make
cd ~/$BUILD_DIR
printf "\n**********\n*\n* FINISHED: Build openssl with Cosmo.\n*\n**********\n\n"

```

---
### Build mmojo-server with Cosmo
```
make clean
make mmojo-server
printf "\n**********\n*\n* FINISHED: Build mmojo-server with Cosmo\n*\n**********\n\n"
```

**Optional:** Build other llama.cpp binaries with Cosmo.
```
make
printf "\n**********\n*\n* FINISHED: Build other llama.cpp binaries with Cosmo\n*\n**********\n\n"
```

If the "Build other llama.cpp binaries" step is successful, it will end with this message:

&nbsp;&nbsp;&nbsp;&nbsp;**NOTICE: The 'server' binary is deprecated. Please use 'llama-server' instead.**

If the build fails and you've checked out the `work-in-progress` branch, well, it's in progess, so switch back to the `master` branch and build that.

If the build fails on the `master` branch, please post a note in the [Discussions](https://github.com/BradHutchings/llama-server-one/discussions) area.

#### List Directory

At this point, you should see `mmojo-server` and other built binaries in the directory listing.
```
ls -al llama-* mmojo-*
printf "\n**********\n*\n* FINISHED: List Directory.\n*\n**********\n\n"
```

#### Verify Zip Archive

`mmojo-server` is actually a zip acrhive with an "Actually Portable Executable" (APE) loader prefix. Let's verify the zip archive part:
```
unzip -l mmojo-server
printf "\n**********\n*\n* FINISHED: Verify Zip Archive.\n*\n**********\n\n"
```

---
### Next step: Configure mmojo-server

Now that you've built `mmojo-server`, you're ready to configure it. Follow instructions in [Configure-mmojo-server.md](Configure-mmojo-server.md).
