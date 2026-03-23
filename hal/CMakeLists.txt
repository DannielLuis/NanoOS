file(GLOB_RECURSE HAL_SRC
    *.cpp
)

add_library(hal STATIC ${HAL_SRC})