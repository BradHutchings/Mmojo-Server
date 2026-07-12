## Model Notes
### About this Note
This is a placeholder for model building code until I find a good place for it.

### Preparation
This needs to be done once on your Mmojo Server system, in the account where Mmojo Server runs.

macOS with homebrew:
```
brew update
brew install python
# Add path to for brew python to .bashrc
# source .bashrc

mm-prepare-install-dependencies.sh
mm-models-clone-llama-cpp.sh
pip3 install transformers torch --break-system-packages
brew install git
brew install git-lfs
git lfs install

# THIS IS NOT A SECURE WAY TO HANDLE YOUR HUGGING FACE CREDENTIALS!!
git config --global credential.helper store
```

Copy `llama-quantize` to the $DEPLOY_DIR. Should be in the build instructions, I think.

### Convert and Quantize Example
Copy this snippet, paste to a text editor, change the `MODEL_NAME` and `MODEL_REPO`, then run the snippet.

```
cd $MODELS_DIR

MODEL_NAME="Google-Gemma-12B-Instruct-v4"
MODEL_TYPE="f16"
MODEL_REPO="https://huggingface.co/google/gemma-4-12B-it"
mm-models-convert-hf-to-gguf.sh $MODEL_NAME $MODEL_TYPE $MODEL_REPO
$DEPLOY_DIR/llama-quantize $MODEL_NAME-f16.gguf $MODEL_NAME-q8_0.gguf q8_0
$DEPLOY_DIR/llama-quantize $MODEL_NAME-f16.gguf $MODEL_NAME-q6-K.gguf q6_K
$DEPLOY_DIR/llama-quantize $MODEL_NAME-f16.gguf $MODEL_NAME-q5-K-M.gguf q5_K_M
$DEPLOY_DIR/llama-quantize $MODEL_NAME-f16.gguf $MODEL_NAME-q4-K-M.gguf q4_K_M
```
