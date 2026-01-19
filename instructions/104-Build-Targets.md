## 104. Build Targets
### Why Build Targets, Plural?
The obvious question is why there need to be build targets if we have Actually Portable Executable (APE) files that run anywhere. The answer is performance. APE files gives us simple deployment at the cost of performance. 

- Because the builds inside them have to be statically linked, we can't, for example, dynamically link against GPU drivers. The original llamafile was able to provide Metal support on Apple M* silicon, but it had to do dynamic compilation on the user's Mac to provide that support. This made installation and maintenance of llamafiles precarious for non-technical users and occasional developers running on Macs. Clever approach, not that workable in practice.

- We can't tune to a particular CPU, as the APE needs to run on a wide variety of x86_64 and aarch64 (arm64) machines.

---
### Benchmarks
I have a home-grown benchmark for evaluating my Mmojo Server builds. It is using Mmojo Complete to summarize a particular one-hour podcast transcript. The transcript comes from YouTube and has been massaged to remove timestamps and other formatting. I time how long the evaluating step takes.

Here are the results of running the benchmark in a Windows Subsystem for Linux (WSL) instance on my 12-gen i7-12700H Dell Laptop with 64 GB RAM and NVIDIA GeForce RTX 3050 Laptop GPU (4 GB GPU RAM). I run an unoptimized "Debug" build, an APE, an optimized CPU Build, and an optimized CPU with CUDA build. `mmojo-server` is invoked with the default number of available threads, which are half (10) the CPU threads available (20) on this system. The input has 17,272 tokens. I'm using Google Gemma 1B Instruct v3 (`Google-Gemma-1B-Instruct-v3-q8_0.gguf`), which you'll typically use to test builds.

| Build              | Evaulation Time | Notes                                                 |
| :-------           | ------:         | -------:                                              |
| Unoptimized Debug  | 24:17           | Tuned CPU but unoptimized compile.                    |
| APE                | 11:34           | Static libraries and generic optimized compile.       |
| Optimized CPU      |  1:45           | Compiler can save a lot of work for a particular CPU. |
| CUDA               |  0:07           | This is what users eventually want.                   |

Same benchmarks on a Raspberry Pi 5 (8 GB RAM), running 4 threads. There is no workable GPU path on stock Pi 5.

| Build              | Evaulation Time | Notes                                                 |
| :-------           | ------:         | -------:                                              |
| Unoptimized Debug  | 1:31:30         | Tuned CPU but unoptimized compile.                    |
| APE                |   13:26         | On $150-ish worth of compute vs. $1200 above.         |
| Optimized CPU      |    7:13         | Compiler can save a lot of work for a particular CPU. |

Same benchmarks for a GKMTec NUC with Intel N97, 12 GB RAM, running 4 threads. No GPU available.

| Build              | Evaulation Time | Notes                                                 |
| :-------           | ------:         | -------:                                              |
| Unoptimized Debug  | 1:00:20         | Tuned CPU but unoptimized compile.                    |
| APE                |   44:58         | On $220-ish worth of compute vs. $150 Raspberry Pi.   |
| Optimized CPU      |    7:49         | Compiler can save a lot of work for a particular CPU. |

Notice how mighty the little Raspberry Pi 5 is on CPU performance!

*Note: I'm working out how to specify the CPU architecture level for the APE builds, whether it makes sense to support anything before x86-64-v3, and whether that would be adequate for CPU builds. Most users would then only download to replace the APE to use GPU. That exploration is in progress now.*

---
### Build Targets
These instructions will help you build:
- APE file that runs on a wide range of x86_64 and aarch64 (arm64) machines, across Linux, Windows, and macOS.
  - This is a good choice for a getting started deployment, where performance is less important than just running. Developers seeking to replace expensive cloud LLMs or just not use them in the first place should be able to validate their development use case with a Mmojo Server APE file containing the LLM they wish to try. Zero configuration required.
- CPU-tuned and optimized build runs faster than the APE build on x86_64 or aarch64 Linux. It can be packaged with a `mmojo-server-support` directory containing user interface, certificates, default configuration, and other supporting files for easy unzip then run deployment.
- CUDA builds are CPU optimized builds that add support for NVIDIA GPUs when present.
- Vulkan builds are CPU optimized builds that theoretically add support for any GPU with a Vulkan driver. They are also just like CPU optimized builds. In practice, the Vulkan builds require a minimum number of shaders that many embedded "AI enabled" devices don't support. Vulkan support inside WSL is hacky and doesn't work with llama.cpp.

---
### Future Build Targets
In the future, these instructions will help you build:
- Untuned CPU builds, compiler optimized that run well on a single operating system and CPU family. These won't be hindered by static linking, as the APE builds are.
- Mac builds with Metal enabled. Unified memory is the best bang for the buck in local, private LLMs.
- Linux builds for AMD Ryzen AI Max PRO, with GPU enabled. More unified memory for the value win.
- Windows native builds. For now, I recommend using the APE for small LLMs, and WSL where possible. We will need a separate instructions and script track for Windows native.

**The best thing you can do to speed these up is to become a paid sponsor of Mmojo Server.**

---
### Proceed
- **Next:** [105. Packaging for Deployment](105-Packaging-for-Deployment.md) 
- **Previous:** [103. Build Environment](103-Build-Environment.md)
- **Up:** [100. Overview](100-Overview.md)

---
[MIT License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
