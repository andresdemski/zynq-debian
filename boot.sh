#!/bin/bash
set -ex
OUTPUT_PATH=$PWD/outputs/
DOCKER_IMG=zynq_build_image
DOCKER_ARGS="-it --rm -v$PWD:$PWD -w $OUTPUT_PATH -u $(id -u):$(id -g)"

./build_docker.sh
docker run $DOCKER_ARGS $DOCKER_IMG mkbootimage ../.files/boot.bif BOOT.bin

