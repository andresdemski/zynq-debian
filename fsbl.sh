#!/bin/bash
set -ex
SRC_PATH=$PWD/srcs/embeddedsw

DOCKER_IMG=zynq_build_image
DOCKER_ARGS="-it --rm -v$PWD:$PWD -w $SRC_PATH -u $(id -u):$(id -g)"

MAKE_ARGS=" -C./lib/sw_apps/zynq_fsbl/src/ BOARD=zed CC=arm-none-eabi-gcc SHELL=/bin/bash"

mkdir -p $PWD/srcs
[[ -d $SRC_PATH ]] || ( git clone https://github.com/Xilinx/embeddedsw $SRC_PATH && \
    cd $SRC_PATH && \
    git apply ../../.files/embedded.patch && \
    cd - )

# Patch reason: *.o uses VFP register arguments, fsbl.elf does not
# It's not a good solution but it works :D

./build_docker.sh
docker run $DOCKER_ARGS $DOCKER_IMG make $MAKE_ARGS

mkdir -p outputs
mv $SRC_PATH/lib/sw_apps/zynq_fsbl/src/fsbl.elf outputs/fsbl.elf

