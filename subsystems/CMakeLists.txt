file(GLOB_RECURSE SUBSYS_SRC
    *.cpp
)

add_library(subsystems STATIC ${SUBSYS_SRC})