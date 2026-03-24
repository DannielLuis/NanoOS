#!/bin/bash

set -e

echo "===== NanoOS build ====="

IMG=boot.img

BOOT=boot.asm
LOADER=loader/loader.asm
KERNEL=kernel.asm

BOOT_BIN=boot.bin
LOADER_BIN=loader.bin
KERNEL_BIN=kernel.bin


echo "[1] Limpando..."
rm -f *.bin *.img


echo "[2] Criando imagem..."
dd if=/dev/zero of=$IMG bs=512 count=2880


echo "[3] Compilando boot..."
nasm -f bin $BOOT -o $BOOT_BIN


echo "[4] Gravando boot..."
dd if=$BOOT_BIN of=$IMG conv=notrunc


echo "[5] Compilando loader..."
nasm -f bin $LOADER -o $LOADER_BIN


echo "[6] Compilando kernel..."
nasm -f bin $KERNEL -o $KERNEL_BIN


echo "[7] Calculando setores loader..."
LOADER_SIZE=$(stat -c%s "$LOADER_BIN")
LOADER_SECTORS=$(( ($LOADER_SIZE + 511) / 512 ))

echo "Loader sectors = $LOADER_SECTORS"


echo "[8] Gravando loader..."
dd if=$LOADER_BIN of=$IMG bs=512 seek=1 conv=notrunc


KERNEL_OFFSET=$((1 + LOADER_SECTORS))

echo "[9] Gravando kernel no setor $KERNEL_OFFSET"
dd if=$KERNEL_BIN of=$IMG bs=512 seek=$KERNEL_OFFSET conv=notrunc


echo "===== BUILD OK ====="