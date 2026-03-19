## 02. Test Mmojo Server
**THIS GUIDE IS A WORK IN PROGRESS.**
### About this Step
In this step, you will test your Mmojo Server build.

---
### Choose a Model
Choose a model. It will be included in your `.zip` archive. I'd suggest choosing **Google-Gemma-4B-Instruct-v3-q8_0.gguf**.
```
mm-model
```

---
### Test Your Build
Test that the build runs with output in the Terminal.
```
mm-debug
```

Connect to Mmojo Complete from a browser:

- [Mmojo Complete](http://127.0.0.1:8080) &larr; Right-click, open in new tab.

Hit `CTRL-C` to stop the debug run when you are finished testing your build.

Since your build is in your `$DEPLOY_DIR`, it's ready to be deployed with `mm-start`.

---
### Proceed
- **Next:** [03. Test Mmojo RPC Server](03-Test-Mmojo-RPC-Server.md)
- **Previous:** [01. Build Mmojo Server](01-Build-Mmojo-Server.md)
- **Up:** [Build Mmojo Server for mac OS](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
