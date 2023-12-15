# see https://github.com/riscv/riscv-gnu-toolchain

FROM ubuntu:22.04 as build

RUN apt-get -y update
RUN apt-get -y install git autoconf automake autotools-dev curl libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev
RUN apt-get -y install python3 # also required by riscv-gnu-toolchain
RUN apt-get -y install autoconf automake autotools-dev curl python3 python3-pip libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev ninja-build git cmake libglib2.0-dev

RUN git config --global http.sslverify false

RUN mkdir /src && \
  cd /src && \
  git clone https://github.com/riscv/riscv-gnu-toolchain

# Build newlib toolchain
RUN cd /src/riscv-gnu-toolchain/ && \
  ./configure --prefix=/riscv32 --with-arch=rv32ia --with-abi=ilp32 && \
  make -j 8 # also installs

RUN apt-get -y install python3 pkg-config libglib2.0-dev libpixman-1-dev

# QEMU is not built automatically
#RUN cd /src/riscv-gnu-toolchain/qemu && \
#  ./configure --prefix=/riscv32 --static --disable-system --target-list=riscv32-linux-user && \
#  make -j 8 && \
#  make install

RUN cd /src && \
  git clone https://git.qemu.org/git/qemu.git && \
  cd qemu && \
  ./configure --prefix=/riscv32 --static --disable-system --target-list=riscv32-linux-user && \
  make -j 8 && \
  make install

COPY hello.cpp /src
RUN /riscv32/bin/riscv32-unknown-elf-gnu-g++ /src/hello.cpp -o /riscv32/bin/hello
COPY register-riscv32.sh qemu-riscv32.sh /riscv32/bin/

FROM ubuntu:22.04

LABEL version="1.0"
LABEL description="RISC-V 32-bit GCC cross compiler toolchain with QEMU."

RUN apt-get update -y && \
  apt-get install -y libmpc-dev libmpfr-dev libgmp-dev && \
  rm -rf /var/lib/apt/lists/*

COPY --from=build /riscv32 /riscv32

ENV PATH /riscv32/bin:$PATH
ENV CC riscv32-unknown-elf-gnu-gcc
ENV CXX riscv32-unknown-elf-gnu-c++
ENV CPP riscv32-unknown-elf-gnu-cpp
ENV AS riscv32-unknown-elf-gnu-as
ENV LD riscv32-unknown-elf-gnu-ld
ENV AR riscv32-unknown-elf-gnu-ar
ENV RANLIB riscv32-unknown-elf-gnu-ranlib
ENV HOST riscv32-unknown-elf-gnu
