/*
  server-mmojo.cpp is a derivative for tools/server/server.cpp.

  This file has been modified to implement Mmojo Server specific
  Modifications are surrounded by:
    // Mmojo Server START
    // Mmojo Server END
    
  Original server.cpp file:
      https://raw.githubusercontent.com/ggml-org/llama.cpp/refs/heads/master/tools/server/server.cpp

  -Brad 2025-11-09
  --
  Brad Hutchings
  brad@bradhutchings.com
*/

#include "server-context.h"
#include "server-http.h"
#include "server-models.h"

#include "arg.h"
#include "common.h"
#include "llama.h"
#include "log.h"

#include <atomic>
#include <exception>
#include <signal.h>
#include <thread> // for std::thread::hardware_concurrency

#if defined(_WIN32)
#include <windows.h>
#endif

// Mmojo Server START
// This could be automated by searching for "using json =" and inserting this block before.
#include <linux/limits.h>
#include <sys/stat.h>
#include <dirent.h>
#include <unistd.h>
#include "mmojo-args.h"

#define PROCESS_NAME "mmojo-server"
#define ARGS_FILENAME "mmojo-server-args"
#define SUPPORT_DIRECTORY_NAME "mmojo-server-support"
#define PRODUCT_NAME "Mmojo Server"

// pre C++20 helpers.
bool starts_with (const std::string &fullString, const std::string &beginning);
bool ends_with (const std::string &fullString, const std::string &ending);
void get_important_paths(const char* argv_0, std::filesystem::path& executablePath, std::filesystem::path& workingDirectoryPath);
void find_first_gguf(const std::filesystem::path& directoryPath, std::filesystem::path& ggufPath);

bool starts_with (const std::string &fullString, const std::string &beginning) {
    if (fullString.length() >= beginning.length()) {
        return (0 == fullString.compare (0, beginning.length(), beginning));
    }
    else {
        return false;
    } 
}

bool ends_with (const std::string &fullString, const std::string &ending) {
    if (fullString.length() >= ending.length()) {
        return (0 == fullString.compare (fullString.length() - ending.length(), ending.length(), ending));
    }
    else {
        return false;
    } 
}

void get_important_paths(const char* argv_0, std::filesystem::path& executablePath, std::filesystem::path& workingDirectoryPath) {
    printf("\n");
    printf("- get_important_paths()\n");

    executablePath.clear();
    workingDirectoryPath.clear();

    if (argv_0 != NULL) {
        printf("  - argv_0: %s\n", argv_0);
        executablePath = argv_0;

        char workingDirectory[PATH_MAX];
        workingDirectory[0] = '\0';

        if (getcwd(workingDirectory, sizeof(workingDirectory) - 1)) {
            printf("  - workingDirectory: %s\n", workingDirectory);

            workingDirectoryPath = workingDirectory;
        }

        if (!executablePath.has_root_path()) {
            executablePath = workingDirectory;
            executablePath /= argv_0;
        }
    }

    printf("  - Raw paths:\n");
    printf("    - workingDirectoryPath: %s\n", workingDirectoryPath.c_str());
    printf("    -       executablePath: %s\n", executablePath.c_str());

    workingDirectoryPath = workingDirectoryPath.lexically_normal();
    executablePath = executablePath.lexically_normal();

    printf("  - Normalized paths:\n");
    printf("    - workingDirectoryPath: %s\n", workingDirectoryPath.c_str());
    printf("    -       executablePath: %s\n", executablePath.c_str());
}

void find_first_gguf(const std::filesystem::path& directoryPath, std::filesystem::path& ggufPath) {
    ggufPath.clear();
    printf("\n");
    printf("- find_first_gguf() in %s:\n", directoryPath.c_str());
  
    DIR *dir;
    struct dirent *entry;

    // Open the directory
    dir = opendir(directoryPath.c_str());
    if (dir != NULL) {
        printf("  - Looking for .gguf in %s:\n", directoryPath.c_str());
        while ((entry = readdir(dir)) != NULL) {
            const std::string& filename = entry->d_name;
            const std::string& extension = ".gguf";            
            const std::string& slash = "/";
            if (ends_with(filename, extension)) {
                printf("  - %s\n", entry->d_name);
                ggufPath = directoryPath;
                ggufPath /= entry->d_name;
                break;
            }
        }
        closedir(dir);
    }
    else {
        perror("Error opening directory");
    }
}

