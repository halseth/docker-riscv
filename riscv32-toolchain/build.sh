#!/bin/bash

echo Building image for RISC-V 32-bit toolchain with QEMU

# --no-cache
docker build -t riscv32-toolchain-newlib:latest .
