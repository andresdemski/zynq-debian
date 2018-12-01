#!/bin/bash
set -ex
SRC_PATH=$PWD/srcs/linux
DOCKERFILE_DIR=.files
DOCKERFILE=Dockerfile.build
BUILD_IMG=zynq_build_image
MAKE_ARGS="ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- DTC_FLAGS=--symbols"
KERNEL_CONFIG=xilinx_zynq_defconfig
DOCKER_ARGS="--rm -v$PWD:$PWD -w $SRC_PATH -u $(id -u):$(id -g)"

mkdir -p $PWD/srcs
[[ -d $SRC_PATH ]] || git clone https://github.com/Xilinx/linux-xlnx.git $SRC_PATH

cd $DOCKERFILE_DIR
docker build -f $DOCKERFILE -t $BUILD_IMG .
cd -

docker run $DOCKER_ARGS $BUILD_IMG fakeroot make $MAKE_ARGS $KERNEL_CONFIG
docker run $DOCKER_ARGS $BUILD_IMG make $MAKE_ARGS deb-pkg
docker run $DOCKER_ARGS $BUILD_IMG make $MAKE_ARGS zynq-zybo.dtb

deb_tars_files=$(find srcs -maxdepth 1 -type f | egrep ".deb$|.tar.gz$|.dsc$|.changes$")

mkdir -p outputs/debian/
mv $deb_tars_files outputs/debian/
mv $SRC_PATH/arch/arm/boot/Image outputs/
mv $SRC_PATH/arch/arm/boot/zImage outputs/
mv $SRC_PATH/arch/arm/boot/dts/zynq-zybo.dtb outputs/zynq-zybo.dtb