// Mmojo Server END

static std::function<void(int)> shutdown_handler;
static std::atomic_flag is_terminating = ATOMIC_FLAG_INIT;

static inline void signal_handler(int signal) {
    if (is_terminating.test_and_set()) {
        // in case it hangs, we can force terminate the server by hitting Ctrl+C twice
        // this is for better developer experience, we can remove when the server is stable enough
        fprintf(stderr, "Received second interrupt, terminating immediately.\n");
        exit(1);
    }

    shutdown_handler(signal);
}

// wrapper function that handles exceptions and logs errors
// this is to make sure handler_t never throws exceptions; instead, it returns an error response
static server_http_context::handler_t ex_wrapper(server_http_context::handler_t func) {
    return [func = std::move(func)](const server_http_req & req) -> server_http_res_ptr {
        std::string message;
        error_type error;
        try {
            return func(req);
        } catch (const std::invalid_argument & e) {
            // treat invalid_argument as invalid request (400)
            error = ERROR_TYPE_INVALID_REQUEST;
            message = e.what();
        } catch (const std::exception & e) {
            // treat other exceptions as server error (500)
            error = ERROR_TYPE_SERVER;
            message = e.what();
        } catch (...) {
            error = ERROR_TYPE_SERVER;
            message = "unknown error";
        }

        auto res = std::make_unique<server_http_res>();
        res->status = 500;
        try {
            json error_data = format_error_response(message, error);
            res->status = json_value(error_data, "code", 500);
            res->data = safe_json_to_str({{ "error", error_data }});
            SRV_WRN("got exception: %s\n", res->data.c_str());
        } catch (const std::exception & e) {
            SRV_ERR("got another exception: %s | while handling exception: %s\n", e.what(), message.c_str());
            res->data = "Internal Server Error";
        }
        return res;
    };
}

