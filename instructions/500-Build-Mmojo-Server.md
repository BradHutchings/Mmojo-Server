## 500. Build Mmojo Server
### About this Section
**THESE ARE OLD INSTRUCTIONS FROM MMOJO SERVER V1 AND V2. SOME PORTIONS REMAIN HERE FOR REFERENCE.**

We're ready to build `mmojo-server` executables. First, we'll build a native version for the build environment platfrom that can be used to test features and changes. Then, we'll build an Actually Portable Executable (APE) with Cosmopolitan that will run anywhere. After that, we'll build unoptimized linux builds for x86_64 and aarch64 (arm64) platforms, as well as optimized builds for specific devices like macOS and Raspberry Pi.

#### Experimental &mdash; llama-server
If you would like to build a vanilla llama-server with a traditional chat-style interface, check out the [llama-server track](llama-server/500-Build-llama-server.md). This is the easiest way to build llama-server and other llama.cpp executables for your computer. I keep up with the ever-evolving llama.cpp so you don't have to.

#### Experimental &mdash; Doghouse
If you would like to build a less branded and opinionated version of llama.cpp, I offer **Doghouse**. It's intended as an example branded server I am offering to paid sponsors of Mmojo Server. Let's work out a sponsorship deal and what you'd like in your custom branded server!

[Jump to these instructions](doghouse/500-Build-Doghouse.md) to build a Doghouse server with a traditional chat-style user interface.

---
### Build Mmojo Server
Here are the things you need to do:
- [501. Prepare to Build](501-Prepare-to-Build.md) - Clone llama.cpp repo, fix some things, and copy some things.
- [502. Prepare to Test](502-Prepare-to-Test.md) - Set some environment variables to customize test runs.
- [510. Platform Builds](510-Platform-Builds.md) - Explains build-platform executables and how to build them. Now with GPU choices and support.
  - [511. Platform (Compatible)](511-Platform-Compatible.md) - Build `mmojo-server` for the base CPU of the build environment platform.
  - [512. Platform (Performant)](512-Platform-Performant.md) - Build `mmojo-server` for recent CPUs from the CPU family of the build environment platform.
  - [513. Platform (Native)](513-Platform-Native.md) - Build `mmojo-server` highly optimized for the CPU of the build environment platform.<br/><br/>

**Get Started:** [501. Prepare to Build](501-Prepare-to-Build.md)

---
[MIT License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
