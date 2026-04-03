/*
  server-http-mmojo.cpp is a derivative for tools/server/server-http.cpp.

  This file has been modified to implement Mmojo Server specific
  Modifications are surrounded by:
    // Mmojo Server START
    // Mmojo Server END
    
  Original server.cpp file:
      https://raw.githubusercontent.com/ggml-org/llama.cpp/refs/heads/master/tools/server/server.cpp

  -Brad 2025-11-25
  --
  Brad Hutchings
  brad@bradhutchings.com
*/

#include "common.h"
#include "server-http.h"
#include "server-common.h"

#include <cpp-httplib/httplib.h>

#include <functional>
#include <string>
#include <thread>

#ifdef LLAMA_BUILD_WEBUI
// auto generated files (see README.md for details)
#include "index.html.hpp"
#include "bundle.js.hpp"
#include "bundle.css.hpp"
// Mmojo Server START -- XXX
// This could be automated by searhing for "loading.html.hpp" and replacing that line with this block.
// #include "loading.html.hpp"
#include "loading-mmojo.html.hpp"

// pre C++20 helpers.
bool starts_with (std::string const &fullString, std::string const &beginning);
bool ends_with (std::string const &fullString, std::string const &ending);
// Mmojo Server END
#endif

//
// HTTP implementation using cpp-httplib
//

class server_http_context::Impl {
public:
    std::unique_ptr<httplib::Server> srv;
};

server_http_context::server_http_context()
    : pimpl(std::make_unique<server_http_context::Impl>())
{}

server_http_context::~server_http_context() = default;

static void log_server_request(const httplib::Request & req, const httplib::Response & res) {
    // skip logging requests that are regularly sent, to avoid log spam
    if (req.path == "/health"
        || req.path == "/v1/health"
        || req.path == "/models"
        || req.path == "/v1/models"
        || req.path == "/props"
        || req.path == "/metrics"
    ) {
        return;
    }

    // reminder: this function is not covered by httplib's exception handler; if someone does more complicated stuff, think about wrapping it in try-catch

    SRV_INF("done request: %s %s %s %d\n", req.method.c_str(), req.path.c_str(), req.remote_addr.c_str(), res.status);

    SRV_DBG("request:  %s\n", req.body.c_str());
    SRV_DBG("response: %s\n", res.body.c_str());
}

