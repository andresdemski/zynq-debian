#!/bin/bash

set -ex
ARCH=armhf
#ARCH=arm64v8
#ARCH=$1

if [ $ARCH == armhf ]; then
    QEMU_STATIC=/usr/bin/qemu-arm-static
elif [ $ARCH == arm64v8 ]; then
    QEMU_STATIC=/usr/bin/qemu-aarch64-static
fi

docker pull $ARCH/debian
DOCK_IMG=$(docker create -v$QEMU_STATIC:$QEMU_STATIC $ARCH/debian)
mkdir -p outputs
docker export $DOCK_IMG > outputs/debian-$ARCH.tar
docker rm $DOCK_IMG
