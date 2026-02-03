## About Mmojo Server

**[Build Mmojo Server Now!](instructions/-Start-Here-TOC.md)**

**[Deploy Mmojo Server + OpenClaw](https://github.com/BradHutchings/Mmojo-Server/blob/main/deploy/500-OpenClaw/README.md)**

Welcome to Mmojo Server version 2! This project makes building and packaging the LLM server and other software from llama.cpp easy and approachable, with some carefully selected extensions and enhancements. Highlights:
- Build and package Actual Portable Executable (APE) files that run on Linux, Windows, macOS operating systems across x86_64 and aarch64 (ARM64) architectures.
  - I am inspired by the original llamafile project.
  - APE files can contain a .gguf model, user interface, certificates, and other support files &mdash; in one single executable file.
  - Download and run the same executable file on x86_64 Linux and an ARM Raspberry Pi (for example).
- Build and package CPU-optimized and GPU-enabled executables that run on specific operating systems and CPU architectures.
- Coordinate testing and packaging across CPU and OS platforms with a file share on your network.
- Instructions (aka "documentation") are extensive, continually maintained, and easy to follow.
- Mmojo Complete completion-style user interface can be the default UI, with chat-style UI as an end-user option.
- Build the new, less branded, less opinionated **Doghouse** LLM server. Even better, become a sponsor of Mmojo Server, and I'll make a branded open source server with your name on it!
- Mmojo Server version 2 is no longer a Github fork of llama.cpp. Instead, it incorporates a locally cloned llama.cpp repository into its build sequence.

End-users should be able to easily get started with the APE build, then upgrade to an optimized CPU/GPU build for their computer. Developers building Mmojo Server should expect a similar experience.

I want Mmojo Server to be the easiest way for developers to build llama.cpp and to foster greater and wider understanding of how llama.cpp works. I don't want my project to be a hair pulling and muscle flexing exercise for developers like most open source software turns out to be.

I use Mmojo Server for my own consulting and commercial offerings. There is no fluff in this project driven by hypothetical use cases, surveys, or discussion board warriors. I do not solicit or accept pull requests from strangers. I do not use LLMs to write the documentation or provide more than sample code to guide my coding. You can depend on Mmojo Server to be maintained and remain relevant.

<!--
For those of you hoping to find the original Mmojo Server, it is archived here: [Mmojo-Server-v1 repo](https://github.com/BradHutchings/Mmojo-Server-v1). I urge you to switch over to this new version now.
-->

Get started now by diving into the [Mmojo Server Instructions](instructions/-Start-Here-TOC.md). Read through it. Start doing it!

-Brad<br/>
--<br/>
Brad Hutchings<br/>
brad@bradhutchings.com

---
[MIT License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