bool server_http_context::init(const common_params & params) {
    path_prefix = params.api_prefix;
    port = params.port;
    hostname = params.hostname;

    auto & srv = pimpl->srv;

#ifdef CPPHTTPLIB_OPENSSL_SUPPORT
    if (params.ssl_file_key != "" && params.ssl_file_cert != "") {
        LOG_INF("Running with SSL: key = %s, cert = %s\n", params.ssl_file_key.c_str(), params.ssl_file_cert.c_str());
        srv.reset(
            new httplib::SSLServer(params.ssl_file_cert.c_str(), params.ssl_file_key.c_str())
        );
    } else {
        LOG_INF("Running without SSL\n");
        srv.reset(new httplib::Server());
    }
#else
    if (params.ssl_file_key != "" && params.ssl_file_cert != "") {
        LOG_ERR("Server is built without SSL support\n");
        return false;
    }
    srv.reset(new httplib::Server());
#endif

    srv->set_default_headers({{"Server", "llama.cpp"}});
    srv->set_logger(log_server_request);
    srv->set_exception_handler([](const httplib::Request &, httplib::Response & res, const std::exception_ptr & ep) {
        // this is fail-safe; exceptions should already handled by `ex_wrapper`

        std::string message;
        try {
            std::rethrow_exception(ep);
        } catch (const std::exception & e) {
            message = e.what();
        } catch (...) {
            message = "Unknown Exception";
        }

        res.status = 500;
        res.set_content(message, "text/plain");
        LOG_ERR("got exception: %s\n", message.c_str());
    });

    srv->set_error_handler([](const httplib::Request &, httplib::Response & res) {
        if (res.status == 404) {
            res.set_content(
                safe_json_to_str(json {
                    {"error", {
                        {"message", "File Not Found"},
                        {"type", "not_found_error"},
                        {"code", 404}
                    }}
                }),
                "application/json; charset=utf-8"
            );
        }
        // for other error codes, we skip processing here because it's already done by res->error()
    });

    // set timeouts and change hostname and port
    srv->set_read_timeout (params.timeout_read);
    srv->set_write_timeout(params.timeout_write);
    srv->set_socket_options([reuse_port = params.reuse_port](socket_t sock) {
        httplib::set_socket_opt(sock, SOL_SOCKET, SO_REUSEADDR, 1);
        if (reuse_port) {
#ifdef SO_REUSEPORT
            httplib::set_socket_opt(sock, SOL_SOCKET, SO_REUSEPORT, 1);
#else
            LOG_WRN("%s: SO_REUSEPORT is not supported\n", __func__);
#endif
        }
    });

    if (params.api_keys.size() == 1) {
        auto key = params.api_keys[0];
        std::string substr = key.substr(std::max((int)(key.length() - 4), 0));
        LOG_INF("%s: api_keys: ****%s\n", __func__, substr.c_str());
    } else if (params.api_keys.size() > 1) {
        LOG_INF("%s: api_keys: %zu keys loaded\n", __func__, params.api_keys.size());
    }

    //
    // Middlewares
    //

    auto middleware_validate_api_key = [api_keys = params.api_keys](const httplib::Request & req, httplib::Response & res) {
        static const std::unordered_set<std::string> public_endpoints = {
            "/health",
            "/v1/health",
            "/models",
            "/v1/models",
            "/api/tags",
            "/",
            "/index.html",
            "/bundle.js",
            "/bundle.css",
        };

        // If API key is not set, skip validation
        if (api_keys.empty()) {
            return true;
        }

        // If path is public or static file, skip validation
        if (public_endpoints.find(req.path) != public_endpoints.end()) {
            return true;
        }

        // Check for API key in the Authorization header
        std::string req_api_key = req.get_header_value("Authorization");
        if (req_api_key.empty()) {
            // retry with anthropic header
            req_api_key = req.get_header_value("X-Api-Key");
        }

        // remove the "Bearer " prefix if needed
        std::string prefix = "Bearer ";
        if (req_api_key.substr(0, prefix.size()) == prefix) {
            req_api_key = req_api_key.substr(prefix.size());
        }

        // validate the API key
        if (std::find(api_keys.begin(), api_keys.end(), req_api_key) != api_keys.end()) {
            return true; // API key is valid
        }

        // API key is invalid or not provided
        res.status = 401;
        res.set_content(
            safe_json_to_str(json {
                {"error", {
                    {"message", "Invalid API Key"},
                    {"type", "authentication_error"},
                    {"code", 401}
                }}
            }),
            "application/json; charset=utf-8"
        );

        LOG_WRN("Unauthorized: Invalid API Key\n");

        return false;
    };

    auto middleware_server_state = [this](const httplib::Request & req, httplib::Response & res) {
        bool ready = is_ready.load();
        if (!ready) {
#ifdef LLAMA_BUILD_WEBUI
            auto tmp = string_split<std::string>(req.path, '.');
            
            // Mmojo Server START -- XXX
            // if (req.path == "/" || tmp.back() == "html") {
            //    res.status = 503;
            //    res.set_content(reinterpret_cast<const char*>(loading_html), loading_html_len, "text/html; charset=utf-8");
            // This can be automated by searching for "req.path == \"/models\"" then replacing previous 3 lines with this block. -Brad 2025-11-05
            if (req.path == "/" || tmp.back() == "html" || ends_with(req.path, "/") || ends_with(req.path, ".html")) {
                // res.set_content(reinterpret_cast<const char*>(loading_html), loading_html_len, "text/html; charset=utf-8");
                res.status = 503;
                res.set_content(reinterpret_cast<const char*>(loading_mmojo_html), loading_mmojo_html_len, "text/html; charset=utf-8");
            // Mmojo Server END

            } else
#endif
            {
                // no endpoints is allowed to be accessed when the server is not ready
                // this is to prevent any data races or inconsistent states
                res.status = 503;
                res.set_content(
                    safe_json_to_str(json {
                        {"error", {
                            {"message", "Loading model"},
                            {"type", "unavailable_error"},
                            {"code", 503}
                        }}
                    }),
                    "application/json; charset=utf-8"
                );
            }
            return false;
        }
        return true;
    };

    // register server middlewares
    srv->set_pre_routing_handler([middleware_validate_api_key, middleware_server_state](const httplib::Request & req, httplib::Response & res) {
        res.set_header("Access-Control-Allow-Origin", req.get_header_value("Origin"));
        // If this is OPTIONS request, skip validation because browsers don't include Authorization header
        if (req.method == "OPTIONS") {
            res.set_header("Access-Control-Allow-Credentials", "true");
            res.set_header("Access-Control-Allow-Methods",     "GET, POST");
            res.set_header("Access-Control-Allow-Headers",     "*");
            res.set_content("", "text/html"); // blank response, no data
            return httplib::Server::HandlerResponse::Handled; // skip further processing
        }
        if (!middleware_server_state(req, res)) {
            return httplib::Server::HandlerResponse::Handled;
        }
        if (!middleware_validate_api_key(req, res)) {
            return httplib::Server::HandlerResponse::Handled;
        }
        return httplib::Server::HandlerResponse::Unhandled;
    });

    // Mmojo Server START
    srv->set_post_routing_handler([](const httplib::Request & req, httplib::Response & res) {
        std::string cacheControlValue = "max-age=3600";
        std::string noCache = "no-cache, no-store, must-revalidate";
        //  LOG_INF("routing handler: %s\n", req.path.c_str());
      
        if (ends_with(req.path, ".html") || ends_with(req.path, "/")) {
            //  LOG_INF("Request ends with .html\n");
            cacheControlValue = noCache;
        }
        if (ends_with(req.path, ".js")) {
            //  LOG_INF("Request ends with .js\n");
            cacheControlValue = noCache;
        }
        if (ends_with(req.path, ".css")) {
            //  LOG_INF("Request ends with .css\n");
            cacheControlValue = noCache;
        }
        if (ends_with(req.path, ".json")) {
            //  LOG_INF("Request ends with .json\n");
            cacheControlValue = noCache;
        }
        if (starts_with(req.path, "/v1/")) {
            //  LOG_INF("Request is an API call.\n");
            cacheControlValue = noCache;
        }
        res.set_header("Cache-Control", cacheControlValue);
    });    
    // Mmojo Server END

    int n_threads_http = params.n_threads_http;
    if (n_threads_http < 1) {
        // +4 threads for monitoring, health and some threads reserved for MCP and other tasks in the future
        n_threads_http = std::max(params.n_parallel + 4, (int32_t) std::thread::hardware_concurrency() - 1);
    }
    LOG_INF("%s: using %d threads for HTTP server\n", __func__, n_threads_http);
    srv->new_task_queue = [n_threads_http] {
        // spawn n_threads_http fixed thread (always alive), while allow up to 1024 max possible additional threads
        // when n_threads_http is used, server will create new "dynamic" threads that will be destroyed after processing each request
        // ref: https://github.com/yhirose/cpp-httplib/pull/2368
        size_t max_threads = (size_t)n_threads_http + 1024;
        return new httplib::ThreadPool(n_threads_http, max_threads);
    };

    //
    // Web UI setup
    //

    if (!params.webui) {
        LOG_INF("Web UI is disabled\n");
    } else {
        // register static assets routes
        if (!params.public_path.empty()) {
            // Set the base directory for serving static files
            bool is_found = srv->set_mount_point(params.api_prefix + "/", params.public_path);
            if (!is_found) {
                LOG_ERR("%s: static assets path not found: %s\n", __func__, params.public_path.c_str());
                return 1;
            }
        } else {
#ifdef LLAMA_BUILD_WEBUI
            // using embedded static index.html
            srv->Get(params.api_prefix + "/", [](const httplib::Request & /*req*/, httplib::Response & res) {
                // COEP and COOP headers, required by pyodide (python interpreter)
                res.set_header("Cross-Origin-Embedder-Policy", "require-corp");
                res.set_header("Cross-Origin-Opener-Policy", "same-origin");
                res.set_content(reinterpret_cast<const char*>(index_html), index_html_len, "text/html; charset=utf-8");
                return false;
            });
            srv->Get(params.api_prefix + "/bundle.js", [](const httplib::Request & /*req*/, httplib::Response & res) {
                res.set_content(reinterpret_cast<const char*>(bundle_js), bundle_js_len, "application/javascript; charset=utf-8");
                return false;
            });
            srv->Get(params.api_prefix + "/bundle.css", [](const httplib::Request & /*req*/, httplib::Response & res) {
                res.set_content(reinterpret_cast<const char*>(bundle_css), bundle_css_len, "text/css; charset=utf-8");
                return false;
            });
#endif
        }
    }

    // Mmojo Server START
    // This can be automated by searching for "server_http_context::start" and inserting this block before the return true above. -Brad 2025-12-29
    // LOG_INF("%s%s\n", "default_ui_endpoint: ", params.default_ui_endpoint.c_str());

    if (params.default_ui_endpoint != "") {
        std::string endpoint = params.default_ui_endpoint;
        if (!starts_with(endpoint, "/")) {
            endpoint = "/" + endpoint;
        }
        while (ends_with(endpoint, "/")) {
            endpoint = endpoint.substr(0, endpoint.length() - 1);
        }

        // LOG_INF("-- %s%s\n", "endpoint: ", endpoint.c_str());
        
        // using embedded static index.html
        srv->Get(endpoint, [](const httplib::Request & req, httplib::Response & res) {
            res.set_redirect(req.path + "/");
            return false;
        });
        srv->Get(endpoint + "/", [](const httplib::Request & /*req*/, httplib::Response & res) {
            // COEP and COOP headers, required by pyodide (python interpreter)
            res.set_header("Cross-Origin-Embedder-Policy", "require-corp");
            res.set_header("Cross-Origin-Opener-Policy", "same-origin");
            res.set_content(reinterpret_cast<const char*>(index_html), index_html_len, "text/html; charset=utf-8");
            return false;
        });
        srv->Get(endpoint + "/bundle.js", [](const httplib::Request & /*req*/, httplib::Response & res) {
            res.set_content(reinterpret_cast<const char*>(bundle_js), bundle_js_len, "application/javascript; charset=utf-8");
            return false;
        });
        srv->Get(endpoint + "/bundle.css", [](const httplib::Request & /*req*/, httplib::Response & res) {
            res.set_content(reinterpret_cast<const char*>(bundle_css), bundle_css_len, "text/css; charset=utf-8");
            return false;
        });

        srv->Get(endpoint + "/props", [](const httplib::Request & req, httplib::Response & res) {
            printf("Redirecting %s /props to /props\n", endpoint.c_str());
            res.set_redirect("/props");
            return false;
        });

        srv->Get(endpoint + R"/v1/.*", [endpoint](const httplib::Request & req, httplib::Response & res) {
            printf("Redirecting %s /v1/*. to /v1/*.\n", endpoint.c_str());
            std::string new_path = req.path.substr(endpoint.length());
            printf("-- new_path: %s\n", new_path.c_str());
            res.set_redirect(new_path);
            return false;
        });

        /*
        srv->Get(endpoint, [](const httplib::Request & req, httplib::Response & res) {
              if (req.get_header_value("Accept-Encoding").find("gzip") == std::string::npos) {
                  res.set_content("Error: gzip is not supported by this browser", "text/plain");
              } else {
                  res.set_header("Content-Encoding", "gzip");
                  // COEP and COOP headers, required by pyodide (python interpreter)
                  res.set_header("Cross-Origin-Embedder-Policy", "require-corp");
                  res.set_header("Cross-Origin-Opener-Policy", "same-origin");
                  res.set_content(reinterpret_cast<const char*>(index_html), index_html_len, "text/html; charset=utf-8");
              }
              return false;
          });
  
          srv->Get(endpoint + "/", [](const httplib::Request & req, httplib::Response & res) {
              res.set_redirect(req.path.substr(0, req.path.length() - 1));
              return false;
          });
        */
    }
    // Mmojo Server END

    return true;
}

