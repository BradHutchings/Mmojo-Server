## 500. Build llama-server
### About llama-server
**llama-server** is the project upon which Mmojo Server builds. This build and package track is intended to be the easiest way to build llama.cpp, especially for developers who don't build it on a continual basis.

---
### About this Section
We're ready to build `llama-server` executables. First, we'll build a native version for the build environment platfrom that can be used to test features and changes. Then, we'll build an Actually Portable Executable (APE) with Cosmopolitan that will run anywhere.

---
### Build llama-server
Here are the things you need to do:
- [501. Prepare to Build](501-Prepare-to-Build.md) - Clone llama.cpp repo, fix some things, and copy some things.
- [502. Prepare to Test](502-Prepare-to-Test.md) - Set some environment variables to customize test runs.
- [503. Debug Build](503-Debug-Build.md) - Build an unoptimized `llama-server` for the CPU of the build environment platformm that can be used to test features and changes.<br/><br/>
- [510. Platform Builds](510-Platform-Builds.md) - Explains build-platform executables and how to build them. Now with GPU choices and support.
  - [511. Platform (Compatible)](511-Platform-Compatible.md) - Build `llama-server` for the base CPU of the build environment platform.
  - [512. Platform (Performant)](512-Platform-Performant.md) - Build `llama-server` for recent CPUs from the CPU family of the build environment platform.
  - [513. Platform (Native)](513-Platform-Native.md) - Build `llama-server` highly optimized for the CPU of the build environment platform.<br/><br/>
- [520. APE Builds](520-APE-Builds.md) - Explains Actual Portable Executables (APEs) and how to build them.
  - [521. APE (Compatible)](521-APE-Compatible.md) - Build `mmojo-server-ape` as an APE with Cosmopolitan. This build is widely compatible with x86_64 and aarch64 (arm64) systems, but not very performant.
  - [522. APE (Performant)](522-APE-Performant.md) - Build `mmojo-server-ape` as an APE with Cosmopolitan. This build is compatible with recent x86_64 and aarch64 (arm64) systems and more performant.<br/><br/>

**Get Started:** [501. Prepare to Build](501-Prepare-to-Build.md)

---
[MIT License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
