## Maintenance

These are the instructions for maintaining the files rooted in this directory. This turns into a mess if we're in the middle of rapid fire commits to llama.cpp. Test builds after maintenance!

1. Switch to the `work-in-progress` branch for this page.

2. Open the Clone Repos script in a new tab:
   - [mm-prepare-clone-llama-cpp.sh](/scripts/mm-prepare-clone-llama-cpp.sh)
  
3. Open recent commits to llama.cpp in a new tab:
   - [Commmits to llama.cpp](https://github.com/ggml-org/llama.cpp/commits/master/)

4. Open the original versions in the llama.cpp repo and the patched versions from this repo (twice) in new tabs:
   - llama.cpp - [common/arg.cpp](https://github.com/ggml-org/llama.cpp/blob/master/common/arg.cpp)
     - Mmojo Server - [common/arg-mmojo.cpp](/files/common/arg-mmojo.cpp)
     - Mmojo Server - [common/arg-mmojo.cpp](/files/common/arg-mmojo.cpp)<br/><br/>
   
   - llama.cpp - [common/common.cpp](https://github.com/ggml-org/llama.cpp/blob/master/common/common.cpp)
     - Mmojo Server - [common/common-mmojo.cpp](/files/common/common-mmojo.cpp)
     - Mmojo Server - [common/common-mmojo.cpp](/files/common/common-mmojo.cpp)<br/><br/>
   
   - llama.cpp - [common/common.h](https://github.com/ggml-org/llama.cpp/blob/master/common/common.h) -- **This can be easily patched with code.**
     - Mmojo Server - [common/common.h](/files/common/common.h)
     - Mmojo Server - [common/common.h](/files/common/common.h)<br/><br/>
   
   - llama.cpp - [tools/server/server.cpp](https://github.com/ggml-org/llama.cpp/blob/master/tools/server/server.cpp)
     - Mmojo Server - [tools/server/server-mmojo.cpp](/files/tools/server/server-mmojo.cpp)
     - Mmojo Server - [tools/server/server-mmojo.cpp](/files/tools/server/server-mmojo.cpp)<br/><br/>

   - llama.cpp - [tools/server/server-http.cpp](https://github.com/ggml-org/llama.cpp/blob/master/tools/server/server-http.cpp)
     - Mmojo Server - [tools/server/server-http-mmojo.cpp](/files/tools/server/server-http-mmojo.cpp)
     - Mmojo Server - [tools/server/server-http-mmojo.cpp](/files/tools/server/server-http-mmojo.cpp)<br/><br/>

   - llama.cpp - [tools/server/server-context.cpp](https://github.com/ggml-org/llama.cpp/blob/master/tools/server/server-context.cpp)
     - Mmojo Server - [tools/server/server-context-mmojo.cpp](/files/tools/server/server-context-mmojo.cpp)
     - Mmojo Server - [tools/server/server-context-mmojo.cpp](/files/tools/server/server-context-mmojo.cpp)

5. Compare last modified dates of the originals and patched files. Discard tab triplets where the original is older.
   <img width="304" height="82" alt="image" src="https://github.com/user-attachments/assets/f8814cc1-e244-4ac5-a4d5-e61fa9f339ad" />

6. Edit the middle tab of tab triplet. Copy left tab file contents. Paste into middle tab edit area.

7. Search for `mmojo-server START` in right tab of tablet triplet. Repeatedly copy those blocks from right tab and paste into middle tab.

8. Commit changes to middle tab

9. Edit the script that clones llama.cpp and change the rollback point. More details needed here.

   <img width="205" height="180" alt="image" src="https://github.com/user-attachments/assets/9beadab3-9b4f-4435-9c0b-41edb728a590" />