bool server_http_context::start() {
    // Bind and listen

    auto & srv = pimpl->srv;
    bool was_bound = false;
    bool is_sock = false;
    if (string_ends_with(std::string(hostname), ".sock")) {
        is_sock = true;
        LOG_INF("%s: setting address family to AF_UNIX\n", __func__);
        srv->set_address_family(AF_UNIX);
        // bind_to_port requires a second arg, any value other than 0 should
        // simply get ignored
        was_bound = srv->bind_to_port(hostname, 8080);
    } else {
        LOG_INF("%s: binding port with default address family\n", __func__);
        // bind HTTP listen port
        if (port == 0) {
            int bound_port = srv->bind_to_any_port(hostname);
            was_bound = (bound_port >= 0);
            if (was_bound) {
                port = bound_port;
            }
        } else {
            was_bound = srv->bind_to_port(hostname, port);
        }
    }

    if (!was_bound) {
        LOG_ERR("%s: couldn't bind HTTP server socket, hostname: %s, port: %d\n", __func__, hostname.c_str(), port);
        return false;
    }

    // run the HTTP server in a thread
    thread = std::thread([this]() { pimpl->srv->listen_after_bind(); });
    srv->wait_until_ready();

    listening_address = is_sock ? string_format("unix://%s",    hostname.c_str())
                                : string_format("http://%s:%d", hostname.c_str(), port);
    return true;
}

