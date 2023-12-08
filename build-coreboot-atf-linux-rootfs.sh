#!/bin/bash

set -ex

# Packages required in a clean ubuntu:bionic docker container:
#   bc bison build-essential cpio curl device-tree-compiler file
#   flex gcc-aarch64-linux-gnu git gnat libncurses5-dev libssl-dev
#   locales m4 rsync u-boot-tools unzip wget zlib1g-dev

# Other valid arguments: a53-gicv2, a53-gicv3
CPU_AND_GIC_VERSION=${1:-a75-gicv3}

CPU_MODEL=${CPU_AND_GIC_VERSION%-*}
GIC_VERSION=${CPU_AND_GIC_VERSION#*gicv}

BUILDROOT_DEFCONFIG=cortex-${CPU_MODEL}_defconfig
if [ "$CPU_MODEL" = "a75" ]; then
  DTS_FILENAME=${CPU_MODEL}.dts
else
  DTS_FILENAME=${CPU_AND_GIC_VERSION}.dts
fi

./build_buildroot.sh $BUILDROOT_DEFCONFIG
./build_linux_payload.sh $DTS_FILENAME
./build_coreboot_with_linux.sh $GIC_VERSION
