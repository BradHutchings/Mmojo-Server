## mmojo-server (née llama-server-one)
Based on [llama.cpp](https://github.com/ggml-org/llama.cpp).

Brad Hutchings<br/>
brad@bradhutchings.com

---
### Project Goals

The goal of this project is to build a single `mmojo-server` executable file that can run "anywhere":
- x86_64 Windows
- x86_64 Linux
- ARM Windows
- ARM Linux
- ARM MacOS

I am inspired by the [llamafile project](https://github.com/Mozilla-Ocho/llamafile). The main drawback of that project is that it has not kept up-to-date with llama.cpp and therefore, does not always support the latest models when llama.cpp supports them. Support for new models in llamafile takes work and time.

I want to use the MIT license as used by llama.cpp.

GPU support is not important to me and can be handled by platform specific builds of llama.cpp. CPU inference is quite adequate for many private end-user applications. Generic CPU inference is implemented. ARM and x86 tuned CPU inference is not implemented yet.

The ability to package support files, such as a custom web UI into the executable file is important to me. This is implemented.

The ability to package default arguments, in an "args" file, into the executable file is important to me. This is implemented.

The ability to read arguments from a file adjacent to the executable file is important to me. This is implemented.

The ability to package a gguf model into the executable file is important to me. This is not implemented yet.

I welcome any of my changes being implemented in the official llama.cpp.

---
### Documentation
Follow these guides in order to build, package, and deploy `mmojo-server`:
- My start-to-finish guide for building `mmojo-server` with Cosmo is in the [Build Steps](docs/Build-mmojo-server.md) file.
- My guide for configuring a `mmojo-server` executable is in the [Configure Steps](docs/Configure-mmojo-server.md) file.
- My guide for packaging a `mmojo-server` executable for deployment is in the [Package Steps](docs/Package-mmojo-server.md) file.

---
### Modifications to llama.cpp

To get this from the llama.cpp source base, there are few files that need to be modified:

1. [Makefile](Makefile) -- Extensive modifications to bring up to date, as it is deprecated in favor of a CMake system, and to support COSMOCC.

2. [common/common.cpp](common/common-mmojo.cpp) -- Added COSMOCC build support.

3. [common/common.h](common/common-mmojo.h) -- Added a paramter for sleep after each batch.

4. [src/llama-context.cpp](src/llama-context-mmojo.cpp) -- COSMOCC doesn't have std::fill in its Standard Templates Library.

5. [src/llama-hparams.cpp](src/llama-hparams-mmojo.cpp) -- COSMOCC doesn't have std::max in its Standard Templates Library.

6. [tools/server/server.cpp](tools/server/server-mmojo.cpp) -- Support embedded or adjacent "args" file, fix Cosmo name conflict with "defer" task member, add additional meta data to `model_meta`.

7. [ggml/src/ggml-cpu/arch/cosmo](ggml/src/ggml-cpu/arch/cosmo) -- Added a cosmo architecture for GGML CPU that uses generic code to compile for both ARM and x86.

8. [completion-ui](completion-ui) -- Default UI is Mmojo Completion.

9. [tools/server/public_legacy/loading-mmojo.html](tools/server/public_legacy/loading-mmojo.html) -- Loading page matches Mmojo Completion theme.

---
### Reference

Here are some projects and pages you should be familiar with if you want to get the most out of `mmojo-server`:
- [llama.cpp](https://github.com/ggml-org/llama.cpp) - Georgi Gerganov and his team are the rock stars who are making the plumbing so LLMs can be available for developers of all kinds. The `llama.cpp` project is the industry standard for inference. I only fork it here because I want to make it a little better for my applications while preserving all its goodness.
- [llamafile](https://github.com/Mozilla-Ocho/llamafile) - `Llamafile` lets you distribute and run LLMs with a single file. It is a Mozilla Foundation project that brough the Cosmopolitan C Library and llama.cpp together. It has some popular GPU support. It is based on an older version of llama.cpp and does not support all of the latest models supported by llama.cpp. Llamafile is an inspiration for this project.
- [Cosmopolitan Libc](https://github.com/jart/cosmopolitan) - `Cosmopolitan` is a project for building cross-platform binaries that run on x86_64 and ARM architectures, supporting Linux, Windows, macOS, and other operating systems. Like `llamafile`, I use Cosmo compile cross-platform executables of `llama.cpp` targets, including `llama-server`.
- [Actually Portable Executable (APE) Specification](https://github.com/jart/cosmopolitan/blob/master/ape/specification.md) - Within the Cosmopolitan Libc repo is documentation about how the cross CPU, cross platform executable works.
- [Brad's LLMs](https://huggingface.co/bradhutchings/Brads-LLMs) - I share private local LLMs built with `llamafile` in a Hugging Face repo.

---
### To Do List

In no particular order of importance, these are the things that bother me:
- Package gguf file into executable file. The zip item needs to be aligned for mmap. There is a zipalign.c tool source in llamafile that seems loosely inspired by the Android zipalign too. I feel like there should be a more generic solution for this problem.
- GPU support without a complicated kludge, and that can support all supported platform / CPU / GPU triads. Perhaps a plugin system with shared library dispatch? Invoking dev tools on Apple Metal like llamafile does is "complicated".
- Code signing instructions. Might have to sign executables within the zip package, plus the package itself.
- Clean up remaining build warnings, either by fixing source (i.e. Cosmo) or finding the magical compiler flags.
- Copy the `cosmo_args` function into `server.cpp` so it could potentially be incorporated upstream in non-Cosmo builds. `common/arg2.cpp` might be a good landing spot. License in [Cosmo source code](https://github.com/jart/cosmopolitan/blob/master/tool/args/args2.c) appears to be MIT compatible with attribution.
  - The args thing is cute, but it might be easier as a yaml file. Key value pairs. Flags can be keys with null values.
- The `--ctx-size` parameter doesn't seem quite right given that new models have the training (or max) context size in their metadata. That size should be used subject to a maximum in a passed parameter. E.g. So a 128K model can run comfortably on a smaller device.
- Write docs for a Deploying step. It should address the args file, removing the extra executable depending on platform, models, host, port. context size.
- ~~Make a `.gitattributes` file so we can set the default file to be displayed and keep the README.md from llama.cpp. This will help in syncing changes continually from upstream. Reference: https://git-scm.com/docs/gitattributes~~ -- This doesn't actually work.
- ~~Cosmo needs libssl and libcrypto. Building these from scratch gets an error about Cosco not liking assembly files. Sort this out.~~ Implemented.
