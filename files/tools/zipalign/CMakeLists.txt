################################################################################
# This CMakeLists.txt script builds zipalign. mm-zipalign is only built with
# Cosmo, and assembled as an Actual Portable Executable (APE) file.
#
# See licensing note at end.
################################################################################

set(TARGET mm-zipalign)

include_directories(${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_BINARY_DIR})

set(TARGET_SRCS
    zip.c
    zipalign.c
)
add_executable(${TARGET} ${TARGET_SRCS})

if(LLAMA_TOOLS_INSTALL)
    install(TARGETS ${TARGET} RUNTIME)
endif()

target_link_libraries(${TARGET} PRIVATE common ${CMAKE_THREAD_LIBS_INIT})

if (WIN32)
    TARGET_LINK_LIBRARIES(${TARGET} PRIVATE ws2_32)
endif()

target_compile_features(${TARGET} PRIVATE cxx_std_17)

################################################################################
#  This is an original script for the Mmojo Server repo. It is covered by
#  the repo's MIT-style LICENSE:
#
#  https://github.com/BradHutchings/Mmojo-Server/blob/main/LICENSE
#
#  Copyright (c) 2025 Brad Hutchings.
#  --
#  Brad Hutchings
#  brad@Mmojo.net
################################################################################
