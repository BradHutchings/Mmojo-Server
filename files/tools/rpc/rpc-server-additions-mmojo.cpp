/*
  rpc-server-additions-mmojo.cpp as an adjunct file for tools/rpc/rpc-server-mmojo.cpp.
  Mmojo specific function implementations will go in this file instead of rpc-server-mmojo.cpp.

  This file has been added to implement Mmojo Server specific fixes and features.

  -Brad 2026-03-17
	----------
	This is a modified source file for the Mmojo Server repo. It is covered by
	the repo's MIT-style LICENSE:

	https://github.com/BradHutchings/Mmojo-Server/blob/main/LICENSE

	Copyright (c) 2025-26 Brad Hutchings.
	--
	Brad Hutchings
	brad@Mmojo.net
*/

#include "rpc-server-additions-mmojo.h"
#include "common/mmojo-args.h"

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
std::filesystem::path zipPath;
std::filesystem::path zipArgsPath;

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

void mmojo_printf(const char* format, const char* stringParam) {
    std::string formatString = format;
    #if defined(_WIN32)
    replaceAll(formatString, "%s", "%ls");
    #endif
    printf(formatString.c_str(), stringParam);
}

void main_addition_1(char* argv_0) {
    printf("\n");
    printf("- main_addition_1(%s)\n", argv_0);

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
        
    zipPath = "/zip";
    zipArgsPath = zipPath;
    zipArgsPath /= ARGS_FILENAME;
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
    mmojo_printf("    -              zipPath: %s\n", (const char*) zipPath.c_str());
    mmojo_printf("    -          zipArgsPath: %s\n", (const char*) zipArgsPath.c_str());

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
    if (std::filesystem::exists(zipPath)) {
        mmojo_printf("    -              zipPath exists: %s\n", (const char*) zipPath.c_str());
    }
    if (std::filesystem::exists(zipArgsPath)) {
        mmojo_printf("    -          zipArgsPath exists: %s\n", (const char*) zipArgsPath.c_str());
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
