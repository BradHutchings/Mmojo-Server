## Mmojo Server Instructions &ndash; Table of Contents
**THESE ARE OLD INSTRUCTIONS FROM MMOJO SERVER V1 AND V2. SOME PORTIONS REMAIN HERE FOR REFERENCE. OTHERS WILL BE REMOVED WHEN NO LONGER NEEDED.**

The Mmojo Server project is mostly my instructions (aka "documentation"), with lots of functioning scripts to work out the gory details. The instructions are organized to be worked through sequentially from start to finish. I'll tell you what the point of this project is, help you prepare your build environment, gather things you'll need, build Mmojo Server, then package it for deployment. Read the instructions on GitHub. You will be instructed to clone this repo to a specific directory on your build machine(s) later.

You really can't do much with this project without R-ing TFM. So [jump in and read](101-Project-Goals.md)! Then start doing! Links to next topics are at the bottom of each page. Table of Contents is below for your reference.

-Brad<br/>
--<br/>
Brad Hutchings<br/>
brad@bradhutchings.com

---
### [100. Overview](100-Overview.md)
This is an overview of what this repository is about, how to work with it, what to contribute, etc. Read this first before diving in!

- [106. Contribute and Sponsor](106-Contribute-and-Sponsor.md) - About contributing to this project and sponsoring my work.

---
### [200. Prepare Build Environment](200-Prepare-Build-Environment.md)
Before you can build Mmojo Server, you need a build environment. Depending on what you want to build, it could be a single computer or multiple computers. You should have a separate share on your network to keep files you only need to download once, and keep the products of your builds. You may find yourself rebuilding your build environments regularly, especially if you edit or enhance code and instructions in the repo.

- [201. Prepare WSL](201-Prepare-WSL.md) - Prepare your Windows Subsystem for Linux (WSL) environment if you're using one.
- [202. Prepare macOS](202-Prepare-macOS.md) - Prepare your macOS environment if you're using one.
- [203. Create Scripts Directory](203-Create-Scripts-Directory.md) - Create `$HOME/mmscripts` directory, then add it to your `$PATH`.
- [204. Clone Mmojo Server Repo](204-Clone-Mmojo-Server-Repo.md) - Clone Mmojo Server Repo for setup and build scripts.
- [205. Set Timezone](205-Set-Timezone.md) - Set your build system's time zone so Completion UI reflects correct build date.
- [206. Create Mmojo Share](206-Create-Mmojo-Share.md) - Create a file share to support multiple build environments.
- [207. Mount Mmojo Share](207-Mount-Mmojo-Share.md) - Mount a file share to support multiple build environments.
- [208. Install Dependencies](208-Install-Dependencies.md) - Install packages needed for your build system.
- [209. mm- Scripts](209-mm-Scripts.md) - All about those `mm-` scripts in your `$HOME/mm-scripts` directory.

---
### [300. Gather Build Pieces](300-Gather-Build-Pieces.md)
Prepare things needed to build Mmojo Server executables. **You only need to do these steps once (in awhile).**

- [301. Download Models](301-Download-Models.md) - Download `.gguf` model files from Hugging Face and copy them to your Mmojo share.
- [302. Copy Models](302-Copy-Models.md) - Copy `.gguf` model files from your Mmojo share.
- [303. Copy Certificates](303-Copy-Certificates.md) - Copy SSL certificate files from your Mmojo share.
- [304. Build Cosmopolitan](304-Build-Cosmopolitan.md) - Patch Cosmopolitan and build it.
- [305. Build OpenSSL](305-Build-OpenSSL.md) - Build OpenSSL static libraries with Cosmopolitan.
- [306. Install CUDA Toolkit](306-Install-CUDA-Toolkit.md) - Install NVIDIA's CUDA Toolkit.
- [307. Build Vulkan SDK](307-Build-Vulkan-SDK.md) - Build Vulkan SDK for platform optimized builds.

---
### [400. Gather Models](400-Gather-Models.md)
Gather pre-built models from the Mmojo Share and use llama.cpp and Hugging Face to build some .gguf models we can use with Mmojo Server.
- [401. Prepare to Connvert](401-Prepare-to-Convert.md) - Clone the llama.cpp GitHub repo, and leave it uncustomized so we can convert with it.
- [402. Google Gemma](402-Google-Gemma.md) - Clone Google's Gemma Repos on Hugging Face, convert to `.gguf` models.
- [403. Meta Llama](403-Meta-Llama.md) - Clone Meta's Llama Repos on Hugging Face, convert to `.gguf` models.
- [404. Mistral AI Ministral](404-Mistral-AI-Ministral.md) - Clone Mistral AI's Ministral Repos on Hugging Face, convert to `.gguf` models.

---
### [500. Build Mmojo Server](500-Build-Mmojo-Server.md)
Build Mmojo Server executables.

- [501. Prepare to Build](501-Prepare-to-Build.md) - Clone llama.cpp repo, fix some things, and copy some things.
- [502. Prepare to Test](502-Prepare-to-Test.md) - Set some environment variables to customize test runs.
- [510. Platform Builds](510-Platform-Builds.md) - Explains build-platform executables and how to build them. Now with GPU choices and support.
  - [511. Platform (Compatible)](511-Platform-Compatible.md) - Build `mmojo-server` for the base CPU of the build environment platform.
  - [512. Platform (Performant)](512-Platform-Performant.md) - Build `mmojo-server` for recent CPUs from the CPU family of the build environment platform.
  - [513. Platform (Native)](513-Platform-Native.md) - Build `mmojo-server` highly optimized for the CPU of the build environment platform.<br/><br/>

---
[MIT License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
