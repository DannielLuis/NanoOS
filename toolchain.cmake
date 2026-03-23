set(CMAKE_SYSTEM_NAME Generic)

set(CMAKE_C_COMPILER i686-elf-gcc)
set(CMAKE_CXX_COMPILER i686-elf-g++)
set(CMAKE_ASM_NASM_COMPILER nasm)

set(CMAKE_C_FLAGS "-ffreestanding -O2 -Wall")
set(CMAKE_CXX_FLAGS "-ffreestanding -O2 -Wall -fno-exceptions -fno-rtti")

set(CMAKE_EXE_LINKER_FLAGS "-nostdlib")



#[[
set(CMAKE_SYSTEM_NAME Generic)

set(CMAKE_C_COMPILER i686-elf-gcc)
set(CMAKE_CXX_COMPILER i686-elf-g++)
set(CMAKE_ASM_NASM_COMPILER nasm)

set(CMAKE_C_FLAGS "-ffreestanding -O2 -Wall -m32")
set(CMAKE_CXX_FLAGS "-ffreestanding -O2 -Wall -m32 -fno-exceptions -fno-rtti")

set(CMAKE_EXE_LINKER_FLAGS "-nostdlib -m32")
]]






#[[
set(CMAKE_SYSTEM_NAME Generic)

set(CMAKE_C_COMPILER i686-elf-gcc)
set(CMAKE_CXX_COMPILER i686-elf-g++)
set(CMAKE_ASM_NASM_COMPILER nasm)

set(CMAKE_C_FLAGS "-ffreestanding -O2 -Wall -m32")
set(CMAKE_CXX_FLAGS "-ffreestanding -O2 -Wall -fno-exceptions -fno-rtti -m32")

set(CMAKE_EXE_LINKER_FLAGS "-nostdlib -m32")
]]




#[[
set(CMAKE_SYSTEM_NAME Generic)

set(CMAKE_C_COMPILER i686-elf-gcc)
set(CMAKE_CXX_COMPILER i686-elf-g++)
set(CMAKE_ASM_COMPILER i686-elf-as)

set(CMAKE_C_FLAGS "-ffreestanding -O2 -Wall")
set(CMAKE_CXX_FLAGS "-ffreestanding -O2 -Wall -fno-exceptions -fno-rtti")

set(CMAKE_EXE_LINKER_FLAGS "-nostdlib")]]