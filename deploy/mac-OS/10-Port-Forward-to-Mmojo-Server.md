## 11. Port Forward to Mmojo Server
**THIS SECTION IS IN PROGRESS.**
### About this Step (Optional)
**THIS IS A HOT MESS. NO IDEA WHAT TO DO ABOUT IT YET.**


Mmojo Server runs in an WSL instance on your computer. It can accept connections from other process running on your computer, including from other WSL instances. This makes WSL an effective sandbox.

If you want Mmojo Server running in WSL to accept connections from other computers on your network, you need to set up port-forwarding so inbound traffic is directed from an inbound port to port 8080 internally, where Mmojo Serevr is listening. Setting this up with the Windows network stack is complicated.

However, there is an easy cheat code! We can use nginx (pronounced "engine ex") to set up a proxy server. This is much less complicated. While I would like to point you to a free GUI app that can do this, I don't know of a good solution. Perhaps I'll write one someday.

---
### Install nginx - Chocolatey
If you have the [Chocolatey package manager](https://chocolatey.org/) installed, you can use it to install the latest version.

<img width="351" height="372" alt="image" src="https://github.com/user-attachments/assets/03e4b8fc-3a78-46f1-9216-8dd07ae8a2a7" />

Open a **Terminal** or **PowerShell** window as Administrator. I right-clicked the `Terminal` icon in my Taskbar, right-clciked **Terminal** in the menu, then clicked **Run as administrator**.
```
choco install -y nginx
```

`nginx.exe` and supporting files will be installed in the directory: `C:\tools\nginx-[version]` where `[version]` is the actual version number of nginx installed.

Go to that directory. You need that directory to be the working directory when you start nginx.

```
cd c:\tools\nginx-*
```

---
### Install nginx - Download from nginx.org
If you don't have Chocolatey installed, you can download directly from [nginx.org](https://nginx.org/en/download.html). These commands will download and install a recent version.

<img width="351" height="372" alt="image" src="https://github.com/user-attachments/assets/03e4b8fc-3a78-46f1-9216-8dd07ae8a2a7" />

Open a **Terminal** or **PowerShell** window as Administrator. I right-clicked the `Terminal` icon in my Taskbar, right-clciked **Terminal** in the menu, then clicked **Run as administrator**.

Following are instructions to download and install a recent version.

Download and unzip a recent nginx.
```
$toolsDir = "C:\tools"
mkdir $toolsDir
$nginxZipFile = "nginx-1.28.2.zip"
$url = "https://nginx.org/download/$nginxZipFile"
$outputPath = "$toolsDir\$nginxZipFile"
Invoke-WebRequest -Uri $url -OutFile $outputPath
Expand-Archive -Path $outputPath -DestinationPath $toolsDir
```

Go to that directory. You need that directory to be the working directory when you start nginx.

```
cd c:\tools\nginx-*
```

---
### Configure nginx
Assuming you have Visual Studio Code installed, you can use it to edit the configuration file.

```
code .\conf\nginx.conf
```

Replace the **http** section of the configuration file with:

```
http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;

  server {
    listen 8080;

    location / {
      proxy_pass http://localhost:8080;
      proxy_redirect http://localhost:8080/ $scheme://$host:8080/;
    }
  }
}
```

Save and close the `nginx.conf` file. Close Visual Studio Code.

--- 
### Start nginx
To start nginx from its working directory:
```
start .\nginx.exe
```

---
### Test from another computer on your network
Find out your computer's hostname:
```
hostname
```

<img width="264" height="74" alt="image" src="https://github.com/user-attachments/assets/62df8e78-fcc1-43aa-8220-c1c3c8bc4bea" />

My computer's hostname is **Seventeen**. It's a 17-inch Dell XPS laptop, and that's how I name my laptops.

Go to another computer on your network, and open a web browser. Now connect to:

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`http://[hostname].local:8080`

In my case, I would connect to:

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`http://seventeen.local:8080`

It is important that you use http, not https. 

---
### Proceed
- **Next:** This is the last step in this section.
- **Previous:** [09. Change Model](09-Change-Model.md)
- **Up:** [Deploy Mmojo Server on mac OS](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
