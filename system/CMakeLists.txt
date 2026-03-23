file(GLOB_RECURSE SYSTEM_SRC
    *.cpp
)

add_library(system STATIC ${SYSTEM_SRC})