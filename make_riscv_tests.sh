#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RISCV_TEST_DIR="/opt/riscv/riscv-tests"
RISCV_TEST_WORK_DIR="$SCRIPT_DIR/tmp"

# Copy RISC-V test files
mkdir -p "$RISCV_TEST_WORK_DIR"
cp -r "$RISCV_TEST_DIR"/* "$RISCV_TEST_WORK_DIR"

# Modify linker script
sed -i "s/. = 0x80000000/. = 0x00000000/g" "$RISCV_TEST_WORK_DIR/env/p/link.ld"

# Build RISC-V tests
pushd "$RISCV_TEST_WORK_DIR" > /dev/null 2>&1
autoconf
./configure --prefix="$SCRIPT_DIR/target"
make
make install
popd > /dev/null 2>&1

# Remove unnecessary files
rm -rf "$RISCV_TEST_WORK_DIR"

# Convert ELF to BIN and HEX
SAVE_DIR="$SCRIPT_DIR/src/riscv"

rm -rf "$SAVE_DIR"
mkdir -p "$SAVE_DIR"

FILES="$SCRIPT_DIR/target/share/riscv-tests/isa/rv32*-p-*"
for f in $FILES; do
  FILE_NAME="${f##*/}"
  if [[ ! $f =~ "dump" ]]; then
    riscv64-unknown-elf-objcopy -O binary "$f" "$SAVE_DIR/$FILE_NAME.bin"
    od -An -tx1 -w1 -v "$SAVE_DIR/$FILE_NAME.bin" >> "$SAVE_DIR/$FILE_NAME.hex"
    rm -f "$SAVE_DIR/$FILE_NAME.bin"
  fi
done
