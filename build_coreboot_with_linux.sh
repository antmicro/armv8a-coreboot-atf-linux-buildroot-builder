#!/bin/bash

set -e

git clone --depth 1 --branch 4.20.1 https://review.coreboot.org/coreboot.git
cp coreboot_defconfig coreboot/configs/defconfig

cd coreboot

# Bump ATF to v2.9.0 and prevent updating it during building.
git clone https://review.coreboot.org/arm-trusted-firmware.git 3rdparty/arm-trusted-firmware
git -C 3rdparty/arm-trusted-firmware checkout v2.9.0
git config --file=.gitmodules submodule.arm-trusted-firmware.update none

# By default ATF doesn't include A75 and A78 CPUs for Qemu platform and doesn't apply active A78 erratas.
git apply ../atf-building-redefine-cpus-and-include-active-erratas.patch

cp ../linux_files/uImage .
make crossgcc-aarch64 CPUS=`nproc`
make defconfig
make QEMU_USE_GIC_DRIVER=QEMU_GICV$1 -j `nproc`

cd -
