## 620. APE Packages
### About Doghouse
**Doghouse** is an example of a branded developer experience. [Read more about Doghouse](400-Build-Doghouse.md).

---
### About this Step
In the following five steps, we will package Doghouse for deployment as actual portable executables.
- **Compatible** builds run on a wide range of x86_64 and aarch64 processors.
- **Performant** builds run on newer x86_64 processors and Apple M* aarch64 processors.
- **Naked** means the APEs do not contain a `.gguf` file. One can be grafted on later using `zip` without modifying the `mmojo-server-args` file. You can also release a naked APE and have users copy the model they want to use into its directory.

**Where:** Perform these steps in either or both your x86_64 and your aarch64 (arm64) build environments.

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
### Proceed
- **Next:** [621. APE (Compatible)](621-APE-Compatible.md)
- **Previous:** This is the first step in this section.
- **Up:** [600. Package Doghouse](600-Package-Doghouse.md)

---
[MIT License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
