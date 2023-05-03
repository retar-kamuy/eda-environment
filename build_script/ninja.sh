#!/usr/bin/env bash

VERSION=1.11.1
export CC=clang
export CXX=clang++

sudo apt-get install -y cmake

git clone https://github.com/ninja-build/ninja.git
cd ninja
git pull
git checkout v$VERSION

cmake -Bbuild-cmake
cmake --build build-cmake
cmake --install build-cmake --prefix /opt/ninja-1.11.1
