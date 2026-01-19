## 102. Project Features
### Project Features
This page contains an itemized list of project features. These are all additions to the stock llama.cpp project. I note files that are added to or patched into your local copy of the llama.cpp repo before building.

I am very choosy about new features. They need to be necessary. They need to be easy for regular end-users to work with. They need to be maintainable. They need to not be clever hacks. They need to not step on llama.cpp or alter it too much. Mostly, they should not try to do what the llama.cpp team is good at, like optimize the GGML algorithms.

---
### Top Shelf Build Instructions
The instructions (aka "documentation") should make building and packaging an LLM server approachable to even casual developers and hobbyists. It can be a comfortable learning experience and spread knowledge of how these systems work beyond hard-core technical people.

Even if you're just trying to build a mostly stock llama.cpp to run locally, I hope my instructions get you through setting up your environment to support GPUs with CUDA, Vulkan, or (soon!) Metal.

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
### "Naked" Executables
This is going to sound silly, but the most exhausting task &mdash; from the start &mdash; in shipping a fleet of llamafile builds was writing or customizing a `default-args` file with a reference to a specific `.gguf` model for each llamafile that I wanted to package and ship. I have solved this with the idea of a "naked APE". It doesn't have a model specified. It just finds the first one it can. It searches the `/zip` directory &mdash; items added to the archive &mdash; then the executable directory, then the working directory. The find a model logic has been extended beyond APE files to all executables and will be supported in my future packaging scheme.

Most importantly, naked executables allow end-users to try .gguf models I have not tested with Mmojo Server. The models users try may not be supported, but if they are, I'm not in the way. They don't need a developer to make a model that works work for them.

***Note:** "Naked APE" should make you chuckle. So should "Attired APE", which I will [introduce in due course](625-Attired-APEs-Compatible.md).*

***Note:** This is an original Mmojo Server feature. So when you copy it for your LLM server and/or can't come up with an original name, a note of credit would be appreciated.*

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
### Enhanced Reporting of Context Window Evaluation
The Mmojo Complete UI shows progress evaluating, and allows a delay between batches for letting little processors (like in a Raspberry Pi 5) cool down for a moment between batches. These let Mmojo Complete provide useful progress feedback for evaluation efforts that may take minutes or even hours.

Some previous work on this was incorporated into llama-server by the llama.cpp team with the `send_partial_response()` function.

- There are additions to [server-mmojo.cpp](/files/tools/server/server-mmojo.cpp) to accommodate this feature.
- There are additions to [arg-mmojo.cpp](/files/common/arg-mmojo.cpp) to accommodate this feature.
- There are additions to [common.h](/files/common/common.h) to accommodate this feature.

---
### Enhanced Meta Data Returned by OpenAI compatible API
I add some useful things to the meta data returned by the `GET /v1/models` endpoint. This code block shows what's returned:
```
return json {
    {"vocab_type",  llama_vocab_type            (vocab)},
    {"n_vocab",     llama_vocab_n_tokens        (vocab)},
    {"n_ctx_train", llama_model_n_ctx_train     (model)},
    {"n_ctx",       llama_n_ctx                 (ctx)},
    {"n_embd",      llama_model_n_embd          (model)},
    {"n_params",    llama_model_n_params        (model)},
    {"size",        llama_model_size            (model)},
    {"general.architecture", general_architecture },
    {"general.type", general_type },
    {"general.name", general_name },
    {"general.version", general_version },
    {"general.finetune", general_finetune },
    {"general.basename", general_basename },
    {"general.size_label", general_size_label },
    {"general.license", general_license },
};
```

- There are additions to [server-mmojo.cpp](/files/tools/server/server-mmojo.cpp) to accommodate this feature.

---
### `sed` Modified Files
Some files in llama.cpp are automatically modified by `sed` to customize them and fix incompatibilities:
- `tools/server/server-queue.cpp`
- `tools/server/server-queue.h`

---
### Self Extracting Application Support (SEAS) Files
I am working on a self-extracting application that can extract support files, including a web user interface and a .gguf model, into an adjacent support directory during the application's initial invocation. These would be a good 2nd thing for users to try &mdash; after an APE package &mdash; because they can contain platform optimized code and GPU support, packaged in a single file.

SEASes are a work in progress.

- There will be additions to the `main()` function in [server-mmojo.cpp](/files/tools/server/server-mmojo.cpp) to accommodate this feature.
---
### Proceed
- **Next:** [103. Build Environment](103-Build-Environment.md)
- **Previous:** [101. Project Goals](101-Project-Goals.md)
- **Up:** [100. Overview](100-Overview.md)

---
[MIT License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
