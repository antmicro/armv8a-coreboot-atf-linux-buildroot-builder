#!/bin/bash

set -e

git clone --depth=1 --branch=2023.08-rc1 https://github.com/buildroot/buildroot

cd buildroot

cp "../buildroot-configs/$1" .config
make olddefconfig

if [ -z "$MAXCPUS" ]; then
	make -j$(nproc)   # local version
else
	make -j${MAXCPUS} # CI version
fi

cd -
cp buildroot/output/images/rootfs.cpio linux_files/rootfs.cpio

