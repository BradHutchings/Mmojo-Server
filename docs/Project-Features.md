## Project Features
### About this Document
This page contains a comprehensive list of project features. These are all additions to the stock llama.cpp project. I note files that are added to or patched into your local copy of the llama.cpp repo before building.

I am very choosy about new features. They need to be necessary. They need to be easy for regular end-users to work with. They need to be maintainable. They need to not be clever hacks. They need to not step on llama.cpp or alter it too much. Mostly, they should not try to do what the llama.cpp team is good at, like optimize the GGML algorithms.

---
### Top Shelf Deploy and Build Instructions
The instructions should make deploying and building an LLM server approachable to even casual developers and hobbyists. It can be a comfortable learning experience and spread knowledge of how these systems work beyond hard-core technical people.

I hope my instructions get you through setting up your environment to support GPUs with CUDA, Vulkan, or (soon!) Metal.

---
### mmojo-server flags
Here are additional flags that can be used when launching `mmojo-server`:
- `--default-ui-endpoint`
  - Specified new endpoint for the chat user interface, since the root endpoint for Mmojo Server is usually the Mmojo Complete user interface.
  - Example: `--default-ui-endpoint /chat`
  - Implemented in: [server-http-mmojo.cpp](/files/tools/server/server-http-mmojo.cpp).
 
- `--batch-sleep-ms`
  - Milliseconds to sleep between evaluation batches. Useful for keeping CPU temperature down on Raspberry Pi.
  - Example: `--batch-sleep-ms 200`
  - Implemented in: [server-context-mmojo.cpp](/files/tools/server/server-context-mmojo.cpp).

- `--show-prompt`
  - If present, the user's prompt will be displayed in diagnostic output stream. This has been useful for figuring out what OpenClaw is trying to accomplish.
  - Example: `--show-prompt`
  - Implemented in: [server-context-mmojo.cpp](/files/tools/server/server-context-mmojo.cpp).
 
- `--show-completion`
  - If present, the finished completion (response) to the user's prompt will be displayed in diagnostic output stream. This has been useful for figuring out what OpenClaw is trying to accomplish.
  - Example: `--show-completion`
  - Implemented in: [server-context-mmojo.cpp](/files/tools/server/server-context-mmojo.cpp).
 
These flags are defined and implemented in these files:
- [arg-mmojo.cpp](/files/common/arg-mmojo.cpp) &mdash; Near bottom of file.
- [common.h](/files/common/common.h) &mdash; Second appearance of `Mmojo Server START`.

---
### Actual Portable Executable (APE) files
Inspired by llamafile, I use the [Cosmopolitan](https://github.com/jart/cosmopolitan) project to create applications that can run anywhere, as described in the introduction to the Cosmopolitan Github repo:

> Cosmopolitan Libc makes C/C++ a build-once run-anywhere language, like Java, except it doesn't need an interpreter or virtual machine. Instead, it reconfigures stock GCC and Clang to output a POSIX-approved polyglot format that runs natively on Linux + Mac + Windows + FreeBSD + OpenBSD 7.3 + NetBSD + BIOS with the best possible performance and the tiniest footprint imaginable.

The APE files are a good starting point for end users because the same binary runs on most computers and can contain an LLM within the file.

- There are additions to [common-mmojo.cpp](/files/common/common-mmojo.cpp) to accommodate this feature.
- There is an additional file [mmojo-args.h](/files/common/mmojo-args.h) to accommodate this feature.
- There is an additional file [mmojo-args.cpp](/files/common/mmojo-args.cpp) to accommodate this feature.

---
### `mmojo-server-args` File and `mmojo-server-support` Directory
These are a way to specify command line defaults and aggregate support files, like the user interface and LLM in the working directory where the `mmojo-server` application is invoked. Like the APE files, these are very helpful for packaging and configuration management.

- There are additions to [server-mmojo.cpp](/files/tools/server/server-mmojo.cpp) to accommodate this feature.
- There is an additional file [mmojo-args.h](/files/common/mmojo-args.h) to accommodate this feature.
- There is an additional file [mmojo-args.cpp](/files/common/mmojo-args.cpp) to accommodate this feature.

---
### Mmojo Complete - Completion User Interface
I hold a currently unpopular opinion that chat interfaces are an abomination. Not in how they're implemented, but in that they make users pretend to have a conversation with a computer in order to extract knowledge from an LLM. I provide an original and powerful Mmojo Complete user interface that can be used as the default user interface, with llama.cpp's traditional chat interface as an option for end-users.

If you have your own preferred UI, you can use the additions to Mmojo Server to support it as well.

- There are additions to [server-mmojo.cpp](/files/tools/server/server-mmojo.cpp) to accommodate this feature.
- There are additions to [arg-mmojo.cpp](/files/common/arg-mmojo.cpp) to accommodate this feature.
- There are additions to [common-mmojo.cpp](/files/common/common-mmojo.cpp) to accommodate this feature.
- There are additions to [common.h](/files/common/common.h) to accommodate this feature.

---
### More Soon!
The original version of this document is in the project archives. Its contents will be added to this document gradually.

- [102. Project Features](https://github.com/BradHutchings/Mmojo-Server/blob/c9229ad86e17f6a76d21e1645b8a5a05f16516c6/instructions/102-Project-Features.md)

Need to document ability to find a .gguf file.


---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@Mmojo.net)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
