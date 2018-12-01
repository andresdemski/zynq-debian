#!/bin/bash
set -ex
SRC_PATH=$PWD/srcs/uboot

DOCKER_IMG=zynq_build_image
DOCKER_ARGS="-it --rm -v$PWD:$PWD -w $SRC_PATH -u $(id -u):$(id -g)"

MAKE_ARGS="ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- DTC_FLAGS=--symbols"
UBOOT_DEFCONFIG=zynq_zybo_defconfig

UENV_TEMPLATE=.files/uEnv.txt.template
TEMPLATE_CMD="sed 's/{% kernel %}/zImage/' $UENV_TEMPLATE | \
              sed 's/{% devicetree %}/zync-zybo.dtb/'"


mkdir -p $PWD/srcs
[[ -d $SRC_PATH ]] || git clone https://github.com/Xilinx/u-boot-xlnx.git $SRC_PATH

./build_docker.sh

docker run $DOCKER_ARGS $DOCKER_IMG make $MAKE_ARGS $UBOOT_DEFCONFIG
docker run $DOCKER_ARGS $DOCKER_IMG make $MAKE_ARGS

mkdir -p outputs
mv $SRC_PATH/u-boot outputs/uboot.elf
eval $TEMPLATE_CMD > outputs/uEnv.txt