void server_http_context::stop() const {
    if (pimpl->srv) {
        pimpl->srv->stop();
    }
}

static void set_headers(httplib::Response & res, const std::map<std::string, std::string> & headers) {
    for (const auto & [key, value] : headers) {
        res.set_header(key, value);
    }
}

static std::map<std::string, std::string> get_params(const httplib::Request & req) {
    std::map<std::string, std::string> params;
    for (const auto & [key, value] : req.params) {
        params[key] = value;
    }
    for (const auto & [key, value] : req.path_params) {
        params[key] = value;
    }
    return params;
}

static std::map<std::string, std::string> get_headers(const httplib::Request & req) {
    std::map<std::string, std::string> headers;
    for (const auto & [key, value] : req.headers) {
        headers[key] = value;
    }
    return headers;
}

static std::string build_query_string(const httplib::Request & req) {
    std::string qs;
    for (const auto & [key, value] : req.params) {
        if (!qs.empty()) {
            qs += '&';
        }
        qs += httplib::encode_query_component(key) + "=" + httplib::encode_query_component(value);
    }
    return qs;
}

// using unique_ptr for request to allow safe capturing in lambdas
using server_http_req_ptr = std::unique_ptr<server_http_req>;

static void process_handler_response(server_http_req_ptr && request, server_http_res_ptr & response, httplib::Response & res) {
    if (response->is_stream()) {
        res.status = response->status;
        set_headers(res, response->headers);
        std::string content_type = response->content_type;
        // convert to shared_ptr as both chunked_content_provider() and on_complete() need to use it
        std::shared_ptr<server_http_req> q_ptr = std::move(request);
        std::shared_ptr<server_http_res> r_ptr = std::move(response);
        const auto chunked_content_provider = [response = r_ptr](size_t, httplib::DataSink & sink) -> bool {
            std::string chunk;
            bool has_next = response->next(chunk);
            if (!chunk.empty()) {
                // TODO: maybe handle sink.write unsuccessful? for now, we rely on is_connection_closed()
                sink.write(chunk.data(), chunk.size());
                SRV_DBG("http: streamed chunk: %s\n", chunk.c_str());
            }
            if (!has_next) {
                sink.done();
                SRV_DBG("%s", "http: stream ended\n");
            }
            return has_next;
        };
        const auto on_complete = [request = q_ptr, response = r_ptr](bool) mutable {
            response.reset(); // trigger the destruction of the response object
            request.reset();  // trigger the destruction of the request object
        };
        res.set_chunked_content_provider(content_type, chunked_content_provider, on_complete);
    } else {
        res.status = response->status;
        set_headers(res, response->headers);
        res.set_content(response->data, response->content_type);
    }
}

void server_http_context::get(const std::string & path, const server_http_context::handler_t & handler) const {
    pimpl->srv->Get(path_prefix + path, [handler](const httplib::Request & req, httplib::Response & res) {
        server_http_req_ptr request = std::make_unique<server_http_req>(server_http_req{
            get_params(req),
            get_headers(req),
            req.path,
            build_query_string(req),
            req.body,
            req.is_connection_closed
        });
        server_http_res_ptr response = handler(*request);
        process_handler_response(std::move(request), response, res);
    });
}

void server_http_context::post(const std::string & path, const server_http_context::handler_t & handler) const {
    pimpl->srv->Post(path_prefix + path, [handler](const httplib::Request & req, httplib::Response & res) {
        server_http_req_ptr request = std::make_unique<server_http_req>(server_http_req{
            get_params(req),
            get_headers(req),
            req.path,
            build_query_string(req),
            req.body,
            req.is_connection_closed
        });
        server_http_res_ptr response = handler(*request);
        process_handler_response(std::move(request), response, res);
    });
}
