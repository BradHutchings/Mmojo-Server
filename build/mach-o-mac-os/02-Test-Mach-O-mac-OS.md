## 02. Test Mach-O Executable for mac OS
### About this Step
In this step, you will build...

---
### Choose a Model
Choose a model. It will be included in your `.zip` archive. I'd suggest choosing **Google Gemma 270M Instruct v3**.
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

[Mmojo Complete](http://127.0.0.1:8080) &larr; Right-click, open in new tab.

Hit `CTRL-C` to stop the debug run when you are finished testing your build.

Since your build is in your `$DEPLOY_DIR`, it's ready to be deployed with `mm-start`.

---
### Proceed
- **Next:** [03. Package Mach-O Executable for mac OS](03-Package-Mach-O-mac-OS.md)
- **Previous:** [01. Build Mach-O Executable for mac OS](01-Build-Mach-O-mac-OS.md)
- **Up:** [Build Mmojo Server](../README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
