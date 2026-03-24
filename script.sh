#!/bin/bash

set -e

echo "===== NanoOS build ====="

IMG=boot.img

BOOT=boot.asm
LOADER=loader.asm

BOOT_BIN=boot.bin
LOADER_BIN=loader.bin


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


echo "[6] Tamanho loader:"
ls -l $LOADER_BIN


echo "[7] Gravando loader..."
dd if=$LOADER_BIN of=$IMG bs=512 seek=1 conv=notrunc


echo "===== BUILD OK ====="