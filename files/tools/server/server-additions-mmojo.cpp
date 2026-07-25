/*
  server-additions-mmojo.cpp as an adjunct file for tools/server/server-mmojo.cpp.
  Mmojo sepecifc function implementations will go in this file instead of server-mmojo.cpp.

  This file has been added to implement Mmojo Server specific fixes and features.

  -Brad 2026-03-03
  --
  Brad Hutchings
  brad@Mmojo.net
*/

#include "server-additions-mmojo.h"
#include "mmojo-args.h"

#include <signal.h>
#include <dirent.h>
#include <unistd.h>

#if defined(_WIN32)
#include <windows.h>
#endif

#if !defined(_WIN32) && !defined (__APPLE__) && !defined (__MACH__)
#include <linux/limits.h>
#endif

std::filesystem::path executablePath;
std::filesystem::path executableParentPath;
std::filesystem::path workingDirectoryPath;

std::filesystem::path argsPath;
std::filesystem::path supportPath;
std::filesystem::path supportArgsPath;
std::filesystem::path zipPath;
std::filesystem::path zipArgsPath;
std::filesystem::path firstGgufPath;

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

void replaceAll(std::string& str, const std::string& from, const std::string& to) {
    if(from.empty())
        return;
    size_t start_pos = 0;
    while((start_pos = str.find(from, start_pos)) != std::string::npos) {
        str.replace(start_pos, from.length(), to);
        // Move the search position forward by the length of the new substring
        start_pos += to.length(); 
    }
}

void get_important_paths(const char* argv_0, std::filesystem::path& executablePath, std::filesystem::path& workingDirectoryPath) {
    printf("\n");
    printf("- get_important_paths()\n");

    executablePath.clear();
    workingDirectoryPath.clear();

    if (argv_0 != NULL) {
        printf("  - argv_0: %s\n", argv_0);

        #if defined(_WIN32)
        std::string executablePathString = argv_0;
        replaceAll(executablePathString, "\\", "\\\\");
        //  printf("  - executablePathString: %s\n", (const char*) executablePathString.c_str());
        executablePath = (const char*) executablePathString.c_str();
        #else
        executablePath = argv_0;
        #endif

        char workingDirectory[PATH_MAX];
        workingDirectory[0] = '\0';

        if (getcwd(workingDirectory, sizeof(workingDirectory) - 1)) {
            printf("  - workingDirectory: %s\n", workingDirectory);

            #if defined(_WIN32)
            std::string workingDirectoryPathString = workingDirectory;
            replaceAll(workingDirectoryPathString, "\\", "\\\\");
            //  printf("  - workingDirectoryPathString: %s\n", (const char*) workingDirectoryPathString.c_str());
            workingDirectoryPath = (const char*) workingDirectoryPathString.c_str();
            #else
            workingDirectoryPath = workingDirectory;
            #endif
        }

        if (!executablePath.has_root_path()) {
            executablePath = workingDirectory;
            executablePath /= argv_0;
        }
    }

    printf("  - Raw paths:\n");
    mmojo_printf("    - workingDirectoryPath: %s\n", (const char*) workingDirectoryPath.c_str());
    mmojo_printf("    -       executablePath: %s\n", (const char*) executablePath.c_str());

    workingDirectoryPath = workingDirectoryPath.lexically_normal();
    executablePath = executablePath.lexically_normal();
  
    printf("  - Normalized paths:\n");
    mmojo_printf("    - workingDirectoryPath: %s\n", (const char*) workingDirectoryPath.c_str());
    mmojo_printf("    -       executablePath: %s\n", (const char*) executablePath.c_str());
}

