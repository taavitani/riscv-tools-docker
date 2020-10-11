FROM debian:sid AS build

RUN DEBIAN_FRONTEND=noninteractive apt-get update -yqq

#
# Build and install the RISC-V GNU Compiler Toolchain.
#
RUN apt-get install -y autoconf automake autotools-dev curl python3 \
	libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison \
	flex texinfo gperf libtool patchutils bc zlib1g-dev \
	libexpat-dev git

RUN git clone --recursive \
	https://github.com/riscv/riscv-gnu-toolchain.git \
	/riscv-gnu-toolchain

# Build the Newlib cross-compiler; recommended for xv6-riscv.
RUN set -e ; \
	cd /riscv-gnu-toolchain ; \
	./configure --prefix=/opt/riscv && make

#
# Build and install the Spike RISC-V ISA Simulator.
#
RUN apt-get install -y device-tree-compiler

RUN git clone https://github.com/riscv/riscv-isa-sim.git /riscv-isa-sim

RUN set -e ; \
	mkdir /riscv-isa-sim/build ; cd /riscv-isa-sim/build ; \
	../configure --prefix=/opt/riscv && make && make install

#
# Build and install the RISC-V Proxy Kernel and Boot Loader.
#
RUN git clone https://github.com/riscv/riscv-pk.git /riscv-pk

ENV RISCV=/opt/riscv
ENV PATH=$RISCV/bin:$PATH

RUN set -e ; \
	mkdir /riscv-pk/build ; cd /riscv-pk/build ; \
	../configure --prefix=$RISCV --host=riscv64-unknown-elf ; \
	make && make install

FROM debian:sid

COPY --from=build /opt /opt

#
# Install runtime dependencies for RISC-V Tools
#
RUN set -e ; \
        apt-get update -yqq ; \
        apt-get install -y --no-install-recommends libexpat1 libmpfr6 \
	libmpc3 device-tree-compiler

ENV PATH=/opt/riscv/bin:$PATH:/opt/riscv/riscv64-unknown-elf/bin/
