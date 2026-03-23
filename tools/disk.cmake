get_filename_component(ROOT_DIR "${CMAKE_CURRENT_LIST_DIR}/.." ABSOLUTE)
set(BIN "${ROOT_DIR}/build")

message("ROOT = ${ROOT_DIR}")
message("BIN = ${BIN}")

execute_process(
    COMMAND nasm -f bin
    ${ROOT_DIR}/boot/boot.asm
    -o ${BIN}/boot.bin
)

execute_process(
    COMMAND i686-elf-objcopy
    -O binary
    ${BIN}/loader/loader.elf
    ${BIN}/loader.bin
)

execute_process(
    COMMAND i686-elf-objcopy
    -O binary
    ${BIN}/kernel/kernel.elf
    ${BIN}/kernel.bin
)

execute_process(
    COMMAND dd if=/dev/zero of=${BIN}/disk.img bs=512 count=2880
)

execute_process(
    COMMAND dd if=${BIN}/boot.bin of=${BIN}/disk.img conv=notrunc
)

execute_process(
    COMMAND dd if=${BIN}/loader.bin of=${BIN}/disk.img bs=512 seek=1 conv=notrunc
)

execute_process(
    COMMAND dd if=${BIN}/kernel.bin of=${BIN}/disk.img bs=512 seek=20 conv=notrunc
)





#[[
#set(SRC ${CMAKE_SOURCE_DIR})
#set(BIN ${CMAKE_BINARY_DIR})
set(SRC "${CMAKE_SOURCE_DIR}")
set(BIN "${CMAKE_BINARY_DIR}")

message("SRC = ${SRC}")
message("BIN = ${BIN}")

execute_process(
    COMMAND nasm -f bin
    ${SRC}/boot/boot.asm
    -o ${BIN}/boot.bin
)

execute_process(
    COMMAND i686-elf-objcopy
    -O binary
    ${BIN}/loader/loader.elf
    ${BIN}/loader.bin
)

execute_process(
    COMMAND i686-elf-objcopy
    -O binary
    ${BIN}/kernel/kernel.elf
    ${BIN}/kernel.bin
)

execute_process(
    COMMAND dd if=/dev/zero of=${BIN}/disk.img bs=512 count=2880
)

execute_process(
    COMMAND dd if=${BIN}/boot.bin of=${BIN}/disk.img conv=notrunc
)

execute_process(
    COMMAND dd if=${BIN}/loader.bin of=${BIN}/disk.img bs=512 seek=1 conv=notrunc
)

execute_process(
    COMMAND dd if=${BIN}/kernel.bin of=${BIN}/disk.img bs=512 seek=20 conv=notrunc
)
]]




#[[
execute_process(
    COMMAND nasm
    -f bin
    ${CMAKE_SOURCE_DIR}/boot/boot.asm
    -o ${CMAKE_BINARY_DIR}/boot.bin
)

execute_process(
    COMMAND i686-elf-objcopy
    -O binary
    ${CMAKE_BINARY_DIR}/loader/loader.elf
    ${CMAKE_BINARY_DIR}/loader.bin
)

execute_process(
    COMMAND i686-elf-objcopy
    -O binary
    ${CMAKE_BINARY_DIR}/kernel/kernel.elf
    ${CMAKE_BINARY_DIR}/kernel.bin
)

execute_process(
    COMMAND dd if=/dev/zero
    of=${CMAKE_BINARY_DIR}/disk.img
    bs=512
    count=2880
)

execute_process(
    COMMAND dd
    if=${CMAKE_BINARY_DIR}/boot.bin
    of=${CMAKE_BINARY_DIR}/disk.img
    conv=notrunc
)

execute_process(
    COMMAND dd
    if=${CMAKE_BINARY_DIR}/loader.bin
    of=${CMAKE_BINARY_DIR}/disk.img
    bs=512
    seek=1
    conv=notrunc
)

execute_process(
    COMMAND dd
    if=${CMAKE_BINARY_DIR}/kernel.bin
    of=${CMAKE_BINARY_DIR}/disk.img
    bs=512
    seek=20
    conv=notrunc
)
]]



#[[
execute_process(COMMAND nasm -f bin boot/boot.asm -o boot.bin)

execute_process(
    COMMAND i686-elf-objcopy -O binary loader/loader.elf loader.bin
)

execute_process(
    COMMAND i686-elf-objcopy -O binary kernel/kernel.elf kernel.bin
)

execute_process(
    COMMAND dd if=/dev/zero of=disk.img bs=512 count=2880
)

execute_process(
    COMMAND dd if=boot.bin of=disk.img conv=notrunc
)

execute_process(
    COMMAND dd if=loader.bin of=disk.img bs=512 seek=1 conv=notrunc
)

execute_process(
    COMMAND dd if=kernel.bin of=disk.img bs=512 seek=20 conv=notrunc
)]]