void find_first_gguf(const std::filesystem::path& directoryPath, std::filesystem::path& ggufPath) {
    ggufPath.clear();
    printf("\n");
    mmojo_printf("- find_first_gguf() in %s:\n", (const char*) directoryPath.c_str());

    #if defined(_WIN32)
        _WDIR *dir;
        struct _wdirent *entry;
        dir = _wopendir((const wchar_t*) directoryPath.c_str());
  
        if (dir != NULL) {
            mmojo_printf("  - Looking for .gguf in %s:\n", (const char*) directoryPath.c_str());
            while ((entry = _wreaddir(dir)) != NULL) {
                using convert_type = std::codecvt_utf8<wchar_t>;
                std::wstring_convert<convert_type, wchar_t> converter;

                const std::string& filename = converter.to_bytes(entry->d_name);
                const std::string& extension = ".gguf";            
                const std::string& slash = "/";
                //  mmojo_printf("    - Considering (entry): %s\n", (const char*) entry->d_name);
                //  printf("    - Considering (filename): %s\n", filename.c_str());
                if (ends_with(filename, extension)) {
                    mmojo_printf("  - %s\n", (const char*) entry->d_name);
                    ggufPath = directoryPath;
                    ggufPath /= entry->d_name;
                    break;
                }
            }
            _wclosedir(dir);
        }
        else {
            perror("Error opening directory");
        }

    #else
        DIR *dir;
        struct dirent *entry;
        dir = opendir((const char*) directoryPath.c_str());
      
        if (dir != NULL) {
            mmojo_printf("  - Looking for .gguf in %s:\n", (const char*) directoryPath.c_str());
            while ((entry = readdir(dir)) != NULL) {
                const std::string& filename = entry->d_name;
                const std::string& extension = ".gguf";            
                const std::string& slash = "/";
                //  mmojo_printf("    - Considering: %s\n", entry->d_name);
                if (ends_with(filename, extension)) {
                    mmojo_printf("  - %s\n", entry->d_name);
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
    #endif
}

void mmojo_printf(const char* format, const char* stringParam) {
    std::string formatString = format;
    #if defined(_WIN32)
    replaceAll(formatString, "%s", "%ls");
    #endif
    printf(formatString.c_str(), stringParam);
}

void main_mmojo_server_1(char* argv_0) {
    printf("\n");
    printf("- main_mmojo_server_1(%s)\n", argv_0);

    // Keep the build from showing up as ape in the process list.
    #if defined (__APPLE__) && defined (__MACH__)
    pthread_setname_np(PROCESS_NAME);
    #else
    pthread_setname_np(pthread_self(), PROCESS_NAME);
    #endif

    //  Find paths we need.
    get_important_paths(argv_0, executablePath, workingDirectoryPath);
    executableParentPath = executablePath.parent_path();

    argsPath = executableParentPath;
    argsPath /= ARGS_FILENAME;
    
    supportPath = executableParentPath;
    supportPath /= SUPPORT_DIRECTORY_NAME;
  
    supportArgsPath = supportPath;
    supportArgsPath /= ARGS_FILENAME;
    
    zipPath = "/zip";
    zipArgsPath = zipPath;
    zipArgsPath /= ARGS_FILENAME;

    // Find a .gguf model to use as a last resort before going into router mode.
    // This makes the naked APEs possible.
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
}

void main_path_diagnostics() {
    printf("\n");
    printf("- main_path_diagnostics()\n");

    printf("\n");
    printf("  - Paths of things we care about:\n");
    mmojo_printf("    -       executablePath: %s\n", (const char*) executablePath.c_str());
    mmojo_printf("    - executableParentPath: %s\n", (const char*) executableParentPath.c_str());
    mmojo_printf("    - workingDirectoryPath: %s\n", (const char*) workingDirectoryPath.c_str());
    mmojo_printf("    -             argsPath: %s\n", (const char*) argsPath.c_str());
    mmojo_printf("    -          supportPath: %s\n", (const char*) supportPath.c_str());
    mmojo_printf("    -      supportArgsPath: %s\n", (const char*) supportArgsPath.c_str());
    mmojo_printf("    -              zipPath: %s\n", (const char*) zipPath.c_str());
    mmojo_printf("    -          zipArgsPath: %s\n", (const char*) zipArgsPath.c_str());
    mmojo_printf("    -        firstGgufPath: %s\n", (const char*) firstGgufPath.c_str());

    printf("\n");
    printf("- These paths exist:\n");
    if (std::filesystem::exists(executablePath)) {
        mmojo_printf("    -       executablePath exists: %s\n", (const char*) executablePath.c_str());
    }
    if (std::filesystem::exists(executableParentPath)) {
        mmojo_printf("    - executableParentPath exists: %s\n", (const char*) executableParentPath.c_str());
    }
    if (std::filesystem::exists(workingDirectoryPath)) {
        mmojo_printf("    - workingDirectoryPath exists: %s\n", (const char*) workingDirectoryPath.c_str());
    }
    if (std::filesystem::exists(argsPath)) {
        mmojo_printf("    -             argsPath exists: %s\n", (const char*) argsPath.c_str());
    }
    if (std::filesystem::exists(supportPath)) {
        mmojo_printf("    -          supportPath exists: %s\n", (const char*) supportPath.c_str());
    }
    if (std::filesystem::exists(supportArgsPath)) {
        mmojo_printf("    -      supportArgsPath exists: %s\n", (const char*) supportArgsPath.c_str());
    }
    if (std::filesystem::exists(zipPath)) {
        mmojo_printf("    -              zipPath exists: %s\n", (const char*) zipPath.c_str());
    }
    if (std::filesystem::exists(zipArgsPath)) {
        mmojo_printf("    -          zipArgsPath exists: %s\n", (const char*) zipArgsPath.c_str());
    }  
    if (std::filesystem::exists(firstGgufPath)) {
        mmojo_printf("    -        firstGgufPath exists: %s\n", (const char*) firstGgufPath.c_str());
    }  
}

void main_args_files(int& argc, char **& argv) {
    printf("\n");
    printf("- main_args_files()\n");

    // Implement an args file feature inspired by llamafile's.
    // It does not require Cosmo anymore, as the mmojo_args function is part of mmojo-server now.
    // This is where we modify argc and argv!!

    // At this point, argc, argv represent:
    //     command (User supplied args)

    #if defined(_WIN32)
    using convert_type = std::codecvt_utf8<wchar_t>;
    std::wstring_convert<convert_type, wchar_t> converter;
    #endif
  
    if (std::filesystem::exists(argsPath)) {
        #if defined(_WIN32)
        const std::string& filename = converter.to_bytes(argsPath.c_str());
        #else
        const std::string& filename = (const char*) argsPath.c_str();
        #endif

        printf("  - using argsPath: %s\n", (const char*) filename.c_str());
        argc = mmojo_args((const char*) filename.c_str(), &argv);
    }

    // At this point, argc, argv represent:
    //     command (argsPath args) (User supplied args)

    if (std::filesystem::exists(supportArgsPath)) {
        #if defined(_WIN32)
        const std::string& filename = converter.to_bytes(supportArgsPath.c_str());
        #else
        const std::string& filename = (const char*) supportArgsPath.c_str();
        #endif

        printf("  - using argsPath: %s\n", (const char*) filename.c_str());
        argc = mmojo_args((const char*) filename.c_str(), &argv);
    }

    // At this point, argc, argv represent:
    //     command (supportArgsPath args) (argsPath args) (User supplied args)

    #ifdef COSMOCC
    if (std::filesystem::exists(zipArgsPath)) {
        // We don't use MinGW to compile for Windows under COSMOCC
        argc = mmojo_args((const char*) zipArgsPath.c_str(), &argv);
    }

    // At this point, argc, argv represent:
    //     command (zipArgsPath args) (supportArgsPath args) (argsPath args) (User supplied args)
    #endif

    // Yep, this is counterintuitive, but how the mmojo_args command works.
}

void main_mmojo_server_2(common_params& params) {
    printf("\n");
    printf("- main_mmojo_server_2()\n");

    printf("  - Checking for missing model and model inside APE zip.\n");
    
    // If we have no model path at this point, use the firstGgufPath.
    // I think I have all the possibilities for specifying a model covered here.
    if ((params.model.path == "") && (params.model.url == "") && (params.model.docker_repo == "") &&  
        (params.model.hf_repo == "") && (params.model.hf_file == "") && 
        std::filesystem::exists(firstGgufPath)) {

        #if defined(_WIN32)
        using convert_type = std::codecvt_utf8<wchar_t>;
        std::wstring_convert<convert_type, wchar_t> converter;
        const std::string& firstGgufPathString = converter.to_bytes(firstGgufPath.c_str());

        printf("  - Using firstGgufPath for model: %s\n", (const char*) firstGgufPathString.c_str());
        params.model.path = (const char*) firstGgufPathString.c_str();
        #else
        printf("  - Using firstGgufPath for model: %s\n", (const char*) firstGgufPath.c_str());
        params.model.path = (const char*) firstGgufPath.c_str();
        #endif
    }
    
    #ifdef COSMOCC
    const std::string zipPathSlash = "/zip/";
    if (starts_with(params.model.path, zipPathSlash)) {
        // if the gguf is in the zip file, we have to turn off use_map.
        printf("  - The model file is in /zip, so turning off use_mmap.\n\n");
        params.use_mmap = false;
    }
    #endif
}

void main_mmojo_server_3(common_params& params) {
    printf("\n");
    printf("- main_mmojo_server_3()\n");

  // This could be automated by looking for "common_init();" and inserting this block immediately after. -Brad 2025-11-05
    // fix params -- model, path, ssl-key-file, ssl-cert-file
    // if they are relative paths, fix to absolute relative to working directory
    if (supportPath != "") {
        const std::string& supportRootPath = "/support/";
        std::string supportPathSlash = (const char*) supportPath.c_str();
        supportPathSlash += "/";
      
        if (starts_with(params.model.path, supportRootPath)) {
            printf("\n");
            mmojo_printf("--model path starts with %s.\n", (const char*) supportRootPath.c_str());
            params.model.path.replace(0, supportRootPath.length(), (const char*) supportPathSlash.c_str());
            printf("  - new model path: %s\n", (const char*) params.model.path.c_str());
        }
        if (starts_with(params.public_path, supportRootPath)) {
            printf("\n");
            mmojo_printf("--path path starts with %s.\n", (const char*) supportRootPath.c_str());
            params.public_path.replace(0, supportRootPath.length(), (const char*) supportPathSlash.c_str());
            printf("  - new path path: %s\n", (const char*) params.public_path.c_str());
        }
        if (starts_with(params.ssl_file_key, supportRootPath)) {
            printf("\n");
            mmojo_printf("--ssl-key-file path starts with %s.\n", (const char*) supportRootPath.c_str());
            params.ssl_file_key.replace(0, supportRootPath.length(), (const char*) supportPathSlash.c_str());
            printf("  - new ssl-key-file path: %s\n", (const char*) params.ssl_file_key.c_str());
        }
        if (starts_with(params.ssl_file_cert, supportRootPath)) {
            printf("\n");
            mmojo_printf("--ssl-cert-file path starts with %s.\n", (const char*) supportRootPath.c_str());
            params.ssl_file_cert.replace(0, supportRootPath.length(), (const char*) supportPathSlash.c_str());
            printf("  - new ssl-cert-file path: %s\n", (const char*) params.ssl_file_cert.c_str());
        }
    }
    if (executableParentPath != "") {
        const std::string& executableRootPath = "/app/";
        std::string executableParentPathSlash = (const char*) executableParentPath.c_str();
        executableParentPathSlash += "/";
      
        if (starts_with(params.model.path, executableRootPath)) {
            printf("\n");
            mmojo_printf("--model path starts with %s.\n", (const char*) executableRootPath.c_str());
            params.model.path.replace(0, executableRootPath.length(), (const char*) executableParentPathSlash.c_str());
            printf("  - new model path: %s\n", (const char*) params.model.path.c_str());
        }
        if (starts_with(params.public_path, executableRootPath)) {
            printf("\n");
            mmojo_printf("--path path starts with %s.\n", (const char*) executableRootPath.c_str());
            params.public_path.replace(0, executableRootPath.length(), (const char*) executableParentPathSlash.c_str());
            printf("  - new path path: %s\n", (const char*) params.public_path.c_str());
        }
        if (starts_with(params.ssl_file_key, executableRootPath)) {
            printf("\n");
            mmojo_printf("--ssl-key-file path starts with %s.\n", (const char*) executableRootPath.c_str());
            params.ssl_file_key.replace(0, executableRootPath.length(), (const char*) executableParentPathSlash.c_str());
            printf("  - new ssl-key-file path: %s\n", (const char*) params.ssl_file_key.c_str());
        }
        if (starts_with(params.ssl_file_cert, executableRootPath)) {
            printf("\n");
            mmojo_printf("--ssl-cert-file path starts with %s.\n", (const char*) executableRootPath.c_str());
            params.ssl_file_cert.replace(0, executableRootPath.length(), (const char*) executableParentPathSlash.c_str());
            printf("  - new ssl-cert-file path: %s\n", (const char*) params.ssl_file_cert.c_str());
        }
    }
}

