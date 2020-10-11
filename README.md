# RISC-V Tools Docker image

This image includes:
* [RISC-V GNU Compiler Toolchain](https://github.com/riscv/riscv-gnu-toolchain)
* [Spike RISC-V ISA Simulator](https://github.com/riscv/riscv-isa-sim)
* [RISC-V Proxy Kernel and Boot Loader](https://github.com/riscv/riscv-pk)

## Building

Note: The GNU toolchain build will require well over 10GB of disk space.

To build taavitani/riscv-tools:latest run:

    $ make build

You can override the image tag. Eg. this would build taavitani/riscv-tools:dev:

    $ make build TAG=dev

After you're done you might want to run `docker system prune` to purge the build stage container image.

## Test the image

The RISCV tools get installed to /opt/riscv/bin and /opt/riscv/riscv64-unknown-elf/bin. (These are included in PATH).

To test that GCC and Spike work as expected:

    $ cat <<_EOT > hello.c
    > #include <stdio.h>
    >
    > int main() {
    >   printf("hello, world!\n");
    >   return 0;
    > }
    > _EOT
    $ riscv64-unknown-elf-gcc hello.c
    $ spike pk a.out
    bbl loader
    hello, world!
