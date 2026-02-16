## 502. Prepare to Test
### About the Build llama-server Track
**llama-server** is the project upon which Mmojo Server builds. [Read more about llama-server](500-Build-llana-server.md).

---
### About this Step
In this step, we will set some environment variables to customize testing.

**Where:** Perform this step in both your x86_64 and your aarch64 (arm64) build environments.

---
<details>
  <summary><b>Update Local Mmojo Server Repo</b> &mdash; Expand if you haven't today.</summary>
  
Have you updated your local clone of the Mmojo Server Repo today? If not, run this first:
```
mm-update-local-mmojo-server-repo.sh
mm-env
```
</details>

---
### Choose `.gguf` Model for Testing
Choose a model. The models from your `$HOME/300-MODELS` directory are available for you to use. This is its own script in your `$HOME/scripts` directory because it sets an environment variable and is resused in these instructions. .
- View the script: <a href="../scripts/ mm-model-choose.sh" target="_blank"> mm-model-choose.sh</a>.
- Run the script.
  ```
  unset MODEL_CHOICE
  . mm-choose-model.sh
  ```

---
### Optional: Choose CPU Threads
By default, llama-server will use half of the CPU threads available. For benchmarking, you may want to set a different value.

Use default &mdash; half of available threads:
```
unset TEST_CPU_THREADS
```

Use a specified number of threads:
```
export TEST_CPU_THREADS=2
```
```
export TEST_CPU_THREADS=4
```
```
export TEST_CPU_THREADS=8
```

---
### Proceed
- **Next:** [503. Debug Build](503-Debug-Build.md)
- **Previous:** [501. Prepare to Build](501-Prepare-to-Build.md)
- **Up:** [500. Build llama-server](500-Build-llama-server.md)

---
[MIT License](/LICENSE)<br/>
Copyright (c) 2025-26 [Brad Hutchings](mailto:brad@bradhutchings.com)<br/>
[https://github.com/BradHutchings/Mmojo-Server](https://github.com/BradHutchings/Mmojo-Server)
