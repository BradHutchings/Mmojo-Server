## 09. Autostart Mmojo Server
**THIS GUIDE IS IN PROGRESS.**
### About this Step
In this step, we're going to install a `launchd` daemon to start Mmojo Server at machine startup, and we're going to add to `.bashrc` to start Mmojo at login if it is not already running.

---
### Create LaunchDameon plist File
duso cat << EOF >> /Library/LaunchDaemons/net.mmojo.mmojo-server.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>net.mmojo.mmojo-server</string>
    <key>Program</key>
    <string>/Users/mmojo-server/mm-deploy/mmojo-server</string>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <false/>
    <key>WorkingDirectory</key>
    <string>/Users/mmojo-server/mm-deploy</string>

    <key>StandardOutPath</key>
    <string>/Users/mmojo-server/mm-deploy/launchd-out</string>
    <key>__StandardErrorPath</key>
    <string>/Users/mmojo-server/mm-deploy/launchd-err</string>

    <key>UserName</key>
    <string>mmojo-server</string>
    <key>GroupName</key>
    <string>staff</string>
    <key>InitGroups</key>
    <true/>
</dict>
</plist>
EOF

---
### Load the Job
Use `launchctl bootstrap` to load the job:
```
sudo launchctl bootstrap system/ /Library/LaunchDaemons/net.mmojo.mmojo-server.plist
```

---
### Start the Job
Use `launchctl kickstart` to load the job:
```
sudo launchctl kickstart system/net.mmojo.mmojo-server
```

*Note: I need to figure out how `mm-mmojo-server-start.sh` and `mm-mmojo-server-stop.sh` will work with this. -Brad 2026-05-01*

---
### Autostart Mmojo Server
Run this command:
```
if ! grep -q "Starting Mmojo Server." "$HOME/.bashrc"; then
cat << EOF >> $HOME/.bashrc

echo "Starting Mmojo Server."
mm-go
echo ""
echo "To stop Mmojo Server, type the alias: << mm-stop >>."
echo ""
EOF
fi
```

---
### Test Autostart
???



Connect to Mmojo Server again in your browser to verify that Mmojo Server is running and available:

- [Mmojo Complete](http://127.0.0.1:8080) &larr; Right-click, open in new tab.

Leave the Terminal window open for as long as you want to run Mmojo Server. When you close it, Mmojo Server will stop automatically within a minute, probably sooner.

---
### Proceed
- **Next:** [10. Change Model](10-Change-Model.md)
- **Previous:** [08. Make Command Aliases](08-Make-Command-Aliases.md)
- **Up:** [Deploy Mmojo Server on macOS](README.md)

---
[MIT-Style License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
