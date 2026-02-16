## 301. Copy Certificates
### About this Step
In this step, we will create a `300-Certificates` directory and copy certificates from your Mmojo Share.

**Where:** Perform this step in both your x86_64 and your aarch64 (arm64) build environments.

**Shortcut:** [Scroll down](#shortcut-create-certificates-directory-copy-certificates-from-mmojo-share).

TO-DO:
- Use the certificates from here when building the APE and zip packages.
- Path for getting defaults from repo. Not the certs I used in production for Mmojo Knowledge Appliance though.

---
<details>
  <summary><b>Update Local Mmojo Server Repo</b> &mdash; Expand if you haven't today.</summary>
  
Have you updated your local clone of the Mmojo Server Repo today? If not, run this first:
```
mm-repo-update-local.sh
mm-env
```
</details>

---
### Create Certificates Directory
This script creates the `$CERTIFICATES_DIR` and uses the `mkcert` utility to create a fake certificate authority and certificates we can use as placeholders in builds.
- View the script: <a href="../scripts/301-Create-Certificates-Directory.sh" target="_blank">301-Create-Certificates-Directory.sh</a>.
  - *On Github, you may need to right-click and choose "Open link in new tab" to open the "View script" links in a new tab.*
    <br/>
    <br/>
- Run the script.
  ```
  $MMOJO_SERVER_SCRIPTS/301-Create-Certificates-Directory.sh
  ```

---
### Copy Certificate Files from Mmojo Share
This script copies files from your Mmojo Share to the `$CERTIFICATES_DIR`:
- View the script: <a href="../scripts/301-Copy-Certificates-from-Mmojo-Share.sh" target="_blank">301-Copy-Certificates-from-Mmojo-Share.sh</a>.
- Run the script.
  ```
  $MMOJO_SERVER_SCRIPTS/301-Copy-Certificates-from-Mmojo-Share.sh
  ```

---
### SHORTCUT: Create Certificates Directory, Copy Certificates from Mmojo Share
I really think you should run through these scripts one at a time the first few times you build, so you can familiarize yourself with the process and know what goes where. But, now that you've run through a few times, you can use the shortcut snippet:
```
################################################################################
# SHORTCUT: DON'T DO THIS IF YOU ALREADY RAN SCRIPTS ABOVE!
################################################################################
$MMOJO_SERVER_SCRIPTS/301-Create-Certificates-Directory.sh
$MMOJO_SERVER_SCRIPTS/301-Copy-Certificates-from-Mmojo-Share.sh
```

---
### Proceed
- **Next:** [302. Build Cosmopolitan](302-Build-Cosmopolitan.md)
- **Previous:** This is the first step in this section.
- **Up:** [300. Gather Build Pieces](300-Gather-Build-Pieces.md)

---
[MIT License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
