## 06. Test Mmojo Server
**THIS SECTION IS IN PROGRESS.**
### About this Step
In this step, you will choose a model and test Mmojo Server.

---
### Choose a Model
First, choose a model. I'd suggest choosing **Google Gemma 4B Instruct**. It will be soft-linked in your `$HOME/Mmojo-Server` directory.
```
mm-model-choose.sh
```

---
### Start Mmojo Server

Launch `mmojo-server` in "debug mode" so you can see it working:
```
mm-mmojo-server-start.sh
```

This starts Mmojo Server in a debug mode with messages displayed on screen so you can see what it's doing. As you can see, it is doing a lot 😆.

<img width="499" height="104" alt="image" src="https://github.com/user-attachments/assets/38d2f22c-96dc-4f6c-9bf1-248c19db18be" />

This `all slots are idle` message tells you that Mmojo Server is ready to use.

If you get a message about an illegal instruction, it's because you installed a performant version of Mmojo Server. Your computer's CPU, sadly, does not support that version. Go back to the download step and try the alternative compatible version.

- [05. Download Mmojo Server](05-Download-Mmojo-Server.md)

---
### Connect to Mmojo Complete
Connect to Mmojo Complete from a browser:

[Mmojo Complete](http://127.0.0.1:8080) &larr; Right-click, open in new tab.

You should see the Mmojo Complete user interface:

<img width="600" alt="image" src="https://github.com/user-attachments/assets/fb6716c6-e7a9-4fd7-8341-7f81313847bf" />

Bookmark Mmojo Complete in your browser while you're there.

---
### Stop Mmojo Server
Go back to the Terminal window and hit `CTRL-C` on your keyboard to stop Mmojo Server. You may need to hit it twice.

<img width="385" height="98" alt="image" src="https://github.com/user-attachments/assets/6ce39db5-85e7-44fc-ae1e-3b922c5785e5" />

You will see your command prompt.

---
### Proceed
- **Next:** [07. Make Command Aliases](07-Make-Command-Aliases.md)
- **Previous:** [05. Download Mmojo Server](05-Download-Mmojo-Server.md)
- **Up:** [Deploy Mmojo Server on Windows (WSL)](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