int main(int argc, char ** argv) {
    // Mmojo Server START
    // This could be automated by looking for "int main(" and inserting this block immediately after. -Brad 2025-11-05
        printf("\n\n----------START: " PRODUCT_NAME " ---------------------------------------------------\n\n");

    // Keep the build from showing up as ape in the process list.
        pthread_setname_np(pthread_self(), PROCESS_NAME);

    //  Find paths we need.
        std::filesystem::path executablePath;
        std::filesystem::path executableParentPath;
        std::filesystem::path workingDirectoryPath;
        get_important_paths(argv[0], executablePath, workingDirectoryPath);
        executableParentPath = executablePath.parent_path();
    
        // Args files if present. The names are different to remove confusion during packaging.
        std::filesystem::path argsPath = executableParentPath;      argsPath /= ARGS_FILENAME;
        std::filesystem::path supportPath = executableParentPath;   supportPath /= SUPPORT_DIRECTORY_NAME;
        std::filesystem::path supportArgsPath = supportPath;        supportArgsPath /= ARGS_FILENAME;
        std::filesystem::path zipPath = "/zip";
        std::filesystem::path zipArgsPath = zipPath;                zipArgsPath /= ARGS_FILENAME;

    // Find a .gguf model to use as a last resort before going into router mode.
    // This makes the naked APEs possible.
        std::filesystem::path firstGgufPath;

        #ifdef COSMOCC
        if (firstGgufPath.empty() && std::filesystem::exists(zipPath)) {
            find_first_gguf(zipPath, firstGgufPath);
        }
        #endif
        if (firstGgufPath.empty() && std::filesystem::exists(executableParentPath)) {
            find_first_gguf(executableParentPath, firstGgufPath);
        }
        if (firstGgufPath.empty() && std::filesystem::exists(supportPath)) {
            find_first_gguf(supportPath, firstGgufPath);
        }
        if (firstGgufPath.empty() && std::filesystem::exists(workingDirectoryPath)) {
            find_first_gguf(workingDirectoryPath, firstGgufPath);
        }

    #if 1
    // Path diagnostics
        printf("\n");
        printf("- Paths of things we care about:\n");
        printf("  -       executablePath: %s\n", executablePath.c_str());
        printf("  - executableParentPath: %s\n", executableParentPath.c_str());
        printf("  - workingDirectoryPath: %s\n", workingDirectoryPath.c_str());
        printf("  -             argsPath: %s\n", argsPath.c_str());
        printf("  -          supportPath: %s\n", supportPath.c_str());
        printf("  -      supportArgsPath: %s\n", supportArgsPath.c_str());
        printf("  -              zipPath: %s\n", zipPath.c_str());
        printf("  -          zipArgsPath: %s\n", zipArgsPath.c_str());
        printf("  -        firstGgufPath: %s\n", firstGgufPath.c_str());

        printf("\n");
        printf("- These paths exist:\n");
        if (std::filesystem::exists(executablePath)) {
            printf("  -       executablePath exists: %s\n", executablePath.c_str());
        }
        if (std::filesystem::exists(executableParentPath)) {
            printf("  - executableParentPath exists: %s\n", executableParentPath.c_str());
        }
        if (std::filesystem::exists(workingDirectoryPath)) {
            printf("  - workingDirectoryPath exists: %s\n", workingDirectoryPath.c_str());
        }
        if (std::filesystem::exists(argsPath)) {
            printf("  -             argsPath exists: %s\n", argsPath.c_str());
        }
        if (std::filesystem::exists(supportPath)) {
            printf("  -          supportPath exists: %s\n", supportPath.c_str());
        }
        if (std::filesystem::exists(supportArgsPath)) {
            printf("  -      supportArgsPath exists: %s\n", supportArgsPath.c_str());
        }
        if (std::filesystem::exists(zipPath)) {
            printf("  -              zipPath exists: %s\n", zipPath.c_str());
        }
        if (std::filesystem::exists(zipArgsPath)) {
            printf("  -          zipArgsPath exists: %s\n", zipArgsPath.c_str());
        }  
        if (std::filesystem::exists(firstGgufPath)) {
            printf("  -        firstGgufPath exists: %s\n", firstGgufPath.c_str());
        }  
    #endif
  
    // Implement an args file feature inspired by llamafile's.
    // It does not require Cosmo anymore, as the mmojo_args function is part of mmojo-server now.

        // At this point, argc, argv represent:
        //     command (User supplied args)

        if (std::filesystem::exists(argsPath)) {
            argc = mmojo_args(argsPath.c_str(), &argv);
        }

        // At this point, argc, argv represent:
        //     command (argsPath args) (User supplied args)

        if (std::filesystem::exists(supportArgsPath)) {
            argc = mmojo_args(supportArgsPath.c_str(), &argv);
        }

        // At this point, argc, argv represent:
        //     command (supportArgsPath args) (argsPath args) (User supplied args)

        #ifdef COSMOCC
        if (std::filesystem::exists(zipArgsPath)) {
            argc = mmojo_args(zipArgsPath.c_str(), &argv);
        }

        // At this point, argc, argv represent:
        //     command (zipArgsPath args) (supportArgsPath args) (argsPath args) (User supplied args)
        #endif
    
        // Yep, this is counterintuitive, but how the mmojo_args command works.

        printf("\n\n----------END: " PRODUCT_NAME  " -----------------------------------------------------\n\n");

    // Mmojo Server END
  
    // own arguments required by this example
    common_params params;

    if (!common_params_parse(argc, argv, params, LLAMA_EXAMPLE_SERVER)) {
        return 1;
    }

    // Mmojo Server START
        printf("\n\n----------START: " PRODUCT_NAME " ---------------------------------------------------\n\n");
        printf("- Checking for missing model and model inside APE zip.\n");

        // If we have no model path at this point, use the firstGgufPath.
        // I think I have all the possibilities for specifying a model covered here.
        if ((params.model.path == "") && (params.model.url == "") && (params.model.docker_repo == "") &&  
            (params.model.hf_repo == "") && (params.model.hf_file == "") && 
            std::filesystem::exists(firstGgufPath)) {

            printf("  - Using firstGgufPath for model: %s\n", firstGgufPath.c_str());
            params.model.path = firstGgufPath;
        }

        #ifdef COSMOCC
        const std::string zipPathSlash = "/zip/";
        if (starts_with(params.model.path, zipPathSlash)) {
            // if the gguf is in the zip file, we have to turn off use_map.
            printf("  - The model file is in /zip, so turning off use_mmap.\n\n");
            params.use_mmap = false;
        }
        #endif

        printf("\n\n----------END: " PRODUCT_NAME " -----------------------------------------------------\n\n");
    // Mmojo Server END

    // validate batch size for embeddings
    // embeddings require all tokens to be processed in a single ubatch
    // see https://github.com/ggml-org/llama.cpp/issues/12836
    if (params.embedding && params.n_batch > params.n_ubatch) {
        LOG_WRN("%s: embeddings enabled with n_batch (%d) > n_ubatch (%d)\n", __func__, params.n_batch, params.n_ubatch);
        LOG_WRN("%s: setting n_batch = n_ubatch = %d to avoid assertion failure\n", __func__, params.n_ubatch);
        params.n_batch = params.n_ubatch;
    }

    if (params.n_parallel < 0) {
        LOG_INF("%s: n_parallel is set to auto, using n_parallel = 4 and kv_unified = true\n", __func__);

        params.n_parallel = 4;
        params.kv_unified = true;
    }

    // for consistency between server router mode and single-model mode, we set the same model name as alias
    if (params.model_alias.empty() && !params.model.name.empty()) {
        params.model_alias = params.model.name;
    }

    // Mmojo Server START
    // This could be automated by looking for "common_init();" and inserting this block immediately after. -Brad 2025-11-05
    // fix params -- model, path, ssl-key-file, ssl-cert-file
    // if they are relative paths, fix to absolute relative to working directory
    if (supportPath != "") {
        const std::string& supportRootPath = "/support/";
      
        if (starts_with(params.model.path, supportRootPath)) {
            printf("\n");
            printf("--model path starts with %s.\n",  supportRootPath.c_str());
            params.model.path.replace(0, supportRootPath.length(), supportPath);
            printf("  - new model path: %s\n", params.model.path.c_str());
        }
        if (starts_with(params.public_path, supportRootPath)) {
            printf("\n");
            printf("--path path starts with %s.\n",  supportRootPath.c_str());
            params.public_path.replace(0, supportRootPath.length(), supportPath);
            printf("  - new path path: %s\n", params.public_path.c_str());
        }
        if (starts_with(params.ssl_file_key, supportRootPath)) {
            printf("\n");
            printf("--ssl-key-file path starts with %s.\n",  supportRootPath.c_str());
            params.ssl_file_key.replace(0, supportRootPath.length(), supportPath);
            printf("  - new ssl-key-file path: %s\n", params.ssl_file_key.c_str());
        }
        if (starts_with(params.ssl_file_cert, supportRootPath)) {
            printf("\n");
            printf("--ssl-cert-file path starts with %s.\n",  supportRootPath.c_str());
            params.ssl_file_cert.replace(0, supportRootPath.length(), supportPath);
            printf("  - new ssl-cert-file path: %s\n", params.ssl_file_cert.c_str());
        }
    }
    // Mmojo Server END
  
    common_init();

    // struct that contains llama context and inference
    server_context ctx_server;

    llama_backend_init();
    llama_numa_init(params.numa);

    LOG_INF("system info: n_threads = %d, n_threads_batch = %d, total_threads = %d\n", params.cpuparams.n_threads, params.cpuparams_batch.n_threads, std::thread::hardware_concurrency());
    LOG_INF("\n");
    LOG_INF("%s\n", common_params_get_system_info(params).c_str());
    LOG_INF("\n");

    server_http_context ctx_http;
    if (!ctx_http.init(params)) {
        LOG_ERR("%s: failed to initialize HTTP server\n", __func__);
        return 1;
    }

    //
    // Router
    //

    // register API routes
    server_routes routes(params, ctx_server);

    bool is_router_server = params.model.path.empty();
    std::optional<server_models_routes> models_routes{};
    if (is_router_server) {
        // setup server instances manager
        try {
            models_routes.emplace(params, argc, argv);
        } catch (const std::exception & e) {
            LOG_ERR("%s: failed to initialize router models: %s\n", __func__, e.what());
            return 1;
        }

        // proxy handlers
        // note: routes.get_health stays the same
        routes.get_metrics                 = models_routes->proxy_get;
        routes.post_props                  = models_routes->proxy_post;
        routes.get_api_show                = models_routes->proxy_get;
        routes.post_completions            = models_routes->proxy_post;
        routes.post_completions_oai        = models_routes->proxy_post;
        routes.post_chat_completions       = models_routes->proxy_post;
        routes.post_anthropic_messages     = models_routes->proxy_post;
        routes.post_anthropic_count_tokens = models_routes->proxy_post;
        routes.post_infill                 = models_routes->proxy_post;
        routes.post_embeddings             = models_routes->proxy_post;
        routes.post_embeddings_oai         = models_routes->proxy_post;
        routes.post_rerank                 = models_routes->proxy_post;
        routes.post_tokenize               = models_routes->proxy_post;
        routes.post_detokenize             = models_routes->proxy_post;
        routes.post_apply_template         = models_routes->proxy_post;
        routes.get_lora_adapters           = models_routes->proxy_get;
        routes.post_lora_adapters          = models_routes->proxy_post;
        routes.get_slots                   = models_routes->proxy_get;
        routes.post_slots                  = models_routes->proxy_post;

        // custom routes for router
        routes.get_props  = models_routes->get_router_props;
        routes.get_models = models_routes->get_router_models;
        ctx_http.post("/models/load",   ex_wrapper(models_routes->post_router_models_load));
        ctx_http.post("/models/unload", ex_wrapper(models_routes->post_router_models_unload));
    }

    ctx_http.get ("/health",              ex_wrapper(routes.get_health)); // public endpoint (no API key check)
    ctx_http.get ("/v1/health",           ex_wrapper(routes.get_health)); // public endpoint (no API key check)
    ctx_http.get ("/metrics",             ex_wrapper(routes.get_metrics));
    ctx_http.get ("/props",               ex_wrapper(routes.get_props));
    ctx_http.post("/props",               ex_wrapper(routes.post_props));
    ctx_http.post("/api/show",            ex_wrapper(routes.get_api_show));
    ctx_http.get ("/models",              ex_wrapper(routes.get_models)); // public endpoint (no API key check)
    ctx_http.get ("/v1/models",           ex_wrapper(routes.get_models)); // public endpoint (no API key check)
    ctx_http.get ("/api/tags",            ex_wrapper(routes.get_models)); // ollama specific endpoint. public endpoint (no API key check)
    ctx_http.post("/completion",          ex_wrapper(routes.post_completions)); // legacy
    ctx_http.post("/completions",         ex_wrapper(routes.post_completions));
    ctx_http.post("/v1/completions",      ex_wrapper(routes.post_completions_oai));
    ctx_http.post("/chat/completions",    ex_wrapper(routes.post_chat_completions));
    ctx_http.post("/v1/chat/completions", ex_wrapper(routes.post_chat_completions));
    ctx_http.post("/api/chat",            ex_wrapper(routes.post_chat_completions)); // ollama specific endpoint
    ctx_http.post("/v1/messages",         ex_wrapper(routes.post_anthropic_messages)); // anthropic messages API
    ctx_http.post("/v1/messages/count_tokens", ex_wrapper(routes.post_anthropic_count_tokens)); // anthropic token counting
    ctx_http.post("/infill",              ex_wrapper(routes.post_infill));
    ctx_http.post("/embedding",           ex_wrapper(routes.post_embeddings)); // legacy
    ctx_http.post("/embeddings",          ex_wrapper(routes.post_embeddings));
    ctx_http.post("/v1/embeddings",       ex_wrapper(routes.post_embeddings_oai));
    ctx_http.post("/rerank",              ex_wrapper(routes.post_rerank));
    ctx_http.post("/reranking",           ex_wrapper(routes.post_rerank));
    ctx_http.post("/v1/rerank",           ex_wrapper(routes.post_rerank));
    ctx_http.post("/v1/reranking",        ex_wrapper(routes.post_rerank));
    ctx_http.post("/tokenize",            ex_wrapper(routes.post_tokenize));
    ctx_http.post("/detokenize",          ex_wrapper(routes.post_detokenize));
    ctx_http.post("/apply-template",      ex_wrapper(routes.post_apply_template));
    // LoRA adapters hotswap
    ctx_http.get ("/lora-adapters",       ex_wrapper(routes.get_lora_adapters));
    ctx_http.post("/lora-adapters",       ex_wrapper(routes.post_lora_adapters));
    // Save & load slots
    ctx_http.get ("/slots",               ex_wrapper(routes.get_slots));
    ctx_http.post("/slots/:id_slot",      ex_wrapper(routes.post_slots));

    //
    // Start the server
    //

    std::function<void()> clean_up;

    if (is_router_server) {
        LOG_INF("%s: starting router server, no model will be loaded in this process\n", __func__);

        clean_up = [&models_routes]() {
            SRV_INF("%s: cleaning up before exit...\n", __func__);
            if (models_routes.has_value()) {
                models_routes->models.unload_all();
            }
            llama_backend_free();
        };

        if (!ctx_http.start()) {
            clean_up();
            LOG_ERR("%s: exiting due to HTTP server error\n", __func__);
            return 1;
        }
        ctx_http.is_ready.store(true);

        shutdown_handler = [&](int) {
            ctx_http.stop();
        };

    } else {
        // setup clean up function, to be called before exit
        clean_up = [&ctx_http, &ctx_server]() {
            SRV_INF("%s: cleaning up before exit...\n", __func__);
            ctx_http.stop();
            ctx_server.terminate();
            llama_backend_free();
        };

        // start the HTTP server before loading the model to be able to serve /health requests
        if (!ctx_http.start()) {
            clean_up();
            LOG_ERR("%s: exiting due to HTTP server error\n", __func__);
            return 1;
        }

        // load the model
        LOG_INF("%s: loading model\n", __func__);

        if (!ctx_server.load_model(params)) {
            clean_up();
            if (ctx_http.thread.joinable()) {
                ctx_http.thread.join();
            }
            LOG_ERR("%s: exiting due to model loading error\n", __func__);
            return 1;
        }

        routes.update_meta(ctx_server);
        ctx_http.is_ready.store(true);

        LOG_INF("%s: model loaded\n", __func__);

        shutdown_handler = [&](int) {
            // this will unblock start_loop()
            ctx_server.terminate();
        };
    }

    // TODO: refactor in common/console
#if defined (__unix__) || (defined (__APPLE__) && defined (__MACH__))
    struct sigaction sigint_action;
    sigint_action.sa_handler = signal_handler;
    sigemptyset (&sigint_action.sa_mask);
    sigint_action.sa_flags = 0;
    sigaction(SIGINT, &sigint_action, NULL);
    sigaction(SIGTERM, &sigint_action, NULL);
#elif defined (_WIN32)
    auto console_ctrl_handler = +[](DWORD ctrl_type) -> BOOL {
        return (ctrl_type == CTRL_C_EVENT) ? (signal_handler(SIGINT), true) : false;
    };
    SetConsoleCtrlHandler(reinterpret_cast<PHANDLER_ROUTINE>(console_ctrl_handler), true);
#endif

    if (is_router_server) {
        LOG_INF("%s: router server is listening on %s\n", __func__, ctx_http.listening_address.c_str());
        LOG_INF("%s: NOTE: router mode is experimental\n", __func__);
        LOG_INF("%s:       it is not recommended to use this mode in untrusted environments\n", __func__);
        if (ctx_http.thread.joinable()) {
            ctx_http.thread.join(); // keep the main thread alive
        }

        // when the HTTP server stops, clean up and exit
        clean_up();
    } else {
        LOG_INF("%s: server is listening on %s\n", __func__, ctx_http.listening_address.c_str());
        LOG_INF("%s: starting the main loop...\n", __func__);

        // optionally, notify router server that this instance is ready
        const char * router_port = std::getenv("LLAMA_SERVER_ROUTER_PORT");
        std::thread monitor_thread;
        if (router_port != nullptr) {
            monitor_thread = server_models::setup_child_server(shutdown_handler);
        }

        // this call blocks the main thread until queue_tasks.terminate() is called
        ctx_server.start_loop();

        clean_up();
        if (ctx_http.thread.joinable()) {
            ctx_http.thread.join();
        }
        if (monitor_thread.joinable()) {
            monitor_thread.join();
        }

        auto * ll_ctx = ctx_server.get_llama_context();
        if (ll_ctx != nullptr) {
            llama_memory_breakdown_print(ll_ctx);
        }
    }

    return 0;
}
