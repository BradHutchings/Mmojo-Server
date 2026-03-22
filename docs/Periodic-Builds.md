## Periodic Builds
### About this Document
This document identifies the periodic builds, when to build them, how to build them, and where to store them.

---
### Mmojo-Server-ape.zip
- **What:** APE build runs on all platforms and CPUs.
- **When:** This should be rebuilt after each sync of llama.cpp.
- **Where:** Build in Windows-WSL environment.
- **How:**
  - Complete a fresh [Windows-WSL deployment](/deploy/Windows-WSL/README.md) after llama.cpp sync.
  - Build with [APE recipe](/build/all-platforms/README.md).
  - Upload `Mmojo-Server-ape.zip` to Hugging Face repo.

---
### Mmojo-Server-x86_64-comp-cud.zip
- **What:** Compatible CUDA x86_64 build runs on Linux x86_64, NVIDIA GPU supported, but optional.
- **When:** This should be rebuilt after each sync of llama.cpp.
- **Where:** Build in Windows-WSL environment.
- **How:**
  - Complete a fresh [Windows-WSL deployment](/deploy/Windows-WSL/README.md) after llama.cpp sync.
  - Build with [elf-debian recipe](/build/elf-debian/README.md), CUDA GPUs, compatible.
  - Upload `Mmojo-Server-x86_64-comp-cud.zip` to Hugging Face repo.

---
### Mmojo-Server-x86_64-perf-cud.zip
- **What:** Performant CUDA x86_64 build runs on Linux x86_64, NVIDIA GPU supported, but optional.
- **When:** This should be rebuilt after each sync of llama.cpp.
- **Where:** Build in Windows-WSL environment.
- **How:**
  - Complete a fresh [Windows-WSL deployment](/deploy/Windows-WSL/README.md) after llama.cpp sync.
  - Build with [elf-debian recipe](/build/elf-debian/README.md), CUDA GPUs, performant.
  - Upload `Mmojo-Server-x86_64-perf-cud.zip` to Hugging Face repo.

---
### Mmojo-Server-x86_64-native-cud.zip
- **What:** Native CUDA x86_64 build runs on Linux x86_64, NVIDIA GPU supported, but optional.
- **When:** This should be rebuilt after each sync of llama.cpp.
- **Where:** Build in Windows-WSL environment.
- **How:**
  - Complete a fresh [Windows-WSL deployment](/deploy/Windows-WSL/README.md) after llama.cpp sync.
  - Build with [elf-debian recipe](/build/elf-debian/README.md), CUDA GPUs, performant.
  - Keep this package available for use with OpenClaw.

---
### Mmojo-Server-aarch64-comp-cud.zip
- **What:** Compatible CUDA aarch64 build runs on Linux aarch64, NVIDIA GPU supported, but optional.
- **When:** This should be rebuilt after each sync of llama.cpp.
- **Where:** Build on Raspberry Pi 5.
- **How:**
  - Run these:
    ```
    mm-repo-update-local.sh
    if [ "$BUILD_DIR" != "" ] && [ -d "$BUILD_DIR" ]; then
        rm -r -f "$BUILD_DIR"
    fi
    ```
  - Build with [elf-debian recipe](/build/elf-debian/README.md), CUDA GPUs, compatible. Don't build for Raspberry Pi.
  - Upload `Mmojo-Server-aarch64-comp-cud.zip` to Hugging Face repo.

**Note:** Brad's Raspberry Pi 5 has 128 GB storage, which can only hold one CUDA build at a time.

---
### Mmojo-Server-aarch64-perf-cud.zip
- **What:** Performant CUDA aarch64 build runs on Linux aarch64, NVIDIA GPU supported, but optional.
- **When:** This should be rebuilt after each sync of llama.cpp.
- **Where:** Build on Raspberry Pi 5.
- **How:**
  - Run these:
    ```
    mm-repo-update-local.sh
    if [ "$BUILD_DIR" != "" ] && [ -d "$BUILD_DIR" ]; then
        rm -r -f "$BUILD_DIR"
    fi
    ```
  - Build with [elf-debian recipe](/build/elf-debian/README.md), CUDA GPUs, performant. Don't build for Raspberry Pi.
  - Upload `Mmojo-Server-aarch64-perf-cud.zip` to Hugging Face repo.

**Note:** Brad's Raspberry Pi 5 has 128 GB storage, which can only hold one CUDA build at a time.

---
### Mmojo-Server-aarch64-rpi5.zip
- **What:** Native Raspberry Pi 5..
- **When:** This should be rebuilt after each sync of llama.cpp.
- **Where:** Build on Raspberry Pi 5.
- **How:**
  - Run these:
    ```
    mm-repo-update-local.sh
    if [ "$BUILD_DIR" != "" ] && [ -d "$BUILD_DIR" ]; then
        rm -r -f "$BUILD_DIR"
    fi
    ```
  - Build with [elf-debian recipe](/build/elf-debian/README.md), No GPUs, native. Build for Raspberry Pi.
  - Upload `Mmojo-Server-aarch64-rpi5.zip` to Hugging Face repo.

**Note:** Brad's Raspberry Pi 5 has 128 GB storage, which can only hold one CUDA build at a time.



---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
