/*
  server-additions-mmojo.cpp as an adjunct file for tools/server/server-mmojo.h.
  Mmojo sepecifc function definitions will go in this file instead of privately
  within server-mmojo.cpp.

  This file has been added to implement Mmojo Server specific fixes and features.

  -Brad 2026-03-03
	----------
	This is a modified source file for the Mmojo Server repo. It is covered by
	the repo's MIT-style LICENSE:

	https://github.com/BradHutchings/Mmojo-Server/blob/main/LICENSE

	Copyright (c) 2025-26 Brad Hutchings.
	--
	Brad Hutchings
*/

#include "server-context.h"
#include "server-http.h"
#include "server-models.h"

#define PROCESS_NAME "mmojo-server"
#define ARGS_FILENAME "mmojo-server-args"
#define SUPPORT_DIRECTORY_NAME "mmojo-server-support"
#define PRODUCT_NAME "Mmojo Server"

// pre C++20 helpers.
bool starts_with (const std::string &fullString, const std::string &beginning);
bool ends_with (const std::string &fullString, const std::string &ending);
void replaceAll(std::string& str, const std::string& from, const std::string& to);
void get_important_paths(const char* argv_0, std::filesystem::path& executablePath, std::filesystem::path& workingDirectoryPath);
void find_first_gguf(const std::filesystem::path& directoryPath, std::filesystem::path& ggufPath);
void mmojo_printf(const char* format, const char* stringParam);

void main_mmojo_server_1(char* argv_0);
void main_path_diagnostics();
void main_args_files(int& argc, char **& argv);
void main_mmojo_server_2(common_params& params);
void main_mmojo_server_3(common_params& params);

extern std::filesystem::path executablePath;
extern std::filesystem::path executableParentPath;
extern std::filesystem::path workingDirectoryPath;

extern std::filesystem::path argsPath;
extern std::filesystem::path supportPath;
extern std::filesystem::path supportArgsPath;
extern std::filesystem::path zipPath;
extern std::filesystem::path zipArgsPath;
extern std::filesystem::path firstGgufPath;
