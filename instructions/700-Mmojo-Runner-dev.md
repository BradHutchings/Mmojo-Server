## Mmojo Runner (dev)
### About Mmojo Runner
What is this? It's going to be a polyglot format that can handle options for a particular platform and CPU. It stems from wanting one `mmojo-server` that contain both compatible and performant versions of the app for multiple platform and CPU family combinations. Or contain versions that can use your GPU.

I think this is going to work. It might turn out to be a dud. Stay tuned!

---
### How Does it Work?
There are a collection of scripts prefixed with `mr-` (for "Mmojo Runner") in your `$HOME/mm-scripts` directory. You use them to create an archive, add files to an archive, then attach the archive to a preamble script to yield a polyglot, i.e. an app that can run on multiple platforms and architectures.

I'm focused on Linux and macOS, x86_64 and aarch64 right now. Windows users are best served by running one of these in a Windows Subsystem for Linux (WSL) instance. This will not require installation of dev tools on macOS to run one of these. It will allow the actual binaries to dynamically link against more performant and security hardened libraries on their systems rather than force them to static link for cross-operating-system functionality.

Perhaps the coolest feature should be (hopefully) that you as a developer can build one of these for one platform CPU combination, and take the package a la carte to other build platforms to add them to the archive. No need to build everything first, gather in one place, then assemble.

-Brad

---
### Constructing a Mmojo Runner &mdash; Model, Certificates, UI, Args File
Snippets I'm using while building this thing out.

Make a new archive.
- View the script: <a href="../scripts/mr-new-runner.sh" target="_blank">mr-new-runner.sh</a>.
- Run the script.
  ```
  mr-new-runner.sh test-archive mmojo-server mmojo-server-args /support mmojo-server-support
  ```

Add a .gguf model to an existing archive:
- View the script: <a href="../scripts/mr-add-model.sh" target="_blank">mr-add-model.sh</a>.
- Run the script.
  ```
  mr-add-model.sh test-archive 300-MODELS/Google-Gemma-1B-Instruct-v3-q8_0.gguf
  ```

Add individual certificates to an existing archive:
- View the script: <a href="../scripts/mr-add-certs.sh" target="_blank">mr-add-certs.sh</a>.
- Run the script.
  ```
  mr-add-certs.sh test-archive $CERTIFICATES_DIR/cert.crt $CERTIFICATES_DIR/cert.key
  ```

Add user interface directory to an existing archive:
- View the script: <a href="../scripts/mr-add-ui.sh" target="_blank">mr-add-ui.sh</a>.
- Run the script.
  ```
  mr-add-ui.sh test-archive $MMOJO_SERVER_REPO_DIR/files/Mmojo-Complete $CERTIFICATES_DIR/selfsignCA.crt
  ```
- Note: The Mmojo Complete UI is not customized with the updated date. Can't touch the repo. Might want to copy Mmojo Complete into it's own 300 thing on cloning the repo or mm-update. Maybe an mm-update-mmojo-complete? Builds would use that copy, not the repo.

Add args file to an existing archive:
- View the script: <a href="../scripts/mr-add-args.sh" target="_blank">mr-add-args.sh</a>.
- Run the script.
  ```
  mr-add-args.sh test-archive
  ```

#### SHORTCUT
```
mr-new-runner.sh test-archive mmojo-server mmojo-server-args /support mmojo-server-support
mr-add-model.sh test-archive 300-MODELS/Google-Gemma-1B-Instruct-v3-q8_0.gguf
mr-add-certs.sh test-archive $CERTIFICATES_DIR/cert.crt $CERTIFICATES_DIR/cert.key
mr-add-ui.sh test-archive $MMOJO_SERVER_REPO_DIR/files/Mmojo-Complete $CERTIFICATES_DIR/selfsignCA.crt
mr-add-args.sh test-archive
```

---
### Assembling Polyglot
- cat the preamble and the archive together to yield polyglot.

---
### Adding builds
- scripts to add them to the polyglot. This way, we can pass the polyglot from build station to build station to add pieces.

---
[MIT License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
