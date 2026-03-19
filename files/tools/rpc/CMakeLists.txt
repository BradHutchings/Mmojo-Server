set(TARGET mmojo-rpc-server)

set(TARGET_SRCS
    rpc-server-mmojo.cpp
    rpc-server-additions-mmojo.h
    rpc-server-additions-mmojo.cpp
)

add_executable(${TARGET} ${TARGET_SRCS})

target_include_directories(${TARGET} PRIVATE ${CMAKE_SOURCE_DIR})
target_link_libraries(${TARGET} PRIVATE ggml PUBLIC common)
target_compile_features(${TARGET} PRIVATE cxx_std_17)

if(LLAMA_TOOLS_INSTALL)
    install(TARGETS ${TARGET} RUNTIME)
endif()
