## Build llama-server

Brad Hutchings<br/>
brad@bradhutchings.com

This file contains instructions for building `llama.cpp` with `cosmocc` to yield a `llama-server` executable that will run on multiple platforms. Instructions have been customized for my environment. You should use these [Building Instructions](Building-ls1.md).


### Environment Variables

Let's define some environment variables, resetting those that affect the Makefile:
```
DOWNLOAD_DIR="0-DOWNLOAD"
BUILD_DIR="1-BUILD-llama.cpp"
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
Clone this repo into a `~\llama.cpp` directory.
```
cd ~
git clone https://github.com/BradHutchings/llama-server-one.git $BUILD_DIR
printf "\n**********\n*\n* FINISHED: Clone this Repo Locally.\n*\n**********\n\n"
```

**Optional:** Use the `work-in-progress` branch where I implement and test my own changes and where I test upstream changes from `llama.cpp`.
```
cd ~/$BUILD_DIR
git checkout work-in-progress
printf "\n**********\n*\n* FINISHED: Checkout work-in-progress.\n*\n**********\n\n"
```

---
### Customize WebUI
```
APP_NAME='Mmojo Chat'
sed -i -e "s/<title>.*<\/title>/<title>$APP_NAME<\/title>/g" examples/server/webui/index.html
sed -i -e "s/>llama.cpp<\/div>/>$APP_NAME<\/div>/g" examples/server/webui/src/components/Header.tsx
cd examples/server/webui
npm i
npm run build
cd ~/$BUILD_DIR
printf "\n**********\n*\n* FINISHED: Customize WebUI.\n*\n**********\n\n"
```

---
### Make llama.cpp
We use the old `Makefile` rather than CMake. We've updated the `Makefile` in this repo to build llama.cpp correctly.
```
cd ~/$BUILD_DIR
export LLAMA_MAKEFILE=1
export LLAMA_SERVER_SSL=ON
make clean
make
printf "\n**********\n*\n* FINISHED: Make llama.cpp.\n*\n**********\n\n"
```

If the build is successful, it will end with this message:

&nbsp;&nbsp;&nbsp;&nbsp;**NOTICE: The 'server' binary is deprecated. Please use 'llama-server' instead.**

If the build fails and you've checked out the `work-in-progress` branch, well, it's in progess, so switch back to the `master` branch and build that.

If the build fails on the `master` branch, please post a note in the [Discussions](https://github.com/BradHutchings/llama-server-one/discussions) area.

#### List Directory

At this point, you should see `llama-server` and other built binaries in the directory listing.
```
ls -al
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
### Prepare to make llama.cpp with Cosmo
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
printf "\n**********\n*\n* FINISHED: Prepare to make llama.cpp with Cosmo.\n*\n**********\n\n"
```

---
### Make openssl with Cosmo
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
printf "\n**********\n*\n* FINISHED: Make openssl with Cosmo.\n*\n**********\n\n"

```

---
### Make llama.cpp with Cosmo
```
make clean
make
printf "\n**********\n*\n* FINISHED: Make llama.cpp with Cosmo\n*\n**********\n\n"
```

If the build is successful, it will end with this message:

&nbsp;&nbsp;&nbsp;&nbsp;**NOTICE: The 'server' binary is deprecated. Please use 'llama-server' instead.**

If the build fails and you've checked out the `work-in-progress` branch, well, it's in progess, so switch back to the `master` branch and build that.

If the build fails on the `master` branch, please post a note in the [Discussions](https://github.com/BradHutchings/llama-server-one/discussions) area.

#### List Directory

At this point, you should see `llama-server` and other built binaries in the directory listing.
```
ls -al
printf "\n**********\n*\n* FINISHED: List Directory.\n*\n**********\n\n"
```

#### Verify Zip Archive

`llama-server` is actually a zip acrhive with an "Actually Portable Executable" (APE) loader prefix. Let's verify the zip archive part:
```
unzip -l llama-server
printf "\n**********\n*\n* FINISHED: Verify Zip Archive.\n*\n**********\n\n"
```

---
### Next step: Configure llama-server-one

Now that you've built `llama-server`, you're ready to configure it as `llama-server-one`. Follow instructions in [Configure-ls1-Brads-Env.md](Configure-ls1-Brads-Env.md).
