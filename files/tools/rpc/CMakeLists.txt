#[[
	----------
	This is a modified source file for the Mmojo Server repo. It is covered by
	the repo's MIT-style LICENSE:

	https://github.com/BradHutchings/Mmojo-Server/blob/main/LICENSE

	Copyright (c) 2025-26 Brad Hutchings.
	--
	Brad Hutchings
	brad@Mmojo.net
]]

set(TARGET mmojo-rpc-server)

set(TARGET_SRCS
    rpc-server-mmojo.cpp
    rpc-server-additions-mmojo.h
    rpc-server-additions-mmojo.cpp
)

add_executable(${TARGET} ${TARGET_SRCS})

target_include_directories(${TARGET} PRIVATE ${CMAKE_SOURCE_DIR})
target_link_libraries(${TARGET} PRIVATE ggml PUBLIC llama-common)
target_compile_features(${TARGET} PRIVATE cxx_std_17)

if(LLAMA_TOOLS_INSTALL)
    install(TARGETS ${TARGET} RUNTIME)
endif()
