## 05. Developers
### About this Step
In this step, you'll learn how to connect your app to Mmojo Server's OpenAI compatible API.

---
### Connect to OpenAI API
For an application running on your computer, use this OpenAI compatible API endpoint:

- **http://127.0.0.1/v1**

---
### Make Mmojo Server Visible on your Network
Mmojo Server, as configured, only accepts local connections.

To allow it to accept connections from any computer on your network, rename the `EXAMPLE-mmojo-server-args` file to `mmojo-server-args`. Then edit it.

The file is formatted:

&nbsp;&nbsp;&nbsp;&nbsp;`--parameter`<br/>
&nbsp;&nbsp;&nbsp;&nbsp;`value`<br/>
&nbsp;&nbsp;&nbsp;&nbsp;`--parameter`<br/>
&nbsp;&nbsp;&nbsp;&nbsp;`value`<br/>

You need to change:

&nbsp;&nbsp;&nbsp;&nbsp;`--host`<br/>
&nbsp;&nbsp;&nbsp;&nbsp;`127.0.0.1`<br/>

Set the value as:

&nbsp;&nbsp;&nbsp;&nbsp;`--host`<br/>
&nbsp;&nbsp;&nbsp;&nbsp;`0.0.0.0`<br/>

Save changes to the file and start Mmojo Server for them to take effect.

---
### Proceed
- **Next:** This is the last step in this guide.
- **Previous:** [04. Stop Mmojo Server](04-Stop-Mmojo-Server.md)
- **Up:** [Deploy Mmojo Server on All Supported Platforms](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
