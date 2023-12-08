#!/bin/bash

set -e

git clone --depth=1 --branch=v6.3 git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-

cd linux

cp ../linux_files/linux.config .config
make olddefconfig

if [ -z "$MAXCPUS" ]; then
	make -j$(nproc)   # local version
else
	make -j${MAXCPUS} # CI version
fi

cd -
cp linux/arch/arm64/boot/Image linux_files

cd linux_files
dtc -I dts -O dtb $1 > virt.dtb
mkimage -f config.its uImage
cd -
