## 207. Set up Cross Compile aarch64 on x86_64
### About this Step
**NOT IN THE TOC OR NEXT ARTICLE FLOW UNTIL WE NEED IT. -Brad**

Cross-compiling llama.cpp does not work very well right now. The llama.cpp CMake build system is meant to discover the capabilities of the host machine and build for that. In particular, I run into problems with OpenSSL that need to be patched for cosmocc builds to link in compatible static libraries.

I've had some limited success building for Raspberry Pi (arm64) from x86_64 Ubuntu, but not for optimized builds. For example, a private summary benchmark I have, running on a Pi 5, takes about 45 minutes with the cosmocc build, 18 minutes with a cross-compiled build, and 7 minutes with an optimized build built on the Pi 5. I'm working towards getting optimized cross-compiled builds, but it's a long term goal.

**Where:** Perform this step in your x86_64 build environment.

---
### Set up Cross Compile aarch64 (arm64) on x86_64
ARM has a few names for various versions and purposes of developer tools. `aarch64` means the same thing in some contexts as `arm64` does in others.

Do this if you're running on x86_64.

- View the script in a new tab: <a href="../scripts/207-Set-up-Cross-Compile-aarch64-on-x86_64.sh" target="_blank">207-Set-up-Cross-Compile-aarch64-on-x86_64.sh</a>
  - *On Github, you may need to right-click and choose "Open link in new tab" to open the "View script" links in a new tab.*
    <br/>
    <br/>
- Run the script. We run with `.` so variables can be defined and exported.
  ```
  . mm-environment-variables.sh
  . $MMOJO_SERVER_REPO_SCRIPTS/207-Set-up-Cross-Compile-aarch64-on-x86_64.sh
  ```

#### Verify that libssl.a and libcrypto.a are Installed for Both Architectures
Find where the files are under `/usr/lib`:
```
find /usr/lib -name "libssl.a"
find /usr/lib -name "libcrypto.a"
printf "\n**********\n*\n* FINISHED: Verify that libssl.a and libcrypto.a are Installed.\n*\n**********\n\n"
```

The output should look like this:
```
/usr/lib/x86_64-linux-gnu/libssl.a
/usr/lib/aarch64-linux-gnu/libssl.a
/usr/lib/x86_64-linux-gnu/libcrypto.a
/usr/lib/aarch64-linux-gnu/libcrypto.a
```

I hope to be able to use these to replace the lengthy openssl build with cosmocc at some point. They aren't currently compatible with Cosmopolitan because `_FORTIFY_SOURCE` was used to build these static libraries.

---
### Proceed
- **Next:** [208. Set up Cross Compile - x86_64 on aarch64](208-Set-up-Cross-Compile-x86_64-on-aarch64.md)
- **Previous:** [206. Install Dependencies](206-Install-Dependencies.md)
- **Up:** [200. Prepare Build Environment](200-Prepare-Build-Environment.md)

---
[MIT License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
