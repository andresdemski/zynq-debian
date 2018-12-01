#!/bin/bash
set -ex
SRC_PATH=$PWD/srcs/embeddedsw
DOCKERFILE_DIR=.files/
DOCKERFILE=Dockerfile.build
BUILD_IMG=zynq_build_image
MAKE_ARGS=" -C./lib/sw_apps/zynq_fsbl/src/ BOARD=zed CC=arm-none-eabi-gcc SHELL=/bin/bash"
DOCKER_ARGS="-it --rm -v$PWD:$PWD -w $SRC_PATH -u $(id -u):$(id -g)"

mkdir -p $PWD/srcs
[[ -d $SRC_PATH ]] || ( git clone https://github.com/Xilinx/embeddedsw $SRC_PATH && \
    cd $SRC_PATH && \
    git apply ../../.files/embedded.patch && \
    cd - )

# Patch reason: *.o uses VFP register arguments, fsbl.elf does not
# It's not a good solution but it works :D

cd $DOCKERFILE_DIR
docker build -f $DOCKERFILE -t $BUILD_IMG .
cd -


docker run $DOCKER_ARGS $BUILD_IMG make $MAKE_ARGS

mkdir -p outputs
mv $SRC_PATH/lib/sw_apps/zynq_fsbl/src/fsbl.elf outputs/fsbl.elf

