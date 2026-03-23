file(GLOB_RECURSE SHELL_SRC
    *.cpp
)

add_library(shell STATIC ${SHELL_SRC})