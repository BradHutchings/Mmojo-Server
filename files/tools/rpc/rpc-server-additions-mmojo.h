/*
  rpc-server-additions-mmojo.cpp as an adjunct file for tools/rpc/rpc-server-mmojo.cpp.
  Mmojo sepecifc function definitions will go in this file instead of privately
  within rpc-server-mmojo.cpp.

  This file has been added to implement Mmojo Server specific fixes and features.

  -Brad 2026-03-17
  --
  Brad Hutchings
  brad@bradhutchings.com
*/

#define PROCESS_NAME "mmojo-rpc-server"
#define ARGS_FILENAME "mmojo-rpc-server-args"
#define PRODUCT_NAME "Mmojo RPC Server"

// pre C++20 helpers.
bool starts_with (const std::string &fullString, const std::string &beginning);
bool ends_with (const std::string &fullString, const std::string &ending);
void replaceAll(std::string& str, const std::string& from, const std::string& to);
void get_important_paths(const char* argv_0, std::filesystem::path& executablePath, std::filesystem::path& workingDirectoryPath);
void mmojo_printf(const char* format, const char* stringParam);

void main_addition_1(char* argv_0);
void main_path_diagnostics();
void main_args_files(int& argc, char **& argv);

extern std::filesystem::path executablePath;
extern std::filesystem::path executableParentPath;
extern std::filesystem::path workingDirectoryPath;

extern std::filesystem::path argsPath;
