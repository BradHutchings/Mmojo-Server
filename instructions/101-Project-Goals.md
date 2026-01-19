## 101. Project Goals
### History
Mmojo Server was inspired by Mozilla Foundation's llamafile, which built llama.cpp as an Actual Portable Executable (APE) file. This file could run on x86 and ARM, under Linux, macOS, Windows, FreeBSD, and a few other less notable operating systems. The APE file contained the LLM, often gigabytes in size. It was download once, run anywhere. I shipped llamafile APE files that also included my completion-style user interface and incorporated SSL certificates. I encouraged my consulting clients to use these on their PCs rather than using cloud LLMs. Even though they aren't very technical people, they were mostly able to make llamafiles work because they didn't have to do too much. Comparatively, systems like Ollama &mdash; built for non-technical people with an extensive UI &mdash; were intimidating!

Unfortunately, Mozilla Foundation stopped actively supporting llamafile around the fall of 2024. This meant that support for new models rolled out in llama.cpp was not incorporated into llamafile. This turned out to be the greatest weakness of llamafile. If nobody kept it up to date with the additions to and changes in llama.cpp, it just wasn't that interesting. This is the main organizing principle for Mmojo Server. It has to offer the run everywhere feature of llamafile, but has to be maintainable, especially the llama.cpp part.

While Mozilla Foundation subsidiary (?) Mozilla.ai has recently picked up and promised to revive work on llamafile, I think the best direct replacement is the [llama-server track](llama-server/500-Build-llama-server.md) in this repo. Read the [100. Overview](100-Overview.md) section, set up your build environment with the [200. Prepare Build Environment](200-Prepare-Build-Environment.md) and [300. Gather Build Pieces](300-Gather-Build-Pieces.md) sections, then jump over to the [llama-server track](llama-server/500-Build-llama-server.md) to build llama-server as standsalone executables and APE files.

I have spoken to a reperesentative of Mozilla.ai about potential ways of working together. I'm not confident they can add any value to what I've done or am doing. YMMV.

---
### Project Goals
The goal of the Mmojo Server project is to provide LLM server software that is easy to install on any supported system, then easy enough to update to a more performant version tuned to users' specific hardware and operating system. Mmojo Server will do the first part with APE files. It will do the second part by not customizing llama.cpp in unmaintainable ways and keeping the llama.cpp part up-to-date at least weekly. This will let us gain from everything llama.cpp is doing for reach and performance.

There are some lessons from llamafile and APE packaging I can apply to the platform-specific build. We can package supporting files &mdash; like configuration, .gguf models, user interface, and certificates &mdash; in subdirectories adjacent to our executables, or perhaps in the executables themselves. Packaging for easy end-user installation is important.

I want to promote my Mmojo Complete completion-style user interface as a better way to use LLMs than the chat illusion. People do not need to pretend they are having a conversation to get good information from an LLM. Meanwhile, the chat illusion can have serious downsides for people who get hooked into it.

For developers, especially in the agent space, the OpenAI compatible API that llama.cpp gives us will save money and support hassle. It will eliminate the drift problem. It has the potential to preserve end-user privacy and dignity as well.

I am not interested in squeezing every ounce of performance out of particular CPUs or GPUs. The llama.cpp team has that covered. One funny thing that made llamafile more complicated than it needed to be was its focus on CPU inference optimization. It's funny because having to run on a wide range of x86 and ARM chips already took many effective CPU specific compiler optimizations off the table. And while the out-of-the-box Metal support on macOS was impressive, it made deploying llamafile for the first time cumbersome for macOS users who weren't developers.

Most importantly to me, I created and maintain Mmojo Server to power my Mmojo Knowledge Appliance. Every feature in Mmojo Server is included because it makes the appliance better. There will be no unmaintainable fluff. My ability and willingness to say "No" will keep Mmojo Server a more usable and useful platform for you.

---
### Shortcuts and Automation
The first developer criticism that Mmojo Server always gets is that it isn't automated enough. Guilty. Hear me out. Automation breaks. When it breaks, someone has to jump in and figure out what broke, then fix it, before anyone can use the automation again. The sequences of discrete automated steps in this repo, invoked manually do two things: (1) isolate what happens to be broken on any particular day, and (2) they foster understanding of each process from users of this repo. In a previous job, I spent ten years fighting against premature optimization that continually and expensively broke. I do not want that in my project.

Having said that, many steps (or pages) in the instructions have "SHORTCUT" scripts at the end. The shortcuts for a step are linked in the **About this Step** area at the top of the page for your convenience. After you've done a few builds end-to-end, you should try them out. I also plan to offer shortcut scripts for whole sections. I promise they will break spectacularly and often, because lots of stuff changes unexpectedly and often in upstream projects like llama.cpp. But if the section shortcuts work well most of the time, they'll be pretty valuable.

---
### Proceed
- **Next:** [102. Project Features](102-Project-Features.md)
- **Previous:** This is the first step in this section.
- **Up:** [100. Overview](100-Overview.md)

---
[MIT License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
