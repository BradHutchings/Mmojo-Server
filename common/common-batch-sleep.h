// Fix common.h by applying this

struct common_params {
    int32_t n_predict             =    -1; // new tokens to predict
    int32_t n_ctx                 =  4096; // context size
    int32_t n_batch               =  2048; // logical batch size for prompt processing (must be >=32 to use BLAS)
    // mmojo-server START
    int32_t n_batch_sleep_ms      =     0; // delay in milliseconds after processing each batch.
    // mmojo-server END
    int32_t n_ubatch              =   512; // physical batch size for prompt processing (must be >=32 to use BLAS)
    int32_t n_keep                =     0; // number of tokens to keep from initial prompt
