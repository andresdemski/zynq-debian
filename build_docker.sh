#!/bin/bash
set -ex

DOCKERFILE_DIR=.files
DOCKERFILE=Dockerfile.build
BUILD_IMG=zynq_build_image

cd $DOCKERFILE_DIR
docker build -f $DOCKERFILE -t $BUILD_IMG .
cd -
