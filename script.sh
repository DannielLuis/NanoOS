#!/bin/bash

set -e

echo "===== NanoOS build (NEW LAYOUT) ====="

IMG=boot.img

BOOT=boot.asm
LOADER=loader/loader.asm
KERNEL=kernel.asm

BOOT_BIN=boot.bin
LOADER_BIN=loader.bin
#KERNEL_BIN=KERNEL
KERNEL_BIN=kernel.bin

# =====================
# LAYOUT FIXO
# =====================
BOOT_SECTOR=0

LOADER_START=1
LOADER_MAX_SECTORS=19   # espaço até setor 19

FS_START=20
#FS_START=10
FS_SECTORS=2

KERNEL_START=30
#KERNEL_START=15

DISK_SIZE=20480  # setores (~10MB)

# =====================
# LIMPAR
# =====================
echo "[1] Limpando..."
rm -f *.bin *.img

# =====================
# CRIAR IMAGEM LIMPA
# =====================
echo "[2] Criando imagem..."
#dd if=/dev/zero of=$IMG bs=512 count=2880 status=none
dd if=/dev/zero of=$IMG bs=512 count=$DISK_SIZE status=none


# =====================
# COMPILAR
# =====================
echo "[3] Compilando boot..."
nasm -f bin $BOOT -o $BOOT_BIN

echo "[4] Compilando loader..."
nasm -f bin $LOADER -o $LOADER_BIN

echo "[5] Compilando kernel..."
nasm -f bin $KERNEL -o $KERNEL_BIN

# =====================
# CALCULAR TAMANHOS
# =====================
LOADER_SIZE=$(stat -c%s "$LOADER_BIN")
LOADER_SECTORS=$(( (LOADER_SIZE + 511) / 512 ))

KERNEL_SIZE=$(stat -c%s "$KERNEL_BIN")
KERNEL_SECTORS=$(( (KERNEL_SIZE + 511) / 512 ))

echo "Loader size: $LOADER_SIZE bytes ($LOADER_SECTORS setores)"
echo "Kernel size: $KERNEL_SIZE bytes ($KERNEL_SECTORS setores)"

# =====================
# VALIDAR TAMANHOS
# =====================
if [ $LOADER_SECTORS -gt $LOADER_MAX_SECTORS ]; then
    echo "[ERRO] Loader muito grande!"
    exit 1
fi

if [ $KERNEL_START -lt $((FS_START + FS_SECTORS)) ]; then
    echo "[ERRO] Kernel sobrescreve FS!"
    exit 1
fi

# =====================
# ALINHAR BINÁRIOS
# =====================
echo "[6] Alinhando binários..."

truncate -s $((LOADER_SECTORS * 512)) $LOADER_BIN
truncate -s $((KERNEL_SECTORS * 512)) $KERNEL_BIN

# =====================
# GRAVAR BOOT
# =====================
echo "[7] Gravando boot..."
dd if=$BOOT_BIN of=$IMG bs=512 seek=$BOOT_SECTOR conv=notrunc status=none

# =====================
# GRAVAR LOADER
# =====================
echo "[8] Gravando loader..."
dd if=$LOADER_BIN of=$IMG bs=512 seek=$LOADER_START conv=notrunc status=none

# =====================
# LIMPAR FS
# =====================
echo "[9] Limpando FS..."
dd if=/dev/zero of=$IMG bs=512 seek=$FS_START count=$FS_SECTORS conv=notrunc status=none

# =====================
# GRAVAR KERNEL
# =====================
echo "[10] Gravando kernel no setor $KERNEL_START..."
dd if=$KERNEL_BIN of=$IMG bs=512 seek=$KERNEL_START conv=notrunc status=none

# =====================
# CRIAR FS
# =====================
echo "[11] Criando FS..."

FS_OFFSET=$((FS_START * 512))

write_entry() {
    local NAME="$1"
    local START=$2
    local SIZE=$3
    local POS=$4

    local PAD
    PAD=$(printf "%-12s" "$NAME")

    # nome (12 bytes)
    printf "%s" "$PAD" | dd of=$IMG bs=1 seek=$POS conv=notrunc status=none

    # start + size (1 byte cada)
    printf "\\$(printf '%03o' $START)" | dd of=$IMG bs=1 seek=$((POS+12)) conv=notrunc status=none
    printf "\\$(printf '%03o' $SIZE)"  | dd of=$IMG bs=1 seek=$((POS+13)) conv=notrunc status=none

    # padding (2 bytes)
    printf "\0\0" | dd of=$IMG bs=1 seek=$((POS+14)) conv=notrunc status=none
}

# escrever entrada do kernel
write_entry "KERNEL" $KERNEL_START $KERNEL_SECTORS $FS_OFFSET

write_entry "INIT" 50 5 $((FS_OFFSET+16))
write_entry "DR_V" 60 3 $((FS_OFFSET+32)) # DRIVER DE VIDEO
write_entry "DRIVER1" 70 8 $((FS_OFFSET+48))

#write_entry "TESTE" 50 5 $((FS_OFFSET+16))
#write_entry "DRIVER1" 55 3 $((FS_OFFSET+32))
#write_entry "DRIVER2" 58 4 $((FS_OFFSET+48))


echo "===== BUILD OK ====="