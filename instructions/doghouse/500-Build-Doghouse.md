## 500. Build Doghouse
### About Doghouse
**Doghouse** is an example of a branded developer experience. You can build Mmojo Server without the Mmojo Server customizations like Mmojo Complete, and package it in an APE file of a different name. I'm working on some very minor customization details like the process name reported to the operating system and the name of the support directory. If you'd like to become a sponsor of Mmojo Server, this is a zero-work on your part branding opportunity.

---
### About this Section
We're ready to build `doghouse` executables. First, we'll build a native version for the build environment platfrom that can be used to test features and changes. Then, we'll build an Actually Portable Executable (APE) with Cosmopolitan that will run anywhere.

---
### Build Doghouse
Here are the things you need to do:
- [501. Prepare to Build](501-Prepare-to-Build.md) - Clone llama.cpp repo, fix some things, and copy some things.
- [502. Prepare to Test](502-Prepare-to-Test.md) - Set some environment variables to customize test runs.
- [503. Debug Build](503-Debug-Build.md) - Build an unoptimized `doghouse` for the CPU of the build environment platformm that can be used to test features and changes.<br/><br/>
- [520. APE Builds](520-APE-Builds.md) - Explains Actual Portable Executables (APEs) and how to build them.
  - [521. APE (Compatible)](521-APE-Compatible.md) - Build `doghouse-ape` as an APE with Cosmopolitan. This build is widely compatible with x86_64 and aarch64 (arm64) systems, but not very performant.
  - [522. APE (Performant)](522-APE-Performant.md) - Build `doghouse-ape` as an APE with Cosmopolitan. This build is compatible with recent x86_64 and aarch64 (arm64) systems and more performant.<br/><br/>

**Get Started:** [501. Prepare to Build](501-Prepare-to-Build.md)

---
[MIT License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